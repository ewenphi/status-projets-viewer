#include <curl/curl.h>
#include <curl/easy.h>
#include <dirent.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/reboot.h>
#include <unistd.h>

#define USER_SIZE 20
#define NIXOS_DIR_SIZE 100
#define PATH_SIZE 128
#define PATH_DIR "/Nixos-Dots/"

#define OUTPUT_SIZE 128

#define COMMAND_DIFF                                                           \
  "cd ~/home-config && git fetch && git diff --quiet origin/main"

#define COMMAND_UPDATE "cd ~/home-config && nix flake update"

#define COMMAND_BUILD "nh home switch -a"

struct memory {
  char *response;
  size_t size;
};

static size_t cb(char *data, size_t size, size_t nmemb, void *clientp) {
  size_t realsize = size * nmemb;
  struct memory *mem = (struct memory *)clientp;

  char *ptr = realloc(mem->response, mem->size + realsize + 1);
  if (!ptr)
    return 0; /* out of memory! */

  mem->response = ptr;
  memcpy(&(mem->response[mem->size]), data, realsize);
  mem->size += realsize;
  mem->response[mem->size] = 0;

  return realsize;
}

int curl_request(struct memory *chunk_curl) {

  CURLcode ret;
  CURL *hnd;
  struct curl_slist *slist1;

  slist1 = NULL;
  slist1 = curl_slist_append(slist1, "X-GitHub-Api-Version: 2022-11-28");

  hnd = curl_easy_init();
  if (!hnd) {
    printf("Erreur lors de l'init locale de curl");
    exit(EXIT_FAILURE);
  }

  curl_easy_setopt(hnd, CURLOPT_BUFFERSIZE, 102400L);
  curl_easy_setopt(
      hnd, CURLOPT_URL,
      "https://api.github.com/repos/NixOs/nixpkgs/commits/nixos-unstable");
  curl_easy_setopt(hnd, CURLOPT_NOPROGRESS, 1L);
  curl_easy_setopt(hnd, CURLOPT_HTTPHEADER, slist1);
  curl_easy_setopt(hnd, CURLOPT_USERAGENT, "curl/8.8.0");
  curl_easy_setopt(hnd, CURLOPT_MAXREDIRS, 50L);
  curl_easy_setopt(hnd, CURLOPT_HTTP_VERSION, (long)CURL_HTTP_VERSION_2TLS);
  curl_easy_setopt(hnd, CURLOPT_CUSTOMREQUEST, "GET");
  curl_easy_setopt(hnd, CURLOPT_FTP_SKIP_PASV_IP, 1L);
  curl_easy_setopt(hnd, CURLOPT_TCP_KEEPALIVE, 1L);

  curl_easy_setopt(hnd, CURLOPT_WRITEDATA, (void *)chunk_curl);
  curl_easy_setopt(hnd, CURLOPT_WRITEFUNCTION, cb);
  /* Here is a list of options the curl code used that cannot get generated
     as source easily. You may choose to either not use them or implement
     them yourself.

  CURLOPT_WRITEDATA was set to an object pointer
  CURLOPT_INTERLEAVEDATA was set to an object pointer
  CURLOPT_WRITEFUNCTION was set to a function pointer
  CURLOPT_READDATA was set to an object pointer
  CURLOPT_READFUNCTION was set to a function pointer
  CURLOPT_SEEKDATA was set to an object pointer
  CURLOPT_SEEKFUNCTION was set to a function pointer
  CURLOPT_ERRORBUFFER was set to an object pointer
  CURLOPT_STDERR was set to an object pointer
  CURLOPT_HEADERFUNCTION was set to a function pointer
  CURLOPT_HEADERDATA was set to an object pointer

  */

  ret = curl_easy_perform(hnd);

  curl_easy_cleanup(hnd);
  hnd = NULL;
  curl_slist_free_all(slist1);
  slist1 = NULL;

  return (int)ret;
}

void test_lock_file_exists(char *flake, char *flake_lock) {
  // NOTE: construction du nom du lock file

  // test si le dossier existe
  FILE *nixos_dir = fopen(flake, "r");
  if (nixos_dir == NULL) {
    perror("Dossier local n'est pas là\n");
    //! clone à implémenter
    exit(EXIT_FAILURE);
  }
  fclose(nixos_dir);

  // teste si le fichier existe
  FILE *lock_file = fopen(flake_lock, "r");
  if (lock_file == NULL) {
    perror("flake.lock n'est pas là, bizarre, clone ou nix flake lock\n");
    exit(EXIT_FAILURE);
  }
  fclose(lock_file);
}

/*
 *      Remove given section from string. Negative len means remove
 *      everything up to the end.
 */
int str_cut(char *str, int begin, int len) {
  int l = strlen(str);

  if (len < 0)
    len = l - begin;
  if (begin + len > l)
    len = l - begin;
  memmove(str + begin, str + begin + len, l - len + 1);

  return len;
}

void test_diff_of_online_nixpkgs(char *flake_lock) {
  // NOTE: construction du nom du lock file

  FILE *lock = fopen(flake_lock, "r");
  if (lock == NULL) {
    printf("erreur lors de l'ouverture du flake.lock\n");
    exit(EXIT_FAILURE);
  }

  // NOTE: get the local nixpkgs rev
  // TODO: USE json-c ou lib grep
  char buf[80];
  char nixpkgs_lock[80];
  bool nixpkgs_lock_nixpkgs = false;
  bool nixpkgs_lock_found = false;
  if (feof(lock))
    printf("feof\n");
  while (!feof(lock) && !nixpkgs_lock_found) {
    if (fgets(buf, 80, lock) == NULL && !feof(lock)) {
      printf("erreur lors de la lecture du flake.lock : %s\n", buf);
      exit(EXIT_FAILURE);
    }

    if (!feof(lock)) {
      if (strstr(buf, "nixpkgs\": {") != NULL) {
        nixpkgs_lock_nixpkgs = true;
      }
      if (nixpkgs_lock_nixpkgs) {
        if (strstr(buf, "rev") != NULL) {
          strtok(buf, "\"");
          for (int i = 0; i < 2; i++) {
            strtok(NULL, "\"");
          }
          strlcpy(nixpkgs_lock, strtok(NULL, "\""), 80);
          nixpkgs_lock_nixpkgs = false;
          nixpkgs_lock_found = true;
        }
      }
    }
  }
  fclose(lock);

  // get the last commit of nixos-unstable

  // premier essai libcurl
  /* curl_global_init(CURL_GLOBAL_ALL); */
  /* CURL* handle = curl_easy_init(); */
  /* curl_easy_setopt(handle,CURLOPT_URL,"https://api.github.com/repos/Nixos/nixpkgs/commits/nixos-unstable\?per_page=1");
   */

  // second essai curl client
  /* FILE* file_remote_nixpkgs; */
  /* char buf_remote[100]; */

  /* if((file_remote_nixpkgs = popen("curl --request GET --url
   * 'https://api.github.com/repos/NixOs/nixpkgs/commits/nixos-unstable'
   * --header 'X-GitHub-Api-Version: 2022-11-28' | jq .sha","r"))==NULL){ */
  /* 	printf("erreur lors de l'ouverture du fichier remote\n"); */
  /* 	exit(EXIT_FAILURE); */
  /* } */

  /* if(fgets(buf_remote,100,file_remote_nixpkgs)==NULL){ */
  /* 	printf("erreur lors de la lecture du fichier remote\n"); */
  /* 	exit(EXIT_FAILURE); */
  /* } */
  /* strtok(buf_remote,"\""); */
  /* str_cut(buf_remote,0,1); */

  /* if(strcmp(nixpkgs_lock,buf_remote)==0){ */
  /* 	printf("tu n'es pas au dernier commit, malgré l'update\n"); */
  /* 	exit(EXIT_FAILURE); */
  /* } */

  // essai use libgit2

  //! NOTE:  avec l'exemple de libcurl writefunction, ça marche lessgooo
  struct memory chunk = {0};

  curl_global_init(CURL_GLOBAL_ALL);

  curl_request(&chunk);

  curl_global_cleanup();

  //! NOTE: extraction du sha de manière pas propre
  char buf_online[256];
  strtok(chunk.response, "\"");
  for (int i = 0; i < 2; i++) {
    strtok(NULL, "\"");
  }
  strlcpy(buf_online, strtok(NULL, "\""), 256);

  free(chunk.response);

  //! TODO: json-c pour extrare le sha ou extraire avec lib grep et "" si flemme

  //
  if ((strcmp(nixpkgs_lock, buf_online)) == 0) {
    printf("pas besoin d'update, le flake.lock est à jour !\n");
    exit(EXIT_SUCCESS);
  }
}

void git_difference(void) {
  if ((system(COMMAND_DIFF)) != 0) {
    printf("Il y a des commits à récuperer ou à pousser\n");
    exit(EXIT_FAILURE);
  }
}

void git_update(void) {
  if ((system(COMMAND_UPDATE)) != 0) {
    printf("erreur lors du nix flake update\n");
    exit(EXIT_FAILURE);
  }
}

void nix_build(void) {
  if ((system(COMMAND_BUILD)) == -1) {
    printf("erreur d'ouverture de la commande d'update\n");
    exit(EXIT_FAILURE);
  }
}

void prompt_reboot(void) {
  char reboot_question[256] = "a";
  while (((strcmp(reboot_question, "y")) != 0 &&
          (strcmp(reboot_question, "Y")) != 0 &&
          (strcmp(reboot_question, "n")) != 0 &&
          (strcmp(reboot_question, "N")) != 0 &&
          (strcmp(reboot_question, "\n")) != 0) ||
         (strlen(reboot_question)) != 1) {
    printf("il y a-t-il eu une update system ? [y/N]: ");
    if (scanf("%s", reboot_question) < 0) {
      perror("erreur lors de la lecture de la réponse");
      exit(EXIT_FAILURE);
    }
  }
  if ((strcmp(reboot_question, "y")) == 0 ||
      (strcmp(reboot_question, "Y")) == 0) {
    printf("Rebooting\n");
    sync();
    int error_system = system("reboot");
    if (error_system == -1 || error_system == 127) {
      perror("erreur lors de l'éxecution du reboot");
      exit(EXIT_FAILURE);
    }
    exit(EXIT_SUCCESS);
  }
}

int main(int argc, char *argv[]) {
  char *flake = getenv("FLAKE");
  char flake_lock[256] = "";
  strncat(flake_lock, flake, NIXOS_DIR_SIZE);
  strncat(flake_lock, "/flake.lock", NIXOS_DIR_SIZE - 1);

  // NOTE: test si le flake.lock existe dans Nixos-Dots
  test_lock_file_exists(flake, flake_lock);
  //
  // NOTE: si "diff" comme argument, ne fait que le check nixpkgs distant
  if (argc == 2) {
    if (strcmp(argv[1], "diff") == 0) {
      test_diff_of_online_nixpkgs(flake_lock);
      printf("besoin d'update\n");
      exit(EXIT_SUCCESS);
    }
  }

  // NOTE: teste s'il y a des commits de diff avec origin
  git_difference();

  // NOTE: teste s'il y a bien besoin de mettre à jour (my recipe)
  test_diff_of_online_nixpkgs(flake_lock);

  // NOTE : nix flake update
  git_update();

  // TODO: avant ça : essaie d'utiliser les libs dont gitlib2

  // NOTE: fait le build et demande l'application
  nix_build();

  // TODO: propose de reboot si sys updated
  prompt_reboot();

  exit(EXIT_SUCCESS);
}

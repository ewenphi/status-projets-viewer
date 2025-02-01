{ pkgs, ... }:
{
  languages.rust.enable = true;

  git-hooks.hooks = {
    rustfmt.enable = true;
    nixpkgs-fmt.enable = true;
    taplo.enable = true;
    markdownlint.enable = true;
    yamlfmt.enable = true;
    clippy.enable = true;
    cargo-check.enable = true;
    commitizen.enable = true;
  };

  packages = [
    #voir la taille des grosses deps
    pkgs.cargo-bloat
    #gerer les deps depuis le cli
    pkgs.cargo-edit
    #auto compile
    pkgs.cargo-watch
  ];

  env = {
    RUST_BACKTRACE = "1";
  };

  enterShell = ''
    echo "shell pour "
  '';
}

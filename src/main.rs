use colored::Colorize;
use serde_derive::Deserialize;
use std::{
    path::Path,
    process::{exit, Command},
};

use git2::{Repository, StatusOptions};

fn flakechecker(p: Projet) -> bool {
    let lock_location = &(p.location + "/flake.lock");
    let path = Path::new(lock_location);
    if !path.is_file() {
        println!("{}", "didn't found lockfile".yellow());
        return false;
    }
    let output_res = Command::new("flake-checker")
        .args(["-f", "--no-telemetry", lock_location])
        .env("NIX_FLAKE_CHECKER_IGNORE_MISSING_FLAKE_LOCK", "false")
        .output();
    match output_res {
        Ok(output) => {
            let lockfile_found = match String::from_utf8(output.stdout) {
                Ok(value) => !value.contains("  no flake lockfile found"),
                Err(_) => false,
            };
            if !lockfile_found {
                println!("{}", "  flake-checker didn't found lockfile".yellow());
                false
            } else {
                println!(
                    "{}",
                    if output.status.success() {
                        "  flake.lock up to date".green()
                    } else {
                        "  flake.lock out of date".red()
                    }
                );
                output.status.success()
            }
        }
        Err(e) => {
            println!("{} : {e}", "erreur lors du flake-checker".yellow());
            false
        }
    }
}

fn gitstatus(repo: &Repository) -> bool {
    let mut status_options = StatusOptions::new();
    status_options.include_ignored(false);
    let res_statuses = repo.statuses(Some(&mut status_options));
    match res_statuses {
        Ok(statuses) => {
            if statuses.is_empty() {
                println!("{}", "  very clean : true".green());
                true
            } else {
                println!("{}", "  very clean : false".red());
                false
            };
            statuses.is_empty()
        }
        Err(e) => {
            println!("{} {}", "  statuses error :".yellow(), e);

            false
        }
    }
}

fn gitbranchdiff(repo: Repository) -> bool {
    let res_branches = repo.branches(None);
    match res_branches {
        Ok(branches) => {
            let mut result = false;
            for res_branch in branches {
                match res_branch {
                    Ok(branch) => {
                        if branch.0.is_head() {
                            let upstream = branch.0.upstream().expect("error opening upstream");
                            let upstream_tree = upstream
                                .get()
                                .peel_to_tree()
                                .expect("error opening upstream tree");
                            let res_diff =
                                repo.diff_tree_to_workdir_with_index(Some(&upstream_tree), None);
                            match res_diff {
                                Ok(diff) => {
                                    let diffstats = diff.stats().expect("error opening difftstats");
                                    if diffstats.files_changed() == 0
                                        && diffstats.insertions() == 0
                                        && diffstats.deletions() == 0
                                    {
                                        println!("{}", "  diff with remote : none".green());
                                        result = true;
                                    } else {
                                        println!("{}", "  diff with remote : diffs".red());
                                    }
                                }
                                Err(e) => {
                                    println!("{} {}", "error in diff :".yellow(), e)
                                }
                            }
                        }
                    }
                    Err(e) => {
                        println!("{} {}", "  branch error :".yellow(), e);
                    }
                }
            }
            result
        }
        Err(e) => {
            println!("{} {}", "  branches error :".yellow(), e);
            false
        }
    }
}

fn git(p: Projet) -> bool {
    if !p.git {
        return true;
    }
    let repo = match Repository::open(p.location) {
        Ok(repo) => repo,
        Err(e) => panic!("{} {}", "failed to open git repo:".yellow(), e),
    };

    gitstatus(&repo) && gitbranchdiff(repo)
}

#[derive(Deserialize)]
struct Config {
    projets: Box<[Projet]>,
}

#[derive(Clone, Deserialize)]
struct Projet {
    name: String,
    location: String,
    git: bool,
}
use std::fs;

fn get_config() -> Config {
    let home_config = match std::env::var("XDG_CONFIG_HOME") {
        Ok(val) => val,
        Err(_) => match std::env::var("HOME") {
            Ok(val) => val + "/.config/",
            Err(e) => {
                eprintln!("couldn't interpret environment variables for : {}", e);
                exit(1);
            }
        },
    };
    let config_dir = home_config + "status-projets-viewer/";
    let config_file = String::from("config.toml");
    let config_path = config_dir.clone() + &config_file;

    //exists dir et file
    if !fs::exists(&config_dir).expect("io exists didn't work") {
        eprintln!(
            "Could not find config directory at `{}`, you need to create it with a config.toml",
            &config_dir
        );
        exit(1);
    }
    if !fs::exists(&config_path).expect("io exists didn't work") {
        eprintln!(
            "Could not find config file at `{}`, you need to create a config.toml",
            &config_path
        );
        exit(1);
    }

    let contents = match fs::read_to_string(&config_path) {
        Ok(c) => c,
        Err(e) => {
            eprintln!(
                "Could not read config file at `{}` for : {}",
                &config_path, e
            );
            exit(1);
        }
    };

    let config: Config = match toml::from_str(&contents) {
        Ok(config) => config,
        Err(e) => {
            eprintln!("Could not load config at `{}` for :{}", config_path, e);
            exit(1);
        }
    };
    config
}

fn main() {
    let projets_list: Box<[Projet]> = get_config().projets;

    let mut args = std::env::args();
    args.next();
    let first = args.next();
    let just = first.is_some_and(|a| a == "--just");

    for projet in projets_list {
        if !just {
            println!("{}", projet.name);
            let res: bool = flakechecker(projet.clone()) && git(projet);
            if res {
                println!("{}", "all".green());
            } else {
                println!("{}", "all".red());
            }
        } else {
            let justfile = &(projet.location.clone() + "/justfile");

            let res = Command::new("nix")
                .args([
                    "develop",
                    &projet.location,
                    "--no-pure-eval",
                    "-c",
                    "just",
                    "-d",
                    &projet.location,
                    "-f",
                    justfile,
                    "all",
                ])
                .status();

            if res.unwrap().success() {
                println!("{} : {}", projet.name, "pass".green());
            } else {
                println!("{} : {}", projet.name, "didn't pass".red());
                exit(1);
            }
        }
    }
}

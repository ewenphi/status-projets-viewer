#this justfile is generated

# print the just commands
default:
    just --list

alias p := pre-commit-all

# launch all the pre-commit hooks on all the files
pre-commit-all:
    pre-commit run --all-files

alias nc := nix-checks

# launch all the checks in a flake if present and nix is available
nix-checks:
    if nix --version; then     nix flake check --no-pure-eval --extra-experimental-features flakes --extra-experimental-features nix-command;  else     echo nix is not available, so the nix checks are skipped;   fi

alias a := all

# launch all the steps
all: pre-commit-all nix-checks

alias w := watch

# launch all the steps (can be very intense on cpu)
watch:
    watchexec just    pre-commit-all

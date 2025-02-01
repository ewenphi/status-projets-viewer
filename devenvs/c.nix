{
  pkgs,
  ...
}:
{
  packages = [ pkgs.clang ];

  git-hooks.hooks = {
    clang-format.enable = true;
  };
}

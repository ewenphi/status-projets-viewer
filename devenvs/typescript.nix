{ pkgs, config, ... }:
{
  enterShell = ''
    echo hello from
  '';

  enterTest = ''
    jest
  '';

  languages = {
    java = {
      enable = true;
      gradle.enable = true;
      jdk.package = pkgs.jdk17;
    };
    javascript = {
      enable = true;
      npm.enable = true;
      npm.install.enable = true;
      package = pkgs.nodejs_latest;
    };
    typescript.enable = true;
  };

  scripts = {
    tests.exec = config.enterTest;
  };

  git-hooks.hooks = {
    prettier.enable = true;
    eslint.enable = true;
  };
}

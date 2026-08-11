{
  pkgs,
  config,
  lib,
  ...
}:

{
  programs.starship = {
    enable = true;
    enableZshIntegration = true;

    settings = {
      add_newline = true;
      scan_timeout = 0;
      format = "$all\n$directory$character";

      line_break = {
        disabled = true;
      };
      command_timeout = 1000;

      character = {
        vicmd_symbol = "\\[N\\] >>>";
        success_symbol = "[➜](bold green)";
      };

      directory.substitutions = { };

      git_branch = {
        format = "[$symbol$branch(:$remote_branch)]($style)";
        style = "bold magenta";
      };

      nix_shell = {
        symbol = "󱄅 ";
        format = "[$symbol$state]($style) ";
        style = "bold cyan";
      };

      custom.nix_files = {
        symbol = "󱄅 ";
        extensions = [ "nix" ];
        files = [
          "flake.nix"
          "shell.nix"
          "default.nix"
        ];
        format = "[$symbol]($style)";
        style = "bold cyan";
      };
    };
  };
}

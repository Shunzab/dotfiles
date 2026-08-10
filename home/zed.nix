{
  config,
  lib,
  pkgs,
  ...
}:

{
  programs.zed-editor = {
    enable = true;
    extensions = [ "nix" ];

    mutableUserSettings = false;
    mutableUserKeymaps = false;
    mutableUserTasks = false;
    mutableUserDebug = false;

    extraPackages = [
      pkgs.nil
    ];

    userSettings = {
      show_whitespaces = "all";
      vim_mode = true;
      load_direnv = "shell_hook";
      lsp = {
        nix.binary = {
          path_lookup = true;
        };
        pyright.binary = {
          path_lookup = true;
        };
      };
      auto_download_models = false;
    };
  };

  systemd.user.tmpfiles.rules = lib.mkIf (!config.programs.zed-editor.enable) [
    "R %h/.config/zed - - - - -"
    "R %h/.local/share/zed - - - - -"
    "R %h/.cache/zed - - - - -"
  ];
}

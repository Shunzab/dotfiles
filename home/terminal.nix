{
  config,
  lib,
  pkgs,
  ...
}:

{
  home.packages = with pkgs; [
    bat
    eza
    ripgrep
    fd
    bottom
    dust

    # for making devenvs in nix
    devenv
  ];

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    defaultKeymap = "viins";

    completionInit = ''
      autoload -Uz compinit && compinit
      zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
      zstyle ':completion:*' menu select
    '';

    shellAliases = {
      cat = "bat";
      ls = "eza";
      grep = "rg";
      find = "fd";
      top = "btm";
      du = "dust";
      l = "eza -l --icons --git -a";
      lt = "eza --tree --level=2 --icons --git";
      cl = "clear";
    };

    initContent = ''
      # Options
      setopt prompt_subst
      setopt auto_cd
      setopt interactive_comments

      # Keybindings
      bindkey 'jj' vi-cmd-mode
      bindkey '^P' up-history
      bindkey '^N' down-history
      bindkey '^L' autosuggest-accept

      # Custom functions
      cx() { cd "$@" && l; }
    '';
  };

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
    options = [
      "--cmd cd"
      "--no-aliases"
    ];
  };

  programs.atuin = {
    enable = true;
    enableZshIntegration = true;

    #flags = [ "--disable-up-arrow" ];

    settings = {
      search_mode = "fuzzy";
      filter_mode = "host";
      style = "compact";
      inline_height = 20;
      show_preview = true;
      enter_accept = false;
      keymap_mode = "vim-normal";
      keymap_cursor = {
        vim_insert = "blink-bar";
        vim_normal = "steady-block";
      };
      update_check = false;
      workspaces = true;
      secrets_filter = true;
      history_filter = [
        "^export"
        "^secret"
      ];
    };
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    enableZshIntegration = true; # Automatically hooks direnv into Zsh
  };
}

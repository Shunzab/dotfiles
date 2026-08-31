{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:

{

  xdg.configFile."nvim".source = ../configs/nvim/lua;

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;

    # Language Servers, Linters, and Formatters installed directly via Nix
    extraPackages = with pkgs; [
      ripgrep # Required for Telescope live_grep
      fd # Required for Telescope file finder

      # lsps nvim-lspconfig
      nil
      lua-language-server

      # formatters conform-nvim
      alejandra
      stylua

      # Linters nvim-lint
      statix
    ];

    # Plugins managed by Nixpkgs
    plugins = with pkgs.vimPlugins; [
      {
        plugin = telescope-nvim;
        type = "lua";
        config = builtins.readFile ./lua/telescope.lua;
      }

      {
        plugin = nvim-treesitter.withAllGrammars;
        type = "lua";
        config = builtins.readFile ./lua/treesitter.lua;
      }

      {
        plugin = plenary-nvim;
      }

      {
        plugin = nvim-lspconfig;
        type = "lua";
        config = builtins.readFile ./lua/lsp.lua;
      }

      {
        plugin = nvim-lint;
        type = "lua";
        config = builtins.readFile ./lua/lint.lua;
      }


      {
        plugin = blink-cmp;
        type = "lua";
        config = builtins.readFile ./lua/completion.lua;
      }

      {
        plugin = conform-nvim;
        type = "lua";
        config = builtins.readFile ./lua/conform.lua;
      }

      {
        plugin = gitsigns-nvim;
        type = "lua";
        config = builtins.readFile ./lua/gitsigns.lua;
      }

      {
        plugin = mini-nvim;
        type = "lua";
        config = builtins.readFile ./lua/mini.lua;
      }


      {
        plugin = rainbow-delimiters-nvim;
        type = "lua";
        config = builtins.readFile ./lua/rainbow-delimiters.lua;
      }


      {
        plugin = trouble-nvim;
        type = "lua";
        config = builtins.readFile ./lua/trouble.lua;
      }
    ];

    initLua = ''

    '';
  };
}


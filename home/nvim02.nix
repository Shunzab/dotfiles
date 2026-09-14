{
  pkgs,
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
    ];

    # Plugins managed by Nixpkgs
    plugins = with pkgs.vimPlugins; [
      {
        plugin = telescope-nvim;
        type = "lua";
        config = builtins.readFile ./lua/plugins/telescope.lua;
      }

      {
        plugin = nvim-treesitter.withAllGrammars;
        type = "lua";
        config = builtins.readFile ./lua/plugins/treesitter.lua;
      }

      {
        plugin = plenary-nvim;
      }

      {
        plugin = direnv-nvim;
        type = "lua";
        config = builtins.readFile ./lua/plugins/direnv.lua;
      }

      {
        plugin = nvim-lspconfig;
        type = "lua";
        config = builtins.readFile ./lua/plugins/lsp.lua;
      }

      {
        plugin = nvim-lint;
        type = "lua";
        config = builtins.readFile ./lua/plugins/lint.lua;
      }

      {
        plugin = blink-cmp;
        type = "lua";
        config = builtins.readFile ./lua/plugins/completion.lua;
      }

      {
        plugin = conform-nvim;
        type = "lua";
        config = builtins.readFile ./lua/plugins/conform.lua;
      }

      {
        plugin = gitsigns-nvim;
        type = "lua";
        config = builtins.readFile ./lua/plugins/gitsigns.lua;
      }

      {
        plugin = mini-nvim;
        type = "lua";
        config = builtins.readFile ./lua/plugins/mini.lua;
      }

      {
        plugin = rainbow-delimiters-nvim;
        type = "lua";
        config = builtins.readFile ./lua/plugins/rainbow-delimiters.lua;
      }

      {
        plugin = trouble-nvim;
        type = "lua";
        config = builtins.readFile ./lua/plugins/trouble.lua;
      }
    ];

    initLua = ''

    '';
  };
}

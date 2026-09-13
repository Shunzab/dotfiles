# gonna use lz-n to manage things, and its alot of work which is gonna extend beyond what i wanted it to extend to.
{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:
{

  xdg.configFile."nvim/lua".source = ../configs/nvim/lua;

  stylix.targets.neovim = {
    enable = true;
    plugin = "mini.base16"; # Options: "base16-nvim" or "mini.base16"
  
  # Optional: Toggle transparency
    transparentBackground = {
      main = true;
      signColumn = true;
    };
  };
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
      telescope-nvim
      telescope-fzf-native-nvim
      nvim-treesitter.withAllGrammars
      nvim-lint
      plenary-nvim
      mini-nvim
      base16-nvim
      lualine-nvim
      nvim-web-devicons
      rainbow-delimiters-nvim
      snacks-nvim
    ];
    initLua = ''
      require("user")
    '';
  };
}

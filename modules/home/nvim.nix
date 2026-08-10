# gonna use lz-n to manage things, and its alot of work which is gonna extend beyond what i wanted it to extend to.
{
  config,
  pkgs,
  lib,
  ...
}:

let
  c = if (config ? lib.stylix.colors.withHashtag) then config.lib.stylix.colors.withHashtag else { };

  bg = c.base00 or "#1a1b26";
  fg = c.base05 or "#c0caf5";
  black = c.base00 or "#15161e";
  red = c.base08 or "#ff757f";
  green = c.base0B or "#c3e88d";
  yellow = c.base0A or "#ffc777";
  blue = c.base0D or "#82aaff";
  magenta = c.base0E or "#c099ff";
  cyan = c.base0C or "#86e1fc";
  bright_blk = c.base03 or "#565f89";
  comment = c.base04 or "#7a88cf";
  selection = c.base02 or "#2e3c64";
in
{
  xdg.configFile."nvim".source = ./configs/nvim;
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;

    # Language Servers, Linters, and Formatters installed directly via Nix
    extraPackages = with pkgs; [
      nil # Nix LSP
      lua-language-server # Lua LSP

      # Formatters & Linters
      alejandra # Nix Formatter
      stylua # Lua Formatter
      statix # Nix Linter
      ripgrep # Required for Telescope live_grep
      fd # Required for Telescope file finder
    ];

    # Plugins managed by Nixpkgs
    plugins = with pkgs.vimPlugins; [
      lz-n
      telescope-nvim
      plenary-nvim
      nvim-treesitter.withAllGrammars
      nvim-lspconfig
      conform-nvim
      nvim-lint
      blink-cmp
      mini-pairs
      mini-surround
    ];

    extraLuaConfig = ''
      require("config.options")
      require("themes.theme")
      require("config.taskbar")
      require("misc.qol")
      require("config.transparency")
      require("themes.indent_lines")
      require("config.keybinds")
      require("plugins.lzn")
    '';
  };
}

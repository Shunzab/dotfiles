{ config, ... }:

let
  c = config.lib.stylix.colors.withHashtag;

  bg         = c.base00;
  fg         = c.base05;
  black      = c.base01;
  red        = c.base08;
  green      = c.base0B;
  yellow     = c.base0A;
  blue       = c.base0D;
  magenta    = c.base0E;
  cyan       = c.base0C;
  bright_blk = c.base03;
  comment    = c.base04;
  selection  = c.base02;
in
{
  # Disable Stylix's standard Neovim target to prevent color conflicts
  stylix.targets.neovim.enable = false;

  # Generate lua file in your nvim config directory
  xdg.configFile."nvim/lua/colors.lua".text = ''
    vim.cmd("highlight clear")
    if vim.fn.exists("syntax_on") == 1 then
      vim.cmd("syntax reset")
    end
    vim.g.colors_name = "stylix_dynamic"

    local c = {
      bg         = "${bg}",
      fg         = "${fg}",
      black      = "${black}",
      red        = "${red}",
      green      = "${green}",
      yellow     = "${yellow}",
      blue       = "${blue}",
      magenta    = "${magenta}",
      cyan       = "${cyan}",
      bright_blk = "${bright_blk}",
      comment    = "${comment}",
      selection  = "${selection}",
    }

    local function hl(group, settings)
      vim.api.nvim_set_hl(0, group, settings)
    end

    -- Editor UI Elements
    hl("Normal",       { fg = c.fg, bg = c.bg })
    hl("NormalFloat",  { fg = c.fg, bg = c.black })
    hl("CursorLine",   { bg = c.selection })
    hl("LineNr",       { fg = c.bright_blk })
    hl("CursorLineNr", { fg = c.yellow, bold = true })
    hl("Visual",       { bg = c.selection })
    hl("SignColumn",   { bg = c.bg })
    hl("ColorColumn",  { bg = c.black })
    hl("StatusLine",   { fg = c.fg, bg = c.black })
    hl("Pmenu",        { fg = c.fg, bg = c.black })
    hl("PmenuSel",     { fg = c.black, bg = c.blue })

    -- Code Syntax Highlighting
    hl("Comment",    { fg = c.comment, italic = true })
    hl("String",     { fg = c.green })
    hl("Number",     { fg = c.yellow })
    hl("Function",   { fg = c.blue })
    hl("Keyword",    { fg = c.magenta, bold = true })
    hl("Statement",  { fg = c.red })
    hl("Type",       { fg = c.cyan })
    hl("Identifier", { fg = c.cyan })
    hl("Constant",   { fg = c.yellow })
    hl("Operator",   { fg = c.blue })
    hl("iCursor",    { bg = c.yellow, fg = c.black })

    vim.opt.guicursor = "n-v-c:block-Cursor,i-ci-ve:ver25-iCursor,r-cr:hor20-Cursor"
  '';
}

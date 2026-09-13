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

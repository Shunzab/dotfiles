-- Reset existing colors
vim.cmd("highlight clear")
if vim.fn.exists("syntax_on") == 1 then
  vim.cmd("syntax reset")
end
vim.g.colors_name = "tokyo_night_moon"

-- 1. Palette definition (Hex values from your Alacritty TOML)

local c = {
  bg        = "#1a1b26",  
  fg        = "#c0caf5", 
  black     = "#15161e",  
  red       = "#ff757f",
  green     = "#c3e88d",
  yellow    = "#ffc777",
  blue      = "#82aaff",
  magenta   = "#c099ff",
  cyan      = "#86e1fc",
  bright_blk= "#565f89",  
  comment   = "#7a88cf",  
  selection = "#2e3c64",  
  }

-- Helper function to set highlights cleanly
local function hl(group, settings)
  vim.api.nvim_set_hl(0, group, settings)
end

-- 2. Editor UI Elements
hl("Normal",       { fg = c.fg, bg = c.bg })
hl("NormalFloat",  { fg = c.fg, bg = c.black })
hl("CursorLine",   { bg = c.selection })
hl("LineNr",       { fg = c.bright_blk })
hl("CursorLineNr", { fg = c.yellow, bold = true })
hl("Visual",       { bg = c.selection })
hl("SignColumn",   { bg = c.bg })
hl("ColorColumn",  { bg = c.black })
hl("StatusLine",   { fg = c.fg, bg = c.black })
hl("Pmenu",        { fg = c.fg, bg = c.black })        -- Completion menu bg
hl("PmenuSel",     { fg = c.black, bg = c.blue })     -- Completion selected item

-- 3. Code Syntax Highlighting
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
hl("iCursor", { bg = c.yellow, fg = c.black })

-- Sets Insert mode (i) cursor to a yellow vertical bar (ver25)
vim.opt.guicursor = "n-v-c:block-Cursor,i-ci-ve:ver25-iCursor,r-cr:hor20-Cursor"

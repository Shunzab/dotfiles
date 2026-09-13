-- 1. Palette definition & Neovim terminal colors
local c = {
  bg         = "#1a1b26",
  fg         = "#c0caf5",
  black      = "#15161e",
  red        = "#ff757f",
  green      = "#c3e88d",
  yellow     = "#ffc777",
  blue       = "#82aaff",
  magenta    = "#c099ff",
  cyan       = "#86e1fc",
  bright_blk = "#565f89",
  comment    = "#7a88cf",
  selection  = "#2e3c64",
}

-- Optional: sync palette with Neovim's built-in terminal
local term_colors = { c.black, c.red, c.green, c.yellow, c.blue, c.magenta, c.cyan, c.fg }
for i, hex in ipairs(term_colors) do
  vim.g["terminal_color_" .. (i - 1)] = hex
end

-- 2. Native indent lines & whitespace indicators
vim.opt.list = true
vim.opt.listchars = {
  tab            = "│ ",
  leadmultispace = "│   ", -- 1 bar + 3 spaces (adjust for your shiftwidth, e.g., 4)
  trail          = "·",
  nbsp           = "␣",
}

-- 3. Batch apply highlight groups
local highlights = {
  Whitespace = { fg = c.bright_blk, bg = "NONE" },
  NonText    = { fg = c.bright_blk, bg = "NONE" },
  LineNr     = { fg = c.bright_blk, bg = "NONE" },
  CursorLine = { bg = "NONE" },
}

for group, opts in pairs(highlights) do
  vim.api.nvim_set_hl(0, group, opts)
end

-- 4. Restrict CursorLine highlight to line numbers only
vim.opt.cursorline = true
vim.opt.cursorlineopt = "number"

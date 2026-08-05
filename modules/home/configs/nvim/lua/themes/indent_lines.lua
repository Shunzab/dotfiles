-- 1. Palette definition
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

local function hl(group, settings)
  vim.api.nvim_set_hl(0, group, settings)
end

-- 2. Native indent lines setup
vim.opt.list = true
vim.opt.listchars = {
  leadmultispace = "│   ", -- Adjust spaces to match your shiftwidth/tabstop
  tab = "│ ",
}

-- 3. Color native guide lines using your palette
hl("Whitespace", { fg = c.bright_blk })
hl("NonText",    { fg = c.bright_blk })

-- 1. Flash Yanked Text (visual confirmation when copying code with 'y')
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.hl.on_yank({ higroup = "IncSearch", timeout = 150 })
  end,
})

-- 2. Restore Cursor Position on Reopening Files
vim.api.nvim_create_autocmd("BufReadPost", {
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local lcount = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- 3. Auto-Create Non-Existent Directories on Save
vim.api.nvim_create_autocmd("BufWritePre", {
  callback = function(event)
    if event.match:match("^%w%w+:[\\/][\\/]") then return end
    local file = vim.uv.fs_realpath(event.match) or event.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
  end,
})

-- Keep sign column fixed to prevent layout shift when diagnostics appear
vim.opt.signcolumn = "yes"

-- 1. Function to apply the highlight fixes
local function fix_cursor_line_nr()
  -- Force yellow text, remove background block completely
  vim.api.nvim_set_hl(0, "CursorLineNr", {
    fg = "#ffc777",
    bg = "NONE",
    bold = true,
    force = true,
  })

  -- Ensure line numbers and sign column stay transparent
  vim.api.nvim_set_hl(0, "LineNr",       { fg = "#565f89", bg = "NONE" })
  vim.api.nvim_set_hl(0, "LineNrAbove",  { fg = "#565f89", bg = "NONE" })
  vim.api.nvim_set_hl(0, "LineNrBelow",  { fg = "#565f89", bg = "NONE" })
  vim.api.nvim_set_hl(0, "SignColumn",   { bg = "NONE" })
end

-- 2. Run inside an autocmd with vim.schedule to beat Stylix's execution order
vim.api.nvim_create_autocmd({ "VimEnter", "ColorScheme" }, {
  pattern = "*",
  callback = function()
    vim.schedule(fix_cursor_line_nr)
  end,
})

-- 3. Run immediately for instant application when sourcing
fix_cursor_line_nr()

local function fix_cursors()
  -- 1. Yellow block cursor for Normal Mode
  vim.api.nvim_set_hl(0, "Cursor", {
    fg = "#15161e",
    bg = "#ffc777",
    force = true,
  })

  -- 2. Yellow bar cursor for Insert Mode
  vim.api.nvim_set_hl(0, "iCursor", {
    fg = "#15161e",
    bg = "#ffc777",
    force = true,
  })
end

-- Map both Cursor and iCursor to guicursor
vim.opt.guicursor = "n-v-c:block-Cursor,i-ci-ve:ver25-iCursor,r-cr:hor20-Cursor"

-- Schedule it so Stylix cannot overwrite it on boot
vim.api.nvim_create_autocmd({ "VimEnter", "ColorScheme" }, {
  pattern = "*",
  callback = function()
    vim.schedule(fix_cursors)
  end,
})

fix_cursors()

-- hides messages like --INSERT-- etc easily.
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    vim.opt.showmode = false
  end,
})

-- ============================================================================
-- 2. PASTE AT CURRENT INDENT LEVEL
-- ============================================================================
-- Corrected: Use ']p' and '[p' (from plugins like vim-unimpaired) or native expressions
vim.keymap.set("n", "p", "]p", { noremap = false, silent = true, desc = "Paste matching current indent" })
vim.keymap.set("n", "P", "[p", { noremap = false, silent = true, desc = "Paste before matching current indent" })

-- Fallback to native raw paste
vim.keymap.set("n", "gp", "p", { noremap = true, silent = true, desc = "Paste raw (original indent)" })
vim.keymap.set("n", "gP", "P", { noremap = true, silent = true, desc = "Paste raw before (original indent)" })

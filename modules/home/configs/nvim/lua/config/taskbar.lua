-- 1. General Configuration
vim.opt.showmode = false          -- Hide default '-- INSERT --' text at bottom
vim.opt.showcmd = false           -- DISABLE keypresses & selection numbers below statusbar
vim.opt.ruler = false             -- DISABLE default ruler info below statusbar
vim.opt.showtabline = 0           -- Disable top buffer tab bar
vim.opt.laststatus = 3            -- Single global statusline across window splits

-- 2. Dynamic Mode Colors
local modes = {
  n       = { name = "NORMAL",  hl = "StNormalMode",  color = "#82aaff" },
  i       = { name = "INSERT",  hl = "StInsertMode",  color = "#c3e88d" },
  v       = { name = "VISUAL",  hl = "StVisualMode",  color = "#c099ff" },
  V       = { name = "V-LINE",  hl = "StVisualMode",  color = "#c099ff" },
  ["\22"] = { name = "V-BLOCK", hl = "StVisualMode",  color = "#c099ff" },
  c       = { name = "COMMAND", hl = "StCmdMode",     color = "#ffc777" },
  R       = { name = "REPLACE", hl = "StReplaceMode", color = "#ff757f" },
  t       = { name = "TERMINAL",hl = "StTermMode",    color = "#86e1fc" },
}

local function setup_statusline_hls()
  for _, m in pairs(modes) do
    vim.api.nvim_set_hl(0, m.hl, { fg = "#15161e", bg = m.color, bold = true })
    vim.api.nvim_set_hl(0, m.hl .. "Sep", { fg = m.color, bg = "#1b1d2b" })
    vim.api.nvim_set_hl(0, m.hl .. "RightSep", { fg = m.color, bg = "#15161e" })
  end
  vim.api.nvim_set_hl(0, "StBg", { fg = "#c0caf5", bg = "#1b1d2b" })

  -- Custom Statusline Highlights
  vim.api.nvim_set_hl(0, "StVisualSel", { fg = "#c099ff", bg = "#1b1d2b", bold = true })
  vim.api.nvim_set_hl(0, "StErr",       { fg = "#ff757f", bg = "#1b1d2b", bold = true })
  vim.api.nvim_set_hl(0, "StWarn",      { fg = "#ffc777", bg = "#1b1d2b", bold = true })
  vim.api.nvim_set_hl(0, "StInfo",      { fg = "#82aaff", bg = "#1b1d2b" })
  vim.api.nvim_set_hl(0, "StHint",      { fg = "#86e1fc", bg = "#1b1d2b" })
  vim.api.nvim_set_hl(0, "StMacro",     { fg = "#ff757f", bg = "#1b1d2b", bold = true })
  vim.api.nvim_set_hl(0, "StSearch",    { fg = "#ffc777", bg = "#1b1d2b", bold = true })
end

setup_statusline_hls()
vim.api.nvim_create_autocmd("ColorScheme", { callback = setup_statusline_hls })

-- 3. Helpers & Visual Selection Counter
local function get_file_icon(fname)
  if fname:match("%.lua$") then return " "
  elseif fname:match("%.py$") then return " "
  elseif fname:match("%.js$") or fname:match("%.ts$") then return " "
  elseif fname:match("%.nix$") then return " "
  elseif fname:match("%.json$") or fname:match("%.toml$") then return " "
  end
  return "󰈙 "
end

local function get_git_branch()
  local handle = io.popen("git rev-parse --abbrev-ref HEAD 2>/dev/null")
  if not handle then return "" end
  local result = handle:read("*a"):gsub("%s+", "")
  handle:close()
  return result ~= "" and ("  " .. result .. " ") or ""
end

vim.api.nvim_create_autocmd({ "BufEnter", "FocusGained" }, {
  callback = function() vim.b.git_branch = get_git_branch() end,
})

-- Visual Mode Selection Count (Appears inside statusbar when selecting)
local function get_visual_selection()
  local mode = vim.api.nvim_get_mode().mode
  if not (mode == "v" or mode == "V" or mode == "\22") then
    return ""
  end

  local line_start = vim.fn.line("v")
  local line_end = vim.fn.line(".")
  local lines = math.abs(line_end - line_start) + 1

  if mode == "V" then
    return string.format("%%#StVisualSel# 󰈈 %d lines %%#StBg#", lines)
  elseif mode == "\22" then
    local col_start = vim.fn.col("v")
    local col_end = vim.fn.col(".")
    local cols = math.abs(col_end - col_start) + 1
    return string.format("%%#StVisualSel# 󰈈 %dx%d block %%#StBg#", lines, cols)
  else
    if lines > 1 then
      return string.format("%%#StVisualSel# 󰈈 %d lines %%#StBg#", lines)
    else
      local col_start = vim.fn.col("v")
      local col_end = vim.fn.col(".")
      local chars = math.abs(col_end - col_start) + 1
      return string.format("%%#StVisualSel# 󰈈 %d chars %%#StBg#", chars)
    end
  end
end

-- LSP Diagnostic Count
local function get_lsp_diagnostics()
  if not rawget(vim, "diagnostic") then return "" end
  local e, w, i, h = 0, 0, 0, 0
  if vim.diagnostic.count then
    local count = vim.diagnostic.count(0)
    e = count[vim.diagnostic.severity.ERROR] or 0
    w = count[vim.diagnostic.severity.WARN] or 0
    i = count[vim.diagnostic.severity.INFO] or 0
    h = count[vim.diagnostic.severity.HINT] or 0
  else
    e = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
    w = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
    i = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO })
    h = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT })
  end

  local res = {}
  if e > 0 then table.insert(res, "%#StErr# " .. e) end
  if w > 0 then table.insert(res, "%#StWarn# " .. w) end
  if i > 0 then table.insert(res, "%#StInfo# " .. i) end
  if h > 0 then table.insert(res, "%#StHint#󰌵 " .. h) end

  return #res > 0 and (" " .. table.concat(res, " ") .. " ") or ""
end

-- Active Search Counter
local function get_search_count()
  if vim.v.hlsearch == 0 then return "" end
  local ok, res = pcall(vim.fn.searchcount, { maxcount = 999, timeout = 100 })
  if not ok or res.total == 0 then return "" end
  return "%#StSearch#  " .. res.current .. "/" .. res.total .. " "
end

-- Macro Recording Indicator
local function get_macro_recording()
  local reg = vim.fn.reg_recording()
  if reg == "" then return "" end
  return "%#StMacro# 󰑋 REC @" .. reg .. " "
end

-- Filetype with Nerd Font Icon
local function get_filetype()
  local ft = vim.bo.filetype
  if ft == "" then return "" end
  local filename = vim.fn.expand("%:t")
  return " " .. get_file_icon(filename) .. ft .. " "
end

-- 4. Main Statusline Render Function
function MyStatusline()
  local m = vim.api.nvim_get_mode().mode
  local mode_info = modes[m] or { name = "NORMAL", hl = "StNormalMode" }
  local mode_hl = "%#" .. mode_info.hl .. "#"
  local sep_hl = "%#" .. mode_info.hl .. "Sep#"
  local right_sep_hl = "%#" .. mode_info.hl .. "RightSep#"

  local filename = vim.fn.expand("%:t")
  if filename == "" then filename = "[No Name]" end
  local icon = get_file_icon(filename)

  return table.concat({
    mode_hl, " ", mode_info.name, " ",            -- Mode block
    sep_hl, "",                                 -- Powerline Arrow
    "%#StBg#",
    "%{get(b:, 'git_branch', '')}",               -- Git branch
    " ", icon, filename, " %m%r",                -- File icon + filename
    get_visual_selection(),                       -- Main bar selection badge (󰈈 9 lines)
    get_lsp_diagnostics(),                        -- LSP Diagnostics
    get_macro_recording(),                        -- Macro recording
    get_search_count(),                           -- Search counter
    "%=",                                         -- Right-align separator
    "%#StBg#",
    get_filetype(),                               --  lua
    "  %L lines | %p%% ",                        -- Total lines + %
    right_sep_hl, "",                           -- Powerline Arrow Left
    mode_hl, " %l:%c ",                           -- Cursor position
  })
end

vim.opt.statusline = "%!v:lua.MyStatusline()"

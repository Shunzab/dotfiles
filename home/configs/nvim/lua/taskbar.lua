-- 1. General Configuration
vim.opt.showmode = false
vim.opt.showcmd = false
vim.opt.ruler = false
vim.opt.showtabline = 0
vim.opt.laststatus = 3

local api, fn, bo = vim.api, vim.fn, vim.bo
local augroup = api.nvim_create_augroup("CustomStatusline", { clear = true })

-- 2. Dynamic Palette / Modes

local function get_hl_color(group, attr, fallback)
  local hl = api.nvim_get_hl(0, { name = group, link = false })
  return hl and hl[attr] or fallback
end

local modes = {
  n       = { name = "NORMAL",   hl = "StNormalMode" },
  i       = { name = "INSERT",   hl = "StInsertMode" },
  v       = { name = "VISUAL",   hl = "StVisualMode" },
  V       = { name = "V-LINE",   hl = "StVisualMode" },
  ["\22"] = { name = "V-BLOCK",  hl = "StVisualMode" },
  s       = { name = "SELECT",   hl = "StVisualMode" },
  S       = { name = "S-LINE",   hl = "StVisualMode" },
  ["\19"] = { name = "S-BLOCK",  hl = "StVisualMode" },
  c       = { name = "COMMAND",  hl = "StCmdMode" },
  R       = { name = "REPLACE",  hl = "StReplaceMode" },
  r       = { name = "PROMPT",   hl = "StReplaceMode" },
  t       = { name = "TERMINAL", hl = "StTermMode" },
}

local function set_hl(name, opts)
  api.nvim_set_hl(0, name, opts)
end

local function setup_statusline_hls()
  -- Fetch active theme colors with fallbacks
  local palette = {
    bg      = get_hl_color("StatusLine", "bg") or get_hl_color("Normal", "bg", "#1b1d2b"),
    alt_bg  = get_hl_color("StatusLineNC", "bg") or get_hl_color("CursorLine", "bg", "#15161e"),
    fg      = get_hl_color("StatusLine", "fg") or get_hl_color("Normal", "fg", "#c0caf5"),
    dim     = get_hl_color("Comment", "fg", "#787c99"),
    blue    = get_hl_color("Function", "fg") or get_hl_color("Directory", "fg", "#82aaff"),
    green   = get_hl_color("String", "fg") or get_hl_color("DiagnosticOk", "fg", "#c3e88d"),
    purple  = get_hl_color("Statement", "fg") or get_hl_color("Keyword", "fg", "#c099ff"),
    yellow  = get_hl_color("DiagnosticWarn", "fg") or get_hl_color("WarningMsg", "fg", "#ffc777"),
    red     = get_hl_color("DiagnosticError", "fg") or get_hl_color("ErrorMsg", "fg", "#ff757f"),
    cyan    = get_hl_color("DiagnosticInfo", "fg") or get_hl_color("Special", "fg", "#86e1fc"),
  }

  -- Assign dynamic mode colors
  modes.n.color       = palette.blue
  modes.i.color       = palette.green
  modes.v.color       = palette.purple
  modes.V.color       = palette.purple
  modes["\22"].color = palette.purple
  modes.s.color       = palette.purple
  modes.S.color       = palette.purple
  modes["\19"].color = palette.purple
  modes.c.color       = palette.yellow
  modes.R.color       = palette.red
  modes.r.color       = palette.red
  modes.t.color       = palette.cyan

  for _, m in pairs(modes) do
    set_hl(m.hl, { fg = palette.alt_bg, bg = m.color, bold = true })
    set_hl(m.hl .. "Sep", { fg = m.color, bg = palette.bg })
    set_hl(m.hl .. "RightSep", { fg = m.color, bg = palette.alt_bg })
  end

  set_hl("StBg",        { fg = palette.fg, bg = palette.bg })
  set_hl("StDim",       { fg = palette.dim, bg = palette.bg })
  set_hl("StVisualSel", { fg = palette.purple, bg = palette.bg, bold = true })
  set_hl("StErr",       { fg = palette.red, bg = palette.bg, bold = true })
  set_hl("StWarn",      { fg = palette.yellow, bg = palette.bg, bold = true })
  set_hl("StInfo",      { fg = palette.blue, bg = palette.bg })
  set_hl("StHint",      { fg = palette.cyan, bg = palette.bg })
  set_hl("StMacro",     { fg = palette.red, bg = palette.bg, bold = true })
  set_hl("StSearch",    { fg = palette.yellow, bg = palette.bg, bold = true })
  set_hl("StModified",  { fg = palette.yellow, bg = palette.bg, bold = true })
  set_hl("StReadOnly",  { fg = palette.red, bg = palette.bg, bold = true })
  set_hl("StCrumbs",    { fg = palette.dim, bg = palette.bg })
  set_hl("StAdd",       { fg = palette.green, bg = palette.bg, bold = true })
  set_hl("StChange",    { fg = palette.yellow, bg = palette.bg, bold = true })
  set_hl("StDelete",    { fg = palette.red, bg = palette.bg, bold = true })
  set_hl("StLsp",       { fg = palette.cyan, bg = palette.bg })
  set_hl("StMeta",      { fg = palette.dim, bg = palette.bg })
end

setup_statusline_hls()
api.nvim_create_autocmd("ColorScheme", {
  group = augroup,
  callback = setup_statusline_hls,
})

-- 3. Helpers

local function stl_escape(s)
  return (s or ""):gsub("%%", "%%%%"):gsub("\n", " ")
end

local function clean_text(s, maxlen)
  s = stl_escape(s)
  s = s:gsub("%s+", " "):gsub("^%s+", ""):gsub("%s+$", "")
  if maxlen and #s > maxlen then
    s = s:sub(1, maxlen - 1) .. "…"
  end
  return s
end

local has_devicons, devicons = pcall(require, "nvim-web-devicons")
local file_icons = {
  lua = " ",
  py = " ",
  js = " ",
  ts = " ",
  jsx = " ",
  tsx = " ",
  nix = " ",
  json = " ",
  toml = " ",
  md = " ",
  css = " ",
  html = " ",
  sh = " ",
  rs = " ",
  go = " ",
  c = " ",
  cpp = " ",
  java = " ",
  yml = " ",
  yaml = " ",
}

local function get_file_icon(name)
  local tail = fn.fnamemodify(name, ":t")
  if has_devicons then
    local icon = devicons.get_icon(tail, fn.fnamemodify(tail, ":e"), { default = true })
    return (icon or "󰈙") .. " "
  end
  local ext = fn.fnamemodify(tail, ":e")
  return file_icons[ext] or "󰈙 "
end

local function get_display_name(bufnr, is_narrow)
  local name = api.nvim_buf_get_name(bufnr)
  local bt = bo[bufnr].buftype

  local display
  if bt == "terminal" then
    display = "terminal"
  elseif bt == "help" then
    display = "help:" .. fn.fnamemodify(name, ":t:r")

  elseif bt == "quickfix" then
    display = "[Quickfix]"
  elseif bt == "nofile" and name ~= "" then
    display = fn.fnamemodify(name, ":t")
  elseif name == "" then
    display = "[No Name]"
  else
    display = fn.fnamemodify(name, ":~:.")

    if is_narrow then
      display = fn.pathshorten(display)
    end
  end

  return clean_text(display)
end

-- 4. Git branch cache / updater

local git_cache = {}
local git_pending = {}

local function find_git_root(bufnr)
  local name = api.nvim_buf_get_name(bufnr)
  if name == "" then
    return nil
  end

  local dir = vim.fs.dirname(name)
  if not dir then
    return nil
  end

  local git_marker = vim.fs.find(".git", {
    path = dir,
    upward = true,
    limit = 1,
  })[1]

  return git_marker and vim.fs.dirname(git_marker) or nil
end

local function update_git_branch(bufnr, force)
  bufnr = bufnr or api.nvim_get_current_buf()
  if not api.nvim_buf_is_valid(bufnr) then
    return
  end

  if bo[bufnr].buftype ~= "" then
    vim.b[bufnr].git_branch = ""
    return
  end

  local root = find_git_root(bufnr)
  if not root then

    vim.b[bufnr].git_branch = ""
    return
  end

  if not force and git_cache[root] ~= nil then
    vim.b[bufnr].git_branch = git_cache[root]
    return
  end

  if git_pending[root] then
    git_pending[root][bufnr] = true
    return
  end

  git_pending[root] = { [bufnr] = true }

  vim.system(
    { "git", "-C", root, "rev-parse", "--abbrev-ref", "HEAD" },
    { text = true },
    function(obj)
      local branch = ""
      if obj.code == 0 and obj.stdout then
        branch = obj.stdout:gsub("%s+$", "")
        if branch == "HEAD" then
          branch = "DETACHED"
        end
      end

      local text = branch ~= "" and ("  " .. stl_escape(branch) .. " ") or ""
      git_cache[root] = text

      local waiting = git_pending[root]
      git_pending[root] = nil

      vim.schedule(function()
        if waiting then
          for b in pairs(waiting) do
            if api.nvim_buf_is_valid(b) then
              vim.b[b].git_branch = text
            end
          end
        end
        vim.cmd.redrawstatus()
      end)
    end
  )
end

api.nvim_create_autocmd("BufEnter", {
  group = augroup,
  callback = function(args)
    update_git_branch(args.buf, false)
  end,
})

api.nvim_create_autocmd({ "FocusGained", "DirChanged" }, {
  group = augroup,
  callback = function()
    local bufnr = api.nvim_get_current_buf()
    local root = find_git_root(bufnr)
    if root then
      git_cache[root] = nil
    end
    update_git_branch(bufnr, true)
  end,
})

-- 5. Diagnostics cache

local diag_cache = {}

local function update_diagnostics(bufnr)
  if not rawget(vim, "diagnostic") or not api.nvim_buf_is_valid(bufnr) then
    return

  end

  if vim.diagnostic.count then
    local count = vim.diagnostic.count(bufnr)
    diag_cache[bufnr] = {
      e = count[vim.diagnostic.severity.ERROR] or 0,
      w = count[vim.diagnostic.severity.WARN] or 0,
      i = count[vim.diagnostic.severity.INFO] or 0,
      h = count[vim.diagnostic.severity.HINT] or 0,
    }
    return
  end

  local counts = { e = 0, w = 0, i = 0, h = 0 }
  for _, d in ipairs(vim.diagnostic.get(bufnr)) do
    if d.severity == vim.diagnostic.severity.ERROR then
      counts.e = counts.e + 1
    elseif d.severity == vim.diagnostic.severity.WARN then
      counts.w = counts.w + 1
    elseif d.severity == vim.diagnostic.severity.INFO then
      counts.i = counts.i + 1
    elseif d.severity == vim.diagnostic.severity.HINT then
      counts.h = counts.h + 1
    end
  end

  diag_cache[bufnr] = counts

end

api.nvim_create_autocmd({ "DiagnosticChanged", "BufEnter" }, {
  group = augroup,
  callback = function(args)
    update_diagnostics(args.buf)
    vim.cmd.redrawstatus()
  end,
})

api.nvim_create_autocmd("BufWipeout", {
  group = augroup,
  callback = function(args)
    diag_cache[args.buf] = nil
  end,
})

-- 6. Breadcrumb cache (Tree-sitter)

local function update_breadcrumb(bufnr)
  bufnr = bufnr or api.nvim_get_current_buf()
  vim.b[bufnr].st_crumbs = ""

  if bo[bufnr].buftype ~= "" then
    return
  end

  local ok, node = pcall(vim.treesitter.get_node)
  if not ok or not node then
    return
  end

  local crumbs = {}

  while node do
    local node_type = node:type()
    local name

    if node_type:match("function")
      or node_type:match("method")
      or node_type:match("class")
      or node_type:match("interface")
      or node_type:match("module")
    then
      local name_node = node:field("name")[1]
      if name_node then
        name = vim.treesitter.get_node_text(name_node, bufnr)
      end
    elseif node_type == "binding" then
      local attrpath = node:field("attrpath")[1]
      if attrpath then
        name = vim.treesitter.get_node_text(attrpath, bufnr)
      end
    elseif node_type == "element" then
      local start_tag = node:child(0)
      if start_tag then
        for child in start_tag:iter_children() do
          if child:type() == "tag_name" then
            name = "<" .. vim.treesitter.get_node_text(child, bufnr) .. ">"
            break
          end
        end
      end
    elseif node_type == "rule_set" then
      local selectors = node:child(0)
      if selectors then
        name = vim.treesitter.get_node_text(selectors, bufnr)
      end
    elseif node_type == "atx_heading" or node_type == "setext_heading" or node_type == "heading" then
      name = vim.treesitter.get_node_text(node, bufnr)
      name = name:gsub("^#+%s*", "")
    else
      local key_field = node:field("key")
      if key_field and key_field[1] then
        name = vim.treesitter.get_node_text(key_field[1], bufnr)
        name = name:gsub('"', ""):gsub("'", "")
      end
    end

    if name then
      name = clean_text(name:gsub("\n.*", ""), 24)
      if name ~= "" and name ~= crumbs[1] then
        table.insert(crumbs, 1, name)

      end
    end

    node = node:parent()
  end

  if #crumbs == 0 then
    return
  end

  if #crumbs > 3 then
    crumbs = { "…", crumbs[#crumbs - 1], crumbs[#crumbs] }
  end

  vim.b[bufnr].st_crumbs = "%#StCrumbs# 󰌵 " .. table.concat(crumbs, " ❯ ") .. "%#StBg#"
end


api.nvim_create_autocmd({ "BufEnter", "CursorMoved", "InsertLeave" }, {
  group = augroup,
  callback = function(args)
    pcall(update_breadcrumb, args.buf)
  end,
})

-- 7. Segments

local function get_buffer_flags(bufnr)
  local flags = {}

  if bo[bufnr].modified then
    flags[#flags + 1] = "%#StModified#󰏫%#StBg#"
  end

  if bo[bufnr].readonly then
    flags[#flags + 1] = "%#StReadOnly#󰌾%#StBg#"
  end

  if not bo[bufnr].modifiable then
    flags[#flags + 1] = "%#StReadOnly#󰏯%#StBg#"
  end

  return #flags > 0 and (" " .. table.concat(flags, " ")) or ""
end

local function get_visual_selection()
  local mode = api.nvim_get_mode().mode
  if mode ~= "v" and mode ~= "V" and mode ~= "\22" then
    return ""
  end

  local line_start = fn.line("v")
  local line_end = fn.line(".")
  local lines = math.abs(line_end - line_start) + 1

  if mode == "V" then
    return "%#StVisualSel# 󰈈 " .. lines .. " lines %#StBg#"
  end

  local col_start = fn.virtcol("v")
  local col_end = fn.virtcol(".")
  local cols = math.abs(col_end - col_start) + 1

  if mode == "\22" then
    return "%#StVisualSel# 󰈈 " .. lines .. "x" .. cols .. " block %#StBg#"
  end

  if lines > 1 then
    return "%#StVisualSel# 󰈈 " .. lines .. " lines %#StBg#"
  end

  return "%#StVisualSel# 󰈈 " .. cols .. " chars %#StBg#"
end

local function get_lsp_diagnostics(bufnr)
  local d = diag_cache[bufnr]
  if not d then

    update_diagnostics(bufnr)
    d = diag_cache[bufnr]
  end
  if not d then
    return ""
  end

  local res = {}
  if d.e > 0 then res[#res + 1] = "%#StErr# " .. d.e end
  if d.w > 0 then res[#res + 1] = "%#StWarn# " .. d.w end
  if d.i > 0 then res[#res + 1] = "%#StInfo# " .. d.i end
  if d.h > 0 then res[#res + 1] = "%#StHint#󰌵 " .. d.h end

  return #res > 0 and (" " .. table.concat(res, " ") .. "%#StBg# ") or ""
end

local function get_search_count()
  if vim.v.hlsearch == 0 then
    return ""
  end

  local ok, res = pcall(fn.searchcount, { maxcount = 999, timeout = 60 })
  if not ok or not res or res.total == 0 then
    return ""
  end

  local total = tostring(res.total)
  if res.incomplete == 1 or res.incomplete == 2 then
    total = tostring(res.maxcount or res.total) .. "+"
  end

  -- The fix is in the line below: (res.current or 0)
  return "%#StSearch#  " .. (res.current or 0) .. "/" .. total .. " %#StBg#"
end

local function get_macro_recording()
  local reg = fn.reg_recording()
  if reg == "" then
    return ""
  end
  return "%#StMacro# 󰑋 REC @" .. stl_escape(reg) .. " %#StBg#"
end

local function get_filetype(bufnr, is_tiny)
  if is_tiny then
    return ""
  end
  local ft = bo[bufnr].filetype
  if ft == "" then
    return ""
  end
  return "%#StMeta# " .. stl_escape(ft) .. " %#StBg#"
end

local function get_file_meta(bufnr, is_narrow)
  if is_narrow then
    return ""
  end
  local ff = bo[bufnr].fileformat
  local enc = bo[bufnr].fileencoding ~= "" and bo[bufnr].fileencoding or vim.o.encoding
  return "%#StMeta# " .. stl_escape(ff) .. " " .. stl_escape(enc) .. " %#StBg#"
end

local function get_lsp_clients(bufnr, is_narrow)
  if is_narrow or not rawget(vim, "lsp") then
    return ""
  end

  local clients = vim.lsp.get_clients({ bufnr = bufnr })
  if not clients or #clients == 0 then
    return ""
  end

  local names = {}
  for _, client in ipairs(clients) do
    names[#names + 1] = client.name
  end

  if #names == 0 then
    return ""
  end

  local text
  if #names > 2 then
    text = names[1] .. ",+" .. (#names - 1)
  else
    text = table.concat(names, ",")
  end

  return "%#StLsp#  " .. stl_escape(text) .. " %#StBg#"
end

local function get_git_diff(bufnr, is_tiny)
  if is_tiny then
    return ""
  end

  local gs = vim.b[bufnr].gitsigns_status_dict
  if type(gs) ~= "table" then
    return ""
  end

  local parts = {}
  if (gs.added or 0) > 0 then

    parts[#parts + 1] = "%#StAdd#+" .. gs.added
  end
  if (gs.changed or 0) > 0 then
    parts[#parts + 1] = "%#StChange#~" .. gs.changed
  end
  if (gs.removed or 0) > 0 then
    parts[#parts + 1] = "%#StDelete#-" .. gs.removed
  end

  return #parts > 0 and (" " .. table.concat(parts, " ") .. "%#StBg# ") or ""
end

local function get_position_info(is_tiny)
  return is_tiny and " %p%% " or "  %L lines | %p%% "
end

-- 8. Main Statusline
_G.MyStatusline = function()
  local winid = vim.g.statusline_winid or api.nvim_get_current_win()
  local bufnr = api.nvim_win_get_buf(winid)
  local width = api.nvim_win_get_width(winid)

  local is_narrow = width < 100
  local is_tiny = width < 70

  local mode_raw = api.nvim_get_mode().mode
  local mode_info = modes[mode_raw] or modes[mode_raw:sub(1, 1)] or modes.n

  local mode_hl = "%#" .. mode_info.hl .. "#"
  local sep_hl = "%#" .. mode_info.hl .. "Sep#"
  local right_sep_hl = "%#" .. mode_info.hl .. "RightSep#"

  local raw_name = api.nvim_buf_get_name(bufnr)
  local display_name = get_display_name(bufnr, is_narrow)
  local icon = get_file_icon(raw_name ~= "" and raw_name or display_name)

  local git_branch = is_tiny and "" or (vim.b[bufnr].git_branch or "")
  local breadcrumbs = is_narrow and "" or (vim.b[bufnr].st_crumbs or "")

  return table.concat({
    mode_hl, " ", mode_info.name, " ",
    sep_hl, "",
    "%#StBg#",
    git_branch,
    " %<", icon, display_name,
    get_buffer_flags(bufnr),
    get_git_diff(bufnr, is_tiny),
    breadcrumbs,
    get_visual_selection(),
    get_lsp_diagnostics(bufnr),
    get_macro_recording(),
    get_search_count(),
    "%=",
    "%#StBg#",
    get_lsp_clients(bufnr, is_narrow),
    get_file_meta(bufnr, is_narrow),
    get_filetype(bufnr, is_tiny),
    get_position_info(is_tiny),
    right_sep_hl, "",
    mode_hl, " %l:%c ",
  })
end

vim.opt.statusline = "%!v:lua.MyStatusline()"

-- 9. Force redraw for async / event-driven segments
api.nvim_create_autocmd({ "RecordingEnter", "RecordingLeave", "LspAttach", "LspDetach" }, {
  group = augroup,
  callback = function()
    vim.cmd.redrawstatus()
  end,
})

local lualine = require("lualine")

-- Custom Mode Name Mapping
local mode_map = {
  ['n']     = 'NORMAL',
  ['i']     = 'INSERT',
  ['v']     = 'VISUAL',
  ['V']     = 'V-LINE',
  ['\22']  = 'V-BLOCK',
  ['s']     = 'SELECT',
  ['S']     = 'S-LINE',
  ['\19']  = 'S-BLOCK',
  ['c']     = 'COMMAND',
  ['R']     = 'REPLACE',
  ['r']     = 'PROMPT',
  ['t']     = 'TERMINAL',
}

-- Custom Components matching your script
local function treesitter_breadcrumbs()
  local ok, node = pcall(vim.treesitter.get_node)
  if not ok or not node then return "" end

  local crumbs = {}
  while node do
    local node_type = node:type()
    local name

    if node_type:match("function") or node_type:match("method") or node_type:match("class") or node_type:match("interface") or node_type:match("module") then
      local name_node = node:field("name")[1]
      if name_node then name = vim.treesitter.get_node_text(name_node, 0) end
    elseif node_type == "binding" then
      local attrpath = node:field("attrpath")[1]
      if attrpath then name = vim.treesitter.get_node_text(attrpath, 0) end
    elseif node_type == "atx_heading" or node_type == "heading" then
      name = vim.treesitter.get_node_text(node, 0):gsub("^#+%s*", "")
    end

    if name then
      name = name:gsub("\n.*", ""):gsub("^%s+", ""):gsub("%s+$", "")
      if #name > 24 then name = name:sub(1, 23) .. "…" end
      if name ~= "" and name ~= crumbs[1] then
        table.insert(crumbs, 1, name)
      end
    end
    node = node:parent()
  end

  if #crumbs == 0 then return "" end
  if #crumbs > 3 then crumbs = { "…", crumbs[#crumbs - 1], crumbs[#crumbs] } end
  return "󰌵 " .. table.concat(crumbs, " ❯ ")
end

local function visual_selection()
  local mode = vim.api.nvim_get_mode().mode
  if mode ~= "v" and mode ~= "V" and mode ~= "\22" then return "" end

  local line_start, line_end = vim.fn.line("v"), vim.fn.line(".")
  local lines = math.abs(line_end - line_start) + 1

  if mode == "V" then return "󰈈 " .. lines .. " lines" end

  local col_start, col_end = vim.fn.virtcol("v"), vim.fn.virtcol(".")
  local cols = math.abs(col_end - col_start) + 1

  if mode == "\22" then return "󰈈 " .. lines .. "x" .. cols .. " block" end
  if lines > 1 then return "󰈈 " .. lines .. " lines" end
  return "󰈈 " .. cols .. " chars"
end

local function macro_recording()
  local reg = vim.fn.reg_recording()
  return reg ~= "" and ("󰑋 REC @" .. reg) or ""
end

local function search_count()
  if vim.v.hlsearch == 0 then return "" end
  local ok, res = pcall(vim.fn.searchcount, { maxcount = 999, timeout = 60 })
  if not ok or not res or res.total == 0 then return "" end
  local total = tostring(res.total)
  if res.incomplete == 1 or res.incomplete == 2 then
    total = tostring(res.maxcount or res.total) .. "+"
  end
  return " " .. (res.current or 0) .. "/" .. total
end

local function lsp_clients()
  local clients = vim.lsp.get_clients({ bufnr = 0 })
  if #clients == 0 then return "" end
  local names = {}
  for _, client in ipairs(clients) do
    table.insert(names, client.name)
  end
  local text = #names > 2 and (names[1] .. ",+" .. (#names - 1)) or table.concat(names, ",")
  return " " .. text
end

local function file_meta()
  local ff = vim.bo.fileformat
  local enc = vim.bo.fileencoding ~= "" and vim.bo.fileencoding or vim.o.encoding
  return ff .. " " .. enc
end

-- Lualine Setup
lualine.setup({
  options = {
    theme = "auto", -- Let Stylix automatically handle colors via active colorscheme
    globalstatus = true,
    component_separators = { left = "", right = "" },
    section_separators = { left = "", right = "" },
    disabled_filetypes = { statusline = { "dashboard", "alpha" } },
  },
  sections = {
    lualine_a = {
      {
        "mode",
        fmt = function(str)
          local mode_code = vim.api.nvim_get_mode().mode
          return mode_map[mode_code] or mode_map[mode_code:sub(1, 1)] or str
        end,
      },
    },
    lualine_b = {
      { "branch", icon = "" },
      { "filename", path = 1, symbols = { modified = "󰏫", readonly = "󰌾", unnamed = "[No Name]" } },
      {
        "diff",
        symbols = { added = "+", modified = "~", removed = "-" },
      },
      { treesitter_breadcrumbs },
    },
    lualine_c = {
      { visual_selection },
      {
        "diagnostics",
        symbols = { error = " ", warn = " ", info = " ", hint = "󰌵 " },
      },
      { macro_recording },
      { search_count },
    },
    lualine_x = {
      { lsp_clients },
      { file_meta },
      { "filetype" },
    },
    lualine_y = {
      {
        function()
          return string.format(" %d lines | %%p%%%%", vim.api.nvim_buf_line_count(0))
        end,
      },
    },
    lualine_z = {
      { "%l:%c" },
    },
  },
})

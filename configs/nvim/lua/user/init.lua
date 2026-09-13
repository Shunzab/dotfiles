require("user.config.options")
require("user.misc.qol")
require("user.config.transparency")
--require("user.themes.indent_lines")
require("user.config.keybinds")
require("user.config.lualine")

vim.g.netrw_banner = 0     -- Hides the introductory banner instructions
vim.g.netrw_liststyle = 3  -- Tree view style listing
vim.g.netrw_winsize = 25   -- Limits width when spawning split views
vim.g.netrw_keepdir = 0


local rainbow = require("rainbow-delimiters")

vim.g.rainbow_delimiters = {
  strategy = { [""] = rainbow.strategy["global"] },
  query = { [""] = "rainbow-delimiters" },
  highlight = {
    "RainbowDelimiterRed",
    "RainbowDelimiterYellow",
    "RainbowDelimiterBlue",
    "RainbowDelimiterOrange",
    "RainbowDelimiterGreen",
    "RainbowDelimiterViolet",
    "RainbowDelimiterCyan",
  },
}
require("snacks").setup({
  indent = {
    enabled = true,
    priority = 1,
    char = "│",
    only_scope = false, -- Keeps background lines visible across the entire file
    only_current = false, -- Shows indent markers for all levels

    -- Active scope configuration (replaces mini.indentscope)
    scope = {
      enabled = true,
      priority = 200,
      char = "│",
      underline = false, -- Highlights the start/end lines of the scope block
      only_current = false, -- Keeps outer parent scopes visible
      hl = "SnacksIndentScope", -- Uses your theme's active accent color
    },

    -- Chunk/Block indicators
    chunk = {
      enabled = true,
      only_current = false,
      hl = "SnacksIndentChunk",
      char = {
        corner_top = "┌",
        corner_bottom = "└",
        horizontal = "─",
        vertical = "│",
        arrow = ">",
      },
    },

    -- Enable rainbow indent guides
    rainbow = {
      enabled = true,
      -- Cycles through standard theme color groups automatically
      hl = {
        "SnacksIndent1",
        "SnacksIndent2",
        "SnacksIndent3",
        "SnacksIndent4",
        "SnacksIndent5",
        "SnacksIndent6",
        "SnacksIndent7",
        "SnacksIndent8",
      },
    },
  },
})

local builtin = require('telescope.builtin')
require('telescope').setup({
  defaults = {
    border = true,
    -- Use standard clean border characters (or adjust corners to your preference)
    borderchars = { '─', '│', '─', '│', '╭', '╮', '╯', '╰' },
    layout_strategy = "horizontal",
    sorting_strategy = "ascending",
    path_display = { "smart" },
    file_ignore_patterns = { "node_modules", ".git/" },
  },
  pickers = {
    find_files = {
      prompt_title = "Find Files",
      hidden = true, -- Include dotfiles (.config, etc.)
      no_ignore = false, -- Keep respecting .gitignore unless needed
    },
    live_grep = {
      prompt_title = "Live Grep",
      additional_args = { "--hidden", "--glob", "!.git/*" },
    },
  },
  extensions = {
    fzf = {
      fuzzy = true,
      override_generic_sorter = true,
      override_file_sorter = true,
      case_mode = "smart_case",
    },
  },
})

pcall(require('telescope').load_extension, 'fzf')

-- Force high-contrast borders while keeping background transparent
vim.api.nvim_set_hl(0, "TelescopeBorder", { fg = "#89b4fa", bg = "NONE" })
vim.api.nvim_set_hl(0, "TelescopePromptBorder", { fg = "#89b4fa", bg = "NONE" })
vim.api.nvim_set_hl(0, "TelescopeResultsBorder", { fg = "#89b4fa", bg = "NONE" })
vim.api.nvim_set_hl(0, "TelescopePreviewBorder", { fg = "#89b4fa", bg = "NONE" })

-- Keymaps for high-speed navigation
vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })

require("nvim-treesitter").setup()
-- 2. Enable native Treesitter highlighting per buffer
vim.api.nvim_create_autocmd("FileType", {
  callback = function(event)
    pcall(vim.treesitter.start, event.buf)
  end,
})
-- 3. Enable native Treesitter-based folding
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
-- Disable automatic Treesitter folding
vim.opt.foldmethod = "manual"
vim.opt.foldexpr = ""
vim.opt.foldlevel = 99
vim.opt.foldenable = false

require("mini.pairs").setup()
local hipatterns = require("mini.hipatterns")
hipatterns.setup({
  highlighters = {
    hex_color = hipatterns.gen_highlighter.hex_color(),
  },
})

require("mini.notify").setup({
window = { config = { border = "rounded" } },
})
vim.notify = require("mini.notify").make_notify()

require("conform").setup({
  formatters_by_ft = {
    lua = { "stylua" },
    python = { "black", "isort" },
    javascript = { "prettierd", "prettier", stop_after_first = true },
    json = { "prettier" },
    nix = { "nixfmt" },
    cpp = { "clang-format" },
    rust = { "rustfmt" },
  },
  format_on_save = {
    timeout_ms = 500,
    lsp_format = "fallback",
  },
  notify_on_error = true,
  notify_no_formatters = true,
})

require("gitsigns").setup({
  signs = {
    add          = { text = "│" },
    change       = { text = "|" },
    delete       = { text = "_" },
    topdelete    = { text = "‾" },
    changedelete = { text = "~" },
    untracked    = { text = "┆" },
  },
  signcolumn = true,
  numhl      = false,
  linehl     = false,
  word_diff  = false,
  watch_gitdir = {
    follow_files = true
  },
  auto_attach = true,
  current_line_blame = true,
  current_line_blame_opts = {
    virt_text = true,
    virt_text_pos = "eol",
    delay = 2000,
  },
  preview_config = {
    border = "single",
    style = "minimal",
    relative = "cursor",
    row = 0,
    col = 1
  },
})

require("mini.trailspace").setup({
  only_in_normal_buffers = true,
})

-- Automatically trim trailing whitespace on save
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*",
  callback = function()
    MiniTrailspace.trim()
  end,
})

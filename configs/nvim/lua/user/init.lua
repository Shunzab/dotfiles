require("user.config.options")
require("user.misc.qol")
require("user.config.transparency")
--require("user.themes.indent_lines")
require("user.config.keybinds")
require("user.config.lualine")

vim.g.netrw_banner = 0    -- Hides the introductory banner instructions
vim.g.netrw_liststyle = 3 -- Tree view style listing
vim.g.netrw_winsize = 25  -- Limits width when spawning split views
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
    only_scope = false,   -- Keeps background lines visible across the entire file
    only_current = false, -- Shows indent markers for all levels

    -- Active scope configuration (replaces mini.indentscope)
    scope = {
      enabled = true,
      priority = 200,
      char = "│",
      underline = false,        -- Highlights the start/end lines of the scope block
      only_current = false,     -- Keeps outer parent scopes visible
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

local builtin = require("telescope.builtin")
require("telescope").setup({
  defaults = {
    border = true,
    -- Use standard clean border characters (or adjust corners to your preference)
    borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
    layout_strategy = "horizontal",
    sorting_strategy = "ascending",
    path_display = { "smart" },
    file_ignore_patterns = { "node_modules", ".git/" },
  },
  pickers = {
    find_files = {
      prompt_title = "Find Files",
      hidden = true,     -- Include dotfiles (.config, etc.)
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

pcall(require("telescope").load_extension, "fzf")

-- Force high-contrast borders while keeping background transparent
vim.api.nvim_set_hl(0, "TelescopeBorder", { fg = "#89b4fa", bg = "NONE" })
vim.api.nvim_set_hl(0, "TelescopePromptBorder", { fg = "#89b4fa", bg = "NONE" })
vim.api.nvim_set_hl(0, "TelescopeResultsBorder", { fg = "#89b4fa", bg = "NONE" })
vim.api.nvim_set_hl(0, "TelescopePreviewBorder", { fg = "#89b4fa", bg = "NONE" })

-- Keymaps for high-speed navigation
vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Telescope find files" })
vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Telescope live grep" })
vim.keymap.set("n", "<leader>fd", "<cmd>Telescope diagnostics<cr>", { desc = "Find Diagnostics (Telescope)" })

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
    add = { text = "│" },
    change = { text = "|" },
    delete = { text = "_" },
    topdelete = { text = "‾" },
    changedelete = { text = "~" },
    untracked = { text = "┆" },
  },
  signcolumn = true,
  numhl = false,
  linehl = false,
  word_diff = false,
  watch_gitdir = {
    follow_files = true,
  },
  auto_attach = true,
  current_line_blame = true,
  current_line_blame_opts = {
    virt_text = true,
    virt_text_pos = "eol",
    delay = 1200,
  },
  preview_config = {
    border = "single",
    style = "minimal",
    relative = "cursor",
    row = 0,
    col = 1,
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

-- Define configurations with their proper canonical names and binary commands
vim.lsp.config("lua_ls", {
  cmd = { "lua-language-server" },
  filetypes = { "lua" },
  settings = {
    Lua = {
      runtime = { version = "LuaJIT" },
      workspace = {
        checkThirdParty = false,
        library = { vim.env.VIMRUNTIME },
      },
    },
  },
})

vim.lsp.config("clangd", {
  cmd = { "clangd", "--background-index", "--clang-tidy", "--header-insertion=iwyu", "--fallback-style=llvm" },
  filetypes = { "c", "cpp", "objc", "objcpp", "cuda", "h", "hpp" },
})

vim.lsp.config("nil_ls", {
  cmd = { "nil" },
  filetypes = { "nix" },
})


vim.lsp.config("pyright", {
  cmd = { "pyright-langserver", "--stdio" },
  filetypes = { "python" },
  settings = {
    python = {
      analysis = {
        autoSearchPaths = true,
        useLibraryCodeForTypes = true,
        diagnosticMode = "openFilesOnly",
      },
    },
  },
  handlers = {
    ["$/progress"] = function(_, result, ctx)
      local client = vim.lsp.get_client_by_id(ctx.client_id)
      if client and client.name == "pyright" then
        return
      end
      vim.lsp.handlers["$/progress"](_, result, ctx)
    end,
  }
})

-- Map configuration keys to their corresponding executable binary names
local servers = {
  lua_ls = "lua-language-server",
  nil_ls = "nil",
  clangd = "clangd",
  pyright = "pyright-langserver",
}

for server_name in pairs(servers) do
  vim.lsp.enable(server_name)
end

vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("LspDevenvCheck", { clear = true }),
  callback = function(args)
    local ft = vim.bo[args.buf].filetype

    -- Map filetypes to your server keys
    local ft_map = {
      lua = "lua_ls",
      nix = "nil_ls",
      c = "clangd",
      cpp = "clangd",
      python = "pyright",
    }

    local server = ft_map[ft]
    if server then
      local binary = servers[server]
      if vim.fn.executable(binary) == 0 then
        vim.notify(
          string.format("LSP binary '%s' missing for %s buffer.", binary, ft),
          vim.log.levels.WARN
        )
      end
    end
  end,
})

--for server_name, binary in pairs(servers) do
--  if vim.fn.executable(binary) == 1 then
--    vim.lsp.enable(server_name)
--  else
--    vim.notify("LSP binary not found on PATH: " .. binary, vim.log.levels.WARN)
--  end
--end


-- Global keymaps for LSP actions attached to buffers
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    local opts = { buffer = args.buf }

    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
    vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)

    if client and client:supports_method("textDocument/signatureHelp") then
      vim.keymap.set("i", "<C-k>", vim.lsp.buf.signature_help, opts)
      vim.api.nvim_create_autocmd("InsertCharPre", {
        buffer = args.buf,
        callback = function()
          if vim.v.char == "(" or vim.v.char == "," then
            vim.schedule(function()
              vim.lsp.buf.signature_help()
            end)
          end
        end,
      })
    end

    -- 2. Inlay hints (renders type hints inline if the server supports it)
    if client and client:supports_method("textDocument/inlayHint") then
      vim.lsp.inlay_hint.enable(true, { bufnr = args.buf })
    end
  end,
})

vim.diagnostic.config({
  virtual_text = {
    prefix = "■", -- Could be '●', '▎', etc.
  },
  signs = true,
  underline = true,
  update_in_insert = false, -- Don't update diagnostics while typing to reduce noise
  severity_sort = true,
})

require("blink.cmp").setup({
  keymap = {
    preset = "none",
    ["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
    ["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
    ["<CR>"] = { "accept", "fallback" },
  },
  appearance = {
    use_nvim_cmp_as_default = true,
    nerd_font_variant = "mono",
  },
  sources = {
    default = { "lsp", "path", "snippets", "buffer" },
  },
  completion = {
    list = { selection = { preselect = false, auto_insert = false }, },
    documentation = {
      auto_show = true,
      auto_show_delay_ms = 200,
    },
    ghost_text = {
      enabled = true,
    },
  },
})


require("trouble").setup({ focus = true })

vim.keymap.set("n", "<leader>xx", function() require("trouble").toggle("diagnostics") end,
  { desc = "Diagnostics (Trouble)" })
vim.keymap.set("n", "<leader>xX",
  function() require("trouble").toggle({ mode = "diagnostics", filter = { buf = 0 } }) end,
  { desc = "Buffer Diagnostics (Trouble)" })
vim.keymap.set("n", "<leader>cs", function()
  require("trouble").toggle({ mode = "symbols", focus = true, win = { position = "right", size = 60 } })
end, { desc = "Symbols (Trouble)" })
vim.keymap.set("n", "<leader>cl", function()
  require("trouble").toggle({ mode = "lsp", focus = true, win = { position = "right", size = 60 } })
end, { desc = "LSP Definitions / references / ... (Trouble)" })

-- Use leader + hjkl to switch windows
vim.keymap.set('n', '<leader>h', '<C-w>h', { desc = 'Move to left window' })
vim.keymap.set('n', '<leader>j', '<C-w>j', { desc = 'Move to lower window' })
vim.keymap.set('n', '<leader>k', '<C-w>k', { desc = 'Move to upper window' })
vim.keymap.set('n', '<leader>l', '<C-w>l', { desc = 'Move to right window' })

-- line wrap with alt+z
vim.keymap.set('n', '<M-z>', function()
  vim.wo.wrap = not vim.wo.wrap
  vim.wo.linebreak = not vim.wo.linebreak
  print("Line wrap: " .. tostring(vim.wo.wrap))
end, { desc = "Toggle line wrap" })

-- sets root if files like .git ... are found to get to envrc easily
vim.api.nvim_create_autocmd("BufEnter", {
  callback = function()
    local root = vim.fs.root(0, { ".git", ".envrc", "flake.nix" })
    if root and root ~= vim.fn.getcwd() then
      vim.cmd.lcd(root)
    end
  end,
})

require('sniprun').setup({})
vim.keymap.set({ 'n', 'v' }, '<leader>f', '<plug>SnipRun', { silent = true, desc = "Run line / selection" })
vim.keymap.set('n', '<leader>fr', ':%SnipRun<CR>', { silent = true, desc = "Run whole file" })

-- silently loads the direnv plugin
vim.g.direnv_silent_load = 1

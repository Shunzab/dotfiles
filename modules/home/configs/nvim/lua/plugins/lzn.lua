local lz = require("lz.n")

lz.load({
  {
    "mini.pairs",
    event = "InsertEnter",
    after = function()

      require("mini.pairs").setup()
    end,
  },
  {
    "mini.surround",
    event = "UIEnter",
    after = function()
      require("mini.surround").setup()
    end,
  },

  {
    "nvim-treesitter",
    event = { "BufReadPost", "BufNewFile" },
    after = function()
      require("nvim-treesitter.configs").setup({
        highlight = { enable = true },
        indent = { enable = true },
      })
    end,
  },

  {
    "telescope.nvim",
    keys = {
      { "<leader>ff", function() require("telescope.builtin").find_files() end, desc = "Find files" },
      { "<leader>fg", function() require("telescope.builtin").live_grep() end,  desc = "Live grep" },
      { "<leader>fb", function() require("telescope.builtin").buffers() end,    desc = "Find buffers" },
      { "<leader>fh", function() require("telescope.builtin").help_tags() end,  desc = "Help tags" },
    },
  },

  {
    "blink.cmp",
    event = "InsertEnter",
    after = function()
      require("blink.cmp").setup({
        keymap = { preset = "default" },
        appearance = { use_nvim_cmp_as_default = true },
        sources = { default = { "lsp", "path", "snippets", "buffer" } },
      })
    end,
  },

  {
    "nvim-lspconfig",
    event = { "BufReadPost", "BufNewFile" },
    after = function()
      local lspconfig = require("lspconfig")
      local capabilities = require("blink.cmp").get_lsp_capabilities()


      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(event)
          local builtin = require("telescope.builtin")
          vim.keymap.set("n", "gd",         vim.lsp.buf.definition,   { buffer = event.buf, desc = "Go to definition" })
          vim.keymap.set("n", "K",          vim.lsp.buf.hover,        { buffer = event.buf, desc = "Hover docs" })
          vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename,       { buffer = event.buf, desc = "Rename symbol" })
          vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action,  { buffer = event.buf, desc = "Code actions" })
          vim.keymap.set("n", "gr",         builtin.lsp_references,   { buffer = event.buf, desc = "Go to references" })
          vim.keymap.set("n", "[d",         vim.diagnostic.goto_prev, { buffer = event.buf, desc = "Previous diagnostic" })
          vim.keymap.set("n", "]d",         vim.diagnostic.goto_next, { buffer = event.buf, desc = "Next diagnostic" })
        end,
      })

      local servers = { "nil_ls", "lua_ls" }
      for _, lsp in ipairs(servers) do
        lspconfig[lsp].setup({ capabilities = capabilities })
      end
    end,

  },

  {
    "conform.nvim",
    event = "BufWritePre",
    keys = {
      {
        "<leader>f",
        function()
          require("conform").format({ async = false, lsp_fallback = true })
        end,
        mode = { "n", "v" },
        desc = "Format current buffer",
      },
    },
    after = function()
      require("conform").setup({
        formatters_by_ft = {
          nix = { "alejandra" },
          lua = { "stylua" },
        },
        format_on_save = {
          timeout_ms = 500,
          lsp_fallback = true,
        },
      })
    end,
  },

  {
    "nvim-lint",
    event = { "BufReadPost", "BufWritePost" },
    after = function()
      local lint = require("lint")
      lint.linters_by_ft = {
        nix = { "statix" },
      }

      vim.api.nvim_create_autocmd({ "BufWritePost", "BufEnter", "InsertLeave" }, {
        callback = function()
          lint.try_lint()
        end,
      })
    end,
  },
})

local lz = require("lz.n")

lz.load({
-- 1. Unnecessary Whitespace Highlighting & Trimming
  {
    "mini.trailspace",
    event = { "BufReadPost", "BufNewFile" },
    after = function()  
      require("mini.trailspace").setup()
    end,
  },

  -- 2. Colorize Hex Codes (and RGB, HSL, CSS colors)
  {
    "mini.hipatterns",
    event = { "BufReadPost", "BufNewFile" },
    after = function()
      local hipatterns = require("mini.hipatterns")
      hipatterns.setup({
        highlighters = {
          -- Highlight standalone hex color strings (#ff0000)
          hex_color = hipatterns.gen_highlighter.hex_color(),
        },
      })
    end,
  },

  -- 3. Git Integration (Hunk indicators in signcolumn + status)
  {
    "mini.diff",
    event = { "BufReadPost", "BufNewFile" },
    after = function()
      require("mini.diff").setup()
    end,
  },
  {
    "mini.git",
    event = "VeryLazy",
    after = function()
      require("mini.git").setup()
    end,
  },

  -- 4. Animations (Cursor, scrolling, window resizing)
  {
    "mini.animate",
    event = "UIEnter",
    after = function()
      require("mini.animate").setup()
    end,
  },

  -- 5. Start Screen
  {
    "mini.starter",
    event = "VimEnter",
    after = function()
      require("mini.starter").setup()
    end,
  },

  -- 6. Rainbow Brackets (using rainbow-delimiters.nvim)
  {
    "rainbow-delimiters.nvim",
    event = { "BufReadPost", "BufNewFile" },
    after = function()
      -- Automatically hooks into Tree-sitter parsers out of the box
      require("rainbow-delimiters.setup").setup({})
    end,
  },

  -- Treesitter
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

  -- Telescope
  {
    "telescope.nvim",
    keys = {
      { "<leader>ff", function() require("telescope.builtin").find_files() end, desc = "Find files" },
      { "<leader>fg", function() require("telescope.builtin").live_grep() end,  desc = "Live grep" },
      { "<leader>fb", function() require("telescope.builtin").buffers() end,    desc = "Find buffers" },
      { "<leader>fh", function() require("telescope.builtin").help_tags() end,  desc = "Help tags" },
    },
  },

  -- nvim-lint
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

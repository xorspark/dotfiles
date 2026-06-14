return {
  {
    "stevearc/conform.nvim",
    event = "BufWritePre", -- uncomment for format on save
    config = function()
      require "configs.conform"
    end,
  },
  {
    "tadmccorkle/markdown.nvim",
    -- ft = "markdown", -- or 'event = "VeryLazy"'
    event = "VeryLazy",
    opts = {
      -- configuration here or empty for defaults
    },
  },
  -- These are some examples, uncomment them if you want to see them work!
  {
    "neovim/nvim-lspconfig",
    config = function()
      require "configs.lspconfig"
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    opts = {
      ensure_installed = {
        "vim",
        "lua",
        "vimdoc",
        "html",
        "css",
        "c",
        "markdown",
        "markdown_inline",
        "javascript",
        "typescript",
        "tsx",
        "go",
        "gomod",
        "gowork",
        "gosum",
        "elixir",
      },
      auto_install = true,
    },
  },
  {
    "mrjones2014/smart-splits.nvim",
    lazy = false,
    config = function()
      local smart_splits = require "smart-splits"
      smart_splits.setup {
        default_amount = 5,
      }
      local keymap = vim.keymap

      keymap.set("n", "<C-h>", smart_splits.move_cursor_left)
      keymap.set("n", "<C-j>", smart_splits.move_cursor_down)
      keymap.set("n", "<C-k>", smart_splits.move_cursor_up)
      keymap.set("n", "<C-l>", smart_splits.move_cursor_right)

      keymap.set("n", "<C-S-h>", smart_splits.resize_left)
      keymap.set("n", "<C-S-j>", smart_splits.resize_down)
      keymap.set("n", "<C-S-k>", smart_splits.resize_up)
      keymap.set("n", "<C-S-l>", smart_splits.resize_right)
    end,
  },
  {
    "shortcuts/no-neck-pain.nvim",
    version = "*",
    opts = {
      autocmds = {
        -- enableOnVimEnter = true,
      },
    },
  },
  {
    "elixir-tools/elixir-tools.nvim",
    version = "*",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      local elixir = require "elixir"
      local elixirls = require "elixir.elixirls"

      elixir.setup {
        nextls = { enable = false },
        elixirls = {
          enable = true,
          cmd = "/home/spark/.bin/elixir-ls/language_server.sh",
          settings = elixirls.settings {
            dialyzerEnabled = false,
            enableTestLenses = false,
          },
          on_attach = function(client, bufnr)
            vim.keymap.set("n", "<space>fp", ":ElixirFromPipe<cr>", { buffer = true, noremap = true })
            vim.keymap.set("n", "<space>tp", ":ElixirToPipe<cr>", { buffer = true, noremap = true })
            vim.keymap.set("v", "<space>em", ":ElixirExpandMacro<cr>", { buffer = true, noremap = true })
          end,
        },
        projectionist = {
          enable = true,
        },
      }
    end,
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
  },
}

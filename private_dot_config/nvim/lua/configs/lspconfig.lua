-- load defaults i.e lua_lsp
require("nvchad.configs.lspconfig").defaults()

-- local lspconfig = require "lspconfig"
-- local lspconfig = vim.lsp.config

local nvlsp = require "nvchad.configs.lspconfig"

local servers = { "html", "cssls", "ts_ls", "eslint", "intelephense", "ruff", "gopls", "ty" } -- "elixirls" } --"basedpyright"

-- lsps with default config
for _, lsp in ipairs(servers) do
  vim.lsp.config(lsp, {
    on_attach = nvlsp.on_attach,
    on_init = nvlsp.on_init,
    capabilities = nvlsp.capabilities,
  })
  vim.lsp.enable(lsp)
end

vim.lsp.config("clangd", {
  on_attach = nvlsp.on_attach,
  on_init = nvlsp.on_init,
  capabilities = nvlsp.capabilities,
  cmd = { "clangd", "--background-index", "--clang-tidy", "--log=verbose" },
  init_options = {
    fallbackFlags = { "-std=c++23" },
  },
})
vim.lsp.enable "clangd"

vim.lsp.config("elixirls", {
  cmd = { "/home/spark/.bin/elixir-ls/language_server.sh" },
})
vim.lsp.enable "elixirls"

vim.lsp.config("pico8_ls", {
  on_attach = nvlsp.on_attach,
  on_init = nvlsp.on_init,
  capabilities = nvlsp.capabilities,
  filetypes = { "p8", "pico8" },
})
vim.lsp.enable "pico8_ls"

-- configuring single server, example: typescript
-- lspconfig.ts_ls.setup {
--   on_attach = nvlsp.on_attach,
--   on_init = nvlsp.on_init,
--   capabilities = nvlsp.capabilities,
-- }

vim.lsp.config("rust_analyzer", {
  on_attach = nvlsp.on_attach,
  on_init = nvlsp.on_init,
  capabilities = nvlsp.capabilities,
  settings = {
    checkOnSave = true,
    cargo = {
      features = "all",
    },
    check = {
      command = "clippy",
    },
  },
})
vim.lsp.enable "rust_analyzer"

vim.lsp.config("efm", {
  on_attach = nvlsp.on_attach,
  -- on_init = nvlsp.on_init,
  capabilities = nvlsp.capabilities,
  init_options = {
    documentFormatting = true,
  },
  filetypes = { "sh", "bash" },
  settings = {
    rootMarkers = {},
    languages = {
      sh = {
        { formatCommand = "shfmt -s -i 2 -ci -bn", formatStdin = true },
        {
          prefix = "shellcheck",
          lintCommand = "shellcheck --color=never -f gcc -x",
          lintSource = "efm/shellcheck",
          lintIgnoreExitCode = true,
          lintStdin = true,
          lintFormats = { "%f:%l:%c: %trror: %m", "%f:%l:%c: %tarning: %m", "%f:%l:%c: %tote: %m" },
        },
      },
      bash = {
        { formatCommand = "shfmt -s -i 2 -ci -bn", formatStdin = true },
        {
          prefix = "shellcheck",
          lintCommand = "shellcheck --color=never -f gcc -x -",
          lintSource = "efm/shellcheck",
          lintIgnoreExitCode = true,
          lintStdin = true,
          lintFormats = { "%f:%l:%c: %trror: %m", "%f:%l:%c: %tarning: %m", "%f:%l:%c: %tote: %m" },
        },
      },
    },
  },
})
vim.lsp.enable "efm"

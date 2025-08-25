-- load defaults i.e lua_lsp
require("nvchad.configs.lspconfig").defaults()

local lspconfig = require "lspconfig"

local nvlsp = require "nvchad.configs.lspconfig"

local servers = { "html", "cssls", "basedpyright", "ts_ls", "eslint", "intelephense", "ruff" }

-- lsps with default config
for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = nvlsp.on_attach,
    on_init = nvlsp.on_init,
    capabilities = nvlsp.capabilities,
  }
end

-- configuring single server, example: typescript
-- lspconfig.ts_ls.setup {
--   on_attach = nvlsp.on_attach,
--   on_init = nvlsp.on_init,
--   capabilities = nvlsp.capabilities,
-- }

lspconfig["rust_analyzer"].setup {
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
}

lspconfig["efm"].setup {
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
}

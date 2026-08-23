-- Deprecated. Set in conform_dynamic.lua
local options = {
  formatters_by_ft = {
    pico8 = { "stylua" },
    p8 = { "stylua" },
    lua = { "stylua" },
    javascript = { "js_beautify" },
    css = { "css_beautify" },
    html = { "html_beautify" },
    sql = { "sqruff" },
    python = { "ruff_fix", "ruff_format", "ruff_organize_imports" },
    go = { "goimports", "gofumpt" },
    cpp = { "clang_format" },
  },
  notify_on_error = true,
  format_on_save = {
    -- These options will be passed to conform.format()
    timeout_ms = 500,
    lsp_fallback = true,
  },
  formatters = {
    js_beautify = {
      inherit = true,
      prepend_args = { "-s", "2" },
    },
    css_beautify = {
      inherit = true,
      prepend_args = { "-s", "2" },
    },
    html_beautify = {
      inherit = true,
      prepend_args = { "-s", "2" },
    },
    clang_format = {
      inherit = true,
      prepend_args = { vim.fn.expand "-style=file:$HOME/.config/clang-format/.clang-format" },
    },
  },
}

require("conform").setup(options)

local options = {
  formatters_by_ft = {
    lua = { "stylua" },
    javascript = { "js_beautify" },
    css = { "css_beautify" },
    html = { "html_beautify" },
    sql = { "sqruff" },
    python = { "ruff_fix", "ruff_format", "ruff_organize_imports" }
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
      prepend_args = { "-s", "2" }
    },
    css_beautify = {
      inherit = true,
      prepend_args = { "-s", "2" }
    },
    html_beautify = {
      inherit = true,
      prepend_args = { "-s", "2" }
    },
  }
}

require("conform").setup(options)

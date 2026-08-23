local ConformConfig = {}
setmetatable(ConformConfig, {
  __call = function(self, ...)
    return self:new(...)
  end,
})
ConformConfig.__index = ConformConfig

function ConformConfig:new(o)
  o = o or {}
  setmetatable(o, self)
  o.__index = self
  o.default_options = {
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
  o.conform_override_file = ".conform.json"
  o.conform_no_format = ".conform.noformat"
  return o
end

function ConformConfig:get_override_config(bufnr)
  -- Override file only supported in git repos
  local path = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(bufnr), ":h")
  local git_root = vim.fn.systemlist("git -C " .. vim.fn.fnameescape(path) .. " rev-parse --show-toplevel")[1]

  if vim.v.shell_error ~= 0 or not git_root then
    vim.notify("No git root found, using defaults", vim.log.levels.DEBUG)
    return nil
  end

  local cfg_path = git_root .. "/" .. self.conform_override_file
  if vim.fn.filereadable(cfg_path) == 0 then
    vim.notify("No " .. self.conform_override_file .. " found, using defaults", vim.log.levels.DEBUG)
    return nil
  end

  local ok_read, content = pcall(vim.fn.readfile, cfg_path)
  if not ok_read or not content then
    vim.notify("Failed to read " .. cfg_path, vim.log.levels.ERROR)
    return nil
  end

  local ok_parse, parsed = pcall(vim.fn.json_decode, table.concat(content, "\n"))
  if not ok_parse then
    vim.notify("Invalid JSON in " .. cfg_path, vim.log.levels.ERROR)
    return nil
  end

  if parsed.formatters_by_ft or parsed.args or parsed.formatters or parsed.format_on_save then
    return {
      formatters_by_ft = parsed.formatters_by_ft or {},
      formatters = parsed.formatters or {},
      args = parsed.args or {},
      notify_on_error = true,
      format_on_save = parsed.format_on_save or {
        timeout_ms = 500,
        lsp_fallback = true,
      },
    }
  end

  return nil
end

function ConformConfig:disable_format(bufnr)
  local path = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(bufnr), ":h")
  local result = vim.fs.find({ self.conform_no_format }, { limit = 1, type = "file", upward = true, directory = path })
  if #result == 1 then
    return true
  end
  return false
end

function ConformConfig:get_default_config()
  return self.default_options
end

return ConformConfig

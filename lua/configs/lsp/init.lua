-- load defaults i.e lua_lsp
require("nvchad.configs.lspconfig").defaults()

local lspconfig = require "lspconfig"

--- EXAMPLE
local servers = { "pyright", "rust_analyzer" }
local nvlsp = require "nvchad.configs.lspconfig"

-- lsps with default config
for _, server in ipairs(servers) do
  local opts = {
    on_attach = nvlsp.on_attach,
    on_init = nvlsp.on_init,
    capabilities = nvlsp.capabilities,
  }

  local settings_exists, settings = pcall(require, "configs.lsp.server-settings." .. server)
  if settings_exists then
    opts = vim.tbl_deep_extend("force", settings, opts)
  end

  lspconfig[server].setup(opts)
end

local x = vim.diagnostic.severity
local diagnostic_config = {
  virtual_text = false,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
  signs = {
    text = { [x.ERROR] = "󰅙", [x.WARN] = "", [x.INFO] = "󰋼", [x.HINT] = "󰌵" },
    numhl = {
      [x.ERROR] = "DiagnosticError",
      [x.WARN] = "DiagnosticWarn",
      [x.INFO] = "DiagnosticInfo",
      [x.HINT] = "DiagnosticHint",
    },
  },
  float = { border = "single" },
}

vim.diagnostic.config(diagnostic_config)

vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
  border = "single",
})

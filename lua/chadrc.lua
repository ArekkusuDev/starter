---@type ChadrcConfig
local M = {}
local highlights = require "highlights"

M.base46 = {
  theme = "catppuccin",
  integrations = { "dap" },

  hl_override = highlights.override,
}

M.ui = {
  nvdash = { load_on_startup = true },
  cmp = { style = "atom" },
  statusline = { theme = "vscode_colored" },
}

return M

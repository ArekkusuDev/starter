-- This file needs to have same structure as nvconfig.lua
-- https://github.com/NvChad/ui/blob/v2.5/lua/nvconfig.lua

---@type ChadrcConfig
local M = {}

local highlights = require "highlights"

M.base46 = {
  theme = "catppuccin",
  integrations = { "dap" },

  hl_override = highlights.override,
}

M.ui = {
  nvdash = {
    load_on_startup = true,
  },

  tabufline = {
    lazyload = false,
  },

  cmp = {
    style = "atom",
  },

  statusline = {
    theme = "minimal",
  },
}

return M

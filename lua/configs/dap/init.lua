dofile(vim.g.base46_cache .. "dap")

local dap = require "dap"

-- import adapters
local python = require "configs.dap.adapters.python"

-- setup adapters
dap.adapters.python = python.adapter

-- adapter's config
dap.configurations.python = python.config

require "configs.dap.ui"

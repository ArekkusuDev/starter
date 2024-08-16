local dap, dapui = require "dap", require "dapui"

local sign_define = vim.fn.sign_define

-- DAP UI configuration --
sign_define("DapBreakpoint", { text = "B", texthl = "DapBreakpoint" })
sign_define("DapStopped", { text = "→", texthl = "DapStopped" })

-- DAP UI listeners --
dap.listeners.before.attach.dapui_config = function()
  dapui.open()
end
dap.listeners.before.launch.dapui_config = function()
  dapui.open()
end
dap.listeners.before.event_terminated.dapui_config = function()
  dapui.close()
end
dap.listeners.before.event_exited.dapui_config = function()
  dapui.close()
end

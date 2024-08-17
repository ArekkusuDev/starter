---@param desc string description of the keymap
local function opts(desc)
  return { noremap = true, silent = true, desc = desc }
end

local map = vim.keymap.set

map("n", "<leader>k", function()
  require("kulala").run()
end, opts "Run the current buffer in Kulala")

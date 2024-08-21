require "nvchad.mappings"

-- add yours here
local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
-- map("i", "jk", "<ESC>")

-- Prevent deleting from also copying
vim.keymap.set({'n', 'v'}, 'd', '"_d', { noremap = true })
vim.keymap.set('n', 'dd', '"_dd', { noremap = true })

-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")

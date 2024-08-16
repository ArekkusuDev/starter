require "nvchad.autocmds"

local autocmd = vim.api.nvim_create_autocmd

autocmd("TermOpen", {
  desc = "Disable signcolumn on term open",
  command = "setlocal signcolumn=no",
})

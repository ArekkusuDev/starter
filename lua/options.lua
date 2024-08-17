require "nvchad.options"

-- add yours here!
local o = vim.o
o.cursorlineopt = "number" -- to enable cursorline!
o.cursorline = true
o.wrap = false
o.swapfile = false
o.backup = false
o.writebackup = false
o.relativenumber = true
o.scrolloff = 8

vim.filetype.add {
  extension = { ["http"] = "http" },
}

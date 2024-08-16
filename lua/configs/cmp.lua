local cmp = require "cmp"

return {
  completion = {
    -- default: menu,menuone
    -- add "noselect" to avoid selecting the first item in the completion menu
    completeopt = "menu,menuone,noselect",
  },
  mapping = {
    ["<CR>"] = require("cmp").mapping.confirm {
      behavior = require("cmp").ConfirmBehavior.Insert,
      -- select false to avoid selecting the first item in the completion menu
      -- NOTE: use this with the "noselect" option in completeopt
      select = false,
    },
  },
  sources = {
    -- add copilot to the list of sources
    { name = "copilot" },
    { name = "nvim_lsp" },
    { name = "luasnip" },
    { name = "buffer" },
    { name = "nvim_lua" },
    { name = "path" },
  },
}

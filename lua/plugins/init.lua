return {
  {
    "stevearc/conform.nvim",
    event = "BufWritePre", -- uncomment for format on save
    opts = require "configs.conform",
  },

  {
    "stevearc/dressing.nvim",
    event = "VeryLazy",
    opts = {
      select = { backend = { "telescope" } },
    },
  },

  -- debugger
  -- NOTE: just load with the filetypes where a debugger is configured
  {
    "mfussenegger/nvim-dap",
    keys = {
      {
        "<leader>db",
        function()
          require("dap").toggle_breakpoint()
        end,
        desc = "DAP place/remove breakpoint",
      },
      {
        "<leader>dc",
        function()
          require("dap").continue()
        end,
        desc = "DAP continue",
      },
      {
        "<leader>dt",
        function()
          require("dap").terminate({}, {}, function()
            require("dapui").close()
            print "Debug session terminated :)"
            require("utils.cmd").clear_cmd(2000)
          end)
        end,
        desc = "DAP terminate current debugg session",
      },
    },
    dependencies = {
      {
        "rcarriga/nvim-dap-ui",
        opts = {},
      },
      "nvim-neotest/nvim-nio",
    },
    config = function()
      ---@diagnostic disable-next-line: different-requires
      require "configs.dap"
    end,
  },

  {
    "mfussenegger/nvim-jdtls",
    ft = "java",
  },

  -- overrides
  {
    "neovim/nvim-lspconfig",
    config = function()
      require "configs.lsp"
    end,
  },

  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      {
        "zbirenbaum/copilot-cmp",
        dependencies = {
          -- copilot
          {
            "zbirenbaum/copilot.lua",
            opts = {
              panel = { enabled = false },
              suggestion = { enabled = false },
            },
          },
        },
        opts = {},
      },
    },
    config = function(_, opts)
      table.insert(opts.sources, 1, { name = "copilot" })
      require("cmp").setup(opts)
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "vim",
        "lua",
        "luadoc",
        "vimdoc",
        "html",
        "css",
        "javascript",
        "typescript",
        "tsx",
        "rust",
        "bash",
        "java",
        "python",
      },
    },
  },
}

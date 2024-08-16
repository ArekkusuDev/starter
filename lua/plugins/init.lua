return {
  {
    "stevearc/conform.nvim",
    -- event = "BufWritePre", -- uncomment for format on save
    opts = require "configs.conform",
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
      require "configs.dap"
    end,
  },

  {
    "mfussenegger/nvim-jdtls",
    ft = "java",
  },

  -- copilot
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    opts = {
      panel = { enabled = false },
      suggestion = { enabled = false },
    },
  },

  {
    "TheLeoP/project.nvim",
    event = "LspAttach",
    -- project.nvim must be configured using opts variable
    opts = {
      detection_methods = { "lsp" },
      exclude_dirs = { "~/.cargo", "~" },
      silent_chdir = false,
    },
    config = function(_, opts)
      require("project_nvim").setup(opts)
    end,
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
      { "zbirenbaum/copilot-cmp", opts = {} },
    },
    opts = require "configs.cmp",
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

  {
    "nvim-telescope/telescope.nvim",
    opts = { extensions_list = { "projects" } },
  },
}

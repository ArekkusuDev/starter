local M = {}

M.adapter = function(cb, config)
  local debugpy_install = require("mason-registry").get_package("debugpy"):get_install_path()

  if config.request == "attach" then
    ---@diagnostic disable-next-line: undefined-field
    local port = (config.connect or config).port
    ---@diagnostic disable-next-line: undefined-field
    local host = (config.connect or config).host or "127.0.0.1"
    cb {
      type = "server",
      port = assert(port, "`connect.port` is required for a python `attach` configuration"),
      host = host,
      options = {
        source_filetype = "python",
      },
    }
  else
    cb {
      type = "executable",
      command = debugpy_install .. "/venv/bin/python",
      args = { "-m", "debugpy.adapter" },
      options = {
        source_filetype = "python",
      },
    }
  end
end

M.config = {
  {
    type = "python",
    request = "launch",
    name = "Launch file",

    program = "${file}",
    pythonPath = function()
      local venv = os.getenv "VIRTUAL_ENV"

      if vim.fn.executable(venv .. "/bin/python") == 1 then
        return venv .. "/bin/python"
      else
        return "/usr/bin/python"
      end
    end,
  },
}

return M

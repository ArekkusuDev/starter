local M = {}

---@param timeout number
M.clear_cmd = function(timeout)
  vim.defer_fn(function()
    vim.api.nvim_echo({}, false, {})
  end, timeout)
end

return M

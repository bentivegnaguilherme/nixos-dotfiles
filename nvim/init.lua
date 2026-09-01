-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

-- F5: run the current file in a terminal split.
vim.keymap.set("n", "<F5>", function()
  local file = vim.fn.expand("%:p")
  if file == "" then
    vim.notify("No file to run", vim.log.levels.WARN)
    return
  end
  vim.cmd("split")
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_win_set_buf(0, buf)
  vim.fn.termopen({ "python", file })
  vim.cmd("startinsert")
end, { desc = "Run current file" })

return {
  "akinsho/toggleterm.nvim",
  version = false,
  keys = {
    { "<F7>", '<cmd>ToggleTerm direction=horizontal size=12<cr>', desc = "Toggle terminal" },
    { "<F7>", [[<C-\><C-n><cmd>ToggleTerm<cr>]], mode = "t", desc = "Close terminal" },
  },
  opts = {
    direction = "horizontal",
    size = 12,
    open_mapping = [[<F7>]],
    shade_filetypes = {},
    shade_terminals = false,
  },
}

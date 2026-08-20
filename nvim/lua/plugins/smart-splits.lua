return {
  "mrjones2014/smart-splits.nvim",
  lazy = false,
  config = function()
    require("smart-splits").setup({})
    local map = vim.keymap.set
    local ss = require("smart-splits")

    -- Move between splits (seamless with kitty/niri via the same keys).
    map("n", "<C-h>", ss.move_cursor_left, { desc = "Move to left window" })
    map("n", "<C-j>", ss.move_cursor_down, { desc = "Move to lower window" })
    map("n", "<C-k>", ss.move_cursor_up, { desc = "Move to upper window" })
    map("n", "<C-l>", ss.move_cursor_right, { desc = "Move to right window" })

    -- Resizing splits.
    map("n", "<A-h>", ss.resize_left, { desc = "Resize split left" })
    map("n", "<A-j>", ss.resize_down, { desc = "Resize split down" })
    map("n", "<A-k>", ss.resize_up, { desc = "Resize split up" })
    map("n", "<A-l>", ss.resize_right, { desc = "Resize split right" })

    -- Swapping buffers between splits.
    map("n", "<leader><C-h>", ss.swap_buf_left, { desc = "Swap buffer left" })
    map("n", "<leader><C-j>", ss.swap_buf_down, { desc = "Swap buffer down" })
    map("n", "<leader><C-k>", ss.swap_buf_up, { desc = "Swap buffer up" })
    map("n", "<leader><C-l>", ss.swap_buf_right, { desc = "Swap buffer right" })
  end,
}

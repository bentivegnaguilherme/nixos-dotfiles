-- Tmux integration stack:
-- - vim-tmux-navigator: C-hjkl moves between vim splits AND tmux panes
--   as one seamless grid (the canonical plugin for exactly this).
-- - vim-test + vimux: run test suites in a tmux split without leaving nvim.
return {
  {
    "christoomey/vim-tmux-navigator",
    lazy = false,
    keys = {
      { "<C-h>", "<cmd>TmuxNavigateLeft<cr>", desc = "Navigate left" },
      { "<C-j>", "<cmd>TmuxNavigateDown<cr>", desc = "Navigate down" },
      { "<C-k>", "<cmd>TmuxNavigateUp<cr>", desc = "Navigate up" },
      { "<C-l>", "<cmd>TmuxNavigateRight<cr>", desc = "Navigate right" },
      { "<C-\\>", "<cmd>TmuxNavigatePrevious<cr>", desc = "Navigate previous pane" },
    },
  },
  {
    "vim-test/vim-test",
    dependencies = { "preservim/vimux" },
    init = function()
      -- Run tests through vimux so they pop up in a tmux split.
      vim.g["test#strategy"] = "vimux"
    end,
    keys = {
      { "<leader>tt", "<cmd>TestNearest<cr>", desc = "Test nearest" },
      { "<leader>tT", "<cmd>TestFile<cr>", desc = "Test file" },
      { "<leader>ta", "<cmd>TestSuite<cr>", desc = "Test suite" },
      { "<leader>tl", "<cmd>TestLast<cr>", desc = "Re-run last test" },
      { "<leader>tg", "<cmd>TestVisit<cr>", desc = "Go to last test" },
    },
  },
}

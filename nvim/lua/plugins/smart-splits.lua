-- smart-splits: vim splits <-> tmux panes as one grid.
-- Keys follow the tmux contract: tmux forwards M-hjkl into nvim for
-- movement (C-h gets mangled into backspace through tmux's legacy
-- encoding), so movement lives on both M- and C- variants, resizes on
-- Ctrl+Alt.
return {
  {
    "mrjones2014/smart-splits.nvim",
    lazy = false,
    opts = {},
    keys = {
      { "<M-h>", function() require("smart-splits").move_cursor_left() end, desc = "Move to left window" },
      { "<M-j>", function() require("smart-splits").move_cursor_down() end, desc = "Move to lower window" },
      { "<M-k>", function() require("smart-splits").move_cursor_up() end, desc = "Move to upper window" },
      { "<M-l>", function() require("smart-splits").move_cursor_right() end, desc = "Move to right window" },
      { "<C-h>", function() require("smart-splits").move_cursor_left() end, desc = "Move to left window" },
      { "<C-j>", function() require("smart-splits").move_cursor_down() end, desc = "Move to lower window" },
      { "<C-k>", function() require("smart-splits").move_cursor_up() end, desc = "Move to upper window" },
      { "<C-l>", function() require("smart-splits").move_cursor_right() end, desc = "Move to right window" },
      { "<C-A-h>", function() require("smart-splits").resize_left() end, desc = "Resize split left" },
      { "<C-A-j>", function() require("smart-splits").resize_down() end, desc = "Resize split down" },
      { "<C-A-k>", function() require("smart-splits").resize_up() end, desc = "Resize split up" },
      { "<C-A-l>", function() require("smart-splits").resize_right() end, desc = "Resize split right" },
      { "<leader><C-h>", function() require("smart-splits").swap_buf_left() end, desc = "Swap buffer left" },
      { "<leader><C-j>", function() require("smart-splits").swap_buf_down() end, desc = "Swap buffer down" },
      { "<leader><C-k>", function() require("smart-splits").swap_buf_up() end, desc = "Swap buffer up" },
      { "<leader><C-l>", function() require("smart-splits").swap_buf_right() end, desc = "Swap buffer right" },
    },
  },
}

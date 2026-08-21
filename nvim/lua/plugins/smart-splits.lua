-- smart-splits: the LazyVim extra (imported in config/lazy.lua) provides
-- the plugin and default keys (C-hjkl move, A-hjkl resize). This file
-- adapts them to our tmux contract: tmux forwards M-hjkl into nvim for
-- MOVEMENT (C-h arrives mangled as backspace through tmux), so resizes
-- move out of Alt to Ctrl+Alt+hjkl.
return {
  {
    "mrjones2014/smart-splits.nvim",
    keys = {
      { "<M-h>", function() require("smart-splits").move_cursor_left() end, desc = "Move to left window" },
      { "<M-j>", function() require("smart-splits").move_cursor_down() end, desc = "Move to lower window" },
      { "<M-k>", function() require("smart-splits").move_cursor_up() end, desc = "Move to upper window" },
      { "<M-l>", function() require("smart-splits").move_cursor_right() end, desc = "Move to right window" },
      { "<C-A-h>", function() require("smart-splits").resize_left() end, desc = "Resize split left" },
      { "<C-A-j>", function() require("smart-splits").resize_down() end, desc = "Resize split down" },
      { "<C-A-k>", function() require("smart-splits").resize_up() end, desc = "Resize split up" },
      { "<C-A-l>", function() require("smart-splits").resize_right() end, desc = "Resize split right" },
    },
  },
}

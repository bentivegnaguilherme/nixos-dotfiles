return {
  -- Use the noctalia colorscheme (colors/noctalia.lua), bridged from
  -- Noctalia's live kitty palette. Disable LazyVim's default tokyonight.
  {
    "LazyVim/LazyVim",
    opts = { colorscheme = "noctalia" },
  },
  { "folke/tokyonight.nvim", enabled = false },
}

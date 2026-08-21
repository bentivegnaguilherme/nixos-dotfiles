return {
  "yetone/avante.nvim",
  event = "VeryLazy",
  version = false,
  -- NOTE: no `build = "make"` -- it compiles a Rust tokenizer and needs cargo.
  -- Without it avante falls back to approximate token counting; if you ever
  -- want exact counts, install cargo and restore the build step.
  opts = {
    -- Default provider is OpenAI-compatible; set OPENAI_API_KEY in your
    -- environment, or add a provider block here (anthropic, copilot, ollama...).
    provider = "openai",
  },
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "stevearc/dressing.nvim",
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    "nvim-tree/nvim-web-devicons",
    {
      -- Markdown rendering for the AI chat pane.
      "MeanderingProgrammer/render-markdown.nvim",
      opts = {},
    },
  },
}

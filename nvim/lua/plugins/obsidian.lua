-- Obsidian vault integration: edit ~/notes with Neovim.
-- Works alongside the Obsidian GUI (graph view, canvas stay there);
-- just don't edit the same note in both apps at once.
return {
  {
    "obsidian-nvim/obsidian.nvim",
    version = "*",
    lazy = true,
    event = {
      "BufReadPre " .. vim.fn.expand "~" .. "/notes/**.md",
      "BufNewFile " .. vim.fn.expand "~" .. "/notes/**.md",
    },
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      workspaces = {
        { name = "notes", path = "~/notes" },
      },
      -- LazyVim's built-in picker
      picker = { name = "snacks.pick" },
      daily_notes = {
        folder = "daily",
        date_format = "%Y-%m-%d",
      },
      -- New notes get readable titles instead of random IDs
      note_id_func = function(title)
        return title and title:gsub("%s", "-"):lower() or tostring(os.time())
      end,
      ui = { enable = false }, -- render-markdown.nvim already handles this
    },
    keys = {
      { "<leader>oo", "<cmd>ObsidianQuickSwitch<cr>", desc = "Obsidian: find note" },
      { "<leader>on", "<cmd>ObsidianNew<cr>", desc = "Obsidian: new note" },
      { "<leader>os", "<cmd>ObsidianSearch<cr>", desc = "Obsidian: search text" },
      { "<leader>od", "<cmd>ObsidianToday<cr>", desc = "Obsidian: today's note" },
      { "<leader>ol", "<cmd>ObsidianLinks<cr>", desc = "Obsidian: backlinks" },
    },
  },
}

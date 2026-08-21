-- "noctalia" colorscheme: bridged live from Noctalia's kitty palette.
-- Noctalia rewrites ~/.config/kitty/themes/noctalia.conf on every theme or
-- wallpaper change; parsing it here keeps neovim in sync automatically.

local function parse_kitty_theme()
  local path = vim.fn.expand("~/.config/kitty/themes/noctalia.conf")
  local f = io.open(path, "r")
  if not f then
    return nil
  end
  local map = {}
  for line in f:lines() do
    local key, value = line:match("^%s*([%w_]+)%s+(#%x%x%x%x%x%x)%s*$")
    if key then
      map[key] = value
    end
  end
  f:close()
  return map
end

local c = parse_kitty_theme()
if not c or not c.background then
  return -- file missing; fall back to whatever colorscheme is available
end

vim.o.termguicolors = true
vim.o.background = "dark"

local bg = c.background
local fg = c.foreground
local dim = c.color8
local sel = c.selection_background or c.color0

local hi = function(group, opts)
  vim.api.nvim_set_hl(0, group, opts)
end

-- Terminal colors (:terminal) from the exact ANSI palette.
for i = 0, 15 do
  vim.g["terminal_color_" .. i] = c["color" .. i]
end

-- Core UI.
hi("Normal", { fg = fg, bg = bg })
hi("NormalFloat", { fg = fg, bg = bg })
hi("FloatBorder", { fg = dim })
hi("FloatTitle", { fg = fg, bold = true })
hi("CursorColumn", { bg = sel })
hi("CursorLine", { bg = sel })
hi("Visual", { bg = sel })
hi("VisualNOS", { bg = sel })
hi("Search", { fg = bg, bg = c.color5 })
hi("IncSearch", { fg = bg, bg = c.color4 })
hi("Substitute", { fg = bg, bg = c.color1 })
hi("LineNr", { fg = dim })
hi("CursorLineNr", { fg = c.color5, bold = true })
hi("SignColumn", { bg = bg })
hi("VertSplit", { fg = dim })
hi("WinSeparator", { fg = dim })
hi("StatusLine", { fg = fg, bg = c.color0 })
hi("StatusLineNC", { fg = dim, bg = c.color0 })
hi("Pmenu", { fg = fg, bg = c.color0 })
hi("PmenuSel", { fg = bg, bg = c.color5 })
hi("PmenuThumb", { bg = dim })
hi("MatchParen", { fg = c.color4, bold = true, underline = true })
hi("ColorColumn", { bg = c.color0 })
hi("Conceal", { fg = dim })
hi("NonText", { fg = dim })
hi("Whitespace", { fg = dim })
hi("Directory", { fg = c.color5 })

-- Syntax.
hi("Comment", { fg = dim, italic = true })
hi("Constant", { fg = c.color2 })
hi("String", { fg = c.color2 })
hi("Character", { fg = c.color2 })
hi("Number", { fg = c.color4 })
hi("Boolean", { fg = c.color4 })
hi("Float", { fg = c.color4 })
hi("Identifier", { fg = fg })
hi("Function", { fg = c.color4 })
hi("Statement", { fg = c.color1 })
hi("Keyword", { fg = c.color1 })
hi("Conditional", { fg = c.color1 })
hi("Repeat", { fg = c.color1 })
hi("Label", { fg = c.color1 })
hi("Operator", { fg = c.color3 })
hi("Exception", { fg = c.color1 })
hi("PreProc", { fg = c.color3 })
hi("Include", { fg = c.color3 })
hi("Define", { fg = c.color3 })
hi("Macro", { fg = c.color3 })
hi("Type", { fg = c.color6 })
hi("StorageClass", { fg = c.color6 })
hi("Structure", { fg = c.color6 })
hi("Typedef", { fg = c.color6 })
hi("Special", { fg = c.color5 })
hi("Underlined", { underline = true })
hi("Error", { fg = c.color9 })
hi("Todo", { fg = c.color3, bold = true })

-- Diagnostics.
hi("DiagnosticError", { fg = c.color9 })
hi("DiagnosticWarn", { fg = c.color11 })
hi("DiagnosticInfo", { fg = c.color5 })
hi("DiagnosticHint", { fg = c.color6 })

-- Git signs (gitsigns.nvim).
hi("GitSignsAdd", { fg = c.color10 })
hi("GitSignsChange", { fg = c.color12 })
hi("GitSignsDelete", { fg = c.color9 })

vim.g.colors_name = "noctalia"

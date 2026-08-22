-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- Neovide only; a terminal nvim ignores these.
-- The cursor animates by default: it slides to the new position and drags a
-- tail behind it. Both off, plus the insert/cmdline variants that are timed
-- separately, and the particle effects.
if vim.g.neovide then
  vim.g.neovide_cursor_animation_length = 0
  vim.g.neovide_cursor_short_animation_length = 0
  vim.g.neovide_cursor_trail_size = 0
  vim.g.neovide_cursor_animate_in_insert_mode = false
  vim.g.neovide_cursor_animate_command_line = false
  vim.g.neovide_cursor_vfx_mode = ""

  -- Match Ghostty. Without this Neovide falls back to its own default size,
  -- which reads noticeably smaller side by side. The family is spelled the way
  -- CoreText registers it - `ghostty +list-fonts` resolves Ghostty's shorter
  -- "JetBrainsMonoNL Nerd Font" to exactly this.
  vim.o.guifont = "JetBrainsMonoNL Nerd Font Mono:h16"
end

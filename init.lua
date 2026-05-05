-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

-- Add this to ~/.config/nvim/lua/config/init.lua
--
-- Change rline color
vim.api.nvim_set_hl(0, "LineNrAbove", { fg = "#8892a8" })
vim.api.nvim_set_hl(0, "LineNrBelow", { fg = "#8892a8" })
--
-- Change winbar color
-- vim.api.nvim_set_hl(0, "WinBar", { bold = true, fg = "#e0e0e0" })
-- vim.api.nvim_set_hl(0, "WinBarNC", { bold = true, fg = "#e0e0e0" })
--
--Change winbar color to always match current rline color
vim.api.nvim_set_hl(0, "WinBar", { link = "CursorLineNr" })
vim.api.nvim_set_hl(0, "WinBarNC", { link = "CursorLineNr" })
--
-- Remap escape from terminal
vim.keymap.set("t", "<Esc><Esc>", [[<C-\><C-n>]])
-- split into 2x2
vim.keymap.set("n", "<leader>w4", function()
  vim.cmd("vsplit | enew | split | enew | wincmd h | split | enew")
end, { desc = "2x2 grid (empty)" })

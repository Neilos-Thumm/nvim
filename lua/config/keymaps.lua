-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
--
-- Enable two buffer clipboard
-- Copy to system clipboard in visual mode using Cmd+C
vim.keymap.set("v", "<D-c>", '"+y', { noremap = true, silent = true, desc = "Copy to system clipboard" })
-- Optional: Copy current line to system clipboard in normal mode using Cmd+C
vim.keymap.set("n", "<D-c>", '"+yy', { noremap = true, silent = true, desc = "Copy line to system clipboard" })
--

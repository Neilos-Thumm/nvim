-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
--
-- Enable two buffer clipboard
-- Copy to system clipboard in visual mode using Cmd+C
vim.keymap.set("v", "<D-c>", '"+y', { noremap = true, silent = true, desc = "Copy to system clipboard" })
-- Optional: Copy current line to system clipboard in normal mode using Cmd+C
vim.keymap.set("n", "<D-c>", '"+yy', { noremap = true, silent = true, desc = "Copy line to system clipboard" })

-- make `A jump to global mark instead of replacing window's buffer
local function smart_mark(mark, exact)
  local pos = vim.api.nvim_get_mark(mark, {})
  -- pos = { row, col, buffer, filename }
  if pos[1] == 0 then
    vim.notify("Mark " .. mark .. " not set", vim.log.levels.WARN)
    return
  end

  local target_buf = pos[3]

  -- If the mark's buffer is already open in a window, jump to it
  if target_buf ~= 0 then
    for _, win in ipairs(vim.api.nvim_list_wins()) do
      if vim.api.nvim_win_get_buf(win) == target_buf then
        vim.api.nvim_set_current_win(win)
        local col = exact and pos[2] or 0
        vim.api.nvim_win_set_cursor(win, { pos[1], col })
        if not exact then
          vim.cmd("normal! ^")
        end
        return
      end
    end
  end

  -- Otherwise, default jump (loads file into current window)
  vim.cmd("normal! " .. (exact and "`" or "'") .. mark)
end

vim.keymap.set("n", "'", function()
  local c = vim.fn.getcharstr()
  if c:match("[A-Z]") then
    smart_mark(c, false)
  else
    vim.cmd("normal! '" .. c)
  end
end)

vim.keymap.set("n", "`", function()
  local c = vim.fn.getcharstr()
  if c:match("[A-Z]") then
    smart_mark(c, true)
  else
    vim.cmd("normal! `" .. c)
  end
end)

vim.keymap.set("n", "<leader>gF", function()
  vim.ui.input({ prompt = "Diff against: ", completion = "file" }, function(f)
    if f and f ~= "" then
      vim.cmd("vert diffsplit " .. f)
    end
  end)
end, { desc = "Diff buffer against file" })

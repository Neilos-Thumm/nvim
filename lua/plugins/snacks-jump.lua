return {
  "folke/snacks.nvim",
  keys = {
    {
      "<leader>o",
      function()
        Snacks.picker.buffers({
          sort_lastused = true,
          current = false,
          confirm = function(picker, item)
            picker:close()
            if not item or not item.buf then
              return
            end
            -- Defer the window jump until the picker float is fully closed
            vim.schedule(function()
              local wins = vim.fn.win_findbuf(item.buf)
              local target_win = nil
              -- Find the first valid, NON-floating window containing the buffer
              for _, win in ipairs(wins) do
                local config = vim.api.nvim_win_get_config(win)
                if config.relative == "" then -- Empty string means a normal window
                  target_win = win
                  break
                end
              end
              if target_win then
                local tab = vim.api.nvim_win_get_tabpage(target_win)
                if tab ~= vim.api.nvim_get_current_tabpage() then
                  vim.api.nvim_set_current_tabpage(tab)
                end
                vim.api.nvim_set_current_win(target_win)
              else
                vim.api.nvim_set_current_buf(item.buf)
              end
            end)
          end,
        })
      end,
      desc = "Find Buffers (Jump to Window across Tabs)",
    },
  },
}

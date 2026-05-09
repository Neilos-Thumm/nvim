return {
  "folke/snacks.nvim",
  opts = {
    picker = {
      sources = {
        marks = {
          confirm = function(picker, item)
            picker:close()
            if not item then
              return
            end

            vim.schedule(function()
              local file = vim.fs.normalize(item.file)
              local row = item.pos[1]
              local col = item.pos[2] or 0

              local target_buf = -1
              for _, buf in ipairs(vim.api.nvim_list_bufs()) do
                if vim.api.nvim_buf_is_loaded(buf) and vim.fs.normalize(vim.api.nvim_buf_get_name(buf)) == file then
                  target_buf = buf
                  break
                end
              end

              if target_buf ~= -1 then
                for _, tab in ipairs(vim.api.nvim_list_tabpages()) do
                  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(tab)) do
                    if vim.api.nvim_win_get_buf(win) == target_buf then
                      vim.api.nvim_set_current_tabpage(tab)
                      vim.api.nvim_set_current_win(win)
                      pcall(vim.api.nvim_win_set_cursor, win, { row, col })
                      return
                    end
                  end
                end
              end

              vim.cmd("edit " .. vim.fn.fnameescape(file))
              pcall(vim.api.nvim_win_set_cursor, 0, { row, col })
            end)
          end,
        },
      },
    },
  },
}

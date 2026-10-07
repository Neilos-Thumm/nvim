-- :T  →  pick a template from ~/Documents/Template matching the current file's
--        extension and insert it, but only if the current buffer is empty.
local template_dir = "/Users/parunthummadetsak/Documents/Template"

return {
  {
    name = "file-templates",
    dir = vim.fn.stdpath("config"), -- local "plugin", nothing to download
    lazy = false,
    config = function()
      vim.api.nvim_create_user_command("T", function()
        -- 1. Only allow on an empty buffer
        local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
        if table.concat(lines, ""):gsub("%s", "") ~= "" then
          vim.notify("File not empty, template not inserted", vim.log.levels.WARN)
          return
        end

        -- 2. Find templates matching this file's extension
        local ext = vim.fn.expand("%:e")
        if ext == "" then
          vim.notify("Current file has no extension", vim.log.levels.WARN)
          return
        end

        local templates = vim.fn.glob(template_dir .. "/*." .. ext, false, true)
        if #templates == 0 then
          vim.notify("No ." .. ext .. " templates in " .. template_dir, vim.log.levels.WARN)
          return
        end

        -- 3. Popup picker
        vim.ui.select(templates, {
          prompt = "Choose ." .. ext .. " template",
          format_item = function(path)
            return vim.fn.fnamemodify(path, ":t")
          end,
        }, function(choice)
          if not choice then
            return
          end
          vim.cmd("0r " .. vim.fn.fnameescape(choice))
          vim.cmd("$delete _")
        end)
      end, { desc = "Insert file template" })
    end,
  },
}

-- return {
--   "brianhuster/live-preview.nvim",
--   cmd = "LivePreview",
--   config = function()
--     vim.api.nvim_create_autocmd({ "InsertLeavePre", "TextChanged", "TextChangedP" }, {
--       pattern = "*.html,*.css,*.js",
--       callback = function()
--         vim.cmd("silent! write")
--       end,
--     })
--   end,
-- }
--
-- noautocmd
return {
  "brianhuster/live-preview.nvim",
  cmd = "LivePreview",
}

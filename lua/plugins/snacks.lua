return {
  "folke/snacks.nvim",
  keys = {
    -- Overrides the default <leader>fb to jump to the existing window
    {
      "<leader>o",
      function()
        Snacks.picker.buffers({
          jump = { reuse_win = true },
        })
      end,
      desc = "Find Buffers (Jump to Window)",
    },
  },
}

-- ~/.config/nvim/lua/plugins/aerial.lua
return {
  "stevearc/aerial.nvim",
  keys = {
    { "<leader>cz", "<cmd>AerialToggle<cr>", desc = "Aerial (Outline)" },
  },
  opts = {
    layout = { default_direction = "prefer_left", width = 30 },
    show_guides = true,
    filter_kind = false,
  },
}

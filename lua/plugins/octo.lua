-- ~/.config/nvim/lua/plugins/octo.lua
-- GitHub issues/PRs in Neovim (uses the `gh` CLI login).
-- Browsing stays on LazyVim's Snacks pickers: <leader>gi/gI (issues), <leader>gp/gP (PRs).
-- Octo is for creating, reviewing and merging.
return {
  "pwntester/octo.nvim",
  cmd = "Octo",
  event = { { event = "BufReadCmd", pattern = "octo://*" } },
  dependencies = { "nvim-lua/plenary.nvim", "folke/snacks.nvim" },
  keys = {
    { "<leader>gn", "<cmd>Octo issue create<cr>", desc = "New Issue (Octo)" },
    { "<leader>gN", "<cmd>Octo pr create<cr>", desc = "New PR (Octo)" },
    { "<leader>gv", "<cmd>Octo review<cr>", desc = "Review PR (Octo)" },
    { "<leader>gO", "<cmd>Octo actions<cr>", desc = "Octo Actions" },
  },
  opts = {
    picker = "snacks",
    enable_builtin = true,
    default_merge_method = "squash",
    -- Octo's own default; LazyVim's extra turned this on, which needs the
    -- `read:project` token scope and caused "token has not been granted" errors.
    default_to_projects_v2 = false,
  },
}

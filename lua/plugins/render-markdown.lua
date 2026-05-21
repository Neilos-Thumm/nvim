return {
  "MeanderingProgrammer/render-markdown.nvim",
  ft = { "markdown" },
  dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
  opts = {
    preset = "lazy",
    checkbox = {
      enabled = true,
    },
    heading = {
      sign = true,
    },
    code = {
      sign = true,
    },
  },
}

return {
  "lervag/vimtex",
  lazy = false, -- don't lazy-load; it breaks inverse search
  init = function()
    vim.g.vimtex_view_method = "skim"
    vim.g.vimtex_compiler_method = "latexmk"
    vim.g.vimtex_quickfix_mode = 0 -- don't auto-pop the error list
    vim.g.vimtex_view_skim_sync = 1 -- sync Skim's position after compile
    vim.g.vimtex_view_skim_activate = 1 -- bring Skim to focus after compile
    -- optional: match SeniorMars's engine choice
    -- vim.g.vimtex_compiler_latexmk_engines = { ["_"] = "-lualatex -shell-escape" }
  end,
}

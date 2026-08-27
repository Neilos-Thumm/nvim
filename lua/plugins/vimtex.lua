return {
  "lervag/vimtex",
  lazy = false, -- don't lazy-load; it breaks inverse search
  init = function()
    vim.g.vimtex_view_method = "skim"
    vim.g.vimtex_compiler_method = "latexmk"
    vim.g.vimtex_compiler_latexmk = { -- move aux file into build/
      aux_dir = "texbuild",
      out_dir = "",
    }
    vim.g.vimtex_quickfix_mode = 0 -- don't auto-pop the error list
    vim.g.vimtex_view_skim_sync = 1 -- sync Skim's position after compile
    vim.g.vimtex_view_skim_activate = 1 -- bring Skim to focus after compile
    vim.g.vimtex_syntax_conceal = {
      accents = 1,
      ligatures = 1,
      cites = 1,
      fancy = 1,
      spacing = 0, -- don't conceal \vspace, \hspace, etc.
      greek = 1, -- keep α, β, etc.
      math_bounds = 1,
      math_delimiters = 1,
      math_fracs = 1,
      math_super_sub = 1,
      math_symbols = 1, -- keep ∑, ∫, etc.
      sections = 0,
      styles = 1,
    }
    vim.g.vimtex_toc_config = {
      hide_line_numbers = 0,
      split_width = 40, -- wider window if entries get cut off
      todo_sorted = 0, -- show TODOs inline by position, not grouped at top
    }
    -- optional: match SeniorMars's engine choice
    -- vim.g.vimtex_compiler_latexmk_engines = { ["_"] = "-lualatex -shell-escape" }
  end,
}

" let the initial folding state be that all folds are closed.
setlocal foldlevel=99

" Use nvim-treesitter for folding
setlocal foldmethod=expr
setlocal foldexpr=nvim_treesitter#foldexpr()

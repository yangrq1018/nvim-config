" let the initial folding state be that all folds are closed.
setlocal foldlevel=0

" Use nvim-treesitter for folding
setlocal foldmethod=expr
setlocal foldexpr=nvim_treesitter#foldexpr()

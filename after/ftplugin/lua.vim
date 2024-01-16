" Disable inserting comment leader after hitting o or O or <Enter>
set formatoptions-=o
set formatoptions-=r

setlocal expandtab
setlocal tabstop=2
setlocal shiftwidth=2

nnoremap <buffer><silent> <F9> :luafile %<CR>

" For delimitMate
let b:delimitMate_matchpairs = "(:),[:],{:}"

setlocal foldlevel=99

" Use nvim-treesitter for folding
setlocal foldmethod=expr
setlocal foldexpr=nvim_treesitter#foldexpr()

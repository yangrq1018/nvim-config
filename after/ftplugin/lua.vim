" Disable inserting comment leader after hitting o or O or <Enter>
set formatoptions-=o
set formatoptions-=r

setlocal expandtab
setlocal tabstop=2
setlocal shiftwidth=2

nnoremap <buffer><silent> <F9> :luafile %<CR>

" For delimitMate
let b:delimitMate_matchpairs = "(:),[:],{:}"

-- Using vim.filetype lua is modern
-- Equivalent to autocmd BufRead,BufNewFile *.njk set filetype=ninja

vim.filetype.add({
  extension = {
    njk = 'html',
    ipynb = 'jupyter',
    rasi = 'rasi',
  }
})

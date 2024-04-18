-- Using vim.filetype lua is modern
-- Equivalent to autocmd BufRead,BufNewFile *.njk set filetype=html

-- match by extension, filename or pattern
vim.filetype.add({
  extension = {
    njk = 'html',
    ipynb = 'jupyter',
    rasi = 'rasi',
  },
  pattern = {
    -- set a dummy filetype for swaylock config file so we have color
    -- highlights
    ['.*/swaylock/.swaylock/config'] = 'text',
  },
})

-- The square bracket syntax around table keys indicates that
-- a string should serve as a key, rather than an array element.
-- Also, it allows use like `[ name ] = 'bar'`, where name is
-- evaluated to its value to be treated as a key.

local enable = function(buf, win, _)
  -- align lines of file with blame column
  if vim.bo[buf].filetype == 'fugitiveblame' then return true end
  -- align lines in diff mode
  if vim.api.nvim_buf_get_name(buf):startswith('diffview:') then return true end
  if vim.api.nvim_buf_get_name(buf):startswith('gitsigns:') then return true end
  return not vim.api.nvim_win_get_config(win).zindex and
             (vim.bo[buf].buftype == '' or vim.bo[buf].buftype == 'terminal') and
             vim.api.nvim_buf_get_name(buf) ~= '' and not vim.wo[win].diff
end

require('dropbar').setup({
  general = {
    attach_events = {
      -- Remove these two as they causes error sometimes when window appears (or just for no reason)
      -- The default values are 'BufWinEnter', 'BufWritePost'
      'BufWinEnter',
    },
    enable = enable
  }
})

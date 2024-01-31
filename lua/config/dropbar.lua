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
      -- 'OptionSet',
      'BufWinEnter',
      'BufWritePost'
    },
    enable = enable
  }
})

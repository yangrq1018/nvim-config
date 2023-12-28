require("nvim-dap-virtual-text").setup({
  virt_text_pos = 'eol',
  clear_on_continue = true,
  highlight_changed_variables = false,
})

-- highlight! to ignore group settings
vim.cmd[[
  autocmd ColorScheme * highlight! link NvimDapVirtualText Comment
]]

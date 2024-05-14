-- This file is a testing VIMRC for lazy.nvim plugin module loader.

-- Allow require('lazy') to load
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
vim.opt.rtp:prepend(lazypath)


local plugin_specs = {
  {
    "yangrq1018/im-switch.nvim",
    dependencies = {'nvim-treesitter/nvim-treesitter'},
    opts = {
      toggle_comment = false,
    },
  },
}

-- configuration for lazy itself.
local lazy_opts = {
  ui = {
    border = "rounded",
    title = "Plugin Manager",
    title_pos = "center",
  },
}
require("lazy").setup(plugin_specs, lazy_opts)

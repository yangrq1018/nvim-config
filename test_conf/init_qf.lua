-- This file is a testing VIMRC for lazy.nvim plugin module loader.
-- Testing issue: switch buffer to quickfix window will close entire neovim

-- Allow require('lazy') to load
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
vim.opt.rtp:prepend(lazypath)


local plugin_specs = {
  {
    "neovim/nvim-lspconfig",
    event = { "BufRead", "BufNewFile" },
    config = function()
      require("config.lsp")
    end,
  },
  {
    "hrsh7th/nvim-cmp",
    event = "VeryLazy",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "onsails/lspkind-nvim",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-omni",
      "hrsh7th/cmp-emoji",
    },
    config = function()
      require("config.nvim-cmp")
    end,
  },
}

-- configuration for lazy itself.
local lazy_opts = {}
require("lazy").setup(plugin_specs, lazy_opts)

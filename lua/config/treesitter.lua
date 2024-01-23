require("nvim-treesitter.configs").setup {
  ensure_installed = {
    "python", "cpp", "lua", "vim", "json", "toml",
    "vimdoc", "markdown", "bash", "go", "gomod",
    "rasi" -- for rofi configuration
  },
  ignore_install = {}, -- List of parsers to ignore installing
  highlight = {
    enable = true, -- false will disable the whole extension
    disable = {"bash"} -- for zsh, mainly...
  }
}

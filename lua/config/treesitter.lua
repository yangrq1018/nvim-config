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
  },
  -- But many modules have buggy indent implementations
  -- It's a pity that there isn't a whitelist way to enable indent..
  indent = {
    enable = true, -- enable indent for autopairs <CR> indentation
    disable = {"python", "lua"},
  },
}

local utils = require("utils")

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

-- check if firenvim is active
local firenvim_not_active = function()
  return not vim.g.started_by_firenvim
end

local plugin_specs = {
  -- auto-completion engine
  {
    "hrsh7th/nvim-cmp",
    -- event = 'InsertEnter',
    event = "VeryLazy",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "onsails/lspkind-nvim",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-omni",
      "hrsh7th/cmp-emoji",
      "quangnguyen30192/cmp-nvim-ultisnips",
    },
    config = function()
      require("config.nvim-cmp")
    end,
  },

  {
    "neovim/nvim-lspconfig",
    event = { "BufRead", "BufNewFile" },
    config = function()
      require("config.lsp")
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter",
    lazy = true,
    enabled = function()
      if vim.g.is_mac or vim.g.is_linux then
        return true
      end
      return false
    end,
    build = ":TSUpdate",
    config = function()
      require("config.treesitter")
    end,
  },

  -- Python indent (follows the PEP8 style)
  { "Vimjas/vim-python-pep8-indent", ft = { "python" } },

  -- Python-related text object
  { "jeetsukumaran/vim-pythonsense", ft = { "python" } },

  { "machakann/vim-swap", event = "VeryLazy" },

  -- IDE for Lisp
  -- 'kovisoft/slimv'
  {
    "vlime/vlime",
    enabled = function()
      if utils.executable("sbcl") then
        return true
      end
      return false
    end,
    config = function(plugin)
      vim.opt.rtp:append(plugin.dir .. "/vim")
    end,
    ft = { "lisp" },
  },

  -- Super fast buffer jump
  -- {
  --   "smoka7/hop.nvim",
  --   event = "VeryLazy",
  --   config = function()
  --     require("config.nvim_hop")
  --   end,
  -- },

  -- Show match number and index for searching
  {
    "kevinhwang91/nvim-hlslens",
    branch = "main",
    keys = { "*", "#", "n", "N" },
    config = function()
      require("config.hlslens")
    end,
  },
  {
    "Yggdroot/LeaderF",
    cmd = "Leaderf",
    build = function()
      if not vim.g.is_win then
        vim.cmd(":LeaderfInstallCExtension")
      end
    end,
  },
  "nvim-lua/plenary.nvim",
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    dependencies = {
      "nvim-telescope/telescope-symbols.nvim",
    },
  },

  -- A list of colorscheme plugin you may want to try. Find what suits you.
  { "navarasu/onedark.nvim", lazy = true },
  { "sainnhe/edge", lazy = true },
  { "sainnhe/sonokai", lazy = true },
  { "sainnhe/gruvbox-material", lazy = true },
  { "shaunsingh/nord.nvim", lazy = true },
  { "sainnhe/everforest", lazy = true },
  { "EdenEast/nightfox.nvim", lazy = true },
  { "rebelot/kanagawa.nvim", lazy = true },
  { "catppuccin/nvim", name = "catppuccin", lazy = true },
  {
    "yangrq1018/onedarkpro.nvim",
    lazy = true,
    config = function()
      require("onedarkpro").setup({
        options = {
          -- need to explicitly set cursorline to true, else highlight group
          -- background color is the same as editor bg (#282c34). The real
          -- color should be #2e333c.
          cursorline = true,
        }
      })
    end
  },
  { "tanvirtin/monokai.nvim", lazy = true },
  { "marko-cerovac/material.nvim", lazy = true },

  { "nvim-tree/nvim-web-devicons", event = "VeryLazy" },

  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    cond = firenvim_not_active,
    config = function()
      require("config.statusline")
    end,
  },

  {
    "akinsho/bufferline.nvim",
    -- this must be lazy, else highlighting is wrong
    lazy = true,
    event = { "BufEnter" },
    cond = firenvim_not_active,
    config = function()
      require("config.bufferline")
    end,
  },

  -- fancy start screen
  {
    "nvimdev/dashboard-nvim",
    cond = firenvim_not_active,
    config = function()
      require("config.dashboard-nvim")
    end,
  },

  {
    "lukas-reineke/indent-blankline.nvim",
    event = "VeryLazy",
    main = 'ibl',
    config = function()
      require("config.indent-blankline")
    end,
  },

  -- Highlight URLs inside vim
  { "itchyny/vim-highlighturl", event = "VeryLazy" },

  -- notification plugin
  {
    "rcarriga/nvim-notify",
    event = "VeryLazy",
    config = function()
      require("config.nvim-notify")
    end,
  },

  -- For Windows and Mac, we can open an URL in the browser. For Linux, it may
  -- not be possible since we may be in a server which disables GUI.
  {
    "tyru/open-browser.vim",
    event = "VeryLazy",
  },

  -- Only install these plugins if ctags are installed on the system
  -- show file tags in vim window
  {
    "liuchengxu/vista.vim",
    enabled = function()
      if utils.executable("ctags") then
        return true
      else
        return false
      end
    end,
    cmd = "Vista",
  },

  -- Snippet engine and snippet template
  {
    "SirVer/ultisnips",
    -- dependencies = { "honza/vim-snippets" },
    event = "InsertEnter"
  },

  -- Automatic insertion and deletion of a pair of characters
  { "Raimondi/delimitMate", event = "InsertEnter" },

  -- Comment plugin
  { "tpope/vim-commentary", event = "VeryLazy" },

  -- Multiple cursor plugin like Sublime Text?
  -- 'mg979/vim-visual-multi'

  -- Autosave files on certain events
  { "907th/vim-auto-save", event = "InsertEnter" },

  -- Show undo history visually
  { "simnalamburt/vim-mundo", cmd = { "MundoToggle", "MundoShow" } },

  -- better UI for some nvim actions
  { "stevearc/dressing.nvim" },

  -- Manage your yank history
  {
    "gbprod/yanky.nvim",
    cmd = { "YankyRingHistory" },
    config = function()
      require("config.yanky")
    end,
  },

  -- Handy unix command inside Vim (Rename, Move etc.)
  { "tpope/vim-eunuch", cmd = { "Rename", "Delete" } },

  -- Repeat vim motions
  { "tpope/vim-repeat", event = "VeryLazy" },

  { "nvim-zh/better-escape.vim", event = { "InsertEnter" } },

  {
    "lyokha/vim-xkbswitch",
    enabled = function()
      if vim.g.is_mac and utils.executable("xkbswitch") then
        return true
      end
      return false
    end,
    event = { "InsertEnter" },
  },

  {
    "Neur1n/neuims",
    enabled = function()
      if vim.g.is_win then
        return true
      end
      return false
    end,
    event = { "InsertEnter" },
  },

  -- Auto format tools
  {
    "mhartington/formatter.nvim",
    cmd = { "Format" },
    config = function()
      require("config.formatter")
    end,
  },

  -- Git command inside vim
  {
    "tpope/vim-fugitive",
    event = "User InGitRepo",
    config = function()
      require("config.fugitive")
    end,
  },

  -- Better git log display
  { "rbong/vim-flog", cmd = { "Flog" } },
  { "christoomey/vim-conflicted", cmd = { "Conflicted" } },
  {
    "ruifm/gitlinker.nvim",
    event = "User InGitRepo",
    config = function()
      require("config.git-linker")
    end,
  },

  -- Show git change (change, delete, add) signs in vim sign column
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("config.gitsigns")
    end,
  },

  -- Better git commit experience
  { "rhysd/committia.vim", lazy = true },

  {
    "sindrets/diffview.nvim"
  },

  {
    "kevinhwang91/nvim-bqf",
    ft = "qf",
    config = function()
      require("config.bqf")
    end,
  },

  -- Another markdown plugin
  { "preservim/vim-markdown", ft = { "markdown" } },

  -- Faster footnote generation
  { "vim-pandoc/vim-markdownfootnotes", ft = { "markdown" } },

  -- Vim tabular plugin for manipulate tabular, required by markdown plugins
  { "godlygeek/tabular", cmd = { "Tabularize" } },

  -- Markdown previewing (only for Mac and Windows)
  {
    "iamcco/markdown-preview.nvim",
    enabled = function()
      if vim.g.is_win or vim.g.is_mac then
        return true
      end
      return false
    end,
    build = "cd app && npm install",
    ft = { "markdown" },
  },

  {
    "folke/zen-mode.nvim",
    cmd = "ZenMode",
    config = function()
      require("config.zen-mode")
    end,
  },

  {
    "rhysd/vim-grammarous",
    enabled = function()
      if vim.g.is_mac then
        return true
      end
      return false
    end,
    ft = { "markdown" },
  },

  { "chrisbra/unicode.vim", event = "VeryLazy" },

  -- Additional powerful text object for vim, this plugin should be studied
  -- carefully to use its full power
  { "wellle/targets.vim", event = "VeryLazy" },

  -- Plugin to manipulate character pairs quickly
  { "machakann/vim-sandwich", event = "VeryLazy" },

  -- Add indent object for vim (useful for languages like Python)
  -- Provide quick selection on indented syntax structure (like if block)
  { "michaeljsmith/vim-indent-object", event = "VeryLazy" },

  -- Only use these plugin when LaTeX is installed
  {
    "lervag/vimtex",
    enabled = function()
      if utils.executable("latex") then
        return true
      end
      return false
    end,
    ft = { "tex" },
  },

  -- Since tmux is only available on Linux and Mac, we only enable these plugins
  -- for Linux and Mac
  -- .tmux.conf syntax highlighting and setting check
  {
    "tmux-plugins/vim-tmux",
    enabled = function()
      if utils.executable("tmux") then
        return true
      end
      return false
    end,
    ft = { "tmux" },
  },

  -- Modern matchit implementation
  { "andymass/vim-matchup", event = "BufRead" },
  { "tpope/vim-scriptease", cmd = { "Scriptnames", "Message", "Verbose" } },

  -- Asynchronous command execution
  { "skywind3000/asyncrun.vim", lazy = true, cmd = { "AsyncRun" } },
  { "cespare/vim-toml", ft = { "toml" }, branch = "main" },

  -- Edit text area in browser using nvim
  {
    "glacambre/firenvim",
    enabled = function()
      if vim.g.is_win or vim.g.is_mac then
        return true
      end
      return false
    end,
    build = function()
      vim.fn["firenvim#install"](0)
    end,
    lazy = true,
  },

  -- Debugger plugin
  {
    "sakhnik/nvim-gdb",
    enabled = function()
      if vim.g.is_win or vim.g.is_linux then
        return true
      end
      return false
    end,
    build = { "bash install.sh" },
    lazy = true,
  },

  -- Session management plugin
  { "tpope/vim-obsession", cmd = "Obsession" },

  {
    "ojroques/vim-oscyank",
    enabled = function()
      if vim.g.is_linux then
        return true
      end
      return false
    end,
    cmd = { "OSCYank", "OSCYankReg" },
  },

  -- The missing auto-completion for cmdline!
  {
    "gelguy/wilder.nvim",
    build = ":UpdateRemotePlugins",
  },

  -- showing keybindings
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    config = function()
      require("config.which-key")
    end,
  },

  -- It's probably better to not set event to "VeryLazy"
  -- as it does not fire the `BufEnter` autocommand (patch 3b999bf) initially.
  -- So you won't get visual hint of whitespaces unless you switch to insert
  -- mode to trigger autocmd on other events.
  -- show and trim trailing whitespaces
  { "yangrq1018/whitespace.nvim", event = {"BufEnter"}},

  -- file explorer
  {
    "nvim-tree/nvim-tree.lua",
    keys = { "<space>s" },
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("config.nvim-tree")
    end,
  },

  { "ii14/emmylua-nvim", ft = "lua" },
  {
    "j-hui/fidget.nvim",
    event = "VeryLazy",
    config = function()
      require("config.fidget-nvim")
    end,
  },
  {
    "yangrq1018/toggleterm.nvim",
    version = "*",
    opts = {
      open_mapping = [[<f1>]],
      direction = 'float',
      -- size = 100,
    }
  },
  -- Xmake build tool
  {
    'Mythos-404/xmake.nvim',
    event = "BufReadPost xmake.lua",
    config = function()
      require("config.xmake")
    end,
    dependencies = {"MunifTanjim/nui.nvim", "nvim-lua/plenary.nvim"}
  },
  -- transparent neovim background
  {
    "xiyaowong/transparent.nvim",
    -- ensure loaded atfer bufferline so bufferline is not transparent
    after = "bufferline",
    config = function()
      require("transparent").setup({
        exclude_groups = {'StatusLine'}
      })
    end,
  },
  -- Github Copilot
  {
    "github/copilot.vim",
    event = { "BufEnter" },
    config = function()
      vim.g.copilot_assume_mapped = true
      vim.keymap.set('i', '<C-e>', [[copilot#Accept("\<CR>")]], {
        silent = true,
        expr = true,
        script = true,
        replace_keycodes = false,
      })
    end,
  },
  -- Github Copilot Chat
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    branch = "main",
    dependencies = {
      -- { "zbirenbaum/copilot.lua" }, -- or github/copilot.vim
      { "github/copilot.vim" },
      { "nvim-lua/plenary.nvim" }, -- for curl, log wrapper
    },
    opts = {
      debug = false, -- Enable debugging
      show_help = false,
      window = {
        layout = "horizontal",
      }
    },
    -- See Commands section for default commands if you want to lazy load on them
  },
  -- REPL and Jupyter Notebook alternative for vim
  {
    'luk400/vim-jukit',
    ft = {'jupyter'}
  },
  -- for windows/macos
  {
    'keaising/im-select.nvim',
    enabled = function()
      return utils.executable("im-select.exe")
    end,
    ft = {'markdown'}, -- lazy-load on markdowns
    config = function()
      require('im_select').setup({
        default_im_select = "1033",
        set_default_events = {"InsertLeave"},
        set_previous_events = {"InsertEnter"},
      })
    end,
  },
  -- for linux
  {
    "yangrq1018/im-switch.nvim",
    enabled = function()
      return vim.loop.os_uname().sysname == "Linux" and utils.executable('fcitx5-remote')
    end,
    dependencies = {'nvim-treesitter/nvim-treesitter'},
    opts = {
      toggle_comment = false,
      switch = {
        text = {"*.md", "*.tex"},
      }
    },
  },
  {
    "yangrq1018/gptcommit",
    event = "VeryLazy",
    opts = {},
  },
  {
    'VonHeikemen/fine-cmdline.nvim',
    dependencies = {"MunifTanjim/nui.nvim"},
    config = function()
      require("fine-cmdline").setup()
      -- Remap CTRL+P to :FineCmdline
      vim.keymap.set('n', '<C-p>', '<cmd>FineCmdline<CR>', { noremap = true, silent = true })
    end,
  },
  {
    "kdheepak/lazygit.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
  },
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "Joakker/lua-json5",  -- needed for dap.ext.vscode
      "nvim-telescope/telescope.nvim", -- run(config) from Telescope
    },
    lazy = true,
    config = function()
      require("config.dap")
    end,
  },
  {
    "theHamsta/nvim-dap-virtual-text",
    event = { "VeryLazy" },
    dependencies = {"nvim-treesitter/nvim-treesitter"},
    config = function()
      require("config.dap-virtual-text")
    end,
  },
  {
    "rcarriga/nvim-dap-ui",
    event = { "VeryLazy" },
    dependencies = {"mfussenegger/nvim-dap", "nvim-neotest/nvim-nio"},
    config = function()
      require("config.dap-ui")
    end,
  },
  {
    "Joakker/lua-json5",
    lazy = true,
    build = "./install.sh",
  },
  {
    'windwp/nvim-autopairs',
    event = "InsertEnter",
    opts = {
      -- avoid unbalance bracket on new lines
      enable_check_bracket_line = false,
    },
  },
  {
    "ziontee113/icon-picker.nvim",
    event = { "VeryLazy" },
    dependencies = {
      "stevearc/dressing.nvim",
    },
    config = function()
      require("icon-picker").setup({
        disable_legacy_commands = true
      })
    end,
  },
  {
    'Bekaboo/dropbar.nvim',
    dependencies = {
      'nvim-telescope/telescope-fzf-native.nvim'
    },
    config = function()
      require("config.dropbar")
    end,
  },
  -- super cool code navigation, alternative of hop
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    opts = {
      modes = {
        search = {
          -- disable flash on regular search by default, can toggle with <c-s>
          enabled = false,
        }
      }
    },
    keys = {
      -- These mode character corresponds to mappings: imap, nmap, ...
      -- n: Normal, o: Operator-pending, x: Visual, c: Command-line
      { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
      { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
      -- allow you yank something somewhere else with motion, and return back to original position
      { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
      -- allow you search for some word, yank a treesitter node around it, and return back to original position
      { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
      { "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
    },
  },
  {
    "NvChad/nvim-colorizer.lua",
    -- non-lazy if you want to color some filetypes that are set very early
    -- event = {"VeryLazy"},
    config = function()
      require("config.colorizer")
    end,
  },
  {
    "kevinhwang91/nvim-ufo",
    dependencies = { "kevinhwang91/promise-async", "nvim-treesitter/nvim-treesitter" },
    event = { "VeryLazy" },
    config = function()
      require("config.ufo")
    end
  },
  { 'wakatime/vim-wakatime', event = {"VeryLazy"} },
  {
    "kawre/leetcode.nvim",
    build = ":TSUpdate html",
    dependencies = {
      "nvim-telescope/telescope.nvim",
      "nvim-lua/plenary.nvim", -- required by telescope
      "MunifTanjim/nui.nvim",
      -- optional
      "nvim-treesitter/nvim-treesitter",
      "rcarriga/nvim-notify",
      "nvim-tree/nvim-web-devicons",
    },
    opts = {
      lang = "python3",
      hooks = {
        LeetEnter = {
          function()
            -- disable copilot for your own good
            vim.cmd[[Copilot disable]]
          end
        }
      }
    },
  },
  {
    "ray-x/lsp_signature.nvim",
    opts = {
      floating_window = false,
      toggle_key = '<M-x>',
    },
    config = function(_, opts) require'lsp_signature'.setup(opts) end
  },
  {
    "sphamba/smear-cursor.nvim",
    opts = {},
  }
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

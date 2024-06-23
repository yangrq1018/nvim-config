-- Setup nvim-cmp.
local cmp = require("cmp")
local lspkind = require("lspkind")
local context = require('cmp.config.context')

cmp.setup {
  enabled = function()
    -- disable cmp in comment
    return not context.in_treesitter_capture('comment')
  end,
  snippet = {
    expand = function(args)
      -- For `ultisnips` user.
      vim.fn["UltiSnips#Anon"](args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert {
    ["<Tab>"] = function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      else
        fallback()
      end
    end,
    ["<S-Tab>"] = function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      else
        fallback()
      end
    end,
    -- ["<CR>"] = cmp.mapping.confirm { select = true },
    ["<C-e>"] = cmp.mapping.abort(),
    ["<Esc>"] = cmp.mapping.close(),
    ["<C-d>"] = cmp.mapping.scroll_docs(-4),
    ["<C-f>"] = cmp.mapping.scroll_docs(4),
  },
  sources = {
    { name = "nvim_lsp" }, -- For nvim-lsp
    { name = "ultisnips" }, -- For ultisnips user.
    { name = "path" }, -- for path completion
    -- { name = "buffer", keyword_length = 3 }, -- for buffer word completion
    -- { name = "emoji", insert = true }, -- emoji completion
  },
  completion = {
    keyword_length = 1,
    -- if remove 'noselect', the first entry is always focused and doc shown
    -- with 'noselect', you need to use TAB to explicitly select the first entry
    completeopt = "menu,noselect",
  },
  -- disable source preselect request (gopls)
  preselect = cmp.PreselectMode.None,
  view = {
    entries = "custom",
  },
  formatting = {
    expandable_indicator = false, -- don't show expand indicator ~
    format = lspkind.cmp_format {
      mode = "symbol_text",
      maxwidth = 40,
      ellipsis_char = '\u{2026}', -- more elegant ellipsis
      menu = {
        nvim_lsp = "[LSP]",
        ultisnips = "[US]",
        nvim_lua = "[Lua]",
        path = "[Path]",
        buffer = "[Buffer]",
        emoji = "[Emoji]",
        omni = "[Omni]",
      },
    },
  },
}

cmp.setup.filetype("tex", {
  formatting = {
    -- Preserve the format as provided by VimTeX's omni completion function
    -- show source types like 'package', 'cmd', etc.
    format = function(entry, vim_item)
        vim_item.menu = ({
          omni = (vim.inspect(vim_item.menu):gsub('%"', "")),
          buffer = "[Buffer]",
          -- formatting for other sources
          })[entry.source.name]
        return vim_item
      end,
  },
  sources = {
    { name = "omni" },
    -- { name = "ultisnips" }, -- For ultisnips user.
    { name = "buffer", keyword_length = 2 }, -- for buffer word completion
    { name = "path" }, -- for path completion
  },
})

cmp.setup.filetype("markdown", {
  sources = {
    { name = "path" },
    { name = "ultisnips" },
  }
})

--  see https://github.com/hrsh7th/nvim-cmp/wiki/Menu-Appearance#how-to-add-visual-studio-code-dark-theme-colors-to-the-menu
vim.cmd([[
  highlight! link CmpItemMenu Comment
  " gray
  highlight! CmpItemAbbrDeprecated guibg=NONE gui=strikethrough guifg=#808080
  " blue
  highlight! CmpItemAbbrMatch guibg=NONE guifg=#569CD6
  highlight! CmpItemAbbrMatchFuzzy guibg=NONE guifg=#569CD6
  " light blue
  highlight! CmpItemKindVariable guibg=NONE guifg=#9CDCFE
  highlight! CmpItemKindInterface guibg=NONE guifg=#9CDCFE
  highlight! CmpItemKindText guibg=NONE guifg=#9CDCFE
  " pink
  highlight! CmpItemKindFunction guibg=NONE guifg=#C586C0
  highlight! CmpItemKindMethod guibg=NONE guifg=#C586C0
  " front
  highlight! CmpItemKindKeyword guibg=NONE guifg=#D4D4D4
  highlight! CmpItemKindProperty guibg=NONE guifg=#D4D4D4
  highlight! CmpItemKindUnit guibg=NONE guifg=#D4D4D4
]])

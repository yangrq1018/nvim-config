local gs = require("gitsigns")

gs.setup {
  signs = {
    add          = {show_count = false},
    change       = {show_count = false},
    delete       = {show_count = true },
    topdelete    = {show_count = true },
    changedelete = {show_count = true },
  },
  word_diff = true,
  numhl = true,
  linehl = false,
  current_line_blame = true,
  on_attach = function(bufnr)
    local function map(mode, l, r, opts)
      opts = opts or {}
      opts.buffer = bufnr
      vim.keymap.set(mode, l, r, opts)
    end

    -- Navigation
    map("n", "]c", function()
      if vim.wo.diff then
        return "]c"
      end
      vim.schedule(function()
        gs.next_hunk()
      end)
      return "<Ignore>"
    end, { expr = true, desc = "next hunk" })

    map("n", "[c", function()
      if vim.wo.diff then
        return "[c"
      end
      vim.schedule(function()
        gs.prev_hunk()
      end)
      return "<Ignore>"
    end, { expr = true, desc = "previous hunk" })

    -- Actions
    map("n", "<leader>hp", gs.preview_hunk, { desc = "preview hunk"})
    map("n", '<leader>hi', gs.preview_hunk_inline, { desc = "preview hunk inline"})
    map("n", "<leader>hb", function()
      gs.blame_line { full = true }
    end, { desc = "blame line" })
    map("n", '<leader>hs', gs.stage_hunk, { desc = "stage hunk"})
    map("n", '<leader>hu', gs.undo_stage_hunk, { desc = "undo stage hunk"})
    map("n", '<leader>hr', gs.reset_hunk, { desc = "reset hunk"})
  end,
}

-- vim.api.nvim_create_autocmd('ColorScheme', {
--   pattern = "*",
--   callback = function()
--     vim.cmd [[
--       hi GitSignsChangeInline gui=reverse
--       hi GitSignsAddInline gui=reverse
--       hi GitSignsDeleteInline gui=reverse
--     ]]
--   end
-- })

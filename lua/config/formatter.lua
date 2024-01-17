local util = require "formatter.util"

local js_beautify = function()
  return {
    exe = "js-beautify",
    args = {
      "-s=2"
    },
    stdin = true
  }
end

local clang_format = function()
  return {
    exe = "clang-format",
    args = {
      '--style="{IndentWidth: 4}"',
    },
    stdin = true
  }
end

-- Provides the Format, FormatWrite, FormatLock, and FormatWriteLock commands
require("formatter").setup {
  logging = true, -- print via notify
  log_level = vim.log.levels.INFO,
  -- All formatter configurations are opt-in
  filetype = {
    lua = {
      function()
        -- You need lua-format executable on $PATH
        local f = require("formatter.filetypes.lua").luaformat()
        table.insert(f.args, 1, "--indent-width=2") -- indent with two spaces instead of four
        table.insert(f.args, 1, "--spaces-inside-table-braces") -- space inside table braces
        return f
      end
    },
    c = { clang_format },
    cpp = { clang_format },
    -- json and json5 filetypes
    json = { js_beautify },
    jsonc = { js_beautify },
    json5 = { js_beautify }
  }
}

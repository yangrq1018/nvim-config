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

-- You might want .go files to have `expandtab`, that's possible
-- with gofmt, which mandates tabs instead of spaces.
local gofmt = function()
  return {
    exe = "gofmt",
    stdin = true,
  }
end

local black = function()
  return {
    exe = "black",
    args = {"-"}, -- need dash as path to indicate black stdin will be used
    stdin = true,
  }
end

local sql_formatter = function()
  return {
    exe = "sql-formatter",
    stdin = true,
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
    c = { require("formatter.filetypes.cpp").clangformat },
    cpp = { require("formatter.filetypes.cpp").clangformat },
    -- json and json5 filetypes
    json = { js_beautify },
    jsonc = { js_beautify },
    json5 = { js_beautify },
    go = { gofmt },
    python = { black },
    sql = { sql_formatter },
  }
}

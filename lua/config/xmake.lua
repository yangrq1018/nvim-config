-- setup plugin itself
require('xmake').setup()

-- keymap
local keymap = {
  x = {
    name = "Xmake",
    b = { "<cmd>XmakeBuild<cr>", "Build current target" },
    B = { "<cmd>XmakeBuildAll<cr>", "Build all targets" },
    i = { "<cmd>XmakeBuildTarget<cr>", "Select and build target"},
    c = { "<cmd>XmakeClean<cr>", "Clean current target" },
    C = { "<cmd>XmakeCleanAll<cr>", "Clean up all targets" },
    m = { "<cmd>XmakeSetMenu<cr>", "Toggle menu"},
    T = { "<cmd>XMakeSetToolchain<cr>", "Set toolchain" },
    o = { "<cmd>XmakeSetMode<cr>", "Set compile mode"},
    t = { "<cmd>XmakeSetTarget<cr>", "Select target"},
  },
}
local opts = {
  mode = "n",
  prefix = "<leader>",
  buffer = nil,
  silent = true,
  noremap = true,
  nowait = true,
}
require("which-key").register(keymap, opts)

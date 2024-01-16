-- Adapters: C++
local dap = require('dap')
dap.adapters.lldb = {
  type = 'executable',
  command = '/usr/bin/lldb-vscode',
  name = 'lldb',
}

-- Configurations
dap.configurations.cpp = {
  {
    name = 'Launch',
    type = 'lldb',
    request = 'launch',
    program = function()
      local abs_path = vim.fn.getcwd() .. '/'
      local xmake = require("xmake.project_config")
      if xmake.info.tg ~= "" then
        local exec_path = xmake.info.target.exec_path
        abs_path = abs_path .. exec_path
      end
      return vim.fn.input('Path to executable: ', abs_path, 'file')
    end,
    cwd = '${workspaceFolder}',
    stopOnEntry = false,
    args = {},
  },
}

-- Shortcuts
local whichkey = require("which-key")
local keymap = {
  d = {
    name = "DAP",
    R = { "<cmd>lua require'dap'.run_to_cursor()<cr>", "Run to Cursor" },
    E = { "<cmd>lua require'dapui'.eval(vim.fn.input '[Expression] > ')<cr>", "Evaluate Input" },
    C = { "<cmd>lua require'dap'.set_breakpoint(vim.fn.input '[Condition] > ')<cr>", "Conditional Breakpoint" },
    U = { "<cmd>lua require'dapui'.toggle()<cr>", "Toggle UI" },
    b = { "<cmd>lua require'dap'.step_back()<cr>", "Step Back" },
    c = { "<cmd>lua require'dap'.continue()<cr>", "Continue" },
    d = { "<cmd>lua require'dap'.disconnect()<cr>", "Disconnect" },
    e = { "<cmd>lua require'dapui'.eval()<cr>", "Evaluate" },
    g = { "<cmd>lua require'dap'.session()<cr>", "Get Session" },
    h = { "<cmd>lua require'dap.ui.widgets'.hover()<cr>", "Hover Variables" },
    S = { "<cmd>lua require'dap.ui.widgets'.scopes()<cr>", "Scopes" },
    i = { "<cmd>lua require'dap'.step_into()<cr>", "Step Into" },
    o = { "<cmd>lua require'dap'.step_over()<cr>", "Step Over" },
    p = { "<cmd>lua require'dap'.pause.toggle()<cr>", "Pause" },
    q = { "<cmd>lua require'dap'.close()<cr>", "Quit" },
    r = { "<cmd>lua require'dap'.repl.toggle()<cr>", "Toggle Repl" },
    s = { "<cmd>lua require'dap'.continue()<cr>", "Start" },
    t = { "<cmd>lua require'dap'.toggle_breakpoint()<cr>", "Toggle Breakpoint" },
    x = { "<cmd>lua require'dap'.terminate()<cr>", "Terminate" },
    u = { "<cmd>lua require'dap'.step_out()<cr>", "Step Out" },
  },
}
local opts = {
  mode = "n",
  prefix = "<leader>",
  buffer = nil,
  silent = true,
  noremap = true,
  nowait = false,
}
whichkey.register(keymap, opts)

-- Customize the icons
vim.fn.sign_define('DapBreakpoint',         {text='🔴', texthl='', linehl='', numhl=''})
vim.fn.sign_define('DapStopped',            {text='🟡', texthl='', linehl='', numhl=''})
vim.fn.sign_define('DapBreakpointRejected', {text='❌', texthl='', linehl='', numhl=''})

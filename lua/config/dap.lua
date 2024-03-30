local dap = require('dap')

-- Utilities
-- TODO: how to prompt for args gracefully?
local prompt_program = function()
  local abs_path = vim.fn.getcwd() .. '/'
  return vim.fn.input('Path to executable: ', abs_path, 'file')
end

local prompt_args = function()
  local args_string = vim.fn.input('Arguments: ')
  return vim.split(args_string, " ")
end

-- Adapters
dap.adapters.lldb = {
  type = 'executable',
  -- install llvm or lldb package, depend on Debian/Arch
  -- e.g. pacman -S lldb
  command = '/usr/bin/lldb-vscode',
  name = 'lldb',
}

dap.adapters.python = function(cb, config)
  if config.request == 'attach' then
    ---@diagnostic disable-next-line: undefined-field
    local port = (config.connect or config).port
    ---@diagnostic disable-next-line: undefined-field
    local host = (config.connect or config).host or '127.0.0.1'
    cb({
      type = 'server',
      port = assert(port, '`connect.port` is required for a python `attach` configuration'),
      host = host,
      options = {
        source_filetype = 'python',
      },
    })
  else
    cb({
      type = 'executable',
      command = vim.g.python3_host_prog,
      args = { '-m', 'debugpy.adapter' },
      options = {
        source_filetype = 'python',
      },
    })
  end
end

-- Configurations as DAP client
dap.configurations.cpp = {
  {
    name = 'Launch CPP',
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

dap.configurations.c = {
  {
    name = 'Launch C',
    type = 'lldb',
    request = 'launch',
    program = prompt_program,
    cwd = '${workspaceFolder}',
    stopOnEntry = false,
    args = {},
  },
}

dap.configurations.python = {
  {
    -- The first three options are required by nvim-dap
    type = 'python', -- the type here established the link to the adapter definition: `dap.adapters.python`
    request = 'launch',
    name = "Launch Python script (Conda base)",
    -- Options below are for debugpy, see https://github.com/microsoft/debugpy/wiki/debug-configuration-settings for supported options
    program = "${file}", -- This configuration will launch the current file if used.
    python = function()
      return vim.g.python3_host_prog
    end,
  },
}

-- Shortcuts
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
require("which-key").register(keymap, opts)

-- Customize the icons
vim.fn.sign_define('DapBreakpoint',         {text='🔴', texthl='', linehl='', numhl=''})
vim.fn.sign_define('DapStopped',            {text='🟡', texthl='', linehl='', numhl=''})
vim.fn.sign_define('DapBreakpointRejected', {text='❌', texthl='', linehl='', numhl=''})

-- Launch project-specific launch.json (VSCode like)
dap_vscode = require('dap.ext.vscode')
-- use JSON5 in launch.json
dap_vscode.json_decode = require'json5'.parse

-- the first parameter defaults to .vscode/launch.json in current working directory
-- but for neovim to properly highlight json5 syntax, explicitly set it here
dap_vscode.load_launchjs(".vscode/launch.json5", {})

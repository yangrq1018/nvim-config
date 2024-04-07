local dap = require('dap')

-- Utilities
local prompt_program_fn_input = function()
  local abs_path = vim.fn.getcwd() .. '/'
  return vim.fn.input('Path to executable: ', abs_path, 'file')
end

-- TODO: how to prompt for args gracefully?
-- local prompt_args = function()
--   local args_string = vim.fn.input('Arguments: ')
--   return vim.split(args_string, " ")
-- end

-- prefill the prompt with current active xmake target executable path
local prompt_xmake_exec = function()
  local abs_path = vim.fn.getcwd() .. '/'
  local xmake = require("xmake.project_config")
  if xmake.info.tg ~= "" then
    local exec_path = xmake.info.target.exec_path
    abs_path = abs_path .. exec_path
  end
  return vim.fn.input('Path to executable: ', abs_path, 'file')
end

-- Adapters
dap.adapters.lldb = {
  type = 'executable',
  -- install llvm or lldb package, depend on Debian/Arch
  -- e.g. pacman -S lldb
  command = '/usr/bin/lldb-vscode',
  name = 'lldb'
}

dap.adapters.python = function(cb, config)
  if config.request == 'attach' then
    ---@diagnostic disable-next-line: undefined-field
    local port = (config.connect or config).port
    ---@diagnostic disable-next-line: undefined-field
    local host = (config.connect or config).host or '127.0.0.1'
    cb({
      type = 'server',
      port = assert(port,
                    '`connect.port` is required for a python `attach` configuration'),
      host = host,
      options = { source_filetype = 'python' }
    })
  else
    cb({
      type = 'executable',
      command = vim.g.python3_host_prog,
      args = { '-m', 'debugpy.adapter' },
      options = { source_filetype = 'python' }
    })
  end
end

-- Configurations as DAP client
-- TODO, default config factory
dap.configurations.cpp = {
  {
    name = 'Launch CPP',
    type = 'lldb',
    request = 'launch',
    program = prompt_xmake_exec,
    cwd = '${workspaceFolder}',
    stopOnEntry = false,
    args = {}
  }
}

dap.configurations.c = {
  {
    name = 'Launch C',
    type = 'lldb',
    request = 'launch',
    program = prompt_program_fn_input,
    cwd = '${workspaceFolder}',
    stopOnEntry = false,
    args = {}
  }
}

dap.configurations.python = {
  {
    -- The first three options are required by nvim-dap
    type = 'python', -- the type here established the link to the adapter definition: `dap.adapters.python`
    request = 'launch',
    name = "Launch Python script (Conda base)",
    -- Options below are for debugpy, see https://github.com/microsoft/debugpy/wiki/debug-configuration-settings for supported options
    program = "${file}", -- This configuration will launch the current file if used.
    python = function() return vim.g.python3_host_prog end
  }
}

-- Return a default DAP configuration object for cpp debug to be used by dap.run
local mkconfig_cpp = function()
  return {
    name = 'Launch CPP',
    type = 'lldb',
    request = 'launch',
    program = "${file}",
    cwd = '${workspaceFolder}',
    stopOnEntry = false,
    args = {}
  }
end

local widgets = require'dap.ui.widgets'
local actions = require('telescope.actions')
local action_state = require('telescope.actions.state')

local run_dap_cpp_cb = function(prompt_bufnr)
  local config = mkconfig_cpp()
  local selected_entry = action_state.get_selected_entry()
  -- entry: {filename, index}
  -- the filename is relative to cwd option
  config.program = "./build/" .. selected_entry[1]
  actions.close(prompt_bufnr) -- close telescope window
  dap.run(config)
end

local run_dap_cpp_telescope = function()
  require("telescope.builtin").find_files({
    -- hidden = true,
    cwd = "./build", -- search in build directory
    find_command = { "fd", "--base-directory", "build", "-t", "x" },
    attach_mappings = function(_, map)
      -- while you type in the popup window, you are in INSERT
      map("i", "<cr>", run_dap_cpp_cb)
      map("n", "<cr>", run_dap_cpp_cb)
      -- return true if want to map default_mappings for this picker
      -- like <ESC> for quit
      return true
    end
  })
end

-- Shortcuts
local keymap = {
  d = {
    name = "DAP",
    -- UI related bindings
    E = {
      "<cmd>lua require'dapui'.eval(vim.fn.input '[Expression] > ')<cr>",
      "Evaluate Input"
    },
    U = { "<cmd>lua require'dapui'.toggle()<cr>", "Toggle UI" },
    e = { "<cmd>lua require'dapui'.eval()<cr>", "Evaluate" },

    -- DAP functions
    C = {
      "<cmd>lua require'dap'.set_breakpoint(vim.fn.input '[Condition] > ')<cr>",
      "Conditional Breakpoint"
    },
    b = { dap.step_back, "Step Back" },
    c = { dap.continue, "Continue" },
    d = { dap.disconnect, "Disconnect" },
    g = { dap.session, "Get Session" },
    h = { widgets.hover, "Hover Variables" },
    S = { function() widgets.centered_float(widgets.scopes) end, "Scopes in float window" },
    i = { dap.step_into, "Step Into" },
    o = { dap.step_over, "Step Over" },
    p = { dap.pause, "Pause" },
    q = { dap.close, "Quit" },
    r = { dap.repl.toggle, "Toggle Repl" },
    R = { dap.run_to_cursor, "Run to Cursor" },
    T = { run_dap_cpp_telescope, 'Pick cpp configuration in Telescope' },
    s = { dap.continue, "Start" },
    t = { dap.toggle_breakpoint, "Toggle Breakpoint" },
    x = { dap.terminate, "Terminate" },
    u = { dap.step_out, "Step Out" }
  }
}
local opts = {
  mode = "n",
  prefix = "<leader>",
  buffer = nil,
  silent = true,
  noremap = true,
  nowait = false
}
require("which-key").register(keymap, opts)

-- Customize the icons
vim.fn.sign_define('DapBreakpoint',
                   { text = '🔴', texthl = '', linehl = '', numhl = '' })
vim.fn.sign_define('DapStopped',
                   { text = '🟡', texthl = '', linehl = '', numhl = '' })
vim.fn.sign_define('DapBreakpointRejected',
                   { text = '❌', texthl = '', linehl = '', numhl = '' })

-- Launch project-specific launch.json (VSCode like)
dap_vscode = require('dap.ext.vscode')
-- use JSON5 in launch.json
dap_vscode.json_decode = require'json5'.parse

-- the first parameter defaults to .vscode/launch.json in current working directory
-- but for neovim to properly highlight json5 syntax, explicitly set it here
dap_vscode.load_launchjs(".vscode/launch.json5", {})

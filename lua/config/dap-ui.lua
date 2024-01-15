local dap = require('dap')
local dapui = require("dapui")

dapui.setup()

-- automatically start dapui on dap events
-- before.<event/command>.<plugin_id> should be a nested table
dap.listeners.before.attach.dapui_config = function()
  dapui.open()
end
dap.listeners.before.launch.dapui_config = function()
  dapui.open()
end
dap.listeners.before.event_terminated.dapui_config = function()
  dapui.close()
end
dap.listeners.before.event_exited.dapui_config = function()
  dapui.close()
end

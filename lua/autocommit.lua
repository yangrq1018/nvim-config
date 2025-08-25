vim.keymap.set('n', '<leader>ga', function()
  local copilotchat = require("CopilotChat")
  local fidget = require("fidget")
  local task = fidget.progress.handle.create({
    title = "CopilotChat Commit",
    message = "Generating commit message...",
    percentage = nil,
    cancellable = false
  })

  copilotchat.ask(
      'Write commit message for the change with commitizen convention. Keep the title under 50 characters and wrap message at 72 characters.' ..
          'Do not include code block notation.', {
        headless = true,
        callback = function(response)
          task.message = "Inserting commit message..."
          vim.cmd('Git commit') -- Opens the commit window

          -- Use vim.schedule to wait until the window is open
          vim.schedule(function()
            local lines = vim.split(response, "\n")
            -- append an empty line to the end of lines
            table.insert(lines, "")
            vim.api.nvim_win_set_cursor(0, { 1, 0 })
            vim.api.nvim_put(lines, 'l', true, true) -- 'c' for after cursor, true for paste as lines
            local first_line = vim.api.nvim_buf_get_lines(0, 0, 1, false)[1]
            if first_line == "" then
              vim.api.nvim_buf_set_lines(0, 0, 1, false, {})
            end
            task:finish()
          end)
          return response
        end,
        sticky = '#gitdiff:staged'
      })

end, { silent = true, desc = "Git commit with CopilotChat" })

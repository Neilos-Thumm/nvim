-- claude-prompt.lua
-- Write Claude Code prompts in Neovim and send them to a Claude Code pane in tmux.
--
-- Install: save as ~/.config/nvim/plugin/claude-prompt.lua (Neovim loads it automatically).
--
-- Usage (inside tmux):
--   :ClaudePrompt        open the prompt buffer
--   <CR>   (normal mode) send the whole buffer to Claude, then clear it
--   <C-s>  (normal/insert) same as above
--   <leader>as (visual, any buffer) send the selection as-is
--
-- Which pane receives the prompt (it must be marked with the tmux option @claude = 1,
-- which the claude-nvim launcher sets; otherwise nothing is sent):
--   1. $CLAUDE_PANE, if set by the launcher and still marked
--   2. otherwise the marked pane in the current tmux window
--
-- Files it writes (nothing else is touched):
--   ~/.local/state/nvim/claude-prompts/<project>.md   unsent drafts, one per project folder
--   ~/.local/state/nvim/claude-prompt-history.md      every prompt you have sent
-- To uninstall: delete this file, ~/.local/bin/claude-nvim, and the two paths above.

-- One draft file per project folder, so two Claude windows never share a draft.
local prompt_dir = vim.fn.stdpath("state") .. "/claude-prompts"
local history_file = vim.fn.stdpath("state") .. "/claude-prompt-history.md"

local function prompt_file()
  vim.fn.mkdir(prompt_dir, "p")
  local name = vim.fn.getcwd():gsub("[/\\:]", "%%")
  return prompt_dir .. "/" .. name .. ".md"
end

local function notify(msg, level)
  vim.notify(msg, level or vim.log.levels.INFO, { title = "Claude prompt" })
end

-- Only ever send to a pane marked as Claude's (@claude = 1). Never guess: guessing could
-- paste the prompt into a plain shell and press Enter, which would run it as commands.
local function is_claude_pane(pane)
  local res = vim.system({ "tmux", "display-message", "-p", "-t", pane, "#{@claude}" }):wait()
  return res.code == 0 and vim.trim(res.stdout or "") == "1"
end

local function target_pane()
  local pane = vim.env.CLAUDE_PANE
  if pane and pane ~= "" and is_claude_pane(pane) then
    return pane
  end
  local res = vim.system({ "tmux", "list-panes", "-F", "#{pane_id} #{@claude}" }):wait()
  if res.code == 0 then
    for line in (res.stdout or ""):gmatch("[^\n]+") do
      local id, mark = line:match("^(%%%d+)%s*(.*)$")
      if id and mark == "1" then
        return id
      end
    end
  end
  return nil
end

--- Paste text into the Claude pane and press Enter. Returns true on success.
local function send(text)
  if not vim.env.TMUX then
    notify("Neovim is not running inside tmux", vim.log.levels.ERROR)
    return false
  end

  text = text:gsub("%s+$", "")
  if text == "" then
    notify("Prompt is empty", vim.log.levels.WARN)
    return false
  end

  local pane = target_pane()
  if not pane then
    notify("No Claude pane in this tmux window. Start one with claude-nvim.", vim.log.levels.ERROR)
    return false
  end

  -- Load the text into a named tmux buffer (via stdin, so quotes and newlines are safe).
  local load = vim.system({ "tmux", "load-buffer", "-b", "claude-prompt", "-" }, { stdin = text }):wait()
  if load.code ~= 0 then
    notify("tmux load-buffer failed: " .. (load.stderr or ""), vim.log.levels.ERROR)
    return false
  end

  -- -p: bracketed paste, so newlines become line breaks instead of submitting early.
  -- -d: delete the tmux buffer afterwards.
  local paste = vim.system({ "tmux", "paste-buffer", "-p", "-d", "-b", "claude-prompt", "-t", pane }):wait()
  if paste.code ~= 0 then
    notify("Could not reach Claude pane " .. pane .. ": " .. (paste.stderr or ""), vim.log.levels.ERROR)
    return false
  end

  -- Small delay so Claude Code finishes handling the paste before Enter arrives.
  vim.defer_fn(function()
    vim.system({ "tmux", "send-keys", "-t", pane, "Enter" })
  end, 150)

  return true
end

local function save_history(text)
  local f = io.open(history_file, "a")
  if f then
    f:write(os.date("## %Y-%m-%d %H:%M"), "  ", vim.fn.getcwd(), "\n\n", text, "\n\n")
    f:close()
  end
end

local function send_buffer()
  local buf = vim.api.nvim_get_current_buf()
  local text = table.concat(vim.api.nvim_buf_get_lines(buf, 0, -1, false), "\n")
  if send(text) then
    save_history(text)
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, {})
    vim.cmd("silent! write")
    vim.cmd("startinsert")
  end
end

local function setup_prompt_buffer(buf)
  local opts = { buffer = buf, silent = true }
  vim.keymap.set("n", "<CR>", send_buffer, vim.tbl_extend("force", opts, { desc = "Send prompt to Claude" }))
  vim.keymap.set({ "n", "i" }, "<C-s>", function()
    vim.cmd("stopinsert")
    send_buffer()
  end, vim.tbl_extend("force", opts, { desc = "Send prompt to Claude" }))
  vim.bo[buf].textwidth = 0
  vim.wo.wrap = true

  -- Save the draft on every change. Closing the tmux window (prefix &) then loses nothing,
  -- and because the buffer has no swap file, Neovim shows no swap warning next time.
  vim.api.nvim_create_autocmd({ "TextChanged", "TextChangedI", "InsertLeave", "FocusLost" }, {
    buffer = buf,
    callback = function()
      vim.cmd("silent! update")
    end,
  })
end

vim.api.nvim_create_user_command("ClaudePrompt", function()
  -- noswapfile: the draft is autosaved instead, so a killed pane never leaves a swap file.
  vim.cmd("noswapfile edit " .. vim.fn.fnameescape(prompt_file()))
  setup_prompt_buffer(vim.api.nvim_get_current_buf())
  vim.cmd("startinsert!")
end, { desc = "Open the Claude Code prompt buffer" })

vim.api.nvim_create_user_command("ClaudeHistory", function()
  vim.cmd("noswapfile edit " .. vim.fn.fnameescape(history_file))
end, { desc = "Open the history of sent Claude prompts" })

-- Send a visual selection from any buffer straight to Claude.
vim.keymap.set("x", "<leader>as", function()
  local lines = vim.fn.getregion(vim.fn.getpos("v"), vim.fn.getpos("."), { type = vim.fn.mode() })
  vim.api.nvim_feedkeys(vim.keycode("<Esc>"), "n", false)
  send(table.concat(lines, "\n"))
end, { desc = "Send selection to Claude" })

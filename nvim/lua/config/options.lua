-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- Sync yank/paste with the windows clipboard automatically
vim.opt.clipboard = "unnamedplus"
vim.g.clipboard = {
  name = "win32yank-wsl",
  copy = {
    ["+"] = "win32yank.exe -i --crlf",
    ["*"] = "win32yank.exe -i --crlf",
  },
  paste = {
    ["+"] = "win32yank.exe -o --lf",
    ["*"] = "win32yank.exe -o --lf",
  },
  cache_enabled = 0,
}

-- Automatically enter the last session while someone enters 'nvim' without arg in a given folder
vim.api.nvim_create_autocmd("VimEnter", {
  group = vim.api.nvim_create_augroup("restore_session", { clear = true }),
  callback = function()
    -- Only restore if opening nvim without a specific file
    if vim.fn.argc() == 0 and not vim.g.started_with_stdin then
      -- Close the dashboard if it's open
      if vim.bo.filetype == "snacks_dashboard" or vim.bo.filetype == "alpha" then
        vim.cmd("bd")
      end
      -- 1. Load the session
      require("persistence").load()

      -- 2. Force a filetype check on the current buffer to kickstart highlighting
      vim.schedule(function()
        vim.cmd("filetype detect")
      end)
    end
  end,
  nested = true, -- Critical for proper buffer loading
})

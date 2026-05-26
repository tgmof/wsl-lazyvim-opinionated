-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Add to lua/config/keymaps.lua

-- Open the Dashboard to be able to quickly do things like modify the lua config from any repo
vim.keymap.set("n", "<leader>dh", function()
  Snacks.dashboard()
end, { desc = "Open Dashboard" })

-- Like in Windows, ctrl+a to select all
vim.keymap.set("n", "<C-a>", "ggVG", { desc = "Select All" })
-- Paste the last yank (Register 0) even if you deleted something in between
vim.keymap.set("n", "<leader>p", '"0p', { desc = "Paste last yank only" })
-- Press escape twice to excit the Terminal Mode
vim.keymap.set("t", "<esc>", "<C-\\><C-n>", { desc = "Enter Normal Mode" })
-- Navigate windows directly from terminal mode
vim.keymap.set("t", "<C-h>", "<C-\\><C-n><C-w>h", { silent = true })
vim.keymap.set("t", "<C-j>", "<C-\\><C-n><C-w>j", { silent = true })
vim.keymap.set("t", "<C-k>", "<C-\\><C-n><C-w>k", { silent = true })
vim.keymap.set("t", "<C-l>", "<C-\\><C-n><C-w>l", { silent = true })

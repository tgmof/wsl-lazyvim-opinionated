-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- When trying to open an image, use windows instead of the terminal to open the image file.
vim.api.nvim_create_autocmd("BufReadCmd", {
  pattern = { "*.png", "*.jpg", "*.pdf" },
  callback = function(ev)
    -- 1. Get the absolute Linux path
    local file = vim.fn.expand("<amatch>")

    -- 2. Convert to Windows path (wslpath -w) and trim newline
    local win_path = vim.fn.system("wslpath -w " .. vim.fn.shellescape(file)):gsub("%s+$", "")

    -- 3. Open in Windows and immediately delete the empty buffer in Neovim
    if win_path ~= "" then
      vim.fn.jobstart({ "explorer.exe", win_path }, { detach = true })
      -- If the user pressed Enter on an image file in the <Leader>e explorer, close it first
      -- This also prevents a weird bug whereby the explorer occupies the whole window and cannot be focused
      local pickers = Snacks.picker.get({ source = "explorer" })
      if #pickers > 0 then
        pickers[1]:close()
      end
      -- Remove the empty buffer that was open above
      vim.api.nvim_buf_delete(ev.buf, { force = true })
      vim.notify("Opening " .. vim.fn.fnamemodify(file, ":t") .. " in Windows", vim.log.levels.INFO)
    end
  end,
})

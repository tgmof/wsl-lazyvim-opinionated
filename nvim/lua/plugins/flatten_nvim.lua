return {
  -- Problem this solves: Use a neovim terminal with a long command, press <C-x><C-e> and it opens
  -- your default editor (setup in bashrc using EDITOR=nvim) which results in a vim in vim issue.
  -- This plugin solves this by opening a buffer inside the current nvim, where you can modify
  -- the command and then delete the buffer to automagically paste the result back to the terminal
  -- and run it.
  "willothy/flatten.nvim",
  config = true,
  -- Ensure it loads early
  lazy = false,
  priority = 1001,
  opts = {
    window = {
      -- Options: "current", "alternate", "split", "vsplit"
      open = "current",
    },
  },
}

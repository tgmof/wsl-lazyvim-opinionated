return {
  "folke/persistence.nvim",
  event = "BufReadPre", -- Load the plugin right before reading a buffer
  config = function(_, opts)
    -- 1. Apply LazyVim's default setup first
    require("persistence").setup(opts)

    -- 2. Safely inject terminal tracking into Neovim's session configuration
    vim.opt.sessionoptions:append("terminal")
  end,
}

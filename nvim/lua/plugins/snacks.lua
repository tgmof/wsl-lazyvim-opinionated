return {
  "folke/snacks.nvim",

  opts = {
    picker = {
      -- Forces Neovim out of insert mode the moment ANY picker opens
      -- The idea here is that all "pop-up" behave the same: Explorer, File navigator, string
      -- search,... all open in normal mode and let you navigate to the (potential) non-filtered list
      -- and requires you to explicitely type i to enter insert mode
      on_show = function()
        vim.cmd.stopinsert()
      end,
      hidden = true,
    },
  },
}

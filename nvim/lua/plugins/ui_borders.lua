return {
  -- 1. Package Manager Window (Lazy)
  {
    "folke/lazy.nvim",
    opts = {
      ui = { border = "single" },
    },
  },

  -- 2. LSP Hover Docs and Signature Help (Noice)
  {
    "folke/noice.nvim",
    opts = {
      presets = {
        lsp_doc_border = true, -- Auto-applies standard borders to hover details
      },
    },
  },

  -- 3. Autocomplete Menus & Suggestion Documentation (nvim-cmp)
  {
    "hrsh7th/nvim-cmp",
    opts = function(_, opts)
      local cmp = require("cmp")
      opts.window = {
        completion = cmp.config.window.allowed and cmp.config.window.bordered({ border = "single" })
          or { border = "single" },
        documentation = cmp.config.window.allowed and cmp.config.window.bordered({ border = "single" })
          or { border = "single" },
      }
    end,
  },

  -- 4. Environment Tooling Manager (Mason)
  {
    "mason-org/mason.nvim",
    opts = {
      ui = { border = "single" },
    },
  },

  -- 5. Floating Terminals & Overlays (Snacks)
  -- See ./snacks.lua
  -- 6. The <leader>cd diagnostic pop-ups
  vim.diagnostic.config({
    float = {
      border = "single",
    },
  }),
}

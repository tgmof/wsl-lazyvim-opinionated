return {
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        json = { "prettier", "jq" }, -- Try prettier first, then jq
      },
    },
  },
}

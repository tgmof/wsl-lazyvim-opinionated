return {
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        json = { "prettier", "jq" }, -- Try prettier first, then jq
      },
      formatters = {
        ruff_format = {
          cwd = require("conform.util").root_file({ "pyproject.toml", "ruff.toml" }),
        },
      },
    },
  },
}

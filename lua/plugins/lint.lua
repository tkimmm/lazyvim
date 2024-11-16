return {
  "mfussenegger/nvim-lint",
  opts = {
    linters_by_ft = {
      markdown = { "markdownlint" },
    },
  },
  config = function()
    local lint = require("lint")
    lint.linters_by_ft = {
      javascript = { "eslint_d" },
      typescript = { "eslint_d" },
      javascriptreact = { "eslint_d" },
      typescriptreact = { "eslint_d" },
    }
    local markdownlint = lint.linters.markdownlint
    markdownlint.args = {
      "--disable",
      "MD013",
      "MD007",
      "--", -- Required
    }
  end,
}

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
      javascript = { "biome" },
      typescript = { "biome" },
      javascriptreact = { "biome" },
      typescriptreact = { "biome" },
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

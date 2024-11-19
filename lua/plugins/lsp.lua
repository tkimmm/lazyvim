local nvim_lsp = require("lspconfig")

return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      document_highlight = {
        enabled = false,
      },
      inlay_hints = {
        enabled = false,
      },
      servers = {
        denols = {
          filetypes = { "typescript", "typescriptreact" },
          root_dir = function(...)
            return nvim_lsp.util.root_pattern("deno.jsonc", "deno.json")(...)
          end,
        },
        vtsls = {
          root_dir = nvim_lsp.util.root_pattern("package.json"),
        },
        gopls = {
          settings = {
            gopls = {
              hints = {
                assignVariableTypes = false,
                compositeLiteralFields = false,
                compositeLiteralTypes = false,
                constantValues = false,
                functionTypeParameters = false,
                parameterNames = false,
                rangeVariableTypes = false,
              },
            },
          },
        },
      },
    },
  },
}

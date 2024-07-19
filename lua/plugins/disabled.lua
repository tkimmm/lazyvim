-- since this is just an example spec, don't actually load anything here and return an empty spec
-- stylua: ignore
if true then
  return {
    { "nvim-dev/dashboard-nvim",     enabled = false },
    { "RRethy/vim-illuminate",       enabled = false },
    { "folke/flash.nvim",            enabled = false },
    { "echasnovski/mini.surround",   enabled = false },
    { "echasnovski/mini.ai",         enabled = false },
    { "nvim-neo-tree/neo-tree.nvim", enabled = false },
    { "nvim-neotest/nvim-nio" },
    {
      "nvim-treesitter/nvim-treesitter",
      opts = {
        ensure_installed = {
          "bash",
          "hurl",
          "html",
          "hcl",
          "javascript",
          "json",
          "jsonc",
          "lua",
          "markdown",
          "markdown_inline",
          "python",
          "http",
          "graphql",
          "xml",
          "query",
          "regex",
          "tsx",
          "terraform",
          "typescript",
          "vim",
          "vimdoc",
          "yaml",
          "sql"
        },
      },
    },
    {
      "L3MON4D3/LuaSnip",
      keys = function()
        return {}
      end,
    },
    {
      "hrsh7th/nvim-cmp",
      dependencies = {
        "hrsh7th/cmp-emoji",
      },
      ---@param opts cmp.ConfigSchema
      opts = function(_, opts)
        local has_words_before = function()
          unpack = unpack or table.unpack
          local line, col = unpack(vim.api.nvim_win_get_cursor(0))
          return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
        end

        local luasnip = require("luasnip")
        local cmp = require("cmp")

        opts.mapping = vim.tbl_extend("force", opts.mapping, {
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
              -- You could replace the expand_or_jumpable() calls with expand_or_locally_jumpable()
              -- this way you will only jump inside the snippet region
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            elseif has_words_before() then
              cmp.complete()
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
        })
      end,
    },
    {
      "folke/which-key.nvim",
      optional = true,
    },
    {
      "lambdalisue/suda.vim",
      config = function()
      end,
    }
  }
end

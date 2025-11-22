-- since this is just an example spec, don't actually load anything here and return an empty spec
-- stylua: ignore
if true then
  return {
    { "nvim-dev/dashboard-nvim",     enabled = false },
    { "RRethy/vim-illuminate",       enabled = false },
    { "folke/flash.nvim",            enabled = false },
    { "nvim-mini/mini.surround",   enabled = false },
    { "nvim-mini/mini.ai",         enabled = false },
    { "nvim-neo-tree/neo-tree.nvim", enabled = false },
    { "theHamsta/nvim-dap-virtual-text", enabled = false },
    { "nvim-neotest/nvim-nio" },
    {
      "nvim-treesitter/nvim-treesitter",
      opts = {
        ensure_installed = {
          "go",
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
      "folke/which-key.nvim",
      optional = true,
      opts = {
        preset = "modern",
      },
    },
    {
      "lambdalisue/suda.vim",
      config = function()
      end,
    },
    {
    "folke/trouble.nvim",
    opts = {
        use_diagnostic_signs = true,
        focus = true,
      },
    },
    {
    "folke/snacks.nvim",
    opts = {
      dashboard = { enabled = false },
      scratch = { enabled = false },
      terminal = { enabled = false },
      scroll = { enabled = false },
      indent = { enabled = false },
    },
    },
  }
end

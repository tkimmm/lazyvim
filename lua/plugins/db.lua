-- if true then return {} end
return {
  {
    "kristijanhusak/vim-dadbod-ui",
    event = "VeryLazy",
    dependencies = {
      { "tpope/vim-dadbod", event = "VeryLazy" },
      { "kristijanhusak/vim-dadbod-completion", ft = { "sql", "mysql", "plsql" }, event = "VeryLazy" },
    },
    keys = {
      { "<leader>m", "<cmd>DBUIToggle<CR>", desc = "DB toggle", { silent = true } },
    },
    cmd = {
      "DBUI",
      "DBUIToggle",
      "DBUIAddConnection",
      "DBUIFindBuffer",
    },
    init = function()
      -- Your DBUI configuration
      vim.g.db_ui_use_nerd_fonts = 1
    end,
  },
  { "tpope/vim-dotenv" },
}

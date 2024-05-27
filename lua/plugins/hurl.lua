return {
  {
    "jellydn/hurl.nvim",
    dependencies = {
      "MunifTanjim/nui.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    ft = "hurl",
    opts = {
      -- Show debugging info
      debug = false,
      -- Show notification on run
      show_notification = false,
      -- Show response in popup or split
      mode = "popup",
      -- popup_position = "50%",
      -- popup_size = {
      --   width = 80,
      --   height = 40,
      -- },
      -- Split settings
      -- split_position = "left",
      -- split_size = "30%",
      formatters = {
        json = { "jq" }, -- Make sure you have install jq in your system, e.g: brew install jq
        html = {
          "prettier", -- Make sure you have install prettier in your system, e.g: npm install -g prettier
          "--parser",
          "html",
        },
      },
      env_file = {
        ".dev.vars",
      },
    },
    keys = {
      -- Run API request
      { "<leader>az", "<cmd>HurlRunner<CR>", desc = "Run All requests" },
      { "<leader>aa", "<cmd>HurlRunnerAt<CR>", desc = "Run Api request" },
      { "<leader>as", "<cmd>HurlRunnerToEntry<CR>", desc = "Run Api request to entry" },
      { "<leader>ad", "<cmd>HurlToggleMode<CR>", desc = "Hurl Toggle Mode" },
      { "<leader>af", "<cmd>HurlVerbose<CR>", desc = "Run Api in verbose mode" },
      -- Run Hurl request in visual mode
      { "<leader>aa", ":HurlRunner<CR>", desc = "Hurl Runner", mode = "v" },
    },
  },
}

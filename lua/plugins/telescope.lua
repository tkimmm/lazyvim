return {
  "nvim-telescope/telescope.nvim",
  keys = {
    { "<leader><space>", vim.NIL },
  },
  opts = {
    defaults = {
      file_ignore_patterns = {
        "node_modules", "lib", "build", "dist", ".git/", ".wrangler"
      },
    },
  },
}

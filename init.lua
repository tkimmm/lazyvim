-- Disable netrw
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.g.loaded_python3_provider = 0

-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

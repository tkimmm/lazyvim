-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- A any additional keymaps here

vim.cmd("set cmdheight=6")
vim.keymap.set("i", "jk", "<Esc>", {})
vim.keymap.set("n", "<C-q>", ":bd<CR>", {})
-- Remove highlight line
vim.o.cursorline = false

-- Leave cursor when moving lines up or down
vim.keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Keep cursor in middle when jumping also keep cursor at the end with jump
vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- keep cursor in the centre after ctrl-o
vim.opt.scrolloff = 30

-- Keep last value in register
-- vim.keymap.set("x", "<leader>p", "\"_dP")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- Copy to system register
vim.keymap.set("n", "<leader>y", '"+y')
vim.keymap.set("v", "<leader>y", '"+y')
vim.keymap.set("n", "<leader>Y", '"+Y')

-- ollama commands
vim.g.generate_auto_split = 1
vim.g.generate_right_split = 1
vim.keymap.set({ "n", "v" }, "<leader>o", ":Gen<CR>")

local builtin = require("telescope.builtin")
vim.keymap.set("n", "<C-p>", function()
  builtin.find_files({ hidden = "true" })
end, { desc = "[F]ind [H]idden files" })
vim.keymap.set("n", "<C-f>", function()
  builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
    previewer = true,
  }))
end, { desc = "[f] Fuzzily search in current buffer" })

vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "[F]ind by [G]rep" })
vim.keymap.set("n", "<leader>ff", builtin.oldfiles, { desc = "[F]ind Recent [F]iles" })
vim.keymap.set("n", "<leader>fr", builtin.registers, { desc = "[F]ind  [R]egisters" })
vim.keymap.set("n", "<leader>fw", builtin.grep_string, { desc = "[F]ind current [W]ord" })
vim.keymap.set("n", "<leader>fe", builtin.diagnostics, { desc = "[F]ind [E]rrors" })
vim.keymap.set("n", "<leader>fh", builtin.git_files, { desc = "[F]ind [G]it files" })

-- vim.keymap.set("n", "_", ":Neotree toggle<CR>", { silent = true })
vim.keymap.set("n", "_", ":NvimTreeFindFileToggle<CR>", { silent = true })

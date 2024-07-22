vim.cmd("set cmdheight=6")
vim.keymap.set("i", "jk", "<Esc>", {})
vim.keymap.set("n", "<C-q>", ":bd<CR>", { silent = true })

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

-- Copy to system register
vim.keymap.set("n", "<leader>y", '"+y')
vim.keymap.set("v", "<leader>y", '"+y')
vim.keymap.set("n", "<leader>Y", '"+Y')

-- ollama commands
vim.g.generate_auto_split = 1
vim.g.generate_right_split = 1

-- Toggle addons
vim.keymap.set({ "n", "v" }, "<leader>o", ":Gen<CR>")
vim.keymap.set({ "n", "v" }, "<leader>t", ":Gen Generate_TSDoc<CR>")
-- vim.keymap.set("n", "<leader><space>", ":Format<CR>", { silent = true })

local builtin = require("telescope.builtin")

vim.keymap.set("n", "<C-p>", function()
  builtin.find_files({ hidden = "true", no_ignore = "true" })
end, { desc = "[F]ind [H]idden files" })

vim.keymap.set("n", "<C-f>", function()
  builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
    previewer = true,
  }))
end, { desc = "[f] Fuzzily search in current buffer" })

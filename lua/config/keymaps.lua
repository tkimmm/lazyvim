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

-- clear highlights after searching on searching
vim.keymap.set("n", "<CR>", function()
  vim.cmd("nohl")
  return "<CR>"
end, { expr = true, desc = "Enter and clear search highlights" })

vim.g.mapleader = " "
vim.keymap.set("n", "<leader>e", vim.cmd.Ex, { desc = "Open netrw" })
vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")
vim.keymap.set({ "n", "v" }, "<leader>v", "<C-v>", {
    noremap = true,
    silent = true,
    desc = "Visual Block Mode",
})

vim.keymap.set({ "n", "v" }, "<leader>r", "<C-r>", {
    noremap = true,
    silent = true,
    desc = "Redo",
})

-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

vim.keymap.set({ "n", "v" }, "<leader>y", '"+y', { desc = "Yank to system clipboard" })
vim.keymap.set({ "n", "v" }, "<leader>p", '"+p', { desc = "Paste from system clipboard" })
vim.keymap.set("n", "<leader>r", function()
  require("telescope").extensions.yank_history.yank_history({})
end, { desc = "Open Yank History" })

vim.keymap.set({ "n", "v" }, "<leader>]", ":Gen<CR>")

-- Disabled keymaps
--
-- LazyVim Changelog
vim.keymap.del("n", "<leader>L")

-- save file
vim.keymap.del({ "i", "x", "n", "s" }, "<C-s>")

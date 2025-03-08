return {
  "renerocksai/telekasten.nvim",
  dependencies = { "nvim-telescope/telescope.nvim" },
  opts = {
    home = vim.fn.expand("~/zettelkasten"),
  },
  keys = {
    { "<leader>z", "<cmd>Telekasten panel<CR>", desc = "Telekasten panel" },
    { "<leader>zf", "<cmd>Telekasten find_notes<CR>", desc = "Telekasten find notes" },
    { "<leader>zg", "<cmd>Telekasten search_notes<CR>", desc = "Telekasten search notes" },
    { "<leader>zd", "<cmd>Telekasten goto_today<CR>", desc = "Telekasten goto today" },
    { "<leader>zz", "<cmd>Telekasten follow_link<CR>", desc = "Telekasten follow link" },
    { "<leader>zn", "<cmd>Telekasten new_note<CR>", desc = "Telekasten new note" },
    { "<leader>zc", "<cmd>Telekasten show_calendar<CR>", desc = "Telekasten show calendar" },
    { "<leader>zb", "<cmd>Telekasten show_backlinks<CR>", desc = "Telekasten show backlinks" },
    { "<leader>zI", "<cmd>Telekasten insert_img_link<CR>", desc = "Telekasten insert img link" },
  },
}

return {
  "williamboman/mason.nvim",
  opts = {
    ensure_installed = {
      "flake8",
      "shellcheck",
      "shfmt",
      "stylua",
    },
  },
}

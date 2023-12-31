return {
  {
    "nvim-neotest/neotest",
    keys = {
      {
        "<leader>tl",
        function()
          require("neotest").run.run_last()
        end,
        desc = "Run Last Test",
      },
    },
    dependencies = {
      "nvim-neotest/neotest-jest",
      "rouge8/neotest-rust",
      "stevanmilic/neotest-scala",
    },
    opts = function(_, opts)
      table.insert(
        opts.adapters,
        require("neotest-jest")({
          jestCommand = "npm test --",
          jestConfigFile = "custom.jest.config.ts",
          env = { CI = true },
          cwd = function()
            return vim.fn.getcwd()
          end,
        })
      )
      table.insert(opts.adapters, require("neotest-rust"))
      table.insert(
        opts.adapters,
        require("neotest-scala")({
          runner = "sbt",
          framework = "scalatest",
        })
      )
    end,
  },
}

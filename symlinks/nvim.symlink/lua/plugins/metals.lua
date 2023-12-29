---@diagnostic disable: unused-local

-- copied from https://github.com/scalameta/nvim-metals/discussions/39

return {
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      { "hrsh7th/cmp-nvim-lsp" },
      { "hrsh7th/cmp-vsnip" },
      { "hrsh7th/vim-vsnip" },
    },
    opts = function()
      local cmp = require("cmp")
      local conf = {
        sources = {
          { name = "nvim_lsp" },
          { name = "vsnip" },
        },
        snippet = {
          expand = function(args)
            -- Comes from vsnip
            vim.fn["vsnip#anonymous"](args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          -- None of this made sense to me when first looking into this since there
          -- is no vim docs, but you can't have select = true here _unless_ you are
          -- also using the snippet stuff. So keep in mind that if you remove
          -- snippets you need to remove this select
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
          -- I use tabs... some say you should stick to ins-completion but this is just here as an example
          ["<Tab>"] = function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            else
              fallback()
            end
          end,
          ["<S-Tab>"] = function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            else
              fallback()
            end
          end,
        }),
      }
      return conf
    end,
  },
  {
    "scalameta/nvim-metals",
    dependencies = {
      "nvim-lua/plenary.nvim",
      {
        "mfussenegger/nvim-dap",
        config = function(self, opts)
          -- Debug settings if you're using nvim-dap
          local dap = require("dap")

          dap.configurations.scala = {
            {
              type = "scala",
              request = "launch",
              name = "RunOrTest",
              metals = {
                runType = "runOrTestFile",
                --args = { "firstArg", "secondArg", "thirdArg" }, -- here just as an example
              },
            },
            {
              type = "scala",
              request = "launch",
              name = "Test Target",
              metals = {
                runType = "testTarget",
              },
            },
          }
        end,
      },
    },
    ft = { "scala", "sbt", "java" },
    opts = function()
      local metals_config = require("metals").bare_config()

      -- Example of settings
      metals_config.settings = {
        showImplicitArguments = true,
        excludedPackages = { "akka.actor.typed.javadsl", "com.github.swagger.akka.javadsl" },
      }

      -- *READ THIS*
      -- I *highly* recommend setting statusBarProvider to true, however if you do,
      -- you *have* to have a setting to display this in your statusline or else
      -- you'll not see any messages from metals. There is more info in the help
      -- docs about this
      -- metals_config.init_options.statusBarProvider = "on"

      -- Example if you are using cmp how to make sure the correct capabilities for snippets are set
      metals_config.capabilities = require("cmp_nvim_lsp").default_capabilities()

      metals_config.on_attach = function(client, bufnr)
        require("metals").setup_dap()

        -- LSP mappings
        vim.map("n", "gD", vim.lsp.buf.definition)
        vim.map("n", "K", vim.lsp.buf.hover)
        vim.map("n", "gi", vim.lsp.buf.implementation)
        vim.map("n", "gr", vim.lsp.buf.references)
        vim.map("n", "gds", vim.lsp.buf.document_symbol)
        vim.map("n", "gws", vim.lsp.buf.workspace_symbol)
        vim.map("n", "<leader>cl", vim.lsp.codelens.run)
        vim.map("n", "<leader>sh", vim.lsp.buf.signature_help)
        vim.map("n", "<leader>rn", vim.lsp.buf.rename)
        vim.map("n", "<leader>f", vim.lsp.buf.format)
        vim.map("n", "<leader>ca", vim.lsp.buf.code_action)

        vim.map("n", "<leader>ws", function()
          require("metals").hover_worksheet()
        end)

        -- all workspace diagnostics
        vim.map("n", "<leader>aa", vim.diagnostic.setqflist)

        -- all workspace errors
        vim.map("n", "<leader>ae", function()
          vim.diagnostic.setqflist({ severity = "E" })
        end)

        -- all workspace warnings
        vim.map("n", "<leader>aw", function()
          vim.diagnostic.setqflist({ severity = "W" })
        end)

        -- buffer diagnostics only
        vim.map("n", "<leader>d", vim.diagnostic.setloclist)

        vim.map("n", "[c", function()
          vim.diagnostic.goto_prev({ wrap = false })
        end)

        vim.map("n", "]c", function()
          vim.diagnostic.goto_next({ wrap = false })
        end)

        -- Example mappings for usage with nvim-dap. If you don't use that, you can
        -- skip these
        vim.map("n", "<leader>dc", function()
          require("dap").continue()
        end)

        vim.map("n", "<leader>dr", function()
          require("dap").repl.toggle()
        end)

        vim.map("n", "<leader>dK", function()
          require("dap.ui.widgets").hover()
        end)

        vim.map("n", "<leader>dt", function()
          require("dap").toggle_breakpoint()
        end)

        vim.map("n", "<leader>dso", function()
          require("dap").step_over()
        end)

        vim.map("n", "<leader>dsi", function()
          require("dap").step_into()
        end)

        vim.map("n", "<leader>dl", function()
          require("dap").run_last()
        end)
      end

      return metals_config
    end,
    config = function(self, metals_config)
      local nvim_metals_group = vim.api.nvim_create_augroup("nvim-metals", { clear = true })
      vim.api.nvim_create_autocmd("FileType", {
        pattern = self.ft,
        callback = function()
          require("metals").initialize_or_attach(metals_config)
        end,
        group = nvim_metals_group,
      })
    end,
  },
}

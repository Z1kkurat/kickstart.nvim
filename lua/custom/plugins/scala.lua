return {
  {
    "folke/which-key.nvim",
    opts = {
      defaults = {
        ["<leader>m"] = { name = "[M]etals" },
      },
    },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, { "scala" })
      end
    end,
  },

  {
    "scalameta/nvim-metals",
    dependencies = {
      "nvim-lua/plenary.nvim",
      {
        "mfussenegger/nvim-dap",
        config = function(self, opts)
          local map = vim.keymap.set
          -- Debug settings if you're using nvim-dap
          local dap = require("dap")

          -- Example mappings for usage with nvim-dap. If you don't use that, you can
          -- skip these
          -- map("n", "<leader>dc", function()
          --   require("dap").continue()
          -- end, { desc = "[d]ap continue" })
          --
          -- map("n", "<leader>dr", function()
          --   require("dap").repl.toggle()
          -- end, { desc = "[d]ap [r]epl toggle" })
          --
          -- map("n", "<leader>dK", function()
          --   require("dap.ui.widgets").hover()
          -- end, { desc = "[d]ap UI widgets" })
          --
          -- map("n", "<leader>dt", function()
          --   require("dap").toggle_breakpoint()
          -- end, { desc = "[d]ap [t]oggle breakpoint" })
          --
          -- map("n", "<leader>dso", function()
          --   require("dap").step_over()
          -- end, { desc = "[d]ap [s]tep [o]ver" })
          --
          -- map("n", "<leader>dsi", function()
          --   require("dap").step_into()
          -- end, { desc = "[d]ap [s]tep [i]nto" })
          --
          -- map("n", "<leader>dl", function()
          --   require("dap").run_last()
          -- end, { desc = "[d]ap run [l]ast" })
          --
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
        end
      }
    },
    config = function()
      local metals_config = require("metals").bare_config()
      local map = vim.keymap.set
      metals_config.settings = {
        showImplicitArguments = true,
        -- excludedPackages = { "akka.actor.typed.javadsl", "com.github.swagger.akka.javadsl" },
      }
      metals_config.init_options.statusBarProvider = "on"
      metals_config.capabilities = require("cmp_nvim_lsp").default_capabilities()

      metals_config.on_attach = function(client, bufnr)
        require("metals").setup_dap()

        map("n", "<leader>mt", function()
          require("metals.tvp").toggle_tree_view()
        end, { desc = "Toggle [m]etals [t]ree view" })

        map("n", "<leader>mr", function()
          require("metals.tvp").reveal_in_tree()
        end, { desc = "[m]etals [r]eveal in tree view" })

        map("n", "<leader>ml", function()
          require("metals").toggle_logs()
        end, { desc = "Show [m]etals [l]ogs" })

        map("n", "<leader>mi", function()
          require("metals").import_build()
        end, { desc = "[m]etals [i]mport build" })

        map("n", "<leader>mf", function()
          require("metals").find_in_dependency_jars()
        end, { desc = "[m]etals [f]ind in dependency JARs" })
      end
      -- Autocmd that will actually be in charging of starting the whole thing
      local nvim_metals_group = vim.api.nvim_create_augroup("nvim-metals", { clear = true })
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "scala", "sbt", "java" },
        callback = function()
          require("metals").initialize_or_attach(metals_config)
        end,
        group = nvim_metals_group,
      })
    end,
  },
}

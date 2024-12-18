return {
  "nvim-tree/nvim-tree.lua",
  version = "*",
  lazy = false,
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    require("nvim-tree").setup {
      view = {
        width = {},
        centralize_selection = true,
      }
    }
  end,
  keys = {
    {
      '<leader>e',
      function()
        require('nvim-tree.api').tree.toggle()
      end,
      desc = 'Open file explorer',
    },
    {
      '<leader>ff',
      function()
        require('nvim-tree.api').tree.open({ focus = true, find_file = true })
      end,
      desc = 'Find file in file explorer',
    }
  },
}

return {
  'ruifm/gitlinker.nvim',
  lazy = true,
  keys = {
    {
      '<leader>gy',
      function()
        local mode = string.lower(vim.fn.mode())
        require("gitlinker").get_buf_range_url(mode)
      end,
      mode = { 'n', 'v' },
      desc = '[g]itlinker [y]ank perma link'
    },
    {
      '<leader>gY',
      function()
        local mode = string.lower(vim.fn.mode())
        require("gitlinker").get_buf_range_url(mode, { action_callback = require("gitlinker.actions").open_in_browser })
      end,
      mode = { 'n', 'v' },
      desc = '[g]itlinker [Y]ank and open perma link'
    }
  },
  config = function()
    require('gitlinker').setup({
      mappings = nil,
      callbacks = {
        ["gitlab.evolution.com"] = require "gitlinker.hosts".get_gitlab_type_url
        -- ["gitlab.evolutiongaming.com"] = require "gitlinker.hosts".get_gitlab_type_url
      }
    })
  end,
}

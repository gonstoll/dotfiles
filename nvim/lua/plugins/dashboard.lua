return {
  'glepnir/dashboard-nvim',
  event = 'UIEnter',
  dependencies = {
    {'nvim-tree/nvim-web-devicons', lazy = true},
  },
  opts = {
    theme = 'hyper',
    config = {
      shortcut = {
        {
          desc = 'Dev projects',
          group = 'DashboardShortCut',
          key = 'd',
          action = 'Telescope file_browser cwd=~/Dev/projects'
        },
      },
      header = {
        [[                                                                                   ]],
        [[                                                                                   ]],
        [[                                                                                   ]],
        [[      ___           ___           ___           ___                       ___      ]],
        [[     /\__\         /\  \         /\  \         /\__\          ___        /\__\     ]],
        [[    /::|  |       /::\  \       /::\  \       /:/  /         /\  \      /::|  |    ]],
        [[   /:|:|  |      /:/\:\  \     /:/\:\  \     /:/  /          \:\  \    /:|:|  |    ]],
        [[  /:/|:|  |__   /::\~\:\  \   /:/  \:\  \   /:/__/  ___      /::\__\  /:/|:|__|__  ]],
        [[ /:/ |:| /\__\ /:/\:\ \:\__\ /:/__/ \:\__\  |:|  | /\__\  __/:/\/__/ /:/ |::::\__\ ]],
        [[ \/__|:|/:/  / \:\~\:\ \/__/ \:\  \ /:/  /  |:|  |/:/  / /\/:/  /    \/__/~~/:/  / ]],
        [[     |:/:/  /   \:\ \:\__\    \:\  /:/  /   |:|__/:/  /  \::/__/           /:/  /  ]],
        [[     |::/  /     \:\ \/__/     \:\/:/  /     \::::/__/    \:\__\          /:/  /   ]],
        [[     /:/  /       \:\__\        \::/  /       ~~~~         \/__/         /:/  /    ]],
        [[     \/__/         \/__/         \/__/                                   \/__/     ]],
        [[                                                                                   ]],
        [[                                                                                   ]],
        [[                                                                                   ]],
      },
      footer = {
        [[]],
        [[]],
        'Do, or do not.',
        'There is no try.',
        [[]],
      }
    }
  },
  config = function(_, opts)
    local dashboard = require('dashboard')
    dashboard.setup(opts)

    local colorscheme = vim.g.colors_name
    if (colorscheme == 'rose-pine') then
      local rp_palette = require('rose-pine.palette')

      vim.api.nvim_set_hl(0, 'DashboardHeader', {fg = rp_palette.text})
      vim.api.nvim_set_hl(0, 'DashboardFooter', {fg = rp_palette.love})
    end
  end
}

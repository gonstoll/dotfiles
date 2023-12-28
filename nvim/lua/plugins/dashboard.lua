return {
  'glepnir/dashboard-nvim',
  event = 'UIEnter',
  dependencies = {'nvim-tree/nvim-web-devicons'},
  opts = {
    theme = 'hyper',
    config = {
      project = {
        enable = true,
        limit = 8,
        action = function(path)
          require('telescope.builtin').find_files({cwd = path})
        end
      },
      shortcut = {
        {
          desc = 'Dev projects',
          group = 'DashboardShortCut',
          key = 'd',
          action = function()
            require('telescope').extensions.file_browser.file_browser({cwd = '~/Dev/projects'})
          end,
        },
        {
          desc = 'Dotfiles',
          group = 'DashboardShortCut',
          key = 'f',
          action = function()
            require('telescope.builtin').find_files({cwd = '~/dotfiles'})
          end,
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
      },
    }
  },
}

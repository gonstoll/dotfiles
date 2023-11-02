# Neovim configuration

This is my Neovim configuration. As you might've guessed by the screenshots, this configuration is heavily inclined for
Frontend development, with support for Typescript, tsx, tailwind, and more. That being said, it's completely extendable
to suit any of your needs :)

Take from it what you need!

| Dark mode                                                                             | Light mode                                                                              |
| ------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------- |
| <img src="/__images/dark-mode-1.png" alt="Neovim dark mode screenshot - Dashboard" /> | <img src="/__images/light-mode-1.png" alt="Neovim light mode screenshot - Dashboard" /> |
| <img src="/__images/dark-mode-2.png" alt="Neovim dark mode screenshot" />             | <img src="/__images/light-mode-2.png" alt="Neovim light mode screenshot" />             |

Always a WIP 😅

## Plugins

- [`lazy.nvim`](https://github.com/folke/lazy.nvim) - A modern plugin manager for Neovim
- [`gruvbox-material`](https://github.com/sainnhe/gruvbox-material) - Gruvbox with Material Palette
- [`rose-pine`](https://github.com/rose-pine/neovim) - Soho vibes for Neovim
- [`nvim-lspconfig`](https://github.com/neovim/nvim-lspconfig) - Quickstart configs for Nvim LSP
  - [`mason.nvim`](https://github.com/williamboman/mason.nvim) - Easily install and manage LSP servers, DAP servers, linters, and formatters
  - [`mason-lspconfig.nvim`](https://github.com/williamboman/mason-lspconfig.nvim) - Extension to mason.nvim that makes it easier to use lspconfig with mason.nvim
- [`nvim-cmp`](https://github.com/hrsh7th/nvim-cmp) - A completion plugin for neovim coded in Lua
  - [`cmp-nvim-lsp`](https://github.com/hrsh7th/cmp-nvim-lsp) - nvim-cmp source for neovim builtin LSP client
  - [`cmp_luasnip`](https://github.com/saadparwaiz1/cmp_luasnip) - luasnip completion source for nvim-cmp
  - [`cmp-buffer`](https://github.com/hrsh7th/cmp-buffer) - nvim-cmp source for buffer words
  - [`cmp-calc`](https://github.com/hrsh7th/cmp-calc) - nvim-cmp source for math calculation
  - [`cmp-cmdline`](https://github.com/hrsh7th/cmp-cmdline) - nvim-cmp source for vim's cmdline
  - [`cmp-emoji`](https://github.com/hrsh7th/cmp-emoji) - nvim-cmp source for emoji
  - [`cmp-path`](https://github.com/hrsh7th/cmp-path) - nvim-cmp source for path
  - [`lspkind-nvim`](https://github.com/onsails/lspkind.nvim) - vscode-like pictograms for neovim lsp completion items
- [`telescope.nvim`](https://github.com/nvim-telescope/telescope.nvim) - Find, Filter, Preview, Pick. All lua, all the time
  - [`telescope-file-browser.nvim`](https://github.com/nvim-telescope/telescope-file-browser.nvim) - File Browser extension for telescope.nvim
  - [`telescope-fzf-native.nvim`](https://github.com/nvim-telescope/telescope-fzf-native.nvim) - FZF sorter for telescope written in c
- [`conform.nvim`](https://github.com/stevearc/conform.nvim) - Lightweight yet powerful formatter plugin for Neovim
- [`gitsigns.nvim`](https://github.com/lewis6991/gitsigns.nvim) - Git integration for buffers
- [`lazygit.nvim`](https://github.com/kdheepak/lazygit.nvim) - Plugin for calling lazygit from within neovim
- [`vim-fugitive`](https://github.com/tpope/vim-fugitive) - A Git wrapper so awesome, it should be illegal
- [`lspsaga.nvim`](https://github.com/nvimdev/lspsaga.nvim) - improve neovim lsp experience
- [`bufferline.nvim`](https://github.com/akinsho/bufferline.nvim) - A snazzy 💅 buffer line (with tabpage integration) for Neovim built using lua
- [`buffdelete.nvim`](https://github.com/famiu/bufdelete.nvim) - Close buffers without Neovim crushing down
- [`lualine.nvim`](https://github.com/nvim-lualine/lualine.nvim) - A blazing fast and easy to configure neovim statusline plugin written in pure lua
- [`indent-blankline.nvim`](https://github.com/lukas-reineke/indent-blankline.nvim) - Indent guides for Neovim
- [`Comment.nvim`](https://github.com/numToStr/Comment.nvim) - Smart and powerful comment plugin for neovim
- [`copilot.vim`](https://github.com/github/copilot.vim) - Neovim plugin for GitHub Copilot
- [`LuaSnip`](https://github.com/L3MON4D3/LuaSnip) - Snippet Engine for Neovim written in Lua
- [`friendly-snippets`](https://github.com/rafamadriz/friendly-snippets) - Set of preconfigured snippets for different languages
- [`dashboard-nvim`](https://github.com/nvimdev/dashboard-nvim) - vim dashboard
- [`diagnostic-window.nvim`](https://github.com/cseickel/diagnostic-window.nvim) - Shows diagnostic messages in a separate window
- [`markdown-preview.nvim`](https://github.com/iamcco/markdown-preview.nvim) - markdown preview plugin for (neo)vim
- [`nvim-autopairs`](https://github.com/windwp/nvim-autopairs) - autopairs for neovim written by lua
- [`nvim-scrollbar`](https://github.com/petertriho/nvim-scrollbar) - Extensible Neovim Scrollbar
- [`nvim-spectre`](https://github.com/nvim-pack/nvim-spectre) - Find the enemy and replace them with dark power
- [`nvim-treesitter`](https://github.com/nvim-treesitter/nvim-treesitter) - Nvim Treesitter configurations and abstraction layer
- [`nvim-ts-autotag`](https://github.com/windwp/nvim-ts-autotag) - Use treesitter to auto close and auto rename html tag
- [`nvim-ufo`](https://github.com/kevinhwang91/nvim-ufo) - Not UFO in the sky, but an ultra fold in Neovim
- [`nvim-web-devicons`](https://github.com/nvim-tree/nvim-web-devicons) - lua `fork` of vim-web-devicons for neovim
- [`schemastore.nvim`](https://github.com/b0o/SchemaStore.nvim) - JSON schemas for Neovim
- [`todo-comments.nvim`](https://github.com/folke/todo-comments.nvim) - Highlight, list and search todo comments in your projects
- [`trouble.nvim`](https://github.com/folke/trouble.nvim) - A pretty diagnostics, references, telescope results, quickfix and location list
- [`typescript-tools.nvim`](https://github.com/pmizio/typescript-tools.nvim) - TypeScript integration NeoVim deserves
- [`vim-surround`](https://github.com/tpope/vim-surround) - Delete/change/add parentheses/quotes/XML-tags/much more with ease
- [`vim-test`](https://github.com/vim-test/vim-test) - Run your tests at the speed of thought
- [`which-key.nvim`](https://github.com/folke/which-key.nvim) - displays a popup with possible keybindings of the command you started typing
- [`package-info.nvim`](https://github.com/vuki656/package-info.nvim) - All the npm/yarn/pnpm commands I don't want to type
- [`vim-visual-multi`](https://github.com/mg979/vim-visual-multi) - Multiple cursors plugin for vim/neovim
- [`neodev.nvim`](https://github.com/folke/neodev.nvim) - plugin development with full signature help, docs and completion for the nvim lua API
- [`vim-carbon-now-sh`](https://github.com/ellisonleao/carbon-now.nvim) - Create beautiful code snippets directly from your neovim terminal
- [`nui.nvim`](https://github.com/MunifTanjim/nui.nvim) - UI Component Library for Neovim
- [`plenary.nvim`](https://github.com/nvim-lua/plenary.nvim) - All the lua functions I don't want to write twice
- [`promise-async`](https://github.com/kevinhwang91/promise-async) - Promise & Async in Lua
- [`duck.nvim`](https://github.com/tamton-aquib/duck.nvim/tree/main) - A duck that waddles arbitrarily in neovim

## More screenshots

<img src="/__images/neovim/neovim-1.png" alt="Neovim and telescope screenshot" />
<img src="/__images/neovim/neovim-2.png" alt="Neovim and lazygit screenshot" />
<img src="/__images/neovim/neovim-3.png" alt="Neovim and tailwind classes screenshot" />
<img src="/__images/neovim/neovim-4.png" alt="Neovim and tailwind colors screenshot" />
<img src="/__images/neovim/neovim-5.png" alt="Neovim and auto-import screenshot" />
<img src="/__images/neovim/neovim-6.png" alt="Neovim and splits screenshot" />

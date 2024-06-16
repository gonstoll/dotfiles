# Neovim configuration

<img src="/__images/screenshot.png" alt="Dotfiles screenshot" />

This is my Neovim configuration. As you might've guessed by the screenshots, this configuration is heavily inclined for
Frontend development, with support for Typescript, tsx, tailwind, and more. That being said, it's completely extendable
to suit any of your needs :)

Take from it what you need!

Always a WIP 😅

## Plugins

- [`lazy.nvim`](https://github.com/folke/lazy.nvim) - A modern plugin manager for Neovim
- [`harpoon`](https://github.com/ThePrimeagen/harpoon/tree/harpoon2) - Getting you where you want with the fewest keystrokes
- [`cloak.nvim`](https://github.com/laytan/cloak.nvim) - Cloak allows you to overlay \*'s over defined patterns in defined files
- [`nvim-dap`](https://github.com/mfussenegger/nvim-dap) - Debug Adapter Protocol client implementation for Neovim
  - [`nvim-dap-ui`](https://github.com/rcarriga/nvim-dap-ui) - A UI for nvim-dap
  - [`vscode-js-debug`](https://github.com/microsoft/vscode-js-debug) - A DAP-compatible JavaScript debugger. Used in VS Code, VS, + more
  - [`nvim-dap-vscode-js`](https://github.com/mxsdev/nvim-dap-vscode-js) - nvim-dap adapter for vscode-js-debug
  - [`nvim-dap-virtual-text`](https://github.com/theHamsta/nvim-dap-virtual-text) - This plugin adds virtual text support to nvim-dap
  - [`one-small-step-for-vimkind`](https://github.com/jbyuki/one-small-step-for-vimkind) - Debug adapter for Neovim plugins
  - [`overseer.nvim`](https://github.com/stevearc/overseer.nvim) - A task runner and job management plugin for Neovim
- [`kanagawa.nvim`](https://github.com/rebelot/kanagawa.nvim) - NeoVim dark colorscheme inspired by the colors of the famous painting by Katsushika Hokusai.
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
- [`oil.nvim`](https://github.com/stevearc/oil.nvim) - Neovim file explorer: edit your filesystem like a buffer
- [`telescope.nvim`](https://github.com/nvim-telescope/telescope.nvim) - Find, Filter, Preview, Pick. All lua, all the time
  - [`telescope-file-browser.nvim`](https://github.com/nvim-telescope/telescope-file-browser.nvim) - File Browser extension for telescope.nvim
  - [`telescope-fzf-native.nvim`](https://github.com/nvim-telescope/telescope-fzf-native.nvim) - FZF sorter for telescope written in c
- [`conform.nvim`](https://github.com/stevearc/conform.nvim) - Lightweight yet powerful formatter plugin for Neovim
- [`gitsigns.nvim`](https://github.com/lewis6991/gitsigns.nvim) - Git integration for buffers
- [`lazygit.nvim`](https://github.com/kdheepak/lazygit.nvim) - Plugin for calling lazygit from within neovim
- [`vim-fugitive`](https://github.com/tpope/vim-fugitive) - A Git wrapper so awesome, it should be illegal
- [`lspsaga.nvim`](https://github.com/nvimdev/lspsaga.nvim) - improve neovim lsp experience
- [`indent-blankline.nvim`](https://github.com/lukas-reineke/indent-blankline.nvim) - Indent guides for Neovim
- [`Comment.nvim`](https://github.com/numToStr/Comment.nvim) - Smart and powerful comment plugin for neovim
- [`copilot.vim`](https://github.com/github/copilot.vim) - Neovim plugin for GitHub Copilot
- [`LuaSnip`](https://github.com/L3MON4D3/LuaSnip) - Snippet Engine for Neovim written in Lua
- [`markdown-preview.nvim`](https://github.com/iamcco/markdown-preview.nvim) - markdown preview plugin for (neo)vim
- [`nvim-spectre`](https://github.com/nvim-pack/nvim-spectre) - Find the enemy and replace them with dark power
- [`nvim-treesitter`](https://github.com/nvim-treesitter/nvim-treesitter) - Nvim Treesitter configurations and abstraction layer
- [`nvim-ts-autotag`](https://github.com/windwp/nvim-ts-autotag) - Use treesitter to auto close and auto rename html tag
- [`nvim-ufo`](https://github.com/kevinhwang91/nvim-ufo) - Not UFO in the sky, but an ultra fold in Neovim
- [`nvim-web-devicons`](https://github.com/nvim-tree/nvim-web-devicons) - lua `fork` of vim-web-devicons for neovim
- [`todo-comments.nvim`](https://github.com/folke/todo-comments.nvim) - Highlight, list and search todo comments in your projects
- [`trouble.nvim`](https://github.com/folke/trouble.nvim) - A pretty diagnostics, references, telescope results, quickfix and location list
- [`vim-surround`](https://github.com/tpope/vim-surround) - Delete/change/add parentheses/quotes/XML-tags/much more with ease
- [`vim-test`](https://github.com/vim-test/vim-test) - Run your tests at the speed of thought
- [`which-key.nvim`](https://github.com/folke/which-key.nvim) - displays a popup with possible keybindings of the command you started typing
- [`package-info.nvim`](https://github.com/vuki656/package-info.nvim) - All the npm/yarn/pnpm commands I don't want to type
- [`neogen`](https://github.com/danymat/neogen) - A better annotation generator. Supports multiple languages and annotation conventions.
- [`neodev.nvim`](https://github.com/folke/neodev.nvim) - plugin development with full signature help, docs and completion for the nvim lua API
- [`vim-carbon-now-sh`](https://github.com/ellisonleao/carbon-now.nvim) - Create beautiful code snippets directly from your neovim terminal
- [`nui.nvim`](https://github.com/MunifTanjim/nui.nvim) - UI Component Library for Neovim
- [`plenary.nvim`](https://github.com/nvim-lua/plenary.nvim) - All the lua functions I don't want to write twice
- [`promise-async`](https://github.com/kevinhwang91/promise-async) - Promise & Async in Lua
- [`dressing.nvim`](https://github.com/stevearc/dressing.nvim) - Neovim plugin to improve the default vim.ui interfaces
- [`duck.nvim`](https://github.com/tamton-aquib/duck.nvim/tree/main) - A duck that waddles arbitrarily in neovim
- [`cellular-automaton.nvim`](https://github.com/Eandrju/cellular-automaton.nvim) - A useless plugin that might help you cope with stubbornly broken tests or overall lack of sense in life. It lets you execute aesthetically pleasing, cellular automaton animations based on the content of neovim buffer

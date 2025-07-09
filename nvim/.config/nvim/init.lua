
vim.opt.compatible = false

vim.opt.termguicolors = true -- Enable true colors (24-bit)

vim.opt.fileencoding = 'utf-8' -- Default file encoding
vim.opt.encoding = 'utf-8'     -- Internal Vim encoding

vim.opt.number = true        -- Show line numbers
vim.opt.relativenumber = false -- Don't use relative line numbers by default, can be toggled
vim.opt.wrap = false         -- Do not wrap lines
vim.opt.linebreak = true     -- Break lines at word boundaries if wrapping is enabled
vim.opt.lazyredraw = true    -- Faster redrawing for macros

vim.opt.backspace = 'indent,eol,start' -- Allow backspacing over various contexts
vim.opt.smarttab = true       -- Smart tab behavior
vim.opt.expandtab = true      -- Use spaces instead of tabs
vim.opt.tabstop = 2           -- Number of spaces a <Tab> in the file counts for
vim.opt.shiftwidth = 2        -- Number of spaces to use for each step of (auto)indent
vim.opt.shiftround = true     -- Round indent to 'shiftwidth' when shifting

vim.opt.laststatus = 3        -- Always show the status line

vim.opt.swapfile = false      -- Disable swap files
vim.opt.backup = false        -- Disable backup files
vim.opt.hidden = true         -- Allow hidden buffers (important for LSP)
vim.opt.writebackup = false   -- Disable writebackup (related to swap/backup)
vim.opt.cmdheight = 1         -- Command line height

vim.opt.updatetime = 300      -- Time in ms to wait for CursorHold (for diagnostics, etc.)
vim.opt.shortmess:append('c') -- Don't pass messages to completion menu

-- Search settings
vim.opt.ignorecase = true     -- Ignore case in search patterns
vim.opt.smartcase = true      -- Override 'ignorecase' if search pattern contains uppercase letters
vim.opt.hlsearch = true       -- Highlight all matches
vim.opt.incsearch = true      -- Highlight matches as you type
vim.opt.showmatch = true      -- Show matching bracket

vim.opt.wildmenu = true       -- Enable wildmenu completion for commands
vim.opt.wildmode = 'list:longest,full' -- How wildmenu completion behaves

vim.opt.signcolumn = 'yes'    -- Always show the signcolumn (for LSP diagnostics)

-- Install lazy.nvim if it's not already there
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Initialize lazy.nvim and declare plugins
require("lazy").setup({
  -- General Editing & Utilities
  "nvim-tree/nvim-web-devicons", -- Required for various icons (e.g., in nvim-tree, lualine)
  {
    "nvim-tree/nvim-tree.lua", -- Replacement for Netrw/Vexplore/Sexplore
    opts = {
      disable_netrw = true, -- Keep this true to use nvim-tree exclusively
      hijack_netrw = true,  -- Keep this true for seamless nvim-tree integration
      update_focused_file = {
        enable = true,
        update_root = true,
      },
    },
  },
  { 'nvim-lua/plenary.nvim' }, -- General utility functions for Lua plugins
  { 'tpope/vim-abolish' },    -- word variants
  { 'tpope/vim-commentary' }, -- commenting with gc
  { 'tpope/vim-endwise' },    -- end blocks
  { 'tpope/vim-fugitive' },   -- Git integration (still excellent)
  { 'tpope/vim-repeat' },     -- repeat custom commands
  { 'tpope/vim-surround' },   -- surround custom commands
  { 'tpope/vim-unimpaired' }, -- bracket mappings

  -- UI & Theming
  {
    "catppuccin/nvim", -- A popular modern colorscheme
    name = "catppuccin",
    priority = 1000, -- Make sure it loads first
    config = function()
      vim.cmd.colorscheme "catppuccin-mocha"
    end,
  },
  {
    'nvim-lualine/lualine.nvim', -- Replacement for vim-airline
    opts = {
      options = {
        icons_enabled = true,
        theme = 'auto',
        component_separators = { left = '', right = '' },
        section_separators = { left = '', right = '' },
        -- You can configure sections here, e.g., to show LSP status, Git status
      },
      sections = {
        lualine_x = { 'diagnostics', 'encoding', 'filetype', 'location' },
        lualine_y = { 'progress' },
        lualine_z = { 'diff', 'branch' },
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { 'filename' },
        lualine_x = { 'location' },
        lualine_y = {},
        lualine_z = {},
      },
      tabline = {},
      extensions = { 'nvim-tree' },
    },
  },

  {
    "mason-org/mason-lspconfig.nvim",
    opts = {},
    dependencies = {
        { "mason-org/mason.nvim", opts = {} },
        "neovim/nvim-lspconfig",
    },
  },
  { 'hrsh7th/cmp-nvim-lsp' }, -- LSP source for nvim-cmp
  { 'hrsh7th/cmp-buffer' },   -- Buffer source for nvim-cmp
  { 'hrsh7th/cmp-path' },     -- Path source for nvim-cmp
  { 'hrsh7th/cmp-cmdline' },  -- Cmdline source for nvim-cmp
  { 'hrsh7th/nvim-cmp' },     -- Autocompletion plugin
  { 'L3MON4D3/LuaSnip' },     -- Snippet engine


  -- Treesitter (Modern Syntax Highlighting & Code Understanding)
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate', -- Command to run after installation
    opts = {
      ensure_installed = {
        'bash', 'c', 'cpp', 'css', 'html', 'javascript', 'json', 'lua',
        'markdown', 'markdown_inline', 'python', 'ruby', 'typescript', 'go',
        'haskell', 'vim', 'vimdoc', 'query'
      },
      highlight = {
        enable = true,
        -- Set to `false` if you don't want the TS highlighting in vim.cmd.colorscheme
        disable = { "html", "css" }, -- Disable for very large files or if it causes issues
        additional_vim_regex_highlighting = { "markdown" },
      },
      indent = { enable = true },
      textobjects = { enable = true }, -- Recommended for better text object selections
    },
    config = function(_, opts)
      require('nvim-treesitter.configs').setup(opts)
    end,
  },
  { 'nvim-treesitter/nvim-treesitter-textobjects' }, -- Extends treesitter text objects

  -- Git Integration
  { 'lewis6991/gitsigns.nvim', config = true }, -- Replacement for vim-signify

  -- Language Specific
  {
    'fatih/vim-go',
    lazy = true, ft = 'go',
    init = function()
      vim.g.go_def_mapping_enabled = 0
      vim.g.go_highlight_functions = 1
      vim.g.go_highlight_types = 1
    end
  },
  {
    'junegunn/fzf',
    build = function()
      vim.fn.system({ vim.fn.stdpath('data') .. '/lazy/fzf/install', '--all' })
    end
  },
  { 'junegunn/fzf.vim' }, -- Finder vim bindings (uses FZF)

  {
  "yetone/avante.nvim",
  -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
  -- ⚠️ must add this setting! ! !
  build = function()
    -- conditionally use the correct build system for the current OS
    if vim.fn.has("win32") == 1 then
      return "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false"
    else
      return "BUILD_FROM_SOURCE=true make"
    end
  end,
  event = "VeryLazy",
  version = false,
  ---@module 'avante'
  ---@type avante.Config
  opts = {
    -- add any opts here
    -- for example
    provider = "gemini",
    providers = {
      gemini = {
        model = "gemini-2.5-pro",
        max_tokens = 4096,
      },
    },
  },
  dependencies = {
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    "echasnovski/mini.pick", -- for file_selector provider mini.pick
    "nvim-telescope/telescope.nvim", -- for file_selector provider telescope
    "hrsh7th/nvim-cmp", -- autocompletion for avante commands and mentions
    "ibhagwan/fzf-lua", -- for file_selector provider fzf
    "stevearc/dressing.nvim", -- for input provider dressing
    "folke/snacks.nvim", -- for input provider snacks
    "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
    "zbirenbaum/copilot.lua", -- for providers='copilot'
    {
      -- support for image pasting
      "HakonHarnes/img-clip.nvim",
      event = "VeryLazy",
      opts = {
        -- recommended settings
        default = {
          embed_image_as_base64 = false,
          prompt_for_file_name = false,
          drag_and_drop = {
            insert_mode = true,
          },
          -- required for Windows users
          use_absolute_path = true,
        },
      },
    },
    {
      -- Make sure to set this up properly if you have lazy=true
      'MeanderingProgrammer/render-markdown.nvim',
      opts = {
        file_types = { "markdown", "Avante" },
      },
      ft = { "markdown", "Avante" },
    },
  },
}

}, {}) -- lazy.nvim setup end

-- 4. Autocommands
-- ----------------------------------------------------
-- Using vim.api.nvim_create_autocmd for cleaner Lua-native autocommands
vim.api.nvim_create_augroup('MyVimrcHooks', { clear = true })
vim.api.nvim_create_autocmd('BufWritePost', {
  group = 'MyVimrcHooks',
  pattern = 'init.lua',
  command = 'Lazy sync',
  desc = 'Reload Neovim config on save',
})

-- Filetype specific settings (from your existing vimrc)
vim.api.nvim_create_augroup('FileTypeSettings', { clear = true })
vim.api.nvim_create_autocmd({'BufRead', 'BufNewFile'}, {
  group = 'FileTypeSettings',
  pattern = '*.md',
  command = 'setf markdown',
  desc = 'Set filetype for markdown',
})
vim.api.nvim_create_autocmd({'BufRead', 'BufNewFile'}, {
  group = 'FileTypeSettings',
  pattern = '*.rake,*.rabl,*.jbuilder',
  command = 'setf ruby',
  desc = 'Set filetype for Ruby variants',
})
vim.api.nvim_create_autocmd('FileType', {
  group = 'FileTypeSettings',
  pattern = 'python',
  command = 'setlocal tabstop=4|setlocal shiftwidth=4',
  desc = 'Python indentation',
})
vim.api.nvim_create_autocmd('FileType', {
  group = 'FileTypeSettings',
  pattern = 'go',
  command = 'setlocal noexpandtab|setlocal tabstop=8|setlocal shiftwidth=8',
  desc = 'Go indentation (tabs)',
})
vim.api.nvim_create_autocmd('FileType', {
  group = 'FileTypeSettings',
  pattern = 'proto',
  command = 'setlocal smartindent',
  desc = 'Proto smart indent',
})

-- Highlight ColorColumn (80 chars)
vim.api.nvim_create_augroup('BgHighlight', { clear = true })
vim.api.nvim_create_autocmd('WinEnter', {
  group = 'BgHighlight',
  callback = function()
    vim.opt.colorcolumn = '80'
    vim.cmd('hi ColorColumn ctermbg=235 guibg=#2c2d27') -- Ensure styling is applied
  end,
  desc = 'Show colorcolumn on WinEnter',
})
vim.api.nvim_create_autocmd('WinLeave', {
  group = 'BgHighlight',
  callback = function()
    vim.opt.colorcolumn = '' -- Clear colorcolumn on WinLeave
  end,
  desc = 'Hide colorcolumn on WinLeave',
})

-- Cursorline settings
vim.api.nvim_create_augroup('CursorLineToggle', { clear = true })
vim.api.nvim_create_autocmd('WinLeave', {
  group = 'CursorLineToggle',
  callback = function() vim.opt.cursorline = false end,
  desc = 'Disable cursorline on WinLeave',
})
vim.api.nvim_create_autocmd('WinEnter', {
  group = 'CursorLineToggle',
  callback = function() vim.opt.cursorline = true end,
  desc = 'Enable cursorline on WinEnter',
})
vim.api.nvim_create_autocmd('InsertEnter', {
  group = 'CursorLineToggle',
  callback = function() vim.opt.cursorline = false end,
  desc = 'Disable cursorline on InsertEnter',
})
vim.api.nvim_create_autocmd('InsertLeave', {
  group = 'CursorLineToggle',
  callback = function() vim.opt.cursorline = true end,
  desc = 'Enable cursorline on InsertLeave',
})


-- 5. Keybindings
-- ----------------------------------------------------
-- Using vim.keymap.set for cleaner Lua-native mappings
vim.g.mapleader = ' ' -- Leader key
vim.g.localmapleader = ' '

local opts = { noremap = true, silent = true }

-- Window navigation
vim.keymap.set('n', '<C-h>', '<C-w>h', opts)
vim.keymap.set('n', '<C-j>', '<C-w>j', opts)
vim.keymap.set('n', '<C-k>', '<C-w>k', opts)
vim.keymap.set('n', '<C-l>', '<C-w>l', opts)

-- Buffer navigation
vim.keymap.set('n', '<S-l>', 'gt', opts) -- Next tab
vim.keymap.set('n', '<S-h>', 'gT', opts) -- Previous tab

-- Toggle between last two buffers
vim.keymap.set('n', '<leader>b', '<C-^>', opts)

-- Remap k/j for wrapped lines (noremap k gk, noremap j gj)
vim.keymap.set('n', 'k', 'gk', { noremap = false }) -- Allow further remapping
vim.keymap.set('n', 'j', 'gj', { noremap = false })

-- Reload Neovim config (was <leader>ev)
vim.keymap.set('n', '<leader>ev', ':tabe ~/.config/nvim/init.lua<CR>', opts)

-- JSON format
vim.keymap.set('n', '<leader>jj', ':%!python -m json.tool<CR>', opts)

-- FZF shortcuts (ensure fzf.vim is installed)
vim.g.fzf_history_dir = vim.fn.expand('~/.local/share/fzf-history') -- Set history dir
vim.keymap.set('n', '<leader>f', ':Files<CR>', opts)
vim.keymap.set('n', '<leader>h', ':History<CR>', opts)
vim.keymap.set('n', '<leader>t', ':Tags<CR>', opts)

-- local avante_prefix = "<leader>a"
-- vim.keymap.set('n', avante_prefix .. "v", ':Avante<CR>', opts) -- Open Avante UI
-- vim.keymap.set('n', avante_prefix .. "e", ':Avante edit<CR>', opts) -- Edit last interaction
-- vim.keymap.set('n', avante_prefix .. "r", ':Avante refresh<CR>', opts) -- Refresh last interaction
-- vim.keymap.set('n', avante_prefix .. "f", ':Avante focus<CR>', opts) -- Focus Avante window
-- vim.keymap.set('n', '<leader>' .. "]", ':Avante diff_next<CR>', opts)
-- vim.keymap.set('n', '<leader>' .. "[", ':Avante diff_prev<CR>', opts)
-- vim.keymap.set('n', avante_prefix .. ".", ':Avante add_current<CR>', opts) -- Add current file

-- -- Visual mode bindings for Avante
-- vim.keymap.set('v', avante_prefix .. "e", ":Avante edit_code<CR>", opts) -- Edit selected code
-- vim.keymap.set('v', avante_prefix .. "d", ":Avante gen_doc<CR>", opts)   -- Generate docs for selected code
-- vim.keymap.set('v', avante_prefix .. "x", ":Avante explain_code<CR>", opts) -- Explain selected code
-- vim.keymap.set('v', avante_prefix .. "t", ":Avante gen_tests<CR>", opts) -- Generate tests for selected code

-- Nvim-tree shortcuts (replacing Vexplore/Sexplore functionality)
-- The original :Vexplore and :Sexplore commands directly invoke netrw.
-- Since nvim-tree.lua generally replaces netrw, these mappings provide
-- similar behavior using nvim-tree's capabilities for split window exploration.
vim.keymap.set('n', '<leader>v', ':NvimTreeToggle<CR>', opts)       -- Toggle NvimTree in current window/split
vim.keymap.set('n', '<leader>sv', ':vsplit | NvimTreeToggle<CR>', opts) -- Open NvimTree in a new vertical split
vim.keymap.set('n', '<leader>sh', ':split | NvimTreeToggle<CR>', opts)  -- Open NvimTree in a new horizontal split

-- Misc bindings
vim.keymap.set('n', '<leader>;', ':nohlsearch<CR>', opts) -- Clear search highlight
vim.keymap.set('v', 's', ':sort<CR>', opts) -- Sort visual selection
vim.keymap.set('n', '<leader>w', ':set wrap!<CR>', opts) -- Toggle wrap
vim.keymap.set('n', 'Q', '@q', opts) -- Re-map Q to repeat last macro

-- Rename File function (direct translation)
vim.api.nvim_create_user_command('RenameFile', function()
  local old_name = vim.fn.expand('%')
  local new_name = vim.fn.input('New file name: ', old_name, 'file')
  if new_name ~= '' and new_name ~= old_name then
    vim.cmd('saveas ' .. new_name)
    vim.cmd('silent !rm ' .. old_name)
    vim.cmd('redraw!')
  end
end, { nargs = 0, desc = 'Rename current file' })
vim.keymap.set('n', '<Leader>n', ':RenameFile<CR>', opts)

cmp = require("cmp")
-- Use buffer and path source for / and ? (command line history)
cmp.setup.cmdline('/', {
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'buffer' },
  })
})

cmp.setup.cmdline(':', {
  sources = cmp.config.sources({
    { name = 'path' },
    { name = 'cmdline' },
  })
})


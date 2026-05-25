-- Source legacy vimrc
vim.cmd("source ~/.vimrc")

-- Colorscheme
if vim.fn.exists("&termguicolors") == 1
  and vim.fn.exists("&winblend") == 1 then
  vim.g.neosolarized_termtrans = 1
  vim.cmd("runtime ./colors/solarized_true.vim")
  vim.opt.termguicolors = true
  vim.opt.winblend = 0
  vim.opt.wildoptions = "pum"
  vim.opt.pumblend = 5
end

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Fix telescope treesitter preview compatibility
vim.treesitter.ft_to_lang = vim.treesitter.language.get_lang
  or vim.treesitter.ft_to_lang

-- Load plugins
require("lazy").setup({
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.8",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local builtin = require("telescope.builtin")
      vim.keymap.set(
        "n", "<leader>ff",
        builtin.find_files,
        { desc = "Find files" }
      )
      vim.keymap.set(
        "n", "<leader>fg",
        builtin.live_grep,
        { desc = "Live grep" }
      )
      vim.keymap.set(
        "n", "<leader>fb",
        builtin.buffers,
        { desc = "Buffer" }
      )
      vim.keymap.set(
        "n", "<leader>ft",
        function()
          require("telescope.builtin").colorscheme({
            enable_preview = true,
          })
        end,
        { desc = "Theme switcher" }
      )
    end,
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
    },
    config = function()
      local lspconfig = require("lspconfig")
      local capabilities = require("cmp_nvim_lsp")
        .default_capabilities()

      -- 1. Initialize Mason base
      require("mason").setup()

      -- 2. Initialize Mason-LSPconfig
      require("mason-lspconfig").setup({
        ensure_installed = { "clangd" },
	-- The modern way to handle automatic setups dinamically
	handlers = {
	  function(server_name)
	    lspconfig[server_name].setup({})
	  end,
	},
      })

      -- Global LSP Keymaps (Optional but highly recommended)
      vim.keymap.set(
        'n', 'gd',
        vim.lsp.buf.definition,
        { desc = "Go to definition" }
      )
      vim.keymap.set(
        'n', 'gD',
        vim.lsp.buf.declaration,
        { desc = "Go to declaration" }
      )
      vim.keymap.set('n', 'K', vim.lsp.buf.hover, { desc = "Hover docs" })
      vim.keymap.set(
        'n', '<leader>rn',
        vim.lsp.buf.rename,
        { desc = "Rename symbol" }
      )
      vim.keymap.set(
        'n', '<leader>ca',
        vim.lsp.buf.code_action,
        { desc = "Code action" }
      )
      vim.keymap.set(
        'n', '<leader>rn',
        vim.lsp.buf.rename,
        { desc = "Rename symbol" }
      )
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    main = "nvim-treesitter",
    opts = {
      ensure_installed = { "c", "cpp" },
      highlight = { enable = true },
    },
  },
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("nvim-tree").setup()
      vim.keymap.set(
        "n", "<leader>e",
        ":NvimTreeToggle<CR>",
        { desc = "File tree" }
      )
    end,
  },
  {
    "folke/tokyonight.nvim",
    priority = 1000, -- load before other plugins
    config = function()
      vim.cmd("colorscheme tokyonight")
    end,
  },
  { "catppuccin/nvim", name = "catppuccin" },
  { "rose-pine/neovim", name = "rose-pine" },
  { "rebelot/kanagawa.nvim" },
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",    -- LSP source
      "hrsh7th/cmp-buffer",      -- words from current buffer
      "hrsh7th/cmp-path",        -- file paths
    };
    config = function()
      local cmp = require("cmp")

      cmp.setup({
        mapping = cmp.mapping.preset.insert({
          ["<Tab>"]   = cmp.mapping.select_next_item(),
          ["<S-Tab>"] = cmp.mapping.select_prev_item(),
          ["<CR>"]    = cmp.mapping.confirm({ select = true }),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"]   = cmp.mapping.abort()
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "buffer" },
          { name = "path" },
        }),
      })
    end,
  },
})

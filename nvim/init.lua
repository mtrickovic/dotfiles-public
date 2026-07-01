-- Source legacy vimrc
local vimrc = vim.fn.expand("~/.vimrc")

if vim.uv.fs_stat(vimrc) then
  vim.cmd.source(vimrc)
end

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
if not vim.treesitter.ft_to_lang then
  vim.treesitter.ft_to_lang = function(ft)
    local ok, lang = pcall(vim.treesitter.language.get_lang, ft)
    if ok and lang then
      return lang
    end
    return ft
  end
end

-- Load plugins
require("lazy").setup({
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
      },
    },
    keys = {
      {
        "<leader>ff",
        function() require("telescope.builtin").find_files() end,
        desc = "Find files",
      },
      {
        "<leader>fg",
        function() require("telescope.builtin").live_grep() end,
        desc = "Live grep",
      },
      {
        "<leader>fb",
        function() require("telescope.builtin").buffers() end,
        desc = "Find buffers",
      },
      {
        "<leader>ft",
        function()
          require("telescope.builtin").colorscheme({ enable_preview = true })
        end,
        desc = "Theme switcher"
      },
      {
        "<leader>fd",
        function() require("telescope.builtin").diagnostics() end,
        desc = "Find diagnostics"
      },
    },
    config = function(_, opts)
      local telescope = require("telescope")

      opts.defaults = vim.tbl_deep_extend("force", opts.defaults or {}, {
        wrap_results = true,
        layout_strategy = "horizontal",
        layout_config = { prompt_position = "top" },
        sorting_strategy = "ascending",
        winblend = 0,
      })

      opts.pickers = {
        diagnostics = {
          theme = "ivy",
          initial_mode = "normal",
          layout_config = { preview_cutoff = 9999 },
        },
      }

      opts.extensions = {
        fzf = {
          fuzzy = true,
          override_generic_sorter = true,
          override_file_sorter = true,
          case_mode = "smart_case",
        },
      }

      telescope.setup(opts)
      telescope.load_extension("fzf")
    end,
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "p00f/clangd_extensions.nvim",
    },
    config = function()
      local lspconfig = require("lspconfig")
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      -- 1. Initialize Mason base
      require("mason").setup()

      -- 2. Initialize Mason-LSPconfig
      require("mason-lspconfig").setup({
          ensure_installed = { "clangd" },
          handlers = {
            function(server_name)
              lspconfig[server_name].setup({
                capabilities = capabilities,
              })
            end,
            -- override just for clangd
            ["clangd"] = function()
              require("clangd_extensions").setup({
                server = { capabilities = capabilities, },
                extensions = {
                  inlay_hints = {
                    inline = true,
                    only_current_line = false,
                    show_parameter_hints = true,
                  },
                  ast = {
                    role_icons = {
                      type = "🄣",
                      declaration = "🄓",
                      expression = "🄔",
                      specifier = "🄢",
                      statement = "🄚",
                      ["template argument"] = "🄣",
                    },
                  },
                },
              })
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
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",

    opts = {
      ensure_installed = {
        "bash",
        "c",
        "cpp",
        "cmake",
        "lua",
        "vim",
        "vimdoc",
        "markdown",
        "markdown_inline",
        "query",
        "json",
        "toml",
      },

      auto_install = true,

      highlight = {
        enable = true,
      },

      indent = {
        enable = true,
      },
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
  { "folke/tokyonight.nvim" },
  { "catppuccin/nvim", name = "catppuccin" },
  { "rose-pine/neovim", name = "rose-pine" },
  { "rebelot/kanagawa.nvim" },
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",    -- LSP source
      "hrsh7th/cmp-buffer",      -- words from current buffer
      "hrsh7th/cmp-path",        -- file paths
    },
    config = function()
      local cmp = require("cmp")

      cmp.setup({
        mapping = cmp.mapping.preset.insert({
          ["<Tab>"]     = cmp.mapping.select_next_item(),
          ["<S-Tab>"]   = cmp.mapping.select_prev_item(),
          ["<CR>"]      = cmp.mapping.confirm({ select = true }),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"]     = cmp.mapping.abort(),
        }),

        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "buffer" },
          { name = "path" },
        }),

        enabled = function()
          return vim.bo.filetype ~= "markdown"
        end,
      })
    end,
  },
  {
    "toppair/peek.nvim",
    event = { "VeryLazy" },
    build = "deno task --quiet build:fast",
    config = function()
      require("peek").setup({
        app = { "firefox" },
        -- automatically open preview on markdown file open
        auto_load = true,
        -- close preview window on buffer delete
        close_on_bdelete = true,
        -- enable syntax highlighting in preview
        syntax = true,           
      })

      vim.api.nvim_create_user_command("PeekOpen", require("peek").open, {})
      vim.api.nvim_create_user_command("PeekClose", require("peek").close, {})

      -- keymaps
      vim.api.nvim_set_keymap("n", "<leader>mp", "<cmd>PeekOpen<cr>", { noremap = true })
      vim.api.nvim_set_keymap("n", "<leader>mc", "<cmd>PeekClose<cr>", { noremap = true })
    end,
  },
  {
    "craftzdog/solarized-osaka.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("solarized-osaka").setup({
        transparent = false,
        terminal_colors = true,
      })

      vim.cmd.colorscheme("solarized-osaka")
    end,
  },
  {
    "akinsho/bufferline.nvim",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      require("bufferline").setup({
        options = {
          diagnostics = "nvim_lsp",
          separator_style = "slant",
          show_buffer_close_icons = false,
          show_close_icon = false,
        },
      })

      vim.keymap.set(
        "n",
        "<S-l>",
        ":BufferLineCycleNext<CR>",
        { silent = true }
      )

      vim.keymap.set(
        "n",
        "<S-h>",
        ":BufferLineCyclePrev<CR>",
        { silent = true }
      )
    end,
  },
  {
    "nvim-lualine/lualine.nvim",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      require("lualine").setup({
        options = {
          theme = "auto",
          globalstatus = true,
        },
      })
    end,
  },
  {
    "stevearc/oil.nvim",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      require("oil").setup()

      vim.keymap.set("n", "-", "<CMD>Oil<CR>")
    end,
  },
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      preset = "modern",
      delay = 300,
    },
    config = function(_, opts)
      local wk = require("which-key")
      wk.setup(opts)
      wk.add({
        -- groups
        { "<leader>f", group = "find" },    -- telescope
        { "<leader>g", group = "git" },     -- gitsigns
        { "<leader>m", group = "markdown" },-- peek.nvim
        { "<leader>t", group = "toggle" },  -- terminal/toggles

        -- telescope (find group)
        { "<leader>ff", desc = "Find files" },
        { "<leader>fg", desc = "Live grep" },
        { "<leader>fb", desc = "Find buffers" },
        { "<leader>ft", desc = "Theme switcher" },

        -- LSP (top-level, not grouped — leave as-is or fold under a "code"/"l"
        -- group later)
        { "<leader>rn", desc = "LSP rename" },
        { "<leader>ca", desc = "LSP code action" },

        -- explore (single key, top-level)
        { "<leader>e", desc = "Toggle file tree (nvim-tree)" },

        -- markdown (peek.nvim)
        { "<leader>mp", desc = "Peek open" },
        { "<leader>mc", desc = "Peek close" },

        -- gitsigns
        { "<leader>gs", desc = "Stage hunk" },
        { "<leader>gr", desc = "Reset hunk" },
        { "<leader>gp", desc = "Preview hunk" },
        { "<leader>gb", desc = "Toggle line blame" },
        { "<leader>gd", desc = "Diff this" },

        -- toggle
        { "<leader>tt", desc = "Open terminal in new tab" },

        -- additional
        { "<leader>c", group = "code/cmake" },
        { "<leader>cc", desc = "CMake configure" },
        { "<leader>cb", desc = "CMake build" },
        { "<leader>cr", desc = "CMake run" },
        { "<leader>cd", desc = "CMake debug" },
        { "<leader>cs", desc = "CMake select build type" },
        { "<leader>tf", desc = "Terminal (float)" },
        { "<leader>th", desc = "Terminal (horizontal)" },
        { "<leader>tv", desc = "Terminal (vertical)" },
      })
    end,
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      indent = { char = "|" },
      scope = {
        enabled = true,
        show_start = true,
        show_end = false,
        highlight = { "Function", "Label" }, -- ties scope color to treesitter captures
      },
      exclude = {
        filetypes = { "help", "alpha", "dashboard", "neo-tree", "Trouble", "lazy", "oil" },
      },
    },
  },
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      signs = {
        add = { text = "|" },
        change = { text = "|" },
        delete = { text = "_" },
        topdelete = { text = "‾" },
        changedelete = { text = "~" },
      },
      current_line_blame = false, -- toggle on with keymap below if you want it
      on_attach = function(bufnr)
        local gs = package.loaded.gitsigns
        local function map(mode, l, r, desc)
          vim.keymap.set(mode, l, r, { buffer = bufnr, desc = desc })
        end

        map("n", "]c", gs.next_hunk, "Next hunk")
        map("n", "[c", gs.prev_hunk, "Prev hunk")
        map("n", "<leader>gs", gs.stage_hunk, "Stage hunk")
        map("n", "<leader>gr", gs.reset_hunk, "Reset hunk")
        map("n", "<leader>gp", gs.preview_hunk, "Preview hunk")
        map("n", "<leader>gb", gs.toggle_current_line_blame, "Toggle blame")
        map("n", "<leader>gd", gs.diffthis, "Diff this")
      end
    },
  },
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {
      check_ts = true, -- treesitter-aware pairing, avoids pairing inside strings/comments
      ts_config = {
        cpp = { "string", "comment" },
        lua = { "string" },
      },
    },
    config = function(_, opts)
      require("nvim-autopairs").setup(opts)
      -- integrate with nvim-cmp so <CR> on a completion doesn't double-close brackets
      local cmp_autopairs = require("nvim-autopairs.completion.cmp")
      local cmp = require("cmp")
      cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
    end,
  },
  {
    "Civitasv/cmake-tools.nvim",
    ft = { "c", "cpp", "cmake" },
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      cmake_build_directory = "build/${variant:buildType}",
    },
    config = function(_, opts)
      require("cmake-tools").setup(opts)

      vim.keymap.set("n", "<leader>cc", "<cmd>CMakeGenerate<CR>", { desc = "CMake configure" })
      vim.keymap.set("n", "<leader>cb", "<cmd>CMakeBuild<CR>", { desc = "CMake build" })
      vim.keymap.set("n", "<leader>cr", "<cmd>CMakeRun<CR>", { desc = "CMake run" })
      vim.keymap.set("n", "<leader>cd", "<cmd>CMakeDebug<CR>", { desc = "CMake debug" })
      vim.keymap.set("n", "<leader>cs", "<cmd>CMakeSelectBuildType<CR>", { desc = "CMake select build type" })
    end,
  },
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    opts = {
      formatters_by_ft = {
        c = { "clang_format" },
        cpp = { "clang_format" },
        sh = { "shfmt" },
        cmake = { "cmake_format" },
      },
      formatters = {
        shfmt = { args = { "-i", "2" } },
      },
      format_on_save = {
        timeout_ms = 500,
        lsp_fallback = true,
      },
    },
  },
  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPost", "BufWritePost" },
    config = function()
      require("lint").linters_by_ft = {
        c = { "cppcheck" },
        cpp = { "cppcheck" },
        sh = { "shellcheck" },
      }

      vim.api.nvim_create_autocmd({ "BufWritePost" }, {
        callback = function()
          require("lint").try_lint()
        end,
      })
    end,
  },
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    event = "VeryLazy",
    opts = {
      open_mapping = [[<C-\>]],
      direction = "float",
      float_opts = { border = "curved" },
    },
    config = function(_, opts)
      require("toggleterm").setup(opts)

      vim.keymap.set("n", "<leader>tf", "<cmd>ToggleTerm direction=float<CR>", { desc = "Terminal (float)" })
      vim.keymap.set("n", "<leader>th", "<cmd>ToggleTerm direction=horizontal<CR>", { desc = "Terminal (horizontal)" })
      vim.keymap.set("n", "<leader>tv", "<cmd>ToggleTerm direction=vertical<CR>", { desc = "Terminal (vertical)" })
    end,
  }
})

vim.keymap.set("n", "<leader>tt", function()
  vim.cmd("tabnew")
  vim.cmd("terminal")
  vim.cmd("startinsert")
end, { desc = "Open terminal in new tab" })

vim.keymap.set(
  "t",
  "<Esc><Esc>",
  [[<C-\><C-n>]],
  { desc = "Exit terminal mode" }
)

vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"

vim.opt.foldenable = false
vim.opt.foldlevel = 99

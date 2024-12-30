---@type LazySpec
return {

  -- == Examples of Adding Plugins ==
  { "scottmckendry/cyberdream.nvim" },
  { "rebelot/kanagawa.nvim" },
  "andweeb/presence.nvim",
  {
    "ray-x/lsp_signature.nvim",
    event = "BufRead",
    config = function() require("lsp_signature").setup() end,
  },

  -- == Examples of Overriding Plugins ==

  -- customize alpha options
  {
    "goolord/alpha-nvim",
    opts = function(_, opts)
      -- customize the dashboard header
      opts.section.header.val = {
        " █████  ███████ ████████ ██████   ██████",
        "██   ██ ██         ██    ██   ██ ██    ██",
        "███████ ███████    ██    ██████  ██    ██",
        "██   ██      ██    ██    ██   ██ ██    ██",
        "██   ██ ███████    ██    ██   ██  ██████",
        " ",
        "    ███    ██ ██    ██ ██ ███    ███",
        "    ████   ██ ██    ██ ██ ████  ████",
        "    ██ ██  ██ ██    ██ ██ ██ ████ ██",
        "    ██  ██ ██  ██  ██  ██ ██  ██  ██",
        "    ██   ████   ████   ██ ██      ██",
      }
      return opts
    end,
  },

  -- You can disable default plugins as follows:
  { "max397574/better-escape.nvim", enabled = false },

  -- You can also easily customize additional setup of plugins that is outside of the plugin's setup call
  {
    "L3MON4D3/LuaSnip",
    config = function(plugin, opts)
      require "astronvim.plugins.configs.luasnip"(plugin, opts) -- include the default astronvim config that calls the setup call
      -- add more custom luasnip configuration such as filetype extend or custom snippets
      local luasnip = require "luasnip"
      luasnip.filetype_extend("javascript", { "javascriptreact" })
    end,
  },

  {
    "windwp/nvim-autopairs",
    config = function(plugin, opts)
      require "astronvim.plugins.configs.nvim-autopairs"(plugin, opts) -- include the default astronvim config that calls the setup call
      -- add more custom autopairs configuration such as custom rules
      local npairs = require "nvim-autopairs"
      local Rule = require "nvim-autopairs.rule"
      local cond = require "nvim-autopairs.conds"
      npairs.add_rules(
        {
          Rule("$", "$", { "tex", "latex" })
            -- don't add a pair if the next character is %
            :with_pair(cond.not_after_regex "%%")
            -- don't add a pair if  the previous character is xxx
            :with_pair(
              cond.not_before_regex("xxx", 3)
            )
            -- don't move right when repeat character
            :with_move(cond.none())
            -- don't delete if the next character is xx
            :with_del(cond.not_after_regex "xx")
            -- disable adding a newline when you press <cr>
            :with_cr(cond.none()),
        },
        -- disable for .vim files, but it work for another filetypes
        Rule("a", "a", "-vim")
      )
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    run = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup {
        ensure_installed = {
          "go",
          "javascript",
          "typescript",
          "json",
          "yaml",
          "dockerfile",
          "toml",
          "markdown",
          "sql",
          "html",
          "css",
          "scss",
          "graphql",
          "proto",
          "lua",
        }, -- установить парсеры для всех языков
        highlight = {
          enable = true, -- включить подсветку
        },
        indent = {
          enable = true, -- автоматическая индентация
        },
      }
    end,
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      local lspconfig = require "lspconfig"
      -- Настройка gopls (Go Language Server)
      lspconfig.gopls.setup {
        cmd = { "gopls" },
        filetypes = { "go", "gomod" },
        settings = {
          gopls = {
            analyses = {
              unusedparams = true,
              unreachable = true,
            },
            staticcheck = true,
          },
        },
      }
    end,
  },
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter", -- Загружается только при входе в режим вставки
    dependencies = {
      "hrsh7th/cmp-nvim-lsp", -- Источник для LSP
      "hrsh7th/cmp-buffer", -- Источник для буфера
      "hrsh7th/cmp-path", -- Источник для путей
    },
    config = function()
      local cmp = require "cmp"
      cmp.setup {
        snippet = {
          expand = function(args) require("luasnip").lsp_expand(args.body) end,
        },
        mapping = cmp.mapping.preset.insert {
          ["<Tab>"] = cmp.mapping.select_next_item(),
          ["<S-Tab>"] = cmp.mapping.select_prev_item(),
          ["<CR>"] = cmp.mapping.confirm { select = true },
        },
        sources = {
          { name = "nvim_lsp" },
          { name = "buffer" },
          { name = "path" },
        },
      }
    end,
  },
  {
    "L3MON4D3/LuaSnip",
    config = function() require("luasnip.loaders.from_vscode").lazy_load() end,
  },
  {
    "mfussenegger/nvim-dap",
    config = function()
      require("dap").adapters.go = {
        type = "server",
        port = 38697,
        executable = {
          command = "dlv",
          args = { "dap" },
        },
      }
      require("dap").configurations.go = {
        {
          type = "go",
          name = "Launch",
          request = "launch",
          program = "${workspaceFolder}",
        },
      }
    end,
  },
  {
    "mhartington/formatter.nvim",
    config = function()
      require("formatter").setup {
        filetype = {
          go = {
            function()
              return {
                exe = "gofmt", -- Форматировщик для Go
                args = {},
                stdin = true,
              }
            end,
          },
        },
      }
    end,
  },
  {
    "iamcco/markdown-preview.nvim",
    run = "cd app && npm install",
    cmd = "MarkdownPreview", -- Загружается только по вызову команды
    config = function() vim.g.mkdp_auto_start = 1 end,
  },
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("telescope").setup {
        defaults = {
          file_ignore_patterns = { "node_modules", ".git" },
        },
      }
      vim.api.nvim_set_keymap("n", "<leader>fg", "<cmd>Telescope live_grep<cr>", { noremap = true })
    end,
  },
}

return {
  "AstroNvim/astrolsp",
  opts = {
    features = {
      codelens = true,
      inlay_hints = false,
      semantic_tokens = true,
    },
    formatting = {
      format_on_save = {
        enabled = true,
        allow_filetypes = {},
      },
      timeout_ms = 1000,
    },
    servers = {
      -- Добавить серверы, если нужно
    },
    config = {
      gopls = {
        settings = {
          gopls = {
            usePlaceholders = true,
            completeUnimported = true,
            analyses = {
              unusedparams = true,
            },
            staticcheck = true,
          },
        },
      },
    },
    handlers = {
      ["textDocument/signatureHelp"] = function() return nil end,
    },
    mappings = {
      n = {
        ["<leader>sh"] = {
          function() vim.lsp.buf.signature_help() end,
          desc = "Show Signature Help",
        },
      },
    },
    on_attach = function(client, bufnr)
      -- Настройка при подключении клиента
    end,
  },
}

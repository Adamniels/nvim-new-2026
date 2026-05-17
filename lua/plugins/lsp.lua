return {
  {
    "neovim/nvim-lspconfig",

    config = function()
      vim.lsp.config("lua_ls", {
        settings = {
          Lua = {
            diagnostics = {
              globals = { "vim" },
            },
            workspace = {
              library = vim.api.nvim_get_runtime_file("", true),
            },
          },
        },
      })

      vim.lsp.config("ts_ls", {})

      vim.lsp.enable({
        "lua_ls",
        "ts_ls",
      })

      -- LSP keymaps
      vim.keymap.set("n", "gd", vim.lsp.buf.definition)
      vim.keymap.set("n", "gR", vim.lsp.buf.references)
      vim.keymap.set("n", "K", vim.lsp.buf.hover)

      vim.keymap.set("n", "<F13>rn", vim.lsp.buf.rename)
      vim.keymap.set("n", "<F13>ca", vim.lsp.buf.code_action)
      vim.keymap.set("n", "<F13>f", vim.lsp.buf.format)

      -- Diagnostics
      vim.keymap.set("n", "[d", function()
        vim.diagnostic.jump({ count = -1, float = true })
      end)

      vim.keymap.set("n", "]d", function()
        vim.diagnostic.jump({ count = 1, float = true })
      end)

      vim.keymap.set("n", "<F13>e", vim.diagnostic.open_float)
    end,
  },
}

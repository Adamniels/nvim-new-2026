return {
  {
    "lewis6991/gitsigns.nvim",
    lazy = false,
    config = function()
      local gitsigns = require("gitsigns")

      gitsigns.setup({
        attach_to_untracked = true,
        current_line_blame = true,
        signs = {
          add = { text = "+" },
          change = { text = "~" },
          delete = { text = "_" },
          topdelete = { text = "_" },
          changedelete = { text = "~" },
          untracked = { text = "?" },
        },
        on_attach = function(bufnr)
          local function map(mode, lhs, rhs, desc)
            vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
          end

          map("n", "]c", function()
            if vim.wo.diff then
              return "]c"
            end
            vim.schedule(function()
              gitsigns.nav_hunk("next")
            end)
            return "<Ignore>"
          end, "Next git hunk")

          map("n", "[c", function()
            if vim.wo.diff then
              return "[c"
            end
            vim.schedule(function()
              gitsigns.nav_hunk("prev")
            end)
            return "<Ignore>"
          end, "Previous git hunk")

          map("n", "<F13>hp", gitsigns.preview_hunk, "Preview git hunk")
          map("n", "<F13>hs", gitsigns.stage_hunk, "Stage git hunk")
          map("n", "<F13>hr", gitsigns.reset_hunk, "Reset git hunk")
          map("n", "<F13>hb", gitsigns.blame_line, "Git blame line")
        end,
      })
    end,
  },

  {
    "sindrets/diffview.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
    },
    keys = {
      { "<leader>gv", ":DiffviewOpen<CR>",          desc = "Git diff (vs index)" },
      { "<leader>gq", ":DiffviewClose<CR>",          desc = "Close git diff" },
      { "<leader>gf", ":DiffviewFileHistory %<CR>",  desc = "Git history (current file)" },
      {
        "<leader>gc",
        function()
          local rev = vim.fn.input("Git revision (commit, HEAD~2, abc123): ")
          if rev ~= "" then vim.cmd.DiffviewOpen(rev) end
        end,
        desc = "Git diff vs revision",
      },
      {
        "<leader>gh",
        function()
          local rev = vim.fn.input("History range (empty = all, or e.g. HEAD~10..HEAD): ")
          if rev == "" then
            vim.cmd.DiffviewFileHistory("%")
          else
            vim.cmd.DiffviewFileHistory({ "%", "--range=" .. rev })
          end
        end,
        desc = "Git file history",
      },
      {
        "<leader>gt",
        function() require("diffview.actions").toggle_files() end,
        desc = "Toggle diff file panel",
      },
    },
    config = function()
      require("diffview").setup({
        use_icons = true,
        view = {
          default = { layout = "diff2_horizontal" },
        },
      })
    end,
  },
}

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
    cmd = {
      "DiffviewOpen",
      "DiffviewClose",
      "DiffviewFileHistory",
      "DiffviewToggleFiles",
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      local actions = require("diffview.actions")

      require("diffview").setup({
        use_icons = true,
        view = {
          default = {
            layout = "diff2_horizontal",
          },
        },
      })

      local function diff_against_rev()
        local rev = vim.fn.input("Git revision (commit, HEAD~2, abc123): ")
        if rev == "" then
          return
        end
        vim.cmd.DiffviewOpen(rev)
      end

      local function file_history_rev()
        local rev = vim.fn.input("History range (empty = all, or e.g. HEAD~10..HEAD): ")
        if rev == "" then
          vim.cmd.DiffviewFileHistory("%")
        else
          vim.cmd.DiffviewFileHistory({ "%", "--range=" .. rev })
        end
      end

      vim.keymap.set("n", "<F13>gv", ":DiffviewOpen<CR>", { desc = "Git diff (vs index)" })
      vim.keymap.set("n", "<F13>gc", diff_against_rev, { desc = "Git diff vs revision" })
      vim.keymap.set("n", "<F13>gq", ":DiffviewClose<CR>", { desc = "Close git diff" })
      vim.keymap.set("n", "<F13>gh", file_history_rev, { desc = "Git file history" })
      vim.keymap.set("n", "<F13>gf", ":DiffviewFileHistory %<CR>", { desc = "Git history (current file)" })

      -- Diffview panel navigation (when focus is in the file panel)
      vim.keymap.set("n", "<F13>gt", actions.toggle_files, { desc = "Toggle diff file panel" })
    end,
  },
}

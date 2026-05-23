return {
  {
    "nvim-telescope/telescope.nvim",
    version = "*",

    dependencies = {
      "nvim-lua/plenary.nvim",
    },

    config = function()
      local telescope = require("telescope")
      local builtin = require("telescope.builtin")
      local previewers = require("telescope.previewers")

      -- Delta-powered previewer for git status (tracked files get a diff,
      -- untracked files get their raw content shown by delta directly)
      local git_status_delta = previewers.new_termopen_previewer({
        get_command = function(entry)
          if entry.status == "??" then
            return { "delta", entry.value }
          end
          return { "sh", "-c",
            "git diff HEAD -- " .. vim.fn.shellescape(entry.value) .. " | delta --paging=never"
          }
        end,
      })

      -- Delta-powered previewer for git commits
      local git_commits_delta = previewers.new_termopen_previewer({
        get_command = function(entry)
          return { "sh", "-c",
            "git show " .. entry.value .. " | delta --paging=never"
          }
        end,
      })

      telescope.setup({
        defaults = {
          layout_strategy = "horizontal",
          layout_config = {
            horizontal = {
              preview_width = 0.55,
            },
          },
        },
        pickers = {
          git_status  = { previewer = git_status_delta },
          git_commits = { previewer = git_commits_delta },
        },
      })


      vim.keymap.set("n", "<F13>a", builtin.find_files, { desc = "Find files" })
      vim.keymap.set("n", "<F13>g", builtin.live_grep, { desc = "Search text" })
      vim.keymap.set("n", "<F13>b", builtin.buffers, { desc = "Find buffers" })
      vim.keymap.set("n", "<F13>h", builtin.help_tags, { desc = "Help tags" })
      vim.keymap.set("n", "<leader>gs", builtin.git_status, { desc = "Git status" })
      vim.keymap.set("n", "<leader>gl", builtin.git_commits, { desc = "Git commits" })
    end,
  },
}

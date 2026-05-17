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

      telescope.setup({
        defaults = {
          layout_strategy = "horizontal",
          layout_config = {
            horizontal = {
              preview_width = 0.55,
            },
          },
        },
      })

      vim.keymap.set("n", "<F13>p", builtin.find_files, { desc = "Find files" })
      vim.keymap.set("n", "<F13>g", builtin.live_grep, { desc = "Search text" })
      vim.keymap.set("n", "<F13>b", builtin.buffers, { desc = "Find buffers" })
      vim.keymap.set("n", "<F13>h", builtin.help_tags, { desc = "Help tags" })
      vim.keymap.set("n", "<leader>gs", builtin.git_status, { desc = "Git status" })
      vim.keymap.set("n", "<leader>gl", builtin.git_commits, { desc = "Git commits" })
    end,
  },
}

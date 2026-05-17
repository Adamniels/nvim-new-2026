-- Basic editor settings
vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true

vim.opt.smartindent = true
vim.opt.wrap = false

vim.opt.termguicolors = true
vim.opt.signcolumn = "yes:1"

vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.clipboard = "unnamedplus"

vim.g.mapleader = " "

-- Netrw explorer settings
vim.g.netrw_banner = 0
vim.g.netrw_liststyle = 3
vim.g.netrw_browse_split = 0
vim.g.netrw_altv = 1
vim.g.netrw_winsize = 25
vim.g.netrw_preview = 1

-- Simple keymaps
vim.keymap.set("n", "<F13>w", ":w<CR>", { desc = "Save file" })
vim.keymap.set("n", "<F13>q", ":q<CR>", { desc = "Quit" })
vim.keymap.set("n", "<F13>h", ":nohlsearch<CR>", { desc = "Clear search highlight" })
vim.keymap.set("n", "<F13>t", ":Explore<CR>", { desc = "Open explorer" })

-- Colorscheme
vim.cmd.colorscheme("habamax")

-- Load lazy.nvim
require("config.lazy")

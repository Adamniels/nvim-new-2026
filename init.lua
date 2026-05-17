-- Must be set before any <leader> keymaps are defined
vim.g.mapleader = " "
vim.g.maplocalleader = " "

require("config.options")
require("config.keymaps")
require("config.autocmds")
require("config.lazy")
require("lib.netrw_git")
require("lib.netrw_reveal")

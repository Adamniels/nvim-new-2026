# nvim-new-2026

## Dependencies

These tools must be installed on your system before everything works correctly.

### Required

| Tool | Install | Used for |
|---|---|---|
| [Neovim](https://neovim.io) >= 0.10 | `brew install neovim` | The editor itself |
| [git](https://git-scm.com) | ships with macOS / `brew install git` | gitsigns, diffview, netrw git decorations |
| [ripgrep](https://github.com/BurntSushi/ripgrep) | `brew install ripgrep` | Telescope live grep (`<leader>g`) |

### Language servers (LSP)

| Tool | Install | Used for |
|---|---|---|
| [lua-language-server](https://github.com/LuaLS/lua-language-server) | `brew install lua-language-server` | Lua LSP |
| [typescript-language-server](https://github.com/typescript-language-server/typescript-language-server) | `npm install -g typescript-language-server typescript` | TypeScript/JavaScript LSP |

### Optional but recommended

| Tool | Install | Used for |
|---|---|---|
| [git-delta](https://github.com/dandavison/delta) | `brew install git-delta` | Syntax-highlighted diffs in Telescope git previews |
| [Nerd Font](https://www.nerdfonts.com) | download and set in terminal | Icons in diffview (`nvim-web-devicons`) |

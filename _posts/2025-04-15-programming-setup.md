---
title: Programming Setup

date: 2025-04-15 12:00:00 -0700

categories: [Programming, Guide]
---

## System

My computer is a MacBook Air (M1, 2020) with 8 GB of memory.

Although my machine is a couple years old, it works well and runs quite fast.

## Terminal

[iTerm2](https://iterm2.com/) is my daily driver.

Based on my experience, it is by far the best terminal for macOS,
offering many configuration options.

I typically work with 2 vertically split panes.
My font is Fira Mono from [Nerd Fonts](https://www.nerdfonts.com/).
My terminal color palette is a slightly modified version of Atom One Dark.

I use `zsh` as my shell, and [Starship](https://starship.rs/) as my shell prompt.

![iTerm2](/assets/img/programming-setup/img_1.png){: .center }
_iTerm2 window_

Some other terminal emulators you may want to look into are [Alacritty](https://alacritty.org/),
[kitty](https://sw.kovidgoyal.net/kitty/), and [Hyper](https://hyper.is/).

## Packages

[Homebrew](https://brew.sh/) is my package manager.

Homebrew works well for me as I am the only user on my computer.

## Editor

[Neovim](https://neovim.io/) is my editor.

To manage plugins, I use [vim-plug](https://junegunn.github.io/vim-plug/).

The plugins I use are:

- [lualine.nvim](https://github.com/nvim-lualine/lualine.nvim) as my statusline
- [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig) for language server configuration
- [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) for Tree-sitter integration
- [onedarkpro.nvim](https://github.com/olimorris/onedarkpro.nvim) as my editor theme
- [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim) for searching
- [telescope-file-browser.nvim](https://github.com/nvim-telescope/telescope-file-browser.nvim)
  for file browsing

The language servers I use are:

- [clangd](https://clangd.llvm.org/) (C++)
- [lua-language-server](https://luals.github.io/) (Lua)
- [pyright](https://github.com/microsoft/pyright) (Python)
- [solargraph](https://solargraph.org/) (Ruby)

![Neovim](/assets/img/programming-setup/img_2.png){: .center }
_Neovim editor_

## Utilities

A couple utilities I use are:

- [bat](https://github.com/sharkdp/bat) instead of `cat`
- [delta](https://dandavison.github.io/delta/) instead of `diff`
- [eza](https://eza.rocks/) instead of `ls`
- [fd](https://github.com/sharkdp/fd) instead of `find`
- [ripgrep](https://github.com/BurntSushi/ripgrep) instead of `grep`

![Utilities](/assets/img/programming-setup/img_3.png){: .center }
_Terminal utilities_

For competitive programming, I also have a local tool `hp`, which can download problems, run tests,
and more.
For stress testing, I use [qstress](https://lwm7708.github.io/entropy/posts/qstress-guide/).

![Competitive programming setup](/assets/img/programming-setup/img_4.png){: .center }
_Competitive programming setup_

# My dotfiles

## Installation

Clone to your `$HOME` directory and use GNU `stow`.

If using my zsh config, bootstrap `$ZDOTDIR` by adding the following lines to `/etc/zsh/zshenv`:

```sh
[[ -o globalrcs ]] || return
[[ -v ZDOTDIR ]] || ZDOTDIR="${XDG_CONFIG_HOME:-$HOME/.config}/zsh"
```

Alternatively, linking `.zshrc` in `$HOME` should also work:

```sh
ln -s .config/zsh/.zshrc
```

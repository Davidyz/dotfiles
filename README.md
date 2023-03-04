# A collection of my dotfiles  

## Dependencies

[GNU stow](https://www.gnu.org/software/stow/)  
[Python 3](https://www.python.org/)  
[pip](https://pypi.org/project/pip/)

The `Makefile` tries to detect these dependencies before installing any
configurations. The installation will be aborted if any of these dependencies
are not met.

## How to Use
Clone the repository to your system:
```sh
git clone git@github.com:Davidyz/dotfiles.git
```
To omit the git history (this avoids long waiting time when cloning), use the 
`--depth 1` flag:
```sh
git clone git@github.com:Davidyz/dotfiles.git --depth 1
```

To deploy the configurations, do either of the following:
1. Individually link the files to the directory of choice by invoking `ln -s`
command;
2. use the make file.  
    * `make server` will install all TUI related configurations, for example 
    [neovim][nvim_url] and [zsh][zsh_url] configurations.  

    * `make pc` will install all GUI related configurations, for example 
    [alacritty][alacritty_url] configuration.

### Stowing a single target

To create symbolic link for only one target, say `neovim`, run the following
command:
```bash
make neovim
```.
This will create symbolic links of the configuration file for `neovim` only.
This is useful if you want to use my config of only one of the projects.

### Hooks

Hooks are executed before and/or after the installation of the dot files. The
hooks are written in Python and the name has to match the name of the directory.

For example, the hook for directory `/neovim` has to be `neovim.py`.


## NeoVim specific
> The vanilla Vim has been abandoned as NeoVim provides better support for
> tree-sitters which makes syntax highlighting and other features more accurate.

The old VimScript config has been re-written with lua because this is a more
generalisable scripting language. If not deploying the `make` command, make sure
to copy/link all the content in `.config/nvim` directory to the target location.

## Credits
Command line utilities listed in [dependencies](Dependencies) ;

Developers who implemented the (neo)vim and [zsh][zsh_url] plugins. The
corresponding repository can be found in the installing scripts or the
configuration files.

[nvim_url]: https://neovim.io/
[zsh_url]: https://www.zsh.org/
[alacritty_url]: https://github.com/alacritty/alacritty

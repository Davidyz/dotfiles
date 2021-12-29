# A collection of my dotfiles  

## Dependencies:

[GNU stow](https://www.gnu.org/software/stow/)  
[Python 3](https://www.python.org/)  
[pip](https://pypi.org/project/pip/)

## How to Use
Clone the repository to your system, and:
1. Individually link the files to the directory of choice by invoking `ln -s`
command;
2. use the make file.  
    * `make server` will install all TUI related configurations, for example [neovim][nvim] and [zsh][zsh] configurations.  

    * `make pc` will install all GUI related configurations, for example [alacritty][alacritty] configuration.  

[nvim]: https://neovim.io/
[zsh]: https://www.zsh.org/
[alacritty]: https://github.com/alacritty/alacritty

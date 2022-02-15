# My neovim configurations

## Directory Structure
### `./keymaps`
>contains all my custom key mapping

The file names corresponds to the following rules:  
1. if the mapping involves a plugin, put it in the file named after the plugin.
2. if the mapping involves a specific `filetype`, put it in the file named 
after the `filetype`.
3. otherwise, put it in `./keymaps/main.lua`.

### `./filetype`
>contains any other filetype-related configs, such as formats and snippets 
inserted when a blank file is created.

Named after the `filetype`.

### `./plugins`
>contains global/local variables of plugins.

Named after the plugins.

### `./colorscheme`
>contains settings related to the colorschemes.

This directory contains both active and inactive colorschemes. The active
colorscheme may be chosen in `./colorscheme/main.lua`.

## Others
`*/main.lua` is the entry point to all the other configs in that sub-directory. 
In other words, when there is a new file to be added, `require` it in 
`./main.lua` rather than putting everything into `init.vim`/`init.lua`.

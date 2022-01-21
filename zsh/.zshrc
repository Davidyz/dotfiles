# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# If you come from bash you might have to change your $PATH.
export PATH=$HOME/bin:/usr/local/bin:$HOME/.local/bin/:$PATH
if [ -d $HOME/.cargo/bin ]
then 
  export PATH=$PATH:$HOME/.cargo/bin
fi

# Path to your oh-my-zsh installation.
export ZSH_DISABLE_COMPFIX=true
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
POWERLEVEL9K_MODE='nerdfont-complete'
ZSH_THEME="powerlevel10k/powerlevel10k"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
CASE_SENSITIVE="false"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to automatically update without prompting.
# DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
HIST_STAMPS="dd/mm/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
#ZSH_CUSTOM=/path/to/new-custom-folder

export FZF_BASE=/usr/bin/fzf
# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
    adb
    git
    zsh-autosuggestions
    zsh-syntax-highlighting
    extract
    sudo
    command-not-found
    pip
    virtualenv
    pipenv
    fzf
    mvn
    ufw
    stack
    cabal
    zsh-256color
    zsh-completions
    docker
)

if [ `which autojump` ]; then plugins+=(autojump) fi

autoload -Uz compinit
compinit
zstyle ':completion:*' menu select

unsetopt sharehistory
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_FIND_NO_DUPS
setopt HIST_SAVE_NO_DUPS
zstyle ':completion:*:hosts' hosts
zstyle ':completion::complete:*' gain-privileges 1

alias google-chrome-stable="google-chrome-stable %U --enable-features=WebUIDarkMode --force-dark-mode"
alias arduino-burn="arduino-compile && sudo arduino-upload"
alias pandoc-pdf="pandoc --template=eisvogel --pdf-engine=xelatex -V mainfont=\"Arial\" -V fontsize=12"
alias pandoc-cn="pandoc --template=eisvogel --pdf-engine=xelatex -V mainfont=\"NotoCJK\""
alias alacritty="env WINIT_UNIX_BACKEND=x11 alacritty"
alias unzip_gbk="unzip -O gbk "
# export TERM=xterm-256color
export LS_COLORS="$LS_COLORS:ow=1;34:tw=1;34:"
export PYTHONPATH=$HOME/git/learning_python/module/
export ANDROID_HOME=/storage/emulated/0/
source $ZSH/oh-my-zsh.sh

zstyle ':completion:*' ignored-patterns '__pycache__'

if [ -f `which lsd` ]
then
    alias ls='lsd'
fi

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
export EDITOR='nvim'

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
if [[ $TERM == xterm-termite ]]; then
    . /etc/profile.d/vte.sh
    __vte_osc7
fi

ZVM_INSERT_MODE_CURSOR=$ZVM_CURSOR_BLINKING_BLOCK
ZVM_NORMAL_MODE_CURSOR=$ZVM_CURSOR_BLINKING_UNDERLINE
ZVM_VISUAL_MODE_CURSOR=$ZVM_CURSOR_BLINKING_UNDERLINE
ZVM_VISUAL_LINE_MODE_CURSOR=$ZVM_CURSOR_BLINKING_UNDERLINE
ZVM_OPPEND_MODE_CURSOR=$ZVM_CURSOR_BLINKING_UNDERLINE

neofetch --color_blocks off --ascii_bold off --gtk3 off --gtk2 off --cpu_temp C

if {test -f $(command -v pacman)} && {test -f /usr/share/doc/find-the-command/ftc.zsh} ; then
    source /usr/share/doc/find-the-command/ftc.zsh
elif {test -f $(command -v apt)} && {test -f /etc/zsh_command_not_found}; then 
    source /etc/zsh_command_not_found
fi

if test -f ~/.local_script.sh;
then
        source ~/.local_script.sh
fi

function virtualenv_info { 
    [ $VIRTUAL_ENV ] && echo '('`basename $VIRTUAL_ENV`') '
}
PROMPT='%{$fg[white]%}$(virtualenv_info)%{$reset_color%}%'+$PROMPT

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

unsetopt null_glob 
unsetopt csh_null_glob
unsetopt nomatch

if ! command -v thefuck > /dev/null && command -v pip3 > /dev/null ; then
  pip3 install thefuck
fi

eval $(thefuck --alias)

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

if [ -f `which fzf` ] > /dev/null ; then
  export FZF_BASE=`which fzf`
fi

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  autoupdate
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
  zsh-autopair
)

if command -v autojump > /dev/null ; then plugins+=(autojump) fi

autoload -Uz compinit
compinit
zstyle ':completion:*' menu select

export UPDATE_ZSH_DAYS=7

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
export TERM=xterm-256color
export LS_COLORS="$LS_COLORS:ow=1;34:tw=1;34:"

PY_PATH=`python -c "import glob, os;dirs = glob.glob(f'{os.path.expanduser(\"~\")}/**/learning_python/module') or glob.glob(f'{os.path.expanduser(\"~\")}/learning_python/module') ;print(dirs[0] if len(dirs) == 1 else exit())"`
if [ -d $PY_PATH ]; then
  export PYTHONPATH=$PY_PATH
fi

export ANDROID_STORAGE=/storage/emulated/0/
source $ZSH/oh-my-zsh.sh

zstyle ':completion:*' ignored-patterns '__pycache__'

if command -v lsd > /dev/null
then
  alias ls='lsd'
fi

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
if command -v nvim > /dev/null;
then
  export EDITOR='nvim'
fi

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

if command -v neofetch > /dev/null ; then
  neofetch --color_blocks off --ascii_bold off --gtk3 off --gtk2 off --cpu_temp C --disable uptime
fi

if {test -f $(command -v pacman)} && {test -f /usr/share/doc/find-the-command/ftc.zsh} ; then
  source /usr/share/doc/find-the-command/ftc.zsh
elif {test -f $(command -v apt)} && {test -f /etc/zsh_command_not_found}; then
  source /etc/zsh_command_not_found
fi

if [ -f ~/.local_script.sh ]
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

bindkey '^[[1;2C' forward-word
bindkey '^[[1;2D' backward-word

if [ -z $VIRTUAL_ENV ] && command -v pip > /dev/null; then
  if ! python -c 'import rope' 2> /dev/null ; then pip install rope > /dev/null; fi
  if ! command -v pystubgen > /dev/null; then pip install pystubgen > /dev/null; fi

  if command -v pystubgen > /dev/null && python -c 'import cv2' 2> /dev/null ; then
    [ ! -f $(python -c 'import cv2, os; print(os.path.dirname(cv2.__file__))')/__init__.pyi ] && pystubgen cv2 > $(python -c 'import cv2, os; print(os.path.dirname(cv2.__file__))')/__init__.pyi
  fi
fi

function omz_termsupport_preexec {
  [[ "${DISABLE_AUTO_TITLE:-}" != true ]] || return

  emulate -L zsh
  setopt extended_glob

  # split command into array of arguments
  local -a cmdargs
  cmdargs=("${(z)2}")
  # if running fg, extract the command from the job description
  if [[ "${cmdargs[1]}" = fg ]]; then
    # get the job id from the first argument passed to the fg command
    local job_id jobspec="${cmdargs[2]#%}"
    # logic based on jobs arguments:
    # http://zsh.sourceforge.net/Doc/Release/Jobs-_0026-Signals.html#Jobs
    # https://www.zsh.org/mla/users/2007/msg00704.html
    case "$jobspec" in
      <->) # %number argument:
        # use the same <number> passed as an argument
        job_id=${jobspec} ;;
      ""|%|+) # empty, %% or %+ argument:
        # use the current job, which appears with a + in $jobstates:
        # suspended:+:5071=suspended (tty output)
        job_id=${(k)jobstates[(r)*:+:*]} ;;
      -) # %- argument:
        # use the previous job, which appears with a - in $jobstates:
        # suspended:-:6493=suspended (signal)
        job_id=${(k)jobstates[(r)*:-:*]} ;;
      [?]*) # %?string argument:
        # use $jobtexts to match for a job whose command *contains* <string>
        job_id=${(k)jobtexts[(r)*${(Q)jobspec}*]} ;;
      *) # %string argument:
        # use $jobtexts to match for a job whose command *starts with* <string>
        job_id=${(k)jobtexts[(r)${(Q)jobspec}*]} ;;
    esac

    # override preexec function arguments with job command
    if [[ -n "${jobtexts[$job_id]}" ]]; then
      1="${jobtexts[$job_id]}"
      2="${jobtexts[$job_id]}"
    fi
  fi

  # cmd name only, or if this is sudo or ssh, the next cmd
  local CMD="${1[(wr)^(*=*|sudo|ssh|mosh|rake|-*)]:gs/%/%%}"
  local LINE="${2:gs/%/%%}"

  # title "$CMD" "%100>...>${LINE}%<<"
  title "$ZSH_THEME_TERM_TITLE_IDLE $CMD" "%100>...>$ZSH_THEME_TERM_TITLE_IDLE \$ $LINE%<<"
}

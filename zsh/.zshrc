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

if [ -d /usr/lib/distcc/bin/ ]
then
  export PATH=$PATH:/usr/lib/distcc/bin/
fi

# Path to your oh-my-zsh installation.
export ZSH_DISABLE_COMPFIX=true
export ZSH="$HOME/.oh-my-zsh"
export ZSH_CUSTOM="$ZSH/custom/"
export PATH="$HOME/perl5/bin${PATH:+:${PATH}}"

[ -d "$ZSH" ] || sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

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
DISABLE_AUTO_UPDATE="true"

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
DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
HIST_STAMPS="dd/mm/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
#ZSH_CUSTOM=/path/to/new-custom-folder


# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
custom_plugins=(
	Davidyz/ipython-selector
	zsh-users/zsh-autosuggestions
	zsh-users/zsh-syntax-highlighting
	chrissicool/zsh-256color
	zsh-users/zsh-completions
	srijanshetty/docker-zsh
	hlissner/zsh-autopair
	marlonrichert/zsh-autocomplete
	TamCore/autoupdate-oh-my-zsh-plugins
	ael-code/zsh-colored-man-pages
	darvid/zsh-poetry
)

for i in "${custom_plugins[@]}"; do
	plugin_dir="${i##*/}"
	[ $plugin_dir = "autoupdate-oh-my-zsh-plugins" ] && plugin_dir=autoupdate
	plugin_dir="$ZSH_CUSTOM/plugins/$plugin_dir"
	if [ ! -d "$plugin_dir" ]; then
		git clone https://github.com/$i.git $plugin_dir
	fi
done

if command -v fastfetch > /dev/null ; then
	fastfetch --disk-show-regular false --disk-show-external false --disk-show-hidden false --bluetooth-show-disconnected false --localip-show-ipv4 false --localip-show-ipv6 false --pipe false
	print
elif command -v neofetch > /dev/null ; then
	neofetch --color_blocks off --ascii_bold off --gtk3 off --gtk2 off --cpu_temp C --disable uptime --de_version off
fi

[ ! -d "$ZSH_CUSTOM/themes/powerlevel10k/" ] && git clone https://github.com/romkatv/powerlevel10k.git $ZSH_CUSTOM/themes/powerlevel10k

autoload -Uz compinit
compinit
plugins=(
	ipython-selector
	autoupdate
	adb
	git
	zsh-autosuggestions
	zsh-syntax-highlighting
	extract
	sudo
	virtualenv
	mvn
	ufw
	stack
	cabal
	zsh-256color
	zsh-completions
	docker
	zsh-autopair
	yarn
	colored-man-pages
	pipenv
	poetry
	zsh-poetry
)


if command -v pdm > /dev/null 2> /dev/null && [ ! -d $ZSH_CUSTOM/plugins/pdm ]; then
	mkdir $ZSH_CUSTOM/plugins/pdm
	pdm completion zsh > $ZSH_CUSTOM/plugins/pdm/_pdm
	plugins+=(pdm)
fi
if command -v fzf > /dev/null ; then
	export FZF_BASE=`which fzf`
	plugins+=(fzf)
fi
if command -v docker-compose > /dev/null; then
	plugins+=(docker-compose)
fi
if command -v autojump > /dev/null ; then plugins+=(autojump) fi
if command -v rsync > /dev/null ; then plugins+=(rsync) fi

zstyle ':completion:*' menu select

export UPDATE_ZSH_DAYS=

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
if [ $USER = root ]; then
	alias v2ray_install="bash <(curl -L https://raw.githubusercontent.com/v2fly/fhs-install-v2ray/master/install-release.sh)"
	alias v2ray_update_data="bash <(curl -L https://raw.githubusercontent.com/v2fly/fhs-install-v2ray/master/install-dat-release.sh)"
fi

export TERM=xterm-256color
export LS_COLORS="$LS_COLORS:ow=1;34:tw=1;34:"

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
setopt nonomatch

bindkey '^[[1;2C' forward-word
bindkey '^[[1;2D' backward-word

if [ ! -z $VIRTUAL_ENV ] && command -v pip > /dev/null; then
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

	PERL5LIB="$HOME/perl5/lib/perl5${PERL5LIB:+:${PERL5LIB}}"; export PERL5LIB;
	PERL_LOCAL_LIB_ROOT="$HOME/perl5${PERL_LOCAL_LIB_ROOT:+:${PERL_LOCAL_LIB_ROOT}}"; export PERL_LOCAL_LIB_ROOT;
	PERL_MB_OPT="--install_base \"$HOME/perl5\""; export PERL_MB_OPT;
	PERL_MM_OPT="INSTALL_BASE=$HOME/perl5"; export PERL_MM_OPT;

	pip(){
		python -m pip "${@:1}"
	}

	print_true_color(){
		awk -v term_cols="${width:-$(tput cols || echo 80)}" 'BEGIN{
		s="/\\";
		for (colnum = 0; colnum<term_cols; colnum++) {
			r = 255-(colnum*255/term_cols);
			g = (colnum*510/term_cols);
			b = (colnum*255/term_cols);
			if (g>255) g = 510-g;
				printf "\033[48;2;%d;%d;%dm", r,g,b;
				printf "\033[38;2;%d;%d;%dm", 255-r,255-g,255-b;
				printf "%s\033[0m", substr(s,colnum%2+1,1);
			}
			printf "\n";
		}'
	}

	if command -v fzf > /dev/null 2> /dev/null ; then
		function nvims(){
			items=()
			sub_dirs=$(ls ~/.config/)
			for dir in $sub_dirs; do
				[ -f ~/.config/$dir/init.lua ] && items+=($dir)
			done
			echo $items
		}
	fi

	if command -v pacman > /dev/null 2> /dev/null ; then
		function command_not_found_handler {
			local purple='\e[1;35m' bright='\e[0;1m' green='\e[1;32m' reset='\e[0m'
			printf 'zsh: command not found: %s\n' "$1"
			local entries=(
			${(f)"$(/usr/bin/pacman -F --machinereadable -- "/usr/bin/$1")"}
		)
		if (( ${#entries[@]} ))
		then
			printf "${bright}$1${reset} may be found in the following packages:\n"
			local pkg
			for entry in "${entries[@]}"
			do
				# (repo package version file)
				local fields=(
				${(0)entry}
			)
			if [[ "$pkg" != "${fields[2]}" ]]
			then
				printf "${purple}%s/${bright}%s ${green}%s${reset}\n" "${fields[1]}" "${fields[2]}" "${fields[3]}"
			fi
			printf '    /%s\n' "${fields[4]}"
			pkg="${fields[2]}"
		done
		fi
		return 127
	}
	fi

	if command -v sx > /dev/null && command -v wezterm > /dev/null; then
		alias sx_nxwm="sx wezterm -n --config enable_tab_bar=false --config window_padding='{left=0,right=0,top=0,bottom=0}' start nvim -c 'lua require\"nxwm\".start()' "
	fi

	command -v ranger > /dev/null 2> /dev/null && export RANGER_LOAD_DEFAULT_RC=false

	[ -d ~/.local/share/bob/nvim-bin/ ] && export PATH=~/.local/share/bob/nvim-bin/:$PATH

	export POETRY_VIRTUALENVS_IN_PROJECT=true

	[ -x wezterm ] && alias imgcat='wezterm imgcat'

	git_delete_merged_branches() {
		local original_branch=$(git status | grep '^On branch' | sed "s/^On branch //" | sed "s/ //g")
		# Fetch all remote branches and prune deleted branches
		git fetch --all --prune

	# Detect the default branch
	local default_branch=$(git remote show origin | grep 'HEAD branch' | cut -d' ' -f5)

	# Switch to the default branch
	git checkout "$default_branch" || echo "You have unsaved changes!!! Commit or stash them before proceeding!"

	# Make sure the default branch is up to date
	git pull origin "$default_branch"

	# List all branches that have been merged into the default branch and delete them
	local branches_to_delete=$(git branch --merged | egrep -v "(^\*|$default_branch)")

	if [[ -n "$branches_to_delete" ]]; then
		echo "$branches_to_delete" | xargs -n 1 git branch -d
	else
		echo "No merged branches to delete."
	fi

	git checkout $original_branch
}

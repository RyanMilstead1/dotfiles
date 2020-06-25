# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-zsh is loaded.
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME=""

# Move next only if `homebrew` is installed
if command -v brew >/dev/null 2>&1; then
  # Load rupa's z if installed
  [ -f $(brew --prefix)/etc/profile.d/z.sh ] && source $(brew --prefix)/etc/profile.d/z.sh
fi

# =============================================================================
#                                   Functions
# =============================================================================

# Use fd and fzf to get the args to a command.
# Works only with zsh
# Examples:
# f mv # To move files. You can write the destination after selecting the files.
# f 'echo Selected:'
# f 'echo Selected music:' --extention mp3
# fm rm # To rm files in current directory
f() {
    sels=( "${(@f)$(fd "${fd_default[@]}" "${@:2}"| fzf)}" )
    test -n "$sels" && print -z -- "$1 ${sels[@]:q:q}"
}

# Like f, but not recursive.
fm() f "$@" --max-depth 1

# fd - cd to selected directory
fd() {
  local dir
  dir=$(find ${1:-.} -path '*/\.*' -prune \
                  -o -type d -print 2> /dev/null | fzf +m) &&
  cd "$dir"
}

# using ripgrep combined with preview
# find-in-file - usage: fif <searchTerm>
fif() {
  if [ ! "$#" -gt 0 ]; then echo "Need a string to search for!"; return 1; fi
  rg --files-with-matches --no-messages "$1" | fzf --preview "highlight -O ansi -l {} 2> /dev/null | rg --colors 'match:bg:yellow' --ignore-case --pretty --context 10 '$1' || rg --ignore-case --pretty --context 10 '$1' {}"
}

# fkill - kill processes - list only the ones you can kill. Modified the earlier script.
fkill() {
    local pid 
    if [ "$UID" != "0" ]; then
        pid=$(ps -f -u $UID | sed 1d | fzf -m | awk '{print $2}')
    else
        pid=$(ps -ef | sed 1d | fzf -m | awk '{print $2}')
    fi  

    if [ "x$pid" != "x" ]
    then
        echo $pid | xargs kill -${1:-9}
    fi  
}

# Modified version where you can press
#   - CTRL-O to open with `open` command,
#   - CTRL-E or Enter key to open with the $EDITOR
fo() (
  IFS=$'\n' out=("$(fzf-tmux --query="$1" --exit-0 --expect=ctrl-o,ctrl-e)")
  key=$(head -1 <<< "$out")
  file=$(head -2 <<< "$out" | tail -1)
  if [ -n "$file" ]; then
    [ "$key" = ctrl-o ] && open "$file" || ${EDITOR:-vim} "$file"
  fi
)

# =============================================================================
#                                   Variables
# =============================================================================
export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"

# Set list of themes to load
# Setting this variable when ZSH_THEME=random
# cause zsh load theme from this variable instead of
# looking in ~/.oh-my-zsh/themes/
# An empty array have no effect
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# =============================================================================
#                                   Plugins
# =============================================================================
# Check if zplug is installed
[ ! -d ~/.zplug ] && git clone https://github.com/zplug/zplug ~/.zplug
#source ~/.zplug/init.zsh && zplug update
source ~/.zplug/init.zsh
# Supports oh-my-zsh plugins and the like
zplug "plugins/git",                  from:oh-my-zsh, if:"which git"
zplug "plugins/sudo",                 from:oh-my-zsh, if:"which sudo"
zplug "plugins/bundler",              from:oh-my-zsh, if:"which bundle"
zplug "plugins/colored-man-pages",    from:oh-my-zsh
zplug "plugins/extract",              from:oh-my-zsh
zplug "plugins/fancy-ctrl-z",         from:oh-my-zsh
zplug "plugins/globalias",            from:oh-my-zsh
zplug "plugins/gpg-agent",            from:oh-my-zsh, if:"which gpg-agent"
zplug "plugins/httpie",               from:oh-my-zsh, if:"which httpie"
zplug "plugins/nanoc",                from:oh-my-zsh, if:"which nanoc"
zplug "plugins/nmap",                 from:oh-my-zsh, if:"which nmap"
# zplug "plugins/tmux",                 from:oh-my-zsh, if:"which tmux"
zplug "rupa/z"
# zplug "plugins/vi-mode", from:oh-my-zsh

# zplug "b4b4r07/enhancd", use:init.sh
zplug "b4b4r07/enhancd", use:enhancd.sh
#zplug "b4b4r07/zsh-vimode-visual", defer:3
#zplug "bhilburn/powerlevel9k", use:powerlevel9k.zsh-theme, at:next
# zplug "bhilburn/powerlevel9k", use:powerlevel9k.zsh-theme
#zplug "knu/zsh-manydots-magic", use:manydots-magic, defer:2
zplug "seebi/dircolors-solarized", ignore:"*", as:plugin

#zplug "zsh-users/zsh-autosuggestions", at:develop
#zplug "zsh-users/zsh-completions", defer:0
#zplug "zsh-users/zsh-history-substring-search"
#zplug "zsh-users/zsh-syntax-highlighting", defer:2
zplug "zsh-users/zsh-completions",              defer:0
zplug "zsh-users/zsh-autosuggestions",          defer:2, on:"zsh-users/zsh-completions"
zplug "zsh-users/zsh-syntax-highlighting",      defer:3, on:"zsh-users/zsh-autosuggestions"
zplug "zsh-users/zsh-history-substring-search", defer:3, on:"zsh-users/zsh-syntax-highlighting"


if ! zplug check; then
 zplug install
fi

source $ZSH/oh-my-zsh.sh

autoload -U promptinit; promptinit
prompt pure

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='vim'
fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
export SSH_KEY_PATH="~/.ssh/rsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
alias bup="brew upgrade && brew update"
alias zshconfig="vim ~/.zshrc"
alias envconfig="vim ~/Documents/code/env.sh"
alias ohmyzsh="vim ~/.oh-my-zsh"
alias g=git
alias gk='git clone'
alias ga='git add'
alias gb='git branch'
alias gba='git branch -a'
alias gc='git commit -v'
alias gl='git pull'
alias gp='git push'
alias gst='git status -sb'
alias gsd='git svn dcommit'
alias gsr='git svn rebase'
alias gs='git stash'
alias gsa='git stash apply'
alias gr='git stash && git svn rebase && git svn dcommit && git stash pop' # git refresh
alias gd='git diff | $GIT_EDITOR -'
alias gmv='git mv'
alias gho='$(git remote -v 2> /dev/null | grep github | sed -e "s/.*git\:\/\/\([a-z]\.\)*/\1/" -e "s/\.git.*//g" -e "s/.*@\(.*\)$/\1/g" | tr ":" "/" | tr -d "\011" | sed -e "s/^/open http:\/\//g" | uniq)'
alias co="git checkout"
alias bashconfig="vim ~/.bash_profile"
alias desk="cd ~/Desktop"
alias host="vim /etc/hosts"
alias add="git add -A"
alias com="git commit -m"
alias s="git status"
alias rebase="git fetch && git rebase"
alias fuck='$(thefuck $(fc -ln -1))'
alias speed="speedtest-cli"
alias vsh="vagrant ssh"
alias vgs="vagrant global-status"
alias vgkill="killall -9 VBoxHeadless && vagrant destroy"
alias vimrc="vim ~/.vimrc"
# docker
alias de='docker exec -e COLUMNS="$(tput cols)" -e LINES="$(tput lines)" -ti'
alias dps='docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}\t{{.Command}}\t{{.Image}}"'
alias dra='docker restart $(docker container ls -a -q)'
alias dr='docker restart'
alias dl='./script/docker_launch'
alias docker_stopall='docker stop $(docker container ls -a -q)'
alias docker_removeall='docker container rm $(docker container ls -a -q)'
alias docker_freshstart='docker container stop $(docker container ls -a -q) && docker system prune -a -f --volumes'
alias dprune='docker system prune'

alias showFiles='defaults write com.apple.finder AppleShowAllFiles YES; killall Finder /System/Library/CoreServices/Finder.app'
alias hideFiles='defaults write com.apple.finder AppleShowAllFiles NO; killall Finder /System/Library/CoreServices/Finder.app'

alias cmmlocal='vim ~/dev/local_override.yml'

# Kill all running containers.
alias dockerkillall='docker kill $(docker ps -q)'

# Delete all stopped containers.
alias dockercleanc='printf "\n>>> Deleting stopped containers\n\n" && docker rm $(docker ps -a -q)'

# Delete all untagged images.
alias dockercleani='printf "\n>>> Deleting untagged images\n\n" && docker rmi $(docker images -q -f dangling=true)'

# Delete all stopped containers and untagged images.
alias dockerclean='dockercleanc || true && dockercleani'

alias rubocop_only_changes='git ls-files -m | xargs ls -1 2>/dev/null | grep '\.rb$' | xargs rubocop'

drm() {
  docker stop $1
  docker rm $1
  rm -rf /Users/rmilstead/dev/apps/$1
}

dlog() {
  docker logs $1 --tail 1000 -f
}

# replace ~/dev with the path to your platform/dev checkout
shovel() ( cd ~/dev && ./script/run shovel "$@"; )

# If you're using zsh, you can add the following to enable tab complete for shovel run.
export PLATFORM_DEV=$HOME/dev # change to match your local dev directory
fpath=($PLATFORM_DEV/misc/completion/ $fpath)
autoload -U compinit && compinit

. $HOME/.asdf/asdf.sh
. $HOME/.asdf/completions/asdf.bash
export APP_ENV="development"
export APP_ID="rmilstead"
export PATH="/usr/local/bin:$PATH"
export PATH="/usr/local/opt/openssl/bin:$PATH"
export PATH="/usr/local/sbin:$PATH"

source /Users/rmilstead/Library/Preferences/org.dystroy.broot/launcher/bash/br

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

findInFiles() { find . -type f -name '*'  | perl -wnE'say if !(/\.git|node_module/i)'  | xargs grep -si "$@"; }
findInFilesSensitive() { find . -type f -name '*'  | perl -wnE'say if !(/\.git|node_module/i)'  | xargs grep -s "$@"; }

versionCheck(){ find . -type f -name 'package.json' | xargs grep -si "\"$@\":" | grep -v readme; }

bigStuffSort() { du --max-depth=1 $@ | sort -nk1; }

genIndex() { 
  echo 'module.exports = exports = {';
  ls | grep -vi 'index' | perl -ple 's/(\w)(\w+)(?:\.js)?/\t\u$1$2: require(".\/$1$2"),/'; 
  echo '};';
}

lgenIndex() { 
  echo 'module.exports = exports = {';
  ls | grep -vi 'index' | perl -ple 's/(\w)([\w\-]+)(?:\.js)?/\t"\l$1$2": require(".\/$1$2"),/'; 
  echo '};';
}

sgenIndex() {
  echo 'module.exports = exports = {';
  find . -maxdepth 1 -type f -printf '%f\n' | grep -vi 'index' | perl -ple 's/(\w)(\w+)(?:\.js)?/\t\u$1$2: require(".\/$1$2"),/';
  find . -maxdepth 1 -type d -printf '%f\n' | grep -vi '\.' | perl -ple 's/(\w)(\w+)(?:\.js)?/\t\l$1$2: require(".\/$1$2"),/';
  echo '};';
}

csgenIndex() {
  echo 'define(function(require, exports, module) {';
  echo -e '\tmodule.exports = exports = {';
  find . -maxdepth 1 -type f -printf '%f\n' | grep -vi 'index' | perl -ple 's/(\w)(\w+)(?:\.js)?/\t\t\u$1$2: require(".\/$1$2"),/';
  find . -maxdepth 1 -type d -printf '%f\n' | grep -vi '\.' | perl -ple 's/(\w)(\w+)(?:\.js)?/\t\t\l$1$2: require(".\/$1$2\/index"),/';
  echo -e '\t};';
  echo '});';
}

clgenIndex() {
  echo 'define(function(require, exports, module) {';
  echo -e '\tmodule.exports = exports = {';
  find . -maxdepth 1 -type f -printf '%f\n' | grep -vi 'index' | perl -ple 's/(\w)(\w+)(?:\.js)?/\t\t\l$1$2: require(".\/$1$2"),/';
  find . -maxdepth 1 -type d -printf '%f\n' | grep -vi '\.' | perl -ple 's/(\w)(\w+)(?:\.js)?/\t\t\l$1$2: require(".\/$1$2\/index"),/';
  echo -e '\t};';
  echo '});';
}


mongodrop() {
  echo -e "Are you *sure* you want to drop everything? (y/n): \c"
  read sure
  test "$sure" != 'y' && (echo "So you're not sure then...";exit 1)
  echo "scorching the earth in mongo...";
  mongo --quiet --eval 'db.getMongo().getDBNames().forEach(function(i){db.getSiblingDB(i).dropDatabase()})'
}


#add findinfiles
alias fif='findInFiles'
alias fifs='findInFilesSensitive'

#git aliases
alias gda='git diff --name-only'
alias pullall='find . -maxdepth 1 -type d -exec git --git-dir={}/.git --work-tree=$PWD/{} pull origin master \;'

#GERP
alias gerp='cat ~/gerp.txt'

#treesize for a directory
alias treesize='bigStuffSort'

#index generation
alias gindex='sgenIndex'
alias cgindex='csgenIndex'
alias clgindex='clgenIndex'
alias lgindex='lgenIndex'


#node aliases
alias nvc='versionCheck'
alias utilinspect='fif util.inspect | grep -v err | grep -v tests | grep -v \.error | grep -v return'

#networking utils
alias whohere='nmap -sP 192.168.1.0/24'
alias mongodrop='mongodrop'

eval $(thefuck --alias)

# gitprompt configuration
# Set config variables first
GIT_PROMPT_ONLY_IN_REPO=1

# GIT_PROMPT_FETCH_REMOTE_STATUS=0   # uncomment to avoid fetching remote status
# GIT_PROMPT_START=...    # uncomment for custom prompt start sequence
# GIT_PROMPT_END=...      # uncomment for custom prompt end sequence
# as last entry source the gitprompt script
# GIT_PROMPT_THEME=Custom # use custom .git-prompt-colors.sh
# GIT_PROMPT_THEME=Solarized # use theme optimized for solarized color scheme
source ~/.bash-git-prompt/gitprompt.sh

#track-your-life aliases
alias radd='bitbucket create-issue --owner rossersp --slug resume --assignee rossersp'
alias rsl='bitbucket issues --owner rossersp --slug resume -a --all'
alias rl='bitbucket issues --owner rossersp --slug resume'
alias ri='bitbucket issue --owner rossersp --slug resume'
alias ric='bitbucket issue --owner rossersp --slug resume --comments'
alias riu='bitbucket update-issue --owner rossersp --slug resume'
alias riac='bitbucket add-comment --owner rossersp --slug resume'
alias riuc='bitbucket update-comment --owner rossersp --slug resume'
alias rstodo='bitbucket issues --owner rossersp --slug resume -a --all --status \!resolved'
alias rsopen='bitbucket issues --owner rossersp --slug resume -a --all --status open'
alias rsnew='bitbucket issues --owner rossersp --slug resume -a --all --status new'

#change crontab editor
export EDITOR=/usr/bin/vim.basic

#source rvm
#source /etc/profile.d/rvm.sh

export PATH=~/.node_modules/bin:$PATH

if dpkg -l | grep xvfb > /dev/null
then
  if pgrep "Xvfb" > /dev/null
  then
    echo "xvfb is running."
  else
    echo "starting xvfb"
    Xvfb -ac -screen scrn 1280x2000x24 :9.0 > /dev/null 2>&1 &
    export DISPLAY=:9.0
  fi
else
  echo "xvfb is not installed, skipping xvfb start"
fi

export TERM=screen-256color
alias tmux="tmux -2"

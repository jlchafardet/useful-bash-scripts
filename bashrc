~/.bashrc

# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

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
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
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
alias st='svn st'
alias up='svn up'
alias add="svn st | grep \"^?\" | awk '{print $2}' | xargs svn add"

function ci () { svn ci -m "$@" ;}

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
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

bind '"\C-e":"\eb `which \ef`\e\C-e"'
alias editbash='v -p ~/.bashrc ~/.profile && source ~/.bashrc && source ~/.profile'
alias v='vim -p'
alias sr='screen -r'
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias ll='ls -alhts --color=always'
alias l='ls -lhts --color=always'
alias c='clear'
alias proctree='ps axjf'
alias topcpu='ps auxf | sort -nr -k 3 | head -10'
alias topmem='ps auxf | sort -nr -k 4 | head -10'
alias remsvndirs='find . -name ".svn" -exec rm -rf {} \;'
alias less='less -R' #repaint screen (to show colors)
alias colorslist="set | egrep 'COLOR_\w*'"  # lists all the colors
alias h=history
alias ..='cd ..'
alias ...='cd .. ; cd ..'
alias ff='find -name '
alias ga='git add'
alias gb='git checkout -b'
alias gd='git diff'
alias gs='git status -s'
alias ts='tig status'
alias tl='tig'
alias gl='git l'
alias currentbranch='git symbolic-ref --short -q HEAD'

alias httpdr='sudo service apache2 restart'
alias networkdr='sudo service network restart'
alias vpndr='sudo service openvpn restart'
alias mynotes='vim ~/.notes'
alias fixtime="sudo /sbin/service ntpd stop; sudo /sbin/ntpdate uk.pool.ntp.org; sudo /sbin/service ntpd start"
alias nstrace='dig +trace @8.8.8.8 scp.io'
alias p0='ping 10.150.0.1'
alias p8='ping 8.8.8.8'
alias ctail='c && tail'
alias lf="ls -l | egrep -v '^d'"
alias ldir="ls -l | egrep '^d'"
alias apachelog='tail -n 100 /var/log/apache2/error.log'

bind '"\e[A"':history-search-backward
bind '"\e[B"':history-search-forward
bind Space:magic-space

shopt -s histappend
export PROMPT_COMMAND='history -a'

function removetrailingspace {
    sed -i 's/ *$//' $1
}


alias untgz="tar xvzf"
function tgz {
    tar cvzf $1.tgz $1
}

function backup {
    tar cvzf $1-backup.tar.gz $1
}

function fixperm {
    find . -type f -user root -exec chown sc:websites {} \;
}

function vo {
    vim -p `ff $1`
}


function vow {
    FILES=`findit $1 | cut -d ':' -f 1 | sort -u | head -n8 | wc -l`
    echo $FILES files matched $1. Now opening these files \(max 8\)
    #findit $1 | head -n12 | cut -d ':' -f 1 | xargs
    vim -p `findit $1 | awk -F: '{print $1}' #| sort -u | head -n8 | xargs`
}

function demacify {
    find -name ._\* -exec rm -v {} \;
    find -name .DS_Store -exec rm -v {} \;
}

function removeswps {
    find -name .\*.swp -exec rm -v {} \;
}


export TERM=xterm-color
export GREP_OPTIONS='--color=auto' GREP_COLOR='1;32'
export CLICOLOR=1

export COLOR_NC='\033[0m' # No Color
export COLOR_WHITE='\033[1;37m'
export COLOR_BLACK='\033[0;30m'
export COLOR_BLUE='\033[0;34m'
export COLOR_LIGHT_BLUE='\033[1;34m'
export COLOR_GREEN='\033[0;32m'
export COLOR_LIGHT_GREEN='\033[1;32m'
export COLOR_CYAN='\033[0;36m'
export COLOR_LIGHT_CYAN='\033[1;36m'
export COLOR_RED='\033[0;31m'
export COLOR_LIGHT_RED='\033[1;31m'
export COLOR_PURPLE='\033[0;35m'
export COLOR_LIGHT_PURPLE='\033[1;35m'
export COLOR_BROWN='\033[0;33m'
export COLOR_YELLOW='\033[1;33m'
export COLOR_GRAY='\033[1;30m'
export COLOR_LIGHT_GRAY='\033[0;37m'



# History ----------------------------------------------------------
export HISTCONTROL=ignoredups
#export HISTCONTROL=erasedups
export HISTFILESIZE=300000
export HISTIGNORE="c:ls:cd:[bf]g:exit:..:...:ll:lla"
export HISTTIMEFORMAT='%F %T '

hf(){
  grep "$@" ~/.bash_history
}

# Misc -------------------------------------------------------------
shopt -s checkwinsize # After each command, checks the windows size and changes lines and columns

# bash completion settings (actually, these are readline settings)
bind "set completion-ignore-case on" # note: bind used instead of sticking these in .inputrc
bind "set bell-style none" # no bell
bind "set show-all-if-ambiguous On" # show list automatically, without double tab

# Navigation -------------------------------------------------------
cl() { cd $1; ls -la; }

# I got the following from, and mod'd it: http://www.macosxhints.com/article.php?story=20020716005123797
#    You can save a directory using an abbreviation of your choosing. Eg. save ms
#    You can subsequently move to one of the saved directories by using cd with
#    the abbreviation you chose. Eg. cd ms  (Note that no '$' is necessary.)
if [ ! -f ~/.dirs ]; then  # if doesn't exist, create it
  touch ~/.dirs
fi


# Editors ----------------------------------------------------------
export EDITOR='vim'  #Command line
export GIT_EDITOR='vim'
# Use mvim in cl/bin to open MacVim


# Search
gns(){ # Case insensitive, excluding svn folders
  find . -path '*/.svn' -prune -o -type f -print0 | xargs -0 grep -I -n -e "$1"
}



function parse_git_branch2 {
    git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'
}

function gbin {
    echo branch \($1\) has these commits and \($(parse_git_branch2)\) does not
    git log ..$1 --no-merges --format='%h | Author:%an | Date:%ad | %s' --date=local
}

function gbout {
    echo branch \($(parse_git_branch2)\) has these commits and \($1\) does not
    git log $1.. --no-merges --format='%h | Author:%an | Date:%ad | %s' --date=local
}

function parse_git_branch() {
  git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(git::\1)/'
}
function parse_svn_branch() {
    parse_svn_url | sed -e 's#^'"$(parse_svn_repository_root)"'##g' | awk -F / '{print "(svn::"$1 "/" $2 ")"}'
}
function parse_svn_url() {
    svn info 2>/dev/null | sed -ne 's#^URL: ##p'
}
function parse_svn_repository_root() {
    svn info 2>/dev/null | sed -ne 's#^Repository Root: ##p'
}
#411 export COLOR_LIGHT_CYAN='\033[1;36m'
#export PS1="\[\033[00m\]\u@\h\[\033[01;34m\] \w \[\033[31m\]\$(parse_git_branch)\$(parse_svn_branch) \[\033[00m\]$\[\033[00m\] "
export PS1="\[\033[00m\]\u@\h\[\033[01;34m\] \w \[\033[31m\]\$(parse_git_branch)\$(parse_svn_branch) \033[1;36m\]$\[\033[00m\] "

## Timestamp in the prompt ----------------------------------------------
export PROMPT_COMMAND="echo -n \[\$(date +%H:%M:%S)\]\" \""
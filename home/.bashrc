# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# don't put duplicate lines in the history. See bash(1) for more options
# don't overwrite GNU Midnight Commander's setting of `ignorespace'.
export HISTCONTROL=$HISTCONTROL${HISTCONTROL+,}ignoredups
# ... or force ignoredups and ignorespace
export HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
#[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

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

function rnd_colorize() {
    local NO_COLOR="\[\033[0m\]"
    n=$(python -c "import random
import socket
random.seed(socket.gethostname())
for x in range($1): random.randint(0, 231)
print '%d' % random.randint(0, 231)
")
    echo "\[\033[38;5;${n}m\]${2}${NO_COLOR}"
}

parse_git_branch() {
    (git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\:\1/')
}

gx_kube_context() {
    context="$(kubectl config current-context 2> /dev/null)"
    if [ ! -z "$context" ] && [[ $context == caas* ]]; then
        echo -e "$context "
    else
        echo -e ''
    fi
}

PS1="\$(gx_kube_context)$(rnd_colorize 0 [)\W\$(parse_git_branch)$(rnd_colorize 1 ])$(rnd_colorize 2 $) "

#PS1="[\W\$(parse_git_branch)]$ "
#if [ "$color_prompt" = yes ]; then
#    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
#else
#    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
#fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    eval "`dircolors -b`"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    #alias grep='grep --color=auto'
    #alias fgrep='fgrep --color=auto'
    #alias egrep='egrep --color=auto'
fi

# some more ls aliases
#alias ll='ls -l'
#alias la='ls -A'
#alias l='ls -CF'

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi

#source ~/phabricator/arcanist/resources/shell/bash-completion
#export PATH=$PATH:~/phabricator/arcanist/bin

source <(kubectl completion bash)

alias emacs='emacs -nw'
export GOPATH=~/go-path
export GOROOT=~/go
export PATH=~/usr/local/bin:$GOROOT/bin:$GOPATH/bin:~/node_modules/.bin:~/.local/bin:$PATH
export EDITOR='emacs -nw'
export CONCURRENCY_LEVEL=2
export GD_USER=sboydwickizer
export USER_HOME=$HOME

# added by Miniconda3 4.3.14 installer
export PATH="/home/sbw/miniconda3/bin:$PATH"

# tabtab source for serverless package
# uninstall by removing these lines or running `tabtab uninstall serverless`
[ -f /home/sbw/card-catalog/node_modules/tabtab/.completions/serverless.bash ] && . /home/sbw/card-catalog/node_modules/tabtab/.completions/serverless.bash
# tabtab source for sls package
# uninstall by removing these lines or running `tabtab uninstall sls`
[ -f /home/sbw/card-catalog/node_modules/tabtab/.completions/sls.bash ] && . /home/sbw/card-catalog/node_modules/tabtab/.completions/sls.bash
# tabtab source for jiractl package
# uninstall by removing these lines or running `tabtab uninstall jiractl`
[ -f /home/sbw/jiractl/node_modules/tabtab/.completions/jiractl.bash ] && . /home/sbw/jiractl/node_modules/tabtab/.completions/jiractl.bash

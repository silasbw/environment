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

unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

source <(kubectl completion bash)

export GOPATH=~/go-path
export GOROOT=~/go
export PATH=~/usr/local/bin:$GOROOT/bin:$GOPATH/bin:~/node_modules/.bin:~/.local/bin:$PATH
export EDITOR='emacs -nw'
export CONCURRENCY_LEVEL=4
export GD_USER=sboydwickizer
export USER_HOME=$HOME

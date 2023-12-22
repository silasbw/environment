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

color() {
    local NO_COLOR="\[\033[0m\]"
    echo "\[\033[38;5;${1}m\]${2}${NO_COLOR}"
}

#PS1="\$(gx_kube_context)$(rnd_colorize 0 [)\W\$(parse_git_branch)$(rnd_colorize 1 ])$(rnd_colorize 2 $) "
# https://jonasjacek.github.io/colors/
PS1="$(color 196 [)\W\$(parse_git_branch)$(color 196 ])$ "

unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

#source <(kubectl completion bash)

export GOPATH=~/go
export PATH=~/usr/local/bin:~/node_modules/.bin:~/.local/bin:$PATH:/usr/local/go/bin:~/go/bin/:~/.cargo/bin
export EDITOR='emacs -nw'
export CONCURRENCY_LEVEL=4
export USER_HOME=$HOME

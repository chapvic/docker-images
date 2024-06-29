# General Aliases
alias cps='cp --sparse=always'
alias la="ls -la"
alias ll="ls -ltan"
alias hosts='cat /etc/hosts'
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias untar="tar xzvkf"
alias ip4="ip -4 addr"
alias ip6="ip -6 addr"
alias os='cat /etc/os-release'

# Colorize Bash prompt
CX_N="\[\e[0;0m\]"      # NONE
CX_R="\[\e[1;31m\]"     # Red
CX_G="\[\e[1;32m\]"     # Green
CX_Y="\[\e[1;33m\]"     # Yellow
CX_W="\[\e[1;37m\]"     # White
if [ "$UID" -eq 0 ]; then
    CX_USER=$CX_R
    p=" #"
else
    CX_USER=$CX_G
    p=">"
fi
CX_PROMPT="${CX_USER}\u${CX_W}@${CX_Y}\h${CX_W}:\w${p} ${CX_N}"
case $TERM in
    *term | rxvt | screen )
        PS1="${CX_PROMPT}\[\e]0;\u@\h:\w\007\]" ;;
    linux )
        PS1="${CX_PROMPT}" ;;
    * )
        PS1="\u@\h:\w${p} " ;;
esac

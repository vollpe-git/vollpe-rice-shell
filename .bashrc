#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

fastfetch

alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias ff='fastfetch'
alias fuck='sudo $(history -p !!)'
alias apps='cat /home/vollpe/APPS.txt'

PS1='[\u@\h \W]\$'
eval "$(starship init bash)"

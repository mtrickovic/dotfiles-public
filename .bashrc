#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'

# Better history (like fish)
shopt -s histappend
HISTSIZE=10000
HISTFILESIZE=20000
HISTCONTROL=ignoreboth:erasedups

# Better completion
bind 'set completion-ignore-case on'
bind 'set show-all-if-ambiguous on'
bind 'TAB:menu-complete'

# Auto cd (just type directory name)
shopt -s autocd

# Spelling correction
shopt -s cdspell
shopt -s dirspell

# Your nice prompt (we just made)
parse_git_branch() {
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
}
parse_git_dirty() {
    [[ $(git status --porcelain 2> /dev/null) ]] && echo "*"
}
export PS1='\[\033[1;34m\]\w\[\033[0m\]\[\033[1;32m\]$(parse_git_branch)\[\033[1;33m\]$(parse_git_dirty)\[\033[0m\]\[\033[1;36m\] ➜\[\033[0m\] '

# Useful aliases
alias ll='ls -lah --color=auto'
alias la='ls -A --color=auto'
alias l='ls -CF --color=auto'
alias ..='cd ..'
alias ...='cd ../..'
alias g='git'

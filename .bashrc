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
alias py=python
alias pre-push="git status && git diff --staged && git log --oneline -5"

export PATH="$HOME/bin/p4merge/bin:$PATH"

# Oh-My-Posh Theme
POSH_THEMES_PATH="${USERPROFILE}/GH/dotfiles"
omp_config="${POSH_THEMES_PATH}/powerflow.omp.json"

if command -v oh-my-posh &>/dev/null; then
  if [[ -f "$omp_config" ]]; then
    eval "$(oh-my-posh init bash --config "$omp_config")"
  else
    echo "WARNING: OMP config not found: $omp_config" >&2
  fi
fi

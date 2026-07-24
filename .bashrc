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
  git branch 2>/dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
}
parse_git_dirty() {
  [[ $(git status --porcelain 2>/dev/null) ]] && echo "*"
}
export PS1='\[\033[1;34m\]\w\[\033[0m\]\[\033[1;32m\]$(parse_git_branch)\[\033[1;33m\]$(parse_git_dirty)\[\033[0m\]\[\033[1;36m\] ➜\[\033[0m\] '

# Modern ls (eza) with fallback to classic ls if eza isn't installed
if command -v eza &>/dev/null; then
  alias ll='eza -lah --icons --group-directories-first'
  alias la='eza -a --icons --group-directories-first'
  alias ls='eza --icons --group-directories-first'
  alias lt='eza --tree --level=2 --icons'
else
  alias ll='ls -lah --color=auto'
  alias la='ls -A --color=auto'
  alias l='ls -CF --color=auto'
fi

# Modern cat (bat) with fallback
command -v bat &>/dev/null && alias cat='bat --paging=never'

# Navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias -- -="cd -"

# Git
alias g='git'
alias pre-push="git status && git diff --staged && git log --oneline -5"

# Python
alias py=python
alias venv='python -m venv .venv && source .venv/bin/activate'

# Misc quality-of-life
alias grep='grep --color=auto'
alias mkdir='mkdir -pv'
alias c='clear'
alias h='history'
alias reload='source ~/.bashrc'

export PATH="$HOME/bin/p4merge/bin:$PATH"
export PATH="$HOME/bin:$PATH"

# Oh-My-Posh Theme
POSH_THEMES_PATH="${HOME}/GH/dotfiles"
omp_config="${POSH_THEMES_PATH}/powerflow.omp.json"

if command -v oh-my-posh &>/dev/null; then
  if [[ -f "$omp_config" ]]; then
    eval "$(oh-my-posh init bash --config "$omp_config")"
  else
    echo "WARNING: OMP config not found: $omp_config" >&2
  fi
fi

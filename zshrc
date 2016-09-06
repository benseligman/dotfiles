export TERM="xterm-256color"

# Path to your oh-my-zsh installation.
export ZSH=~/.oh-my-zsh

export VISUAL=vim
export EDITOR=vim

export PATH="$PATH:$HOME/bin:$HOME/go_appengine"
export GOPATH=$HOME
ZSH_THEME=""
plugins=(git)

source $ZSH/oh-my-zsh.sh
source ~/.aliasrc

# below stolen from notwaldorf/.not-quite-dotfiles
# Fix the git_prompt_info output for oh-my-zsh.
ZSH_THEME_GIT_PROMPT_PREFIX=" on %{$fg[cyan]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[cyan]%}"
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg[cyan]%}"
ZSH_THEME_GIT_PROMPT_CLEAN=""

# Fastest possible way to check if repo is dirty. Thanks btford for anything that looks magical in here.
git_dirty() {
  # check if we're in a git repo
  command git rev-parse --is-inside-work-tree &>/dev/null || return
  # check if it's dirty
  command git diff --quiet --ignore-submodules HEAD &>/dev/null; [ $? -eq 1 ] && echo ' ⚡︎' || echo ' ☀'
}

# For my own and others sanity
# git:
# %b => current branch
# %a => current action (rebase/merge)
# prompt:
# %F => color dict
# %f => reset color
# %~ => current path
# %c => trail of %~
# %* => time
# %n => username
# %m => shortname host
# %(?..) => prompt conditional - %(condition.true.false)

# This prompt works in oh-my-zsh because og git_prompt_info magic.
PROMPT='%F{green}%c%F{cyan}$(git_prompt_info) %F{cyan}%`git_dirty` %f%F{red}❥ %f'

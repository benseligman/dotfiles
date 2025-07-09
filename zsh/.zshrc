# ----------------------------------------------------
# ~/.zshrc - Minimal & Ergonomic Zsh Configuration
# Managed by GNU Stow - Located at ~/dotfiles/zsh/.zshrc
# ----------------------------------------------------

export TERM="xterm-256color"
export VISUAL="vim"
export EDITOR="vim"
export PATH="$HOME/bin:$HOME/go_appengine:$HOME/go/bin:/usr/local/lib/node_modules:$PATH"

setopt hist_ignore_dups
setopt hist_save_no_dups
setopt auto_cd
setopt auto_pushd
setopt pushd_ignore_dups
setopt interactive_comments
setopt extended_glob
setopt no_beep

bindkey -v

git_dirty() {
  command git rev-parse --is-inside-work-tree &>/dev/null || return
  command git diff --quiet --ignore-submodules HEAD &>/dev/null; [ $? -eq 1 ] && echo ' ⚡︎' || echo ' ☀'
}

setopt prompt_subst
PROMPT='%F{green}%c %F{cyan}%`git_dirty` %f%F{red}> %f'

if [ -f "$HOME/.aliasrc" ]; then
    source "$HOME/.aliasrc"
fi
[ -f "$HOME/.fzf.zsh" ] && source "$HOME/.fzf.zsh"

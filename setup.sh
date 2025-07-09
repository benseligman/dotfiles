#!/usr/bin/env bash

if [ ! -e ~/.vim/autoload/plug.vim ]; then
  echo "installing plug for vim packages"
  curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi

# Define your dotfiles directory
DOTFILES_DIR="$HOME/dotfiles"

# Change to the dotfiles directory
cd "$DOTFILES_DIR" || { echo "Error: Could not change to dotfiles directory."; exit 1; }

echo "Stowing dotfiles..."

# Stow each package
stow zsh
stow vim
stow tmux
stow nvim

echo "Dotfiles stowed successfully!"

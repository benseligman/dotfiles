#!/usr/bin/env bash
cwd=`pwd`

# install dein for managing vim packages
if [ ! -e ~/.vim/autoload/plug.vim ]; then
  curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi

echo "creating symlinks"
DOTFILES=(vimrc)
for file in $DOTFILES; do
  echo $file
  ln -sf $cwd/$file $HOME/.$file
done

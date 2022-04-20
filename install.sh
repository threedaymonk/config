#!/bin/sh

origin=$(pwd)
cd $HOME
for f in \
  Xdefaults \
  Xresources \
  ackrc \
  ctags \
  emacs.d \
  fonts.conf \
  gitconfig \
  gitignore \
  jshintrc \
  rspec \
  tmux.conf \
  vim \
  vimrc \
  zshenv \
  zshrc ;
do
  ln -sfn "$origin/$f" ".$f"
done

mkdir -p $HOME/.config
cd $origin/config
for f in *; do
  ln -sfn $origin/config/$f $HOME/.config/$f
done

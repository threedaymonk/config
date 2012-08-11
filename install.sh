#!/bin/sh

origin=$(pwd)
cd $HOME
for f in \
  ackrc \
  ctags \
  gitignore \
  fonts.conf \
  tmux.conf \
  vimrc \
  vim \
  zshenv \
  zshrc \
  Xdefaults \
  Xresources ;
do
  ln -sfn "$origin/$f" ".$f"
done

mkdir -p $HOME/.config
cd $origin/config
for f in *; do
  ln -sfn $origin/config/$f $HOME/.config/$f
done

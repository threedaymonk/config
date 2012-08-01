#!/bin/sh

origin=$(pwd)
cd $HOME
for f in ackrc ctags tmux.conf vimrc vim zshenv zshrc; do
  ln -sf "$origin/$f" ".$f"
done

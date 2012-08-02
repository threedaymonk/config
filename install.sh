#!/bin/sh

origin=$(pwd)
cd $HOME
for f in ackrc ctags tmux.conf vimrc vim zshenv zshrc; do
  ln -sfn "$origin/$f" ".$f"
done

cd $origin/config
for f in *; do
  ln -sfn $origin/config/$f $HOME/.config/$f
done

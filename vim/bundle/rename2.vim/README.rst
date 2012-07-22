==========
VIM RENAME
==========

A command and function that basically does a ":saveas <newfile>" then removes the old filename on the disk.

This plugin is forked from::

    http://www.vim.org/scripts/script.php?script_id=2724

With only one fix so far: allows to rename files even file path has space in it.

Simple usage
------------

When you editing a file and you need to rename it, in command mode execute::

    :Rename new_file_name.txt

How to install?
---------------

Simply copy the script to your ~/.vim/plugin directory.

Authors
-------

Original author Christian J. Robinson, contributed by Manni Heumann and Remigijus Jarmalavičius.

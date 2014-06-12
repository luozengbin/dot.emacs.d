#!/bin/sh

# sync submodule which contains master branch
# git submodule foreach 'git checkout master; git pull'
git submodule foreach 'if git branch | grep -s "master"; then git checkout master; git pull; fi'


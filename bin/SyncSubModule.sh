#!/bin/sh

# sync submodule which contains master branch
# git submodule foreach 'git checkout master; git pull'
git submodule foreach 'if git branch | grep -s "master"; then git checkout master; git pull; fi'

# sync octopress submodule
pushd blogs/octopress

git remote rm origin
git remote add origin git@github.com:luozengbin/luozengbin.github.com.git

git remote rm bitbicket
git remote add bitbicket https://luozengbin@bitbucket.org/luozengbin/octopress-source.git

git remote rm octopress
git remote add octopress https://github.com/imathis/octopress.git

git checkout source
git pull bitbicket source

pushd

# do not change to stable version for popwin
pushd lisp/popwin-el
git co bd130a65d832669d6763cba170216937e04f692e
pushd

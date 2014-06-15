#!/bin/sh
# sync octopress submodule
pushd blogs/octopress

# git remote rm origin
# git remote add origin https://github.com/luozengbin/luozengbin.github.com.git

git remote rm bitbicket
git remote add bitbicket https://luozengbin@bitbucket.org/luozengbin/octopress-source.git

git remote rm octopress
git remote add octopress https://github.com/imathis/octopress.git

git checkout source
git pull bitbicket source

# テーマを追加する
git clone https://github.com/kAworu/octostrap3 .themes/octostrap3

# githubと同期化するの準備
rm -rf _deploy
git clone https://github.com/luozengbin/luozengbin.github.com.git _deploy

pushd


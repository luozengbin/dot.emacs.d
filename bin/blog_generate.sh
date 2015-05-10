#!/bin/sh
## Usage: blog_generate.sh
##
## Options: $1 octopressディレクトリの位置
##   
## Comment: octopress配下にblog静的
##          コンテンツの生成
##################################################################### 

RUBY_VER="1.9.3-p0"
OCTOPRESS_DIR=$1

which rbenv
if [ $? = 0 ]; then
    # ruby バージョン切り替え処理
    rbenv global $RUBY_VER
    rbenv rehash
    global_ver=`rbenv global`
    if [ $global_ver = $RUBY_VER ]; then
        # blogコンテンツの生成
        echo "run rake with `ruby --version`"
        pushd $OCTOPRESS_DIR
        rake generate
        popd
    fi
fi

#!/bin/sh
## Usage: blog_preview.sh
##
## Options: $1 octopressディレクトリの位置
##   
## Comment: octopress配下にblog静的
##          コンテンツのプレビュー
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
        # blogコンテンツのプレビュー
        echo "run rake with `ruby --version`"
        pushd $OCTOPRESS_DIR
        if [ -z "`netstat -nutl | grep 4000`" ] ; then
            echo ">>> Startup Preview"
            nohup rake preview 2>&1  >/dev/null &
            sleep 2
        fi
        popd
    fi
fi

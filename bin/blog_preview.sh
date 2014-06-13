#!/bin/sh
## Usage: blog_preview.sh
##
## Options:
##   
## Comment: ~/.emacs.d/blogs/octopress配下にblog静的
##          コンテンツの生成とプレビュー
##################################################################### 

RUBY_VER="1.9.3-p0"

which rbenv
if [ $? = 0 ]; then
    # ruby バージョン切り替え処理
    rbenv global $RUBY_VER
    rbenv rehash
    global_ver=`rbenv global`
    if [ $global_ver = $RUBY_VER ]; then
        # blogコンテンツ生成とデプロイ
        echo "run rake with `ruby --version`"
        rake generate
        if [ -z "`netstat -nutl | grep 4000`" ] ; then
            echo ">>> Startup Preview"
            rake preview &
            sleep 2
        fi
    fi
fi

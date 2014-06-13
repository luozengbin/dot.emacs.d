#!/bin/sh
#!/bin/sh
## Usage: blog_deploy.sh
##
## Options:
##   
## Comment: ~/.emacs.d/blogs/octopress配下にblog静的
##          コンテンツの生成とデプロイ
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
        rake deploy
    fi
fi

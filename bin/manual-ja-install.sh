#! /bin/bash

EMACS=/usr/local/Cellar/emacs/HEAD/Emacs.app/Contents/MacOS/Emacs #emacsのパス
INFODIR=/Users/akira/.emacs.d/share/info_ja  #インストールするinfoのパス

# elispマニュアルのインデックス生成を正しく行うため
export LC_ALL='C'

# マニュアルのダウンロード
mkdir info-work
cd info-work
test ! -f emacs-src.tar.gz && wget http://www.bookshelf.jp/texi/emacs-man/21-3/emacs-src.tar.gz
test ! -f elisp-src.tar.gz && wget http://www.bookshelf.jp/texi/elisp-manual/21-2-8/elisp-src.tar.gz
test ! -f makeinfo-ja.el && wget http://www.meadowy.org/meadow/netinstall/export/745/branches/3.00/pkginfo/info-ja-emacs/makeinfo-ja.el

# info インストール先がなければ作る
test ! -d $INFODIR && mkdir -p $INFODIR

#############################################################################
# emacs マニュアルのインストール
#############################################################################
# マニュアルを解凍
mkdir emacs-src
cd emacs-src
tar zxf ../emacs-src.tar.gz

# マニュアルにパッチを当てる(そのままだとビルドに失敗するため)
cp -p emacs.texi emacs.texi.orig
cat emacs.texi.orig | sed -e "s/\.\.\/info\/emacs-ja/emacs-ja/" > emacs.texi
cp -p faq.texi faq.texi.orig
cat faq.texi.orig | sed -e "s/@buffer{/@file{/g" -e "s/@header{/@samp{/g" -e "s/@menuitem{/@samp{/g" -e "s/coding: iso-2022-7bit//" -e "s/\.\.\/info\/efaq-ja/efaq-ja/" -e "s/efaq-ja/efaq-ja/" > faq.texi
cp -p autotype.texi autotype.texi.orig
cat autotype.texi.orig | sed -e "s/\.\.\/info\/autotype-ja/autotype-ja/" > autotype.texi

# texi -> info に変換する
cp ../makeinfo-ja.el .
for file in faq.texi autotype.texi emacs.texi
do
    $EMACS -batch -l makeinfo-ja.el $file -f makeinfo-ja
done

# インストール
cp -p efaq-ja{,-{1..3}*} $INFODIR/
cp -p autotype-ja $INFODIR/
cp -p emacs-ja{,-{1..9}*} $INFODIR/
cd ../

#############################################################################
# elisp マニュアルのインストール
#############################################################################
# マニュアルを解凍
mkdir elisp-src
cd elisp-src
tar zxf ../elisp-src.tar.gz

# マニュアルにパッチを当てる(そのままだとビルドに失敗するため)
cp -p elisp.texi elisp.texi.orig
cat elisp.texi.orig | sed -e "s/@@mail/(at)mail/g" > elisp.texi
cp -p backups.texi backups.texi.orig
cat backups.texi.orig | sed -e "s/@deffn Command auto-save-mode arg//" > backups.texi

# texi -> info に変換する
cp ../makeinfo-ja.el .
$EMACS -batch -l makeinfo-ja.el elisp.texi -f makeinfo-ja

# インストール
cp -p elisp-ja{,-{1..24}*} $INFODIR/
cd ../

#############################################################################
# dir のインストール
#############################################################################
cat > dir <<EOF
This is the file .../info/dir, which contains the
topmost node of the Info hierarchy, called (dir)Top.
The first time you invoke Info you start off looking at this node.

File: dir,	Node: Top	This is the top of the INFO tree

  This (the Directory node) gives a menu of major topics.
  Typing "q" exits, "?" lists all Info commands, "d" returns here,
  "h" gives a primer for first-timers,
  "mEmacs<Return>" visits the Emacs manual, etc.

  In Emacs, you can click mouse button 2 on a menu item or cross reference
  to select it.

* Menu:

Emacs
* Elisp-ja: (elisp-ja).	The Emacs Lisp Reference Manual.
* Emacs FAQ JA: (efaq-ja).	Frequently Asked Questions about Emacs.
* Emacs-ja: (emacs-ja).	The extensible self-documenting text editor.
* Autotype-ja: (autotype-ja). Convenient features for text that you enter frequently
                          in Emacs.

EOF

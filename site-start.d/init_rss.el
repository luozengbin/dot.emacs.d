;;; init_rss.el --- configuration for rss reader

;; Copyright (C) 2013  LuoZengbin

;; Author: LuoZengbin <jalen.cn@gmail.com>
;; Keywords: news

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;;

;;; Code:

(require 'newsticker)

;; wgetがあるときは使う
(setq newsticker-retrieval-method
      (if (executable-find newsticker-wget-name) 'extern 'intern))

;; デフォルトでemacswikiのRSSが登録されているので、いらない人はnilに
(setq newsticker-url-list-defaults nil)

;; フィードのリスト
(setq newsticker-url-list
      '(;; ("gnu:whatsnew" "http://www.gnu.org/rss/whatsnew.rss")
        ;; ("gnu:recent" "http://www.gnu.org/rss/quagga.rss")
        ("SourceForge.JP" "http://sourceforge.jp/magazine/rss")
        ("Publickey" "http://www.publickey1.jp/atom.xml")
        ("Publickey Topics" "http://www.publickey2.jp/atom.xml")
        ))

;; 30分おきに自動更新する。デフォルトで1時間。
(setq newsticker-retrieval-interval 60)

;; HTMLレンダリングの設定
(setq newsticker-html-renderer 'w3m-region) ;emacs-w3m
;; (setq newsticker-html-renderer 'newsticker-htmlr-render) ;htmlr

;; 裏でフィードを更新するタイマーを設置する
;; (newsticker-start)

;; 起動コマンドをキーに割り当てる
;; (global-set-key (kbd "C-c r") 'newsticker-show-news)

(provide 'init_rss)
;;; init_rss.el ends here

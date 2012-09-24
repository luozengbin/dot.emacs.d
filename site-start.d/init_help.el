;;; init_help.el --- configuration for help system

;; Copyright (C) 2012  LuoZengbin

;; Author: LuoZengbin <jalen.cn@gmail.com>
;; Keywords: 

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

;; ヘルプシステム設定

;;; Code:

;;
;; womanから参照できる man ドキュメント
;;______________________________________________________________________
;; 新たにフレームは作らなくて良い
(setq woman-use-own-frame nil)

;; 初回起動が遅いので cache 作成。
(setq woman-cache-filename (expand-file-name (concat my-cache-dir "woman_cache")))

;; womanパスの指定
(setq woman-manpath my-man-dirs)

;; 日本語imenuを表示できるように設定する
(eval-after-load "woman"
  '(setq woman-imenu-generic-expression
         (append woman-imenu-generic-expression
                 '((nil "^\\(   \\)?\\([ぁ-んァ-ヴー一-龠ａ-ｚＡ-Ｚ０-９a-zA-Z0-9]+\\)" 2)))))

;; WoManでanything-imenu候補がでこない場合使用する
;;(setq woman-imenu t)

;; migemoを使用したimenuソースを定義
(eval-after-load "anything-config"
  '(setq anything-c-source-imenu
        (append anything-c-source-imenu (list '(migemo)))))

;;
;; infoドキュメントの整備
;;______________________________________________________________________
;; http://d.hatena.ne.jp/kitokitoki/20100808/p1
;; http://www.bookshelf.jp/
;; http://www.meadowy.org/meadow/dists/3.00/packages/
;; cvs -d:pserver:guest@openlab.ring.gr.jp:/circus/cvsroot login
;; cvs -z3 -d:pserver:guest@openlab.ring.gr.jp:/circus/cvsroot co -P gnujdoc
;;(setq Info-additional-directory-list nil)
(eval-after-load "info"
  '(progn
     (dolist (path (list
                    (expand-file-name (concat user-emacs-directory "share/info-ja/autoconf/2.12"))
                    (expand-file-name (concat user-emacs-directory "share/info-ja/automake/1.9/"))
                    (expand-file-name (concat user-emacs-directory "share/info-ja/binutils/2.16.1/"))
                    (expand-file-name (concat user-emacs-directory "share/info-ja/bison/1.28/"))
                    (expand-file-name (concat user-emacs-directory "share/info-ja/fileutils/4.1/"))
                    (expand-file-name (concat user-emacs-directory "share/info-ja/flex/2.5.4/"))
                    (expand-file-name (concat user-emacs-directory "share/info-ja/gengetopt/2.14/"))
                    (expand-file-name (concat user-emacs-directory "share/info-ja/gzip/1.2.4/"))
                    (expand-file-name (concat user-emacs-directory "share/info-ja/hurd/0.2/"))
                    (expand-file-name (concat user-emacs-directory "share/info-ja/libtool/1.5/"))
                    (expand-file-name (concat user-emacs-directory "share/info-ja/m4/1.4/"))
                    (expand-file-name (concat user-emacs-directory "share/info-ja/coreutils/5.2.1"))
                    (expand-file-name (concat user-emacs-directory "share/info-ja/cvs/1.11"))
                    (expand-file-name (concat user-emacs-directory "share/info-ja/diffutils/2.8.1"))
                    (expand-file-name (concat user-emacs-directory "share/info-ja/findutils/4.2.23"))
                    (expand-file-name (concat user-emacs-directory "share/info-ja/sh-utils/2.0"))
                    (expand-file-name (concat user-emacs-directory "share/info-ja/textutils/2.0"))
                    (expand-file-name (concat user-emacs-directory "share/info-ja/grep/2.5"))
                    (expand-file-name (concat user-emacs-directory "share/info-ja/sed/4.1.2"))
                    (expand-file-name (concat user-emacs-directory "share/info-ja/wget/1.9"))
                    (expand-file-name (concat user-emacs-directory "share/info-ja/gdb/4.18"))
                    (expand-file-name (concat user-emacs-directory "share/info-ja/standards"))
                    ;; Perlマニュアル
                    ;; http://www.namazu.org/~tsuchiya/perl/info/
                    (expand-file-name (concat user-emacs-directory "share/info-ja/perl/5.0"))
                    ;; pythonマニュアル
                    ;; http://www.python.jp/pub/doc_jp/
                    (expand-file-name (concat user-emacs-directory "share/info-ja/python/info-2.3.5-jp"))
                    ;; org-mode日本語
                    ;; https://github.com/org-mode-doc-ja/org-ja
                    (expand-file-name (concat user-emacs-directory "share/info-ja/org-ja/work"))
                    ;; SDIC英和辞書マニュアル
                    ;; http://www.namazu.org/~tsuchiya/sdic/index.html
                    (expand-file-name (concat user-emacs-directory "share/info-ja/sdic"))
                    ;; EB ライブラリを用いた対話型の電子辞書マニュアル
                    ;; http://openlab.jp/edict/eblook/
                    (expand-file-name (concat user-emacs-directory "share/info-ja/eblook/1.6.1"))
                    ;; navi2ch日本語ドキュメント
                    (expand-file-name (concat user-emacs-directory "share/info-ja/navi2ch"))
                    ;; Yet Another TeX mode for Emacs
                    (expand-file-name (concat user-emacs-directory "share/info-ja/yatex/1.75"))
                    ;; lookupの日本語ドキュメント
                    (expand-file-name (concat user-emacs-directory "share/info-ja/lookup"))
                    ;; gnus周りの日本語ドキュメント
                    (expand-file-name (concat user-emacs-directory "share/info-ja/gnus"))
                    ;; emacs-w3mの日本語ドキュメント
                    (expand-file-name (concat user-emacs-directory "share/info-ja/emacs-w3m"))
                    ;; texinfoの日本語ドキュメント
                    (expand-file-name (concat user-emacs-directory "share/info-ja/texinfo"))
                    ;; mewマニュアル
                    (expand-file-name (concat user-emacs-directory "share/info-ja/mew"))
                    ;; やさしいEmacs-lisp講座
                    (expand-file-name (concat user-emacs-directory "share/info-ja/elisp.x"))
                    ;; Emacs Lispリファレンスマニュアル2.9版
                    (expand-file-name (concat user-emacs-directory "share/info-ja/elisp/2.9_e21.3"))
                    ;; Emacs Lisp 入門
                    (expand-file-name (concat user-emacs-directory "share/info-ja/eintr/2.04"))
                    ;; Emacs マニュアル、FAQ
                    (expand-file-name (concat user-emacs-directory "share/info-ja/emacs/2.41_e21.3"))

                    ;; dir定義ファイルを集めたディレクトリ
                    (expand-file-name (concat user-emacs-directory "share/info-ja"))))
       (add-to-list 'Info-additional-directory-list path))))
;;
;; info+.elでinfoを読みやすく
;;______________________________________________________________________
;; (auto-install-from-emacswiki "info+.el")
(eval-after-load "info" '(require 'info+))

;;
;; anythingからinfoやmanページを引く
;;______________________________________________________________________
(eval-after-load "init_anything"
  '(progn
    ;; manやinfoを調べるコマンドを作成してみる
    ;; anything-for-document 用のソースを定義
    (defvar anything-for-document-sources)
    (setq anything-for-document-sources
          (list anything-c-source-man-pages
                anything-c-source-info-pages
                anything-c-source-apropos-emacs-commands
                anything-c-source-apropos-emacs-functions
                anything-c-source-apropos-emacs-variables
                anything-c-source-google-suggest
                ))

    ;; anything-for-document コマンドを作成
    (defun anything-for-document ()
      "Preconfigured `anything' for anything-for-document."
      (interactive)
      (let (search-target)
        (if (region-active-p)
            (setq search-target (buffer-substring (region-beginning) (region-end)))
          (if (thing-at-point 'symbol)
              (setq search-target (thing-at-point 'symbol))
            (setq search-target (thing-at-point 'word)))
          )
        (anything anything-for-document-sources
                  ;;(thing-at-point 'symbol)
                  search-target
                  nil nil nil "*anything for document*")))
    ;; C-z d に anything-for-documentを割り当て
    (define-key global-map (kbd "C-z d") 'anything-for-document)))

;;
;; python日本語ドキュメント
;;______________________________________________________________________
;; anything からpythonドキュメントを引く
(defvar anything-c-source-info-python-lib-ja '((info-index . "python-lib-jp.info")))
(defvar anything-c-source-info-python-ref-ja '((info-index . "python-ref-jp.info")))
(defvar anything-c-source-info-python-api-ja '((info-index . "python-api-jp.info")))
(defvar anything-c-source-info-python-ext-ja '((info-index . "python-ext-jp.info")))
(defvar anything-c-source-info-python-tut-ja '((info-index . "python-tut-jp.info")))
(defvar anything-c-source-info-python-dist-ja '((info-index . "python-dist-jp.info")))

(defun anything-info-python-at-point ()
  "Preconfigured `anything' for searching info at point."
  (interactive)
  (anything '(anything-c-source-info-python-lib-ja
              anything-c-source-info-python-ref-ja
              anything-c-source-info-python-api-ja
              anything-c-source-info-python-ext-ja
              anything-c-source-info-python-tut-ja
              anything-c-source-info-python-dist-ja)
            (thing-at-point 'symbol) nil nil nil "*anything info*"))

;;
;; my-info.el (my info mode extention)
;;______________________________________________________________________
(require 'my-info)

(provide 'init_help)
;;; init_help.el ends here

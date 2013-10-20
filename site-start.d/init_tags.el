;;; init_tags.el --- configutation for source code tag systems

;; Copyright (C) 2012  LuoZengbin

;; Author: LuoZengbin <jalen.cn@gmail.com>
;; Keywords: tags

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

;;
;; etags
;;______________________________________________________________________
;;; デフォルト参照するTAGSファイルのパス
(setq tags-table-list (list (expand-file-name user-emacs-directory)
                            "/usr/share/emacs/24.1/lisp"))

;;
;; ctags
;; http://www.bookshelf.jp/soft/meadow_42.html#SEC636
;; http://d.hatena.ne.jp/tama_sh/20110212/1297499584
;; http://d.hatena.ne.jp/whitypig/20110415/1302865110
;;______________________________________________________________________
(require 'ctags nil t)
(setq tags-revert-without-query t)

;;; anything-exuberant-ctags用のtagsファイルを生成するコマンド
(setq ctags-command "ctags -R --fields=\"+afikKlmnsSzt\" ")
;;; etags用のtagsファイルを生成するコマンド
;; (setq ctags-command "ctags -e -R ")

;;; タグファイル自動作成と更新するコマンド
;;(global-set-key (kbd "<f5>") 'ctags-create-or-update-tags-table)
;;(global-set-key (kbd "M-.")  'ctags-search)

;;
;; gtag 設定
;;______________________________________________________________________
;; gtagsで関数TAG環境の整備
;; install gtag on mac os ---> sudo brew install global
;; cp /usr/local/Cellar/global/6.0/share/gtags/gtags.el ~/.emacs.d/lisp/
(require 'gtags nil t)
(add-hook 'java-mode-hook (lambda () (gtags-mode 1)))
(add-hook 'c-mode-hook (lambda () (gtags-mode 1)))
(add-hook 'c++-mode-hook (lambda () (gtags-mode 1)))

;;
;; anything for tag systems
;;______________________________________________________________________
(require 'anything-yaetags nil t)
(require 'anything-gtags nil t)
(require 'anything-exuberant-ctags nil t)

;;; TAGS情報源の定義
(defvar anything-for-tags
  (list anything-c-source-imenu
        anything-c-source-gtags-select
        ;; anything-c-source-etags-select
        anything-c-source-exuberant-ctags-select ;
        ))

;;; コマンド定義
(defun anything-for-tags ()
  "anything command for tags system"
  (interactive)
  (anything anything-for-tags
            (thing-at-point 'symbol)
            nil nil nil "*anything for tags*"))


;;
;; xcscope linuxカーネルソースブラウジング
;;______________________________________________________________________
(when (require 'xcscope nil t)
  (setq cscope-database-regexps
        '(
          ("^/usr/src/linux-3.11.5-1-ARCH"
           ("/home/akira/cscope")))))

(provide 'init_tags)
;;; init_tags.el ends here

;;; init_navi2ch.el --- configuration for navi2ch lisp psackage

;; Copyright (C) 2011  Zouhin.Ro

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

;; navi2ch.el ２チャネルを見る

;;; Code:

;; install
;; http://navi2ch.sourceforge.net/
;; http://navi2ch.sourceforge.net/doc/navi2ch_1.html
;; http://homepage.mac.com/matsuan_tamachan/software/NaviNich.html
;; git clone git://navi2ch.git.sourceforge.net/gitroot/navi2ch/navi2ch

;; (require 'navi2ch)
;; Navi2ch 用の設定
(autoload 'navi2ch "navi2ch" "Navigator for 2ch for Emacs" t)

;; インストール時指定したiconフォルダー
(setq navi2ch-icon-directory (concat user-emacs-directory "etc/navi2ch"))

;; プロキシ設定
(if my-local-proxy-enable
    ( progn
      (setq navi2ch-net-http-proxy my-local-http-proxy)
      ;; (setq navi2ch-net-http-proxy-userid "")
      ;; (setq navi2ch-net-http-proxy-password "")
      ))

;; 偶に、url が変わる事がある。
;; (setq navi2ch-list-bbstable-url "http://menu.2ch.net/bbsmenu.html")
(setq navi2ch-article-exist-message-range '(1 . 1000)) ;既存のレス
(setq navi2ch-article-new-message-range '(1000 . 1))   ;新レス
;; Boardモードのレス数欄にレスの増加数を表示する
(setq navi2ch-board-insert-subject-with-diff t)
;; Boardモードのレス数欄にレスの未読数を表示する
(setq navi2ch-board-insert-subject-with-unread t)
;; 板一覧のカテゴリをデフォルトですべて開いて表示する
(setq navi2ch-list-init-open-category t)
;; レスをexpire(削除)しない
(setq navi2ch-board-expire-date nil)
;; 履歴の行数を制限しない
(setq navi2ch-history-max-line nil)

;; 送信控えをとる
(setq navi2ch-message-save-sendlog t)

;; 以下はエラーになる
;; (add-to-list 'navi2ch-list-navi2ch-category-alist
;;              navi2ch-message-sendlog-board)

;; 送信控えのレスに板名も表示する
(setq navi2ch-message-sendlog-message-format-function
      'navi2ch-message-sendlog-message-format-with-board-name)

;; ;; キーバインド
;; ;; http://navi2ch.sourceforge.net/doc/navi2ch_4.html#SEC32
;; (add-hook 'navi2ch-article-mode-hook
;;           (lambda ()
;;             (let ((map navi2ch-article-mode-map))
;;               (define-key map "w" 'navi2ch-article-write-sage-message) ; w で sage
;;               (define-key map "W" 'navi2ch-article-write-message)      ; W で age
;;               (define-key map "j" 'navi2ch-article-next-message)       ; j で次のレスへ
;;               (define-key map "k" 'navi2ch-article-previous-message)   ; k で前のレスへ
;;               (define-key map "n" 'navi2ch-article-few-scroll-up)      ; n で1行下ヘスクロール
;;               (define-key map "p" 'navi2ch-article-few-scroll-down)    ; p で1行上へスクロール
;;               )))

(provide 'init_navi2ch)
;;; init_navi2ch.el ends here

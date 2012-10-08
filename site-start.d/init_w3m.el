;;; init_w3m.el --- configuration w3m lisp package

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

;; w3mブラウザ設定

;;; Code:

(eval-after-load "w3m"
  '(progn
     (setq  w3m-command "w3m")

     ;; (setq w3m-home-page "http://www.google.co.jp/") ;起動時に開くページ
     (setq w3m-use-cookies t)           ;クッキーを使う
     (setq w3m-bookmark-file (concat my-private-emacs-path "configuration/.w3m/bookmark.html")) ;ブックマークを保存するファイル

     ;; 検索エンジンの設定
     (setq w3m-search-default-engin "google-ja")

     ;; キーバンドをカスタマイズする
     (add-hook 'w3m-mode-hook
               (lambda ()
                 (define-key w3m-mode-map [up] 'previous-line)
                 (define-key w3m-mode-map [down] 'next-line)
                 (define-key w3m-mode-map [left] 'backward-char)
                 (define-key w3m-mode-map [right] 'forward-char)
                 ))))

;; ポインター位置のurlをw3mテキストブラウザで開く
(global-set-key (kbd "C-z v") 'my-w3m-browse-url-at-point)

(provide 'init_w3m)
;;; init_w3m.el ends here

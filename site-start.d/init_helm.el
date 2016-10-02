;;; init_helm.el --- configuration for helm

;; Copyright (C) 2012  LuoZengbin

;; Author: LuoZengbin <jalen.cn@gmail.com>
;; Keywords: helm

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
(message "init-helm ...")

(require 'helm-config)
(require 'helm-command)

;;
;; helm global setting
;;______________________________________________________________________
(setq helm-truncate-lines t)

;;
;; helm-migemo
;;______________________________________________________________________
;;; M-x helm-occur
;; (when
;;     (and (executable-find "cmigemo")
;;          (require 'helm-migemo nil t))
;;   ;; defaultでは無効にする
;;   (setq helm-use-migemo nil))

;;
;; helm-imenu
;;______________________________________________________________________
(require 'helm-imenu)

;;
;; helm コマンドの定義
;;______________________________________________________________________
;; my-helm
(defun my-helm ()
  "helm command for me "
  (interactive)
  (require 'helm-files)
  (unless helm-source-buffers-list
    (setq helm-source-buffers-list
          (helm-make-source "Buffers" 'helm-source-buffers)))
  (helm-other-buffer
   '(helm-source-buffers-list
     helm-source-bookmarks
     helm-source-recentf
     helm-source-files-in-current-dir ;; 遅い
     helm-source-imenu
     helm-source-buffer-not-found)
   "*helm*"))

;;
;; helmキーバンディングのカスタマイズ
;;______________________________________________________________________
;; helm-commandのprefix-Keyを "<f5> a" → "C-z a"に変える
(custom-set-variables '(helm-command-prefix-key "C-z a"))

;; [C-SPC] → [C-@]
;; helmでオブジェクト選択キーバンディングを変える
(define-key helm-map (kbd "C-@") 'helm-toggle-visible-mark)

;;
;; helm-show-kill-ring
;;______________________________________________________________________
(define-key global-map (kbd "M-y") 'helm-show-kill-ring)

;;
;; describe-bindingsをhelmインタフェースに変えて、絞れるように改善する
;;______________________________________________________________________
;;(global-set-key (kbd "C-h b") 'helm-descbinds)
(when (require 'helm-descbinds nil t)
  ;; describe-bindingsをHelmに置き換える
  (helm-descbinds-mode))

;;
;; helmによる補完
;;______________________________________________________________________
;; 補足：M-c 元はseq-capitalize-backward-wordコマンドに割り当てられている
(require 'helm-elisp)
(define-key emacs-lisp-mode-map (kbd "M-c") 'helm-lisp-completion-at-point)

;;
;; key binding
;;______________________________________________________________________
;; helmメニュー表示する
(global-set-key (kbd "C-x c") 'helm-mini)
(global-set-key (kbd "C-x z") 'helm-resume)

;; [M-z] に割り当てする
(define-key esc-map "t"  'my-helm)
;;; hidden bufferの絞り込み
(global-set-key (kbd "C-x y") 'my-helm-hidden-buffer-commands)

(define-key global-map (kbd "M-x")     'helm-M-x)
(define-key global-map (kbd "C-x i")     'helm-imenu)

;;
;; helm occur
;;______________________________________________________________________
(global-set-key (kbd "C-M-o") 'helm-occur) ;helm-occurの起動
(define-key isearch-mode-map (kbd "C-o") 'helm-occur-from-isearch) ;isearchからhelm-occurを起動
;; (define-key helm-map (kbd "C-c C-a") 'all-from-helm-occur) ; helm-occurからall-extに受け渡し

;;
;; helm-ag.el The Silver Searcherの helmインタフェースです
;;______________________________________________________________________
(require 'helm-ag)

(setq helm-ag-base-command "ag --nocolor --nogroup --ignore-case")
(setq helm-ag-thing-at-point 'symbol)

;;
;; google 検索エンジンのインタフェース
;;______________________________________________________________________
(define-key global-map (kbd "C-x s")     'helm-google-suggest)
(setq helm-google-suggest-use-curl-p (executable-find "curl"))
(setq helm-google-suggest-search-url
      "http://www.google.co.jp/search?hl=ja&num=100&as_qdr=y5&lr=lang_ja&ie=utf-8&oe=utf-8&q=")
(setq helm-google-suggest-url
      "http://google.co.jp/complete/search?ie=utf-8&oe=utf-8&hl=ja&output=toolbar&q=")

;;
;; surfraw 検索エンジンのインタフェース
;; helm-surfraw.el
;; install surfraw first: $ sudo pacman -S surfraw
;; init setting file for surfraw
;; ==== ~/.config/surfraw/conf
;; SURFRAW_lang=jp
;; # SURFRAW_text_browser='urxvtc -e w3m -o display_charset=utf-8'
;; SURFRAW_google_country=jp
;; SURFRAW_amazon_country=jp
;; SURFRAW_google_country=jp
;; SURFRAW_ixquick_lang=nihongo
;; SURFRAW_graphical_browser=/usr/bin/firefox
;; #SURFRAW_text_browser=/usr/bin/elinks
;; SURFRAW_graphical=yes
;; ====
;;______________________________________________________________________
(define-key global-map (kbd "C-x S")     'helm-surfraw)

;;
;; custom helm
;;______________________________________________________________________
;; 自作関数をローディングする
;; (require 'my-helm-sources)

(provide 'init_helm)
;;; init_helm.el ends here

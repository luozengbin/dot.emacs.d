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
  (helm-other-buffer
   '(helm-c-source-buffers-list
     helm-c-source-bookmarks
     helm-c-source-recentf
     helm-c-source-files-in-current-dir ;; 遅い
     helm-c-source-imenu
     helm-c-source-buffer-not-found)
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
(global-set-key (kbd "C-x c") 'my-helm)
;; [M-z] に割り当てする
(define-key esc-map "t"  'my-helm)
;;; hidden bufferの絞り込み
(global-set-key (kbd "C-x y") 'my-helm-hidden-buffer-commands)

;;
;; custom helm
;;______________________________________________________________________
;; 自作関数をローディングする
(require 'my-helm-sources)

(provide 'init_helm)
;;; init_helm.el ends here

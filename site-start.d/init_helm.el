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
(require 'helm-config)


;;
;; helm-show-kill-ring
;;______________________________________________________________________
(define-key global-map (kbd "M-y") 'helm-show-kill-ring)

;;
;; helm-migemo
;;______________________________________________________________________
(when
    (and (executable-find "cmigemo")
         (require 'helm-migemo nil t))
  ;; defaultでは無効にする
  (setq helm-use-migemo nil))

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
  (helm-other-buffer
   '(helm-c-source-buffers-list
     helm-c-source-bookmarks
     helm-c-source-recentf
     ;; helm-c-source-files-in-current-dir ;; 遅い
     helm-c-source-imenu
     helm-c-source-buffer-not-found)
   "*helm*"))

(provide 'init_helm)
;;; init_helm.el ends here

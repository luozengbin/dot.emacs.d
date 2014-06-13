;;; init_buffer.el --- configuration for init buffers

;; Copyright (C) 2012  LuoZengbin

;; Author: LuoZengbin <jalen.cn@gmail.com>
;; Keywords: buffer

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

(message "init_buffer ...")

;;
;; scratchバッファーの保存と復元
;;______________________________________________________________________
;;  scratch-log拡張でスクラッチバッファを安心に使えるように
;; git clone https://github.com/wakaran/scratch-log.git
;; refs: http://d.hatena.ne.jp/kitokitoki/20100612/p1
(require 'scratch-log)
(setq sl-append-scratch-p nil)
(setq sl-prev-scratch-string-file (concat my-private-emacs-path "configuration/.scratch-prev"))
(setq sl-scratch-log-file (concat my-private-emacs-path "configuration/.scratch-history"))

;; nil なら emacs 起動時に，最後に終了したときの スクラッチバッファの内容を復元しない。初期値は t です。
;; (setq sl-restore-scratch-p nil)
;; nil なら スクラッチバッファを削除できるままにする。初期値は t です。
;; (setq sl-prohibit-kill-scratch-buffer-p nil)


;;
;; Reverting All Buffers
;;______________________________________________________________________
;;; 全自動リロード
;; (global-auto-revert-mode 1)

;; http://www.neilvandyke.org/revbufs/
;; (install-elisp "http://www.neilvandyke.org/revbufs/revbufs.el")
(require 'revbufs)
(define-key global-map (kbd "C-z <f5>") 'my-revert-buffer)
(defun my-revert-buffer (arg)
  (interactive "P")
  (if (null arg)
      (revbufs)
    (revert-buffer)))

;;; すべてのファイルバッファーを全部リロードする
;;; http://irreal.org/blog/?p=857
(defun revert-all-buffers ()
  "Revert all non-modified buffers associated with a file.
This is to update existing buffers after a Git pull of their underlying files."
  (interactive)
  (save-current-buffer
    (mapc (lambda (b)
            (set-buffer b)
            (unless (or (null (buffer-file-name)) (buffer-modified-p))
              (revert-buffer t t)
              (message "Reverted %s\n" (buffer-file-name))))
          (buffer-list))))

(defun revert-buffer-keep-undo (&rest -)
  "Revert buffer but keep undo history."
  (interactive)
  (let ((inhibit-read-only t))
    (erase-buffer)
    (insert-file-contents (buffer-file-name))
    (set-visited-file-modtime (visited-file-modtime))
    (set-buffer-modified-p nil)))

;; (setq revert-buffer-function 'revert-buffer-keep-undo)

;;
;; clenaup buffer
;;______________________________________________________________________
(defun cleanup-buffers ()
  (interactive)
  (loop for buffer being the buffers
        do (kill-buffer buffer)))

(provide 'init_buffer)
;;; init_buffer.el ends here

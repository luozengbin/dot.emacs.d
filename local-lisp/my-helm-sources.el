;;; my-helm-sources.el --- define source for helm

;; Copyright (C) 2013  LuoZengbin

;; Author: LuoZengbin <jalen.cn@gmail.com>
;; Keywords: helm-sources

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
;; 見えないbuffer一覧のanythingインタフェース
;;______________________________________________________________________
;;; アクション定義
(define-helm-type-attribute 'hidden-buffer
  `((action
     ("Switch to buffer" . helm-switch-to-buffer)
     ,(and (locate-library "popwin") '("Switch to buffer in popup window" . popwin:popup-buffer))
     ("Switch to buffer other window" . switch-to-buffer-other-window)
     ("Switch to buffer other frame" . switch-to-buffer-other-frame)
     ,(and (locate-library "elscreen") '("Display buffer in Elscreen" . helm-find-buffer-on-elscreen))
     ("Query replace regexp" . helm-buffer-query-replace-regexp)
     ("Query replace" . helm-buffer-query-replace)
     ("View buffer" . view-buffer)
     ("Display buffer"   . display-buffer)
     ("Grep buffers (C-u grep all buffers)" . helm-zgrep-buffers)
     ("Multi occur buffer(s)" . helm-multi-occur-as-action)
     ("Revert buffer(s)" . helm-revert-marked-buffers)
     ("Insert buffer" . insert-buffer)
     ("Kill buffer(s)" . helm-kill-marked-buffers)
     ("Diff with file" . diff-buffer-with-file)
     ("Ediff Marked buffers" . helm-ediff-marked-buffers)
     ("Ediff Merge marked buffers" . (lambda (candidate)
                                       (helm-ediff-marked-buffers candidate t))))
    (persistent-help . "Show this buffer")
    ;; (filtered-candidate-transformer helm-skip-boring-buffers
    ;;                                 helm-highlight-buffers)
    )
  "Buffer or buffer name.")

(defun my-helm-hidden-buffer-commands ()
  (interactive)
  (helm (list
         (list (cons 'name "Hidden Buffer List")
               (cons 'candidates (my-hidden-buffer-list))
               (cons 'type 'hidden-buffer))) nil nil nil))

(provide 'my-helm-sources)
;;; my-helm-sources.el ends here

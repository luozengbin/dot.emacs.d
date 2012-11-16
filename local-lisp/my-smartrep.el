;;; my-smartrep.el --- extention for smartrep lisp

;; Copyright (C) 2012  LuoZengbin

;; Author: LuoZengbin <jalen.cn@gmail.com>
;; Keywords: smartrep, keybinding

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

(defvar smartrep-help-buffer-name " *Smartrep Help*")
(defvar smartrep-show-help nil)

(require 'popwin)
(push `(,smartrep-help-buffer-name :height 15 :position bottom :noselect t)
      popwin:special-display-config)

(defadvice smartrep-extract-fun (around smartrep-extract-fun-around activate)
  (if (string= "63" (pp-to-string char))
      (smartrep-show-help char alist)
    ad-do-it
    (message "smartrep-key: %s" char)))

(defadvice smartrep-define-key (before smartrep-define-key-before activate)
  ;; append "?" key define here
  (if (not (assoc "?" alist))
      (add-to-list 'alist '("?" "dummy command"))))

(defadvice smartrep-map-internal (after smartrep-map-internal-after activate)
  (let* ((buf-name smartrep-help-buffer-name)
         (buf-win (get-buffer-window buf-name)))
    (if buf-win
        (delete-window buf-win))
    (setq smartrep-show-help nil)))

(defun smartrep-show-help (char alist)
  (let* ((buf-name smartrep-help-buffer-name)
         (buf-win (get-buffer-window buf-name)))
    (if smartrep-show-help
        ;; hidden help windows
        (progn
          (if buf-win
              (delete-window buf-win))
          (setq smartrep-show-help nil)
          (message "close smartrep help window"))
      ;; show help window
      (smartrep-render-help-buffer char alist)
      (display-buffer buf-name)
      (setq smartrep-show-help t)
      (message "show smartrep help window"))))

(defun smartrep-render-help-buffer (char alist)
  (if (get-buffer smartrep-help-buffer-name)
      (kill-buffer smartrep-help-buffer-name))
  (let ((buf
         (smartrep-render-ctbl-buffer
          (loop for ele in alist
                collect (list (car ele) (pp-to-string (cdr ele)))))))
    (with-current-buffer buf
      (rename-buffer smartrep-help-buffer-name))))

(defun smartrep-render-ctbl-buffer (data-alist)
  (require 'ctable)
  (let ((param (copy-ctbl:param ctbl:default-rendering-param)))
    (setf (ctbl:param-fixed-header param) t)
    (setf (ctbl:param-draw-hlines param)
          (lambda (model row-index)
            (cond ((memq row-index '(0 1 -1)) t)
                  (t nil ))))
    (let ((cp
           (ctbl:create-table-component-buffer
            :width 80 :height nil
            :model
            (make-ctbl:model
             :column-model
             (list (make-ctbl:cmodel :title "Key" :min-width 5 :max-width 10 :align 'left)
                   (make-ctbl:cmodel :title "Command & Form" :align 'left))
             :data data-alist)
            :param param)))
      (ctbl:cp-add-selection-change-hook cp (lambda () (message "CTable : Select Hook")))
      (ctbl:dest-ol-selection-clear (ctbl:component-dest cp))
      (ctbl:cp-get-buffer cp))))

(provide 'my-smartrep)
;;; my-smartrep.el ends here

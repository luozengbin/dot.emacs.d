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
(require 'guide-key)

(defvar smartrep-help-buffer-name " *Smartrep Help*")
(defvar smartrep-show-help nil)

(defun smartrep-execute-form (form)
  (cond
   ((commandp form)
    (setq this-command form)
    (unwind-protect
        (call-interactively form)
      (setq last-command form)))
   ((functionp form) (funcall form))
   ((and (listp form) (symbolp (car form))) (eval form))
   (t (error "Unsupported form %s" form))))

(defun switch-smartrep-map-append (form key-alist)
"append smartrep map when running form"
  (smartrep-execute-form form)
  (let ((smartrep-skip-first-time t))
    (setq key-alist (smartrep-append-help-key key-alist))
    (smartrep-map-internal key-alist)))

(defadvice smartrep-define-key (before smartrep-define-key-before activate)
  (setq alist (smartrep-append-help-key alist)))

(defun smartrep-append-help-key (alist)
  ;; append "?" key define here
  (append alist (loop for elt in '(("q" "quite smartrep mode")
                                   ("?" "show smartrep help buffer")
                                   ;; ("{" "scroll smartrep help buffer down")
                                   ;; ("}" "scroll smartrep help buffer up")
                                   )
                      unless (assoc (car elt) alist)
                      collect elt)))

(defadvice smartrep-map-internal (after smartrep-map-internal-after activate)
  (let* ((buf-name smartrep-help-buffer-name)
         (buf-win (get-buffer-window buf-name)))
    (if buf-win
        (delete-window buf-win))
    (setq smartrep-show-help nil)))

(defadvice smartrep-extract-fun (around smartrep-extract-fun-around activate)
  (cond
   ((string= "q" (single-key-description char))
    (smartrep-close-help-buffer)
    (execute-kbd-macro (read-kbd-macro "C-g"))
    )
   ((string= "?" (single-key-description char))
    (smartrep-show-help char alist))
   ;; ((string= "{" (single-key-description char))
   ;;  (smartrep-scroll-help-buffer char alist))
   ;; ((string= "}" (single-key-description char))
   ;;  (smartrep-scroll-help-buffer char alist))
   (t
    ad-do-it
    (message "smartrep-key {%s} : %s"
             (single-key-description char)
             (pp-to-string last-command)))))

(defadvice smartrep-do-fun (around smartrep-do-fun-around activate)
  (if (and (boundp 'smartrep-skip-first-time)
           smartrep-skip-first-time)
      (setq smartrep-skip-first-time nil)
    ad-do-it))

(defvar smartrep-this-prefix-vector nil)
(defvar smartrep-last-prefix-vector nil)
(defadvice smartrep-read-event-loop (before smartrep-read-event-loop-before activate)
  (setq smartrep-this-prefix-vector
        (vconcat(butlast (append (this-command-keys-vector) nil) 1))))

;;; ---------------------- help-buffer controller
(defun smartrep-popup-help-buffer ()
  "Pop up smartrep help buffer"
  (with-current-buffer (get-buffer smartrep-help-buffer-name)
    (popwin:popup-buffer (current-buffer)
                         :position 'bottom
                         :noselect t
                         :height (+ (count-lines (point-min) (point-max)) 3))))

(defun smartrep-close-help-buffer ()
  "Close help buffer."
  (when (eq popwin:popup-buffer
            (get-buffer smartrep-help-buffer-name))
    (popwin:close-popup-window)))

(defun smartrep-show-help (char alist)
  (let* ((buf-name smartrep-help-buffer-name)
         (buf-win (get-buffer-window buf-name)))
    (if (and smartrep-show-help buf-win)
        ;; hidden help windows
        (progn
          (smartrep-close-help-buffer)
          (setq smartrep-show-help nil)
          (message "close smartrep help window"))
      ;; show help window
      ;; (smartrep-render-help-buffer char alist)
      (smartrep-prepare-help-buffer char alist)
      (smartrep-popup-help-buffer)
      (setq smartrep-show-help t)
      (message "show smartrep help window"))))

(defun smartrep-prepare-help-buffer (char alist)
  (let ((key-seq smartrep-this-prefix-vector)
        (dsc-buf (current-buffer))
        (hi-regexp guide-key/highlight-command-regexp)
        (max-width 0))
    (unless (equal key-seq smartrep-last-prefix-vector)
      (with-current-buffer (get-buffer-create smartrep-help-buffer-name)
        (unless truncate-lines (setq truncate-lines t)) ; don't fold line
        (when indent-tabs-mode (setq indent-tabs-mode nil)) ; don't use tab as white space
        (erase-buffer)
        (describe-buffer-bindings dsc-buf key-seq)
        (smartrep-format-help-buffer alist key-seq hi-regexp))
      (setq smartrep-last-prefix-vector key-seq))))

(defun smartrep-format-help-buffer (alist key-seq hi-regexp)
  (let ((fkey-list nil)      ; list of (following-key space command)
        (fkey-str-list nil)  ; fontified string of `fkey-list'
        (fkey-list-len 0)    ; length of above lists
        (key-dsc (key-description key-seq)))
    (untabify (point-min) (point-max))  ; replace tab to space
    (goto-char (point-min))
    ;; extract following keys from buffer bindings
    (while (re-search-forward
            (format "^%s \\([^ \t]+\\)\\([ \t]+\\)\\(\\(?:[^ \t\n]+ ?\\)+\\)$" key-dsc) nil t)
      (add-to-list 'fkey-list
                   (list (match-string 1) (match-string 2) (match-string 3)) t))
    (erase-buffer)
    (when (> (setq fkey-list-len (length fkey-list)) 0)
      ;; fontify following keys as string
      (setq fkey-str-list
            (loop for (key space command) in fkey-list
                  when (assoc key alist)
                  collect (guide-key/fontified-string key space command hi-regexp)))
      ;; insert a few following keys per line
      (cond ((popwin:position-horizontal-p guide-key/popup-window-position)
             (guide-key/insert-following-key
              fkey-str-list (1+ (/ (length fkey-str-list) (1- (frame-height))))))
            ((popwin:position-vertical-p guide-key/popup-window-position)
             (guide-key/insert-following-key  ; caluculation of second argument is rough
              fkey-str-list (/ (frame-width)
                               (apply 'max (mapcar 'length fkey-str-list))))))
      (align-regexp (point-min) (point-max) "\\(\\s-*\\) \\[" 1 1 t)
      (goto-char (point-min)))
    fkey-list-len))

;;; --------------------------------------- old help buffer
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

(defun smartrep-scroll-help-buffer (char alist)
  (let* ((keystr (single-key-description char))
         (buf-win (get-buffer-window smartrep-help-buffer-name)))
    (if (and buf-win (member keystr '("{" "}")))
        (with-selected-window buf-win
          (if (string= "}" keystr)
              (scroll-up)
            (scroll-down)))
      (execute-kbd-macro (read-kbd-macro keystr)))))

(provide 'my-smartrep)
;;; my-smartrep.el ends here

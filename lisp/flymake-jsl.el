;;; flymake-jsl.el
;;;
;;; Copyright (C) 2007 Kazu Yamamoto
;;;

;; (add-hook 'javascript-mode-hook
;; 	  (lambda () 
;; 	    (require 'flymake-jsl)
;; 	    (setq flymake-check-was-interrupted t)))


;; (setq flymake-jsl-mode-map 'ecmascript-mode-map)
;; (add-hook 'ecmascript-mode-hook
;; 	  (lambda () 
;; 	    (require 'flymake-jsl)
;; 	    (setq flymake-check-was-interrupted t)))

(require 'flymake)

(defvar flymake-jsl-minor-mode-prefix "\C-cf")

(easy-mmode-defmap flymake-jsl-minor-mode-map
                   '(("p" . flymake-goto-prev-error)
                     ("n" . flymake-goto-next-error)
                     ("c" . flymake-start-syntax-check)
                     ("?" . flymake-display-err-menu-for-current-line))
                   "")

(defvar flymake-jsl-mode-map 'js-mode-map)

(easy-mmode-define-keymap
 `((,flymake-jsl-minor-mode-prefix . ,flymake-jsl-minor-mode-map))
 nil
 (symbol-value flymake-jsl-mode-map))

(defvar flymake-jsl-allowed-file-name-masks
  '(("\\.js$" flymake-jsl-init flymake-simple-cleanup flymake-get-real-file-name)))

(defvar flymake-jsl-err-line-patterns
  '(("^\\(.+\\)(\\([0-9]+\\)): \\(SyntaxError:.+\\)$" 1 2 nil 3)
    ("^\\(.+\\)(\\([0-9]+\\)): \\(.*warning:.+\\)$" 1 2 nil 3)))

(setq flymake-allowed-file-name-masks
      (append flymake-jsl-allowed-file-name-masks flymake-allowed-file-name-masks))

(setq flymake-err-line-patterns
      (append flymake-jsl-err-line-patterns flymake-err-line-patterns))

(defun flymake-jsl-init ()
  (let* ((temp-file (flymake-init-create-temp-buffer-copy
                     'flymake-create-temp-inplace))
         (local-file (file-relative-name
                      temp-file
                      (file-name-directory buffer-file-name))))
    (list "jsl" (list "-process" local-file))))

(provide 'flymake-jsl)
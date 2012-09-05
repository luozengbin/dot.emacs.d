;;; imcap.el: capture images

;;; M-x imcap-capture
;;; M-x imcap-display

;;; var

(defvar imcap-file-name-format "%Y-%m-%d-%H%M%S.jpg")
(defvar imcap-directory nil)  ;; nil means current directory
; (defvar imcap-directory "~/imcap")
(defvar imcap-capture-delay 5)

;;; command

(defun imcap-capture ()
  (interactive)
  (let* ((filename (format-time-string imcap-file-name-format (current-time)))
         (fileloc (imcap-expand-file-name filename))
         (command (format (imcap-capture-command-format) fileloc))
         (paste (format (imcap-paste-format)
                        (if imcap-directory
                            fileloc
                          filename))))
    (imcap-prepare-dir)
    (when (and (file-exists-p fileloc)
               (not (y-or-n-p ("File %s exists. Overwrite? " fileloc))))
      (error))
    (dolist (cmdline (split-string command ";")) 
      (message cmdline)
      (shell-command cmdline))
    (insert paste "\n")
    ;; (imcap-display)
    (message fileloc)))

(defun imcap-display ()
  (interactive)
  (save-excursion
    (goto-char (point-min))
    (let ((buffer-read-only nil)
          (modified-p (buffer-modified-p)))
      (while (imcap-goto-next-image)
        (let* ((region (imcap-image-region))
               (filename (imcap-image-file))
               (fileloc (imcap-expand-file-name filename)))
          (when (file-exists-p fileloc)
            (let ((start (car region))
                  (end (cadr region))
                  (image (cons 'image (cdr (create-image fileloc)))))
              (add-text-properties start end
                                   (list 'display image
                                         'intangible image
                                         'rear-nonsticky (list 'display)))))))
      (set-buffer-modified-p modified-p))))

;;; private

(defun imcap-capture-command-format () "import %s")

(defun imcap-expand-file-name (filename)
  (abbreviate-file-name (expand-file-name filename imcap-directory)))

(defun imcap-goto-next-image ()
  (let ((regexp (format (regexp-quote (imcap-paste-format))
                        "\\(.*\\.\\(jpg\\|png\\|gif\\)\\)")))
    (re-search-forward regexp nil t)))

(defun imcap-image-file ()
  (match-string-no-properties 1))

(defun imcap-image-region ()
  (list (match-beginning 0) (match-end 0)))

(defun imcap-prepare-dir ()
  (let ((image-dir (expand-file-name imcap-directory
                                    default-directory)))
    (when (and imcap-directory
               (not (file-exists-p image-dir)))
      (mkdir image-dir))))

(defun imcap-paste-format ()
  ">>> %s")

;;; provide

(provide 'imcap)

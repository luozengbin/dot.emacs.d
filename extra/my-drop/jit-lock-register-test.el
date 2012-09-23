
(defcustom dired-dispicon-default-display-icon nil
  "*Non-nil forces display icon by default."
  :group 'dired
  :type 'boolean)

(make-variable-buffer-local 'dired-dispicon-display-icon)
(defvar dired-dispicon-display-icon nil)

;; Icon cache.
(defvar dired-dispicon-icon-alist nil)
(defvar dired-dispicon-icon-alist-length 20)
(defvar dired-dispicon-image-cache nil)
(defvar dired-dispicon-image-cache-size 1024)

(defvar dired-dispicon-delay-threshold 250)
(defvar dired-dispicon-delay-process-list nil)
(defvar dired-dispicon-program "GetFileIcon")
(defvar dired-dispicon-size "16")

;; (autoload 'dired-dispicon-setup
;;           "dired-dispicon" "dispicon & dropfile on dired" t)

;; (add-hook 'dired-mode-hook 'dired-dispicon-setup)
;; (setq dired-dispicon-default-display-icon t)

(defun dired-dispicon-toggle (&optional args)
  (interactive)
  (setq dired-dispicon-default-display-icon
        (or args
            (not dired-dispicon-default-display-icon)))
  (if dired-dispicon-default-display-icon
      (add-hook 'dired-mode-hook 'dired-dispicon-setup)
    (remove-hook 'dired-mode-hook 'dired-dispicon-setup))
  (message "Dired default dispicon: %s" (if dired-dispicon-default-display-icon "ON" "off"))
  (dired-dispicon-refresh-all-buffer))

(defun dired-dispicon-refresh-all-buffer ()
  (dolist (buf (buffer-list))
    (with-current-buffer buf
      (when (eq major-mode 'dired-mode)
        (setq dired-dispicon-display-icon dired-dispicon-default-display-icon)
        (if dired-dispicon-display-icon
            (jit-lock-register 'dired-dispicon-fontify-region)
          (jit-lock-unregister 'dired-dispicon-fontify-region))
        (revert-buffer)))))

(defun dired-dispicon-toggle-local (&optional args)
  "Toggle display icons.
If optional ARGS are non-nil, force display icons."
  (interactive "P")
  (when (eq major-mode 'dired-mode)
    (setq dired-dispicon-display-icon (or args
                                          (not dired-dispicon-display-icon)))
    (message "Dired dispicon: %s" (if dired-dispicon-display-icon "ON" "off"))
    (revert-buffer)))

(defun dired-dispicon-setup ()
  "Setup function for `dired-dispicon'."
  (interactive)
  (setq dired-dispicon-display-icon dired-dispicon-default-display-icon)
  (jit-lock-register 'dired-dispicon-fontify-region))

(defun dired-dispicon-icon-alist (dir-path)
  (let ((icon-alist (assoc-default dir-path dired-dispicon-icon-alist))
        file-count)
    (unless icon-alist
      (setq file-count (string-to-int
                        (replace-regexp-in-string
                         "\n" ""
                         (shell-command-to-string
                          (format "ls -al %s | wc -l" dir-path)))))
      (if (> file-count dired-dispicon-delay-threshold)
          ;; fetch folder icon alist by sync process
          (dispicon-delay-get-icon-alist dir-path)
        ;; start process right now
        (setq icon-alist (dired-dispicon-call-process "complex" dir-path))
        (dired-dispicon-icon-alist-add dir-path icon-alist)))
    icon-alist))

(defun dired-dispicon-icon-alist-add (dir-path icon-alist)
  (setq dired-dispicon-icon-alist
        (cons (cons dir-path icon-alist) dired-dispicon-icon-alist))
  (when (> (length dired-dispicon-icon-alist)
           dired-dispicon-icon-alist-length)
    (setcdr (nthcdr (1- dired-dispicon-icon-alist-length)
                    dired-dispicon-icon-alist) nil)))

(defun dispicon-delay-get-icon-alist (dir-path)
  (unless (assoc dir-path dired-dispicon-delay-process-list)
    (setq dired-dispicon-delay-process-list
          (cons (cons dir-path t)
                dired-dispicon-delay-process-list))
    (lexical-let ((dir-path dir-path))
      (deferred:$
        (deferred:process-buffer dired-dispicon-program "complex" dir-path dired-dispicon-size)
        (deferred:nextc it
          (lambda (buf)
            (dired-dispicon-icon-alist-add
             dir-path (dired-dispicon-eval-process-buffer buf))
            (setq dired-dispicon-delay-process-list
                  (delete (assoc dir-path dired-dispicon-delay-process-list)
                          dired-dispicon-delay-process-list))))))))

(defun dired-dispicon-call-process (mode dir-path)
  (let (process-result)
    (condition-case nil
        (with-current-buffer (get-buffer-create " *GetFileIcon*")
          (erase-buffer)
          (call-process dired-dispicon-program nil (current-buffer)
                        nil mode dir-path dired-dispicon-size)
          (setq process-result (dired-dispicon-eval-process-buffer (current-buffer))))
      (error nil))
    process-result))

(defun dired-dispicon-eval-process-buffer (buf)
  (let (process-result)
    (with-current-buffer buf
      (goto-char (point-min))
      (when (search-forward ";; === result alist ===" nil t)
        (save-excursion
          (insert (format "\n(setq %s " (symbol-name 'process-result)))
          (goto-char (point-max))
          (insert ")"))
        (eval-region (match-end 0) (point-max))
        process-result))))

(defun dired-dispicon-image-cache (icon-file)
  (let ((image-str (assoc-default icon-file dired-dispicon-image-cache)))
    (unless image-str
      (setq image-str (propertize
                       " "
                       'display (create-image icon-file nil nil :ascent 90)
                       'invisible t))
      (setq dired-dispicon-image-cache
            (cons (cons icon-file image-str) dired-dispicon-image-cache))
      (when (> (length dired-dispicon-image-cache)
               dired-dispicon-image-cache-size)
        (setcdr (nthcdr (1- dired-dispicon-image-cache-size)
                        dired-dispicon-image-cache) nil)))
    image-str))

(defun dired-dispicon-fontify-region (&optional beg end)
  (when dired-dispicon-display-icon
    (let ((buffer-read-only nil)
          (inhibit-read-only t)
          (after-change-functions nil)
          (inhibit-point-motion-hooks t)
          (icon-alist (dired-dispicon-icon-alist (expand-file-name dired-directory))))
      (save-excursion
        (setq beg (or beg (point-min)))
        (setq end (or end (point-max)))
        (goto-char beg)
        (while (< (point) end)
          ( condition-case nil
              (when (dired-move-to-filename)
                (unless (get-text-property (point) 'dropfile)
                  (let* ((beg (point))
                         (end (save-excursion (dired-move-to-end-of-filename) (point)))
                         (file (buffer-substring beg end))
                         (ovl (make-overlay beg end))
                         (icon-file (car (assoc-default file icon-alist)))
                         (icon-file
                          (if icon-file icon-file
                            (dired-dispicon-call-process
                             "single"
                             (expand-file-name file dired-directory)))))
                    ;; add dropfile propertie on file name
                    (add-text-properties beg end '(dropfile t))
                    (when icon-file
                      (overlay-put ovl
                                   'before-string
                                   (dired-dispicon-image-cache icon-file))
                      (overlay-put ovl 'evaporate t)))))
            (error nil))
          (forward-line 1))
        (set-buffer-modified-p nil)))))

(defun dired-dispicon-icon-alist-clear ()
  (interactive)
  (setq dired-dispicon-icon-alist nil))

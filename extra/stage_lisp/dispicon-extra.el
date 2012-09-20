(setq image
      (create-image
       "D:/ProgramData/download/FileTypeAndIcon/ConsoleApplication1/bin/Debug/0001"
       nil nil :ascent 90
       ))

(let ((filename (dispicon-unix-to-dos-filename (expand-file-name "~/.emacs.d")))
      (output-icon (dispicon-unix-to-dos-filename (expand-file-name (my-cache-dir "dummy-dispicon"))))
      image)
  ;; 同期プロセスでファイルアイコンをゲットする
  (call-process "GetFileIcon" nil nil nil filename output-icon)
  (setq image (create-image output-icon nil nil :ascent 90))
  (insert (propertize " " 'display image 'invisible nil)))

;;; usable image file type
(mapcar (lambda (type) (cons type (image-type-available-p type))) image-types) ; =>

;;; make temp folder
(expand-file-name (user-login-name) (if (fboundp 'temp-directory)
                                        (temp-directory)
                                      (if (boundp 'temporary-file-directory)
                                          temporary-file-directory
                                        "/tmp")))


(defun mew-temp-dir-init ()
  "Setting temporary directory for Mew.
mew-temp-file must be local and readable for the user only
for privacy/speed reasons."
  (setq mew-temp-dir (make-temp-name mew-temp-file-initial))
  (mew-make-directory mew-temp-dir)
  (set-file-modes mew-temp-dir mew-folder-mode)
  (setq mew-temp-file (expand-file-name "mew" mew-temp-dir))
  (add-hook 'kill-emacs-hook 'mew-temp-dir-clean-up))

;;; ------------------ setup for dired mode

(insert (dispicon-local-internal "c:/.rnd"))

(autoload 'dired-dispicon-setup
          "dired-dispicon" "dispicon & dropfile on dired" t)
(add-hook 'dired-mode-hook
	  (lambda ()
	    ;; (define-key dired-mode-map "\C-c\C-d" 'dired-dispicon-toggle)
	    ;; (define-key dired-mode-map "\C-c\C-t" 'dired-dispicon-toggle-type)
	    ;; (define-key dired-mode-map "\C-c\C-v" 'dired-dispicon-do-view-thumbnail)
	    (dired-dispicon-setup)))


(defun make-direx-buffer (data)
  (let* ((root-name (car data))
         (root (make-instance 'direx:directory
                              :name root-name
                              :full-name root-name))
         (root-item (direx:my-make-item root nil)))
    (make-direx-item root-item (car (cdr data)))
    (direx:my-add-root-item-into-buffer root-item (direx:make-buffer root))))

(defun make-direx-item (parent-item data)
  (setf (direx:item-children parent-item)
        (loop for child-data in data
              collect
              (let ((current-item
                     (direx:my-make-item
                      (make-instance 'direx:directory
                                     :name (car child-data)
                                     :full-name (car child-data))
                      parent-item)))
                (if (car (cdr child-data))
                    (make-direx-item current-item (car (cdr child-data))))
                current-item))))


;; (make-instance 'direx:regular-file
;;                :name (file-name-nondirectory filename)
;;                :full-name (direx:canonical-filename filename))

;; (defmethod direx:make-item ((file direx:regular-file) parent)
;;   (let* ((filename (direx:file-full-name file))
;;          (face (when (string-match direx:ignored-files-regexp filename)
;;                  'dired-ignored)))
;;     (make-instance 'direx:regular-file-item
;;                    :tree file
;;                    :parent parent
;;                    :face face
;;                    :keymap direx:file-keymap)))

(defmethod direx:my-make-item ((dir direx:directory) parent)
  (make-instance 'direx:directory-item
                 :tree dir
                 :parent parent
                 :face 'dired-directory
                 :keymap direx:my-direx-map))

(defvar direx:my-direx-map
  (let ((map (make-sparse-keymap)))
    (define-key map (kbd "RET")         'direx:my-maybe-find-item)
    map))

(defun direx:my-maybe-find-item (&optional item)
  (interactive)
  (let* ((item (direx:item-at-point!))
         (file (direx:item-tree item))
         (item-key (direx:file-full-name file)))
    (message "Switch to %s" item-key)
    (other-window 1)
    (mew-summary-visit-folder (concat "%" item-key))
    ))

(defun direx:my-add-root-item-into-buffer (root-item buffer)
  (with-current-buffer buffer
    (save-excursion
      (let ((buffer-read-only nil))
        (goto-char (point-max))
        (setf (direx:item-open root-item) t)
        (direx:item-insert root-item)
        (setq direx:root-item root-item)
        (save-excursion
          (direx:my-expand-children-item root-item)
          (direx:item-change-icon root-item direx:open-icon)))))
  buffer)

(defun direx:my-expand-children-item (parent-item)
  (goto-char (overlay-end (direx:item-overlay parent-item)))
  (dolist (child (direx:item-children parent-item))
    (setf (direx:item-open child) t)
    (direx:item-insert child)
    (direx:my-expand-children-item child)
    ;; (direx:item-change-icon child direx:open-icon)
    (direx:item-toggle child)
    ))

(defun run-my-dired-test ()
  (interactive)
  (let ((data
         '("root"
           (
            ("bin" nil)
            ("sbin" nil)
            ("etc" nil)
            ("usr" (
                    ("share" nil)
                    ("lib" (
                            ("ibus" nil)
                            ("dbus" nil)
                            ("udev" nil)))
                    ("include" nil)))
            ("var" (
                    ("log" nil)
                    ("cache" nil)
                    ("db" nil)
                    ))
            ("run" nil)
            ))))
    (pop-to-buffer (make-direx-buffer data))))

(run-my-dired-test)

(defun make-mew-tree ()
  (interactive)
  (let* ((mew-root (make-instance 'direx:directory
                                  :name "mew"
                                  :full-name "/mew"))
         (mew-root-item (direx:my-make-item mew-root nil))
         (folder-sets
          (loop for (key . value) in (mew-imap-folder-alist)
                ;; (mew-local-folder-alist)
                collect (split-string (substring key 1 (length key)) "/")))
         (folder-items nil))
    (dolist (folder-set folder-sets)
      (let* ((item-key (car folder-set))
             (item-key-1 (car (cdr folder-set)))
             (current-item (assoc item-key folder-items))
             (child-item nil)
             (child-item-list nil))
        (if current-item
            (when item-key-1
              (setq current-item (cdr current-item))
              (setq child-item
                    (direx:my-make-item
                     (make-instance 'direx:directory
                                    :name item-key-1
                                    :full-name (concat item-key "/" item-key-1)
                                    ;; (concat "%" item-key "/" item-key-1)
                                    )
                     current-item))
              (setq child-item-list (cons child-item (direx:item-children current-item)))
              (setf (direx:item-children current-item) child-item-list))
          ;; else
          (setq current-item
                (direx:my-make-item
                 (make-instance 'direx:directory
                                :name item-key
                                :full-name item-key ;; (concat "/mew/" item-key)
                                ;;
                                )
                 mew-root-item))
          (setq folder-items (cons (cons item-key current-item) folder-items)))
        ))
    (setf (direx:item-children mew-root-item)
          (loop for (key . value) in folder-items
                collect value))
    (pop-to-buffer (direx:my-add-root-item-into-buffer mew-root-item (direx:make-buffer mew-root)))
    ))


;; (defun direx:item-render-icon-part (item)
;;   (if (direx:item-leaf-p item)
;;       direx:leaf-icon
;;     (if (direx:item-open item)
;;         direx:open-icon
;;       direx:closed-icon)))

;; (defun direx:item-show-children (item)
;;   (unless (direx:item-leaf-p item)
;;     (if (direx:item-open item)
;;         (dolist (child (direx:item-children item))
;;           (direx:item-show child)
;;           (direx:item-show-children child)))))

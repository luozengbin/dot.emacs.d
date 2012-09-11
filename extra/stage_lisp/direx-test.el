(defun direx:my-add-root-item-into-buffer (root-item buffer)
  (with-current-buffer buffer
    (save-excursion
      (let ((buffer-read-only nil))
        (goto-char (point-max))
        (setf (direx:item-open root-item) t)
        (direx:item-insert root-item)
        (setq direx:root-item root-item)
        (save-excursion
          (direx:my-expand-children-item root-item))))))

(defun direx:item-render-icon-part (item)
  (if (direx:item-leaf-p item)
      direx:leaf-icon
    (if (direx:item-open item)
        direx:open-icon
      direx:closed-icon)))

(defun direx:my-expand-children-item (parent-item)
  (goto-char (overlay-end (direx:item-overlay parent-item)))
  (dolist (child (direx:item-children parent-item))
    (setf (direx:item-open child) t)
    (direx:item-insert child)
    (direx:my-expand-children-item child)))


(defun direx:item-show-children (item)
  (unless (direx:item-leaf-p item)
    (if (direx:item-open item)
        (dolist (child (direx:item-children item))
          (direx:item-show child)
          (direx:item-show-children child)))))

;; (setq my-root (make-instance 'direx:directory
;;                                   :name "project"
;;                                   :full-name "/mew/project"))

;; (setq my-root-item (direx:make-item my-root nil))      

;; (setq my-c1 (make-instance 'direx:directory
;;                                 :name "mmc"
;;                                 :full-name "/mew/project/mmc"))

;; (setq my-c1-item (direx:make-item my-c1 my-root-item))

;; (setq my-c2 (make-instance 'direx:directory
;;                                 :name "zbs"
;;                                 :full-name "/mew/project/zbs"))

;; (setq my-c2-item (direx:make-item my-c2 my-root-item))



;; (setq my-sub1 (make-instance 'direx:directory
;;                                 :name "q001"
;;                                 :full-name "/mew/project/zbs/q001"))

;; (setq my-sub1-item (direx:make-item my-sub1 my-c2-item))

;; (setq my-sub2 (make-instance 'direx:directory
;;                                   :name "q002"
;;                                   :full-name "/mew/project/zbs/q002"))

;; (setq my-sub2-item (direx:make-item my-sub2 my-c2-item))

;; (setq my-c2-children (list my-sub1-item my-sub2-item))
;; (setf (direx:item-children my-c2-item) my-c2-children)

;; (setq my-root-children (list my-c1-item my-c2-item))
;; (setf (direx:item-children my-root-item) my-root-children)

;; (setq my-root-item (direx:my-add-root-item-into-buffer my-root-item (direx:make-buffer my-root))) ; => nil


(let* ((mew-root (make-instance 'direx:directory
                                :name "mew"
                                :full-name "/mew"))
       (mew-root-item (direx:make-item mew-root nil))
       (folder-sets
        (loop for (key . value) in (mew-local-folder-alist)
              collect (split-string (substring key 1 (string-width key)) "/")))
       (folder-items nil))
  folder-sets
  (dolist (folder-set folder-sets)
    (let* ((item-key (car folder-set))
           (item-key-1 (car (cdr folder-set)))
           (current-item (assoc item-key folder-items))
           (child-item nil)
           (child-item-list nil)
           )
      item-key
      current-item
      (if current-item
          (when item-key-1
            item-key-1 ; =>
            (setq current-item (cdr current-item))
            (setq child-item
                  (direx:make-item
                   (make-instance 'direx:directory
                                  :name item-key-1
                                  :full-name (concat "/mew/" item-key "/" item-key-1))
                   current-item))
            (setq child-item-list (cons child-item (direx:item-children current-item)))
            (setf (direx:item-children current-item) child-item-list))
        ;; else
        (setq current-item
              (direx:make-item
               (make-instance 'direx:directory
                              :name item-key
                              :full-name (concat "/mew/" item-key))
               mew-root-item))
        (setq folder-items (cons (cons item-key current-item) folder-items)))
      ))
  folder-items ; =>
  (setf (direx:item-children mew-root-item)
        (loop for (key . value) in folder-items
              collect value))
  (direx:my-add-root-item-into-buffer mew-root-item (direx:make-buffer mew-root)))



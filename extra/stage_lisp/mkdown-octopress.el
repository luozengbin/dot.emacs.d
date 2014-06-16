(mkdown-jekyll-property
 '(:date
   :jekyll-categories
   :title
   :jekyll-published
   :input-file)
 "/home/akira/.emacs.d/blogs/octopress/source/_posts/2014-06-16-title0001.markdown"
 )

(defun mkdown-jekyll-property (keys &optional filename)
  (let
      ((plist (mkdown-jekyll-property-list filename))
       )
    (mapcar (lambda (key) (org-export-data-with-backend (plist-get plist key) 'jekyll plist))
            keys)))

(defun mkdown-jekyll-property-list (filename)
  (with-temp-buffer
    (insert-file-contents filename)
    (goto-char (point-min))
    (when (re-search-forward "layout: \\(.+\\)\ntitle: \"\\(.+\\)\"\ndate: \\([^ ]+\\).+\n.+\ncategories: \\(.+\\)"  nil t)
      (let* ((layout (buffer-substring-no-properties (match-beginning 1) (match-end 1)))
             (title (buffer-substring-no-properties (match-beginning 2) (match-end 2)))
             (date (buffer-substring-no-properties (match-beginning 3) (match-end 3)))
             (categories (buffer-substring-no-properties (match-beginning 4) (match-end 4)))
             (org-temp-str "#+TITLE: %s
#+DATE: %s
#+JEKYLL_LAYOUT: %s
#+JEKYLL_CATEGORIES: %s
#+JEKYLL_PUBLISHED: true
")
             (backend 'jekyll)
             plist)
        (with-temp-buffer
          (insert-string  (format org-temp-str title date layout categories))
          (message (buffer-string))
          (org-mode)
          (setq plist (org-export-get-environment backend))
          (setq plist (plist-put plist :input-file filename))
          plist)))))


;;; ----------------------------------------------------

(defun org-octopress--scan-post ()
  (mapcar
   (lambda (filename)
     (org-jekyll-property
      '(:date
        :jekyll-categories
        :title
        :jekyll-published
        :input-file)
      filename))
   (directory-files
    (expand-file-name
     org-octopress-directory-org-posts) t "^[0-9].*\\.org$")))

(org-jekyll-property
 '(:date
   :jekyll-categories
   :title
   :jekyll-published
   :input-file)
 "/home/akira/.emacs.d/blogs/octopress/source/blog/2014-06-12-java-mission-controlメモ.org"
 )

(defun org-jekyll-property (keys &optional filename)
  (let
      ((plist (org-jekyll-property-list filename))
       )
    (mapcar (lambda (key) (org-export-data-with-backend (plist-get plist key) 'jekyll plist))
            keys)))

(defun org-jekyll-property-list (&optional filename)
  (let ((backend 'jekyll) plist)
    (if filename
        (with-temp-buffer
          (insert-file-contents filename)
          (org-mode)
          (setq plist (org-export-get-environment backend))
          (setq plist (plist-put plist :input-file filename)))
      (setq plist (org-export-backend-options backend))
      plist)))

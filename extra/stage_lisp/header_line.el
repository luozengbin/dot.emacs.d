(defvar header-rin:new-products nil)

(defvar header-rin:url
  "http://www.dmm.co.jp/mono/dvd/-/list/=/article=actress/id=23447/sort=date/rss=create/")

(defun header-rin:get-new-products ()
  (let ((lst nil))
    (with-temp-buffer
      (call-process "wget" nil t t "-q" "-O-" header-rin:url)
      (goto-char (point-min))
      (while (re-search-forward "^<title>\\([^<]+\\)</title>" nil t)
        (push (buffer-substring-no-properties (match-beginning 1)
                                              (match-end 1))
              lst)))
    ;; remove RSS title
    (cddr (reverse lst))))

(defface header-rin:face
  '((t (:background "white" :foreground "blue"
                    :weight extra-bold :height 1.5)))
  "header face")

(defun header-rin ()
  (interactive)
  (setq header-rin:new-products (header-rin:get-new-products))
  (header-rin:update))

(defun header-rin:update ()
  (let ((str (pop header-rin:new-products)))
    (setq header-line-format (and str (propertize str 'face 'header-rin:face)))
    (redraw-display)
    (if str
        (run-at-time 2 nil 'header-rin:update))))



(defun sugachan-atom (url charset)
  (lexical-let ((char-set charset))
  ;;; HTML取得
    (deferred:$
      (deferred:url-retrieve url) ;HTML取得
      (deferred:nextc it
        (lambda (buf)                       ;HTMLバッファーの表示
          (with-current-buffer buf
            (goto-char (point-min))
            (decode-coding-region (point-min) (point-max) char-set)
            (set-buffer-multibyte t))
          (sugachan-render-new-entrys buf)
          (kill-buffer buf))))))

(defun sugachan-render-new-entrys (buf)
  (let ((entry-match-reg "<a href=\"\\(.+[.]html\\)\"[ ]+title=\"?\\(.+?\\)\">\\(.+\\)</a>.+\(\\([0-9|/]+\\))")
        (entry-template (with-temp-buffer
                          (insert-file-contents "~/.emacs.d/extra/rss/koushin_entry.xml")
                          (buffer-string)))
        (entry-buffer (with-current-buffer (get-buffer-create "*entry*")
                        (erase-buffer)
                        (current-buffer))))
    (with-current-buffer buf
      (goto-char (point-min))
      (while (re-search-forward entry-match-reg nil t)
        (let ((url (match-string 1))
              (header (match-string 2))
              (title (match-string 3))
              (update-date (match-string 4)))
          (with-current-buffer entry-buffer
            (insert (format entry-template
                            title
                            url
                            (sugachan-parse-time-string update-date)
                            url
                            header))))))
    (with-current-buffer entry-buffer
      (unless (string= (buffer-string)
                       (with-temp-buffer
                         (insert-file-contents "~/.emacs.d/extra/rss/koushin_entrys")
                         (buffer-string)))
        (write-region (point-min) (point-max) "~/.emacs.d/extra/rss/koushin_entrys" nil)
        (with-temp-buffer
          (insert (format (with-temp-buffer
                            (insert-file-contents "~/.emacs.d/extra/rss/koushin_template.xml")
                            (buffer-string))
                          (concat
                           (format-time-string "%Y-%m-%dT%T")
                           ((lambda (x) (concat (substring x 0 3) ":" (substring x 3 5)))
                            (format-time-string "%z")))
                          (with-current-buffer entry-buffer
                            (buffer-string))))
          (write-region (point-min) (point-max) "~/.emacs.d/extra/rss/koushin.xml" nil))
        (message "koushin rss updated!!!")))))

(defun sugachan-parse-time-string (date-str)
  (with-temp-buffer
    (insert date-str)
    (goto-char (point-min))
    (re-search-forward "\\([0-9]+\\)/\\([0-9]+\\)/\\([0-9]+\\)")
    (format "%s-%s-%s"
            (match-string 1)
            (if (= 1 (length (match-string 2)))
                (concat "0" (match-string 2))
              (match-string 2))
            (if (= 1 (length (match-string 3)))
                (concat "0" (match-string 3))
              (match-string 3)))))

(sugachan-atom "http://www.geocities.jp/sugachan1973/koushin.html" 'euc-jp)

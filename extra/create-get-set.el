(defun create-bean-comment ()
  (interactive)
  (let ((get-comment-template "/**
 * %sを取得します。
 *
 * @return %s
 */
public %s get%s() {
  return %s;
}
" )
        (set-comment-template "/**
 * %sを設定します。
 *
 * @param %s %s
 */
public void set%s(%s %s) {
  this.%s = %s;
}
") (result-buffer (get-buffer-create "*comment-result*"))
        field-type field-name field-comment)
    (with-current-buffer result-buffer (erase-buffer))
    (with-current-buffer (current-buffer)
      (goto-char (point-min))
      (while (re-search-forward ".+/[*][*][ ]*\\([^ ]+\\)[ ]*[*]/.*\n.+\\(private\\|public\\|protected\\)[ ]+\\([^ ]+\\)[ ]+\\([^;]+\\);" nil t)
        (setq field-comment (match-string 1))
        (setq field-type (match-string 3))
        (setq field-name (match-string 4))
        (with-current-buffer result-buffer
          (insert (format get-comment-template
                          field-comment field-comment
                          field-type
                          (upcase-initials field-name) field-name))
          (insert "\n")
          (insert (format set-comment-template field-comment field-name
                          field-comment
                          (upcase-initials field-name)
                          field-type
                          field-name
                          field-name
                          field-name
                          ))
          (insert "\n"))
        ))
    (pop-to-buffer result-buffer)))

;; (create-bean-comment)

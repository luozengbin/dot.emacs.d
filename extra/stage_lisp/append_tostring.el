;;; emacs --script append_tostring.el ~/test.java
(defun append_tostring (java-file)
  "toString関数を自動付ける処理"
  (interactive)
  (find-file java-file)
  (unless (search-forward "import " nil t)
    (search-forward "package " nil t))
  (end-of-line)
  (insert "\nimport org.apache.commons.lang3.builder;")
  (goto-char (point-max))
  (when (search-backward "}" nil t)
    (beginning-of-line)
    (insert "
    /**
     * Returns a string representation of the object.
     *
     * @return a string representation of the object.
     */
     public String toString() {
        return ToStringBuilder.reflectionToString(this);
    }
\n"))
  (save-buffer)
  ;; (princ (buffer-string))
  )

(append_tostring (nth 0 command-line-args-left))

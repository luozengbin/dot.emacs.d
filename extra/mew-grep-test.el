(defun mew-summary-pick (&optional regionp)
  "Pick messages according to a specified pick pattern.
Then put the '*' mark onto them. 'mewl' or 'grep' is called as a
picking command. If called with '\\[universal-argument]', the
target is the region."
  (interactive "P")
  (mew-pickable
   (mew-summary-with-mewl
    (let* ((folder (mew-summary-physical-folder))
	   (msgs (mew-summary-pick-msgs folder regionp))
	   (prompt (format "%s/%s pick" mew-prog-mewl mew-prog-grep))
	   (prog mew-prog-grep)
	   (opts mew-prog-grep-opts)
	   mew-inherit-pick-mewlp
	   grepp pattern prog-opts-pat)
      (if (not msgs)
	  (message "No message")
	(setq pattern (mew-input-pick-pattern prompt))
    (with-output-to-temp-buffer "*pattern*"
      (print pattern))
	(cond
	 ((string= pattern "")
      (message "aaaa")
	  (setq prog-opts-pat (mew-input-pick-command prog opts))
	  (mew-set '(prog opts pattern) prog-opts-pat)
	  (setq grepp t))
	 (t
      (message "bbbb")
	  (setq pattern (mew-pick-canonicalize-pattern pattern))
	  (unless mew-inherit-pick-mewlp (setq grepp t))))
	(if (and grepp (not (mew-which-exec prog)))
	    (message "'%s' not found" prog)
	  (cond
	   (grepp
        (message "xxxxx")
	    (mew-sinfo-set-find-key pattern)
	    (message "Picking messages in %s..." folder)
	    (setq msgs (mew-summary-pick-with-grep prog opts pattern folder msgs))
        (print msgs)
	    (message "Picking messages in %s...done" folder))
	   (t
        (message "yyyy")
	    (mew-sinfo-set-find-key nil) ;; force to ask a user
	    (message "Picking messages in %s..." folder)
	    (setq msgs (mew-summary-pick-with-mewl pattern folder msgs))
        (print msgs)
	    (message "Picking messages in %s...done" folder)))
	  (mew-summary-pick-ls folder msgs)))))))

(defun mew-summary-pick-with-grep (prog opts pattern folder src-msgs)
  "A function to pick messages matching PATTERN."
  (let* ((dir (mew-expand-folder folder))
         (default-directory dir) ;; buffer local
         msgs nxt)
    ;; no sort here
    (if (= (length src-msgs) 1) (setq src-msgs (cons null-device src-msgs)))
    (if pattern (setq pattern (mew-cs-encode-arg pattern)))
    (print pattern)
    (with-temp-buffer
      (mew-set-buffer-multibyte t)
      (cd dir)
      (print dir)
      (mew-piolet mew-cs-text-for-read mew-cs-text-for-write
        (while src-msgs
          (goto-char (point-max))
          (setq nxt (nthcdr mew-prog-grep-max-msgs src-msgs))
          (if nxt (mew-ntake mew-prog-grep-max-msgs src-msgs))

          (print "--------")

          (print prog)
          (print opts)
          (print (and pattern (list pattern)))
          (print src-msgs)
          (print "--------")
          ;; (apply 'call-process prog nil t nil
          ;;        (append opts (and pattern (list pattern)) src-msgs))
          ;;(call-process "lgrep" nil t nil "-n" "-Ou" "-Ia" "あきら" "*.mew")
          (cd "c:/Documents and Settings/113430A0001VM.NSL/Application Data/Mail/inbox")
          (call-process "lgrep" nil t nil "-n" "-Ou" "-Ia" "z-ro" "*.mew")

          (print (buffer-string))
          (setq src-msgs nxt)))
      (goto-char (point-min))
      (while (re-search-forward mew-regex-message-files2 nil t)
        (setq msgs (cons (mew-match-string 1) msgs))
        (forward-line)))
    (setq msgs (mew-uniq-list msgs))
    (setq msgs (mapcar 'string-to-number msgs))
    (setq msgs (sort msgs '<))
    (mapcar 'number-to-string msgs)))

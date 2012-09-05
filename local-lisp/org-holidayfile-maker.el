(require 'japanese-holidays)
(setq holiday-org-dir "~/.emacs.d/myfiles/"
      calendar-holidays (append japanese-holidays local-holidays other-holidays))
(loop for year from 2009 to 2037 do
      (let ((calendar-date-display-form '((format "<%4s-%02d-%02d >" year
                                                  (string-to-int month)
                                                  (string-to-int day)))))
        (save-window-excursion
          (save-excursion
            (list-holidays year year)
            (set-buffer "*Holidays*")
            (setq buffer-read-only nil)
            (goto-char 1)
            (insert "* 祝日\n")
            (while (not (eobp))
              (when (search-forward ": " nil t)
                (let ((date (buffer-substring (point-at-bol) (match-beginning 0)))
                      (holiday (buffer-substring (match-end 0) (point-at-eol))))
                  (delete-region (point-at-bol) (point-at-eol))
                  (insert "** " holiday "\n  CLOSED: " date "\n"))))
            (write-region 1 (point-max) (format "%sholidays.%s.org"
                                                holiday-org-dir year))))))
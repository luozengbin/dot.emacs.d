(cond
 (mac-p
  ;; Mac OS X の HFS+ ファイルフォーマットではファイル名は NFD (の様な物)で扱う
  ;; 以下はファイル名を NFC で扱う環境と共同作業等する場合の対処
  (require 'ucs-normalize)
  (setq file-name-coding-system 'utf-8-hfs)
  (setq locale-coding-system 'utf-8-hfs))
 (windows-p
  (setq file-name-coding-system 'cp932)
  (setq locale-coding-system 'cp932)
  ;; (set-selection-coding-system 'utf-16le-dos)
  )
 (t
  (setq file-name-coding-system 'utf-8)
  (setq locale-coding-system 'utf-8))
 )

(provide 'init_global_ext)
;;; init_global_ext.el ends here

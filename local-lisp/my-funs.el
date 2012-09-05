;;=======================================================================
;; カスタマイズ関数の定義
;;=======================================================================

;; 時間文字列を獲得関数の制定
(defun insert-date ()
  "Insert date at point."
  (interactive)
  (insert (format-time-string "%Y年%m月%e日 %l:%M %a %p")))

;; orgモードにて読み取りのみの時間を生成する
(defun insert-org-readonly-datetime ()
  "get readonly org timestamp."
  (interactive)
  (format-time-string "[%Y-%m-%e %a %H:%M]"))

;; shellモードの切替
(defun bash-mode()
  (interactive)
  (progn 
   (setq shell-file-name "sh")
  )
)
(defun dos-mode()
  (interactive)
  (progn 
    (setq shell-file-name "cmdproxy.exe")
    )
  )

;; タイトルなしのバッファーを作成する
(global-set-key (kbd "C-x n") 'create-new-untitled-buffer)
(defun create-new-untitled-buffer ()
  ;; "タイトルなしのバッファーを作成する"
  (interactive)
  (progn 
    (let (buf))
    ;; (setq buf (get-buffer-create  "untitled"))
    (setq buf (generate-new-buffer  "untitled")) ;複数無名バッファーを作成できるように修正する
    (with-current-buffer buf (select-window(display-buffer buf))) 
    (with-current-buffer buf (text-mode))
    )
  )

;; ポインター位置のurlをw3mテキストブラウザで開く
(defun my-w3m-browse-url-at-point ()
  "ポインター位置のurlをw3mテキストブラウザで開く"
  (interactive)
  (let ((target-url (thing-at-point 'url)))
    (if (eq target-url nil)
        (message "the url that you point is null")
      (other-window 1)
      (w3m-goto-url target-url)
      ))
  )

;; do google it
(defun google-it ()
  "Googles a query or region if any."
  (interactive)
  (browse-url
   (concat
    "http://www.google.com/search?ie=utf-8&oe=utf-8&q="
    (if mark-active
        (buffer-substring (region-beginning) (region-end))
      (read-string "Google: ")))))

;; simple logging function
(defun my-logging (buffername content &optional do-clear)
  "simple logging function"
  (interactive)
  (save-excursion
    (save-restriction
      (get-buffer-create buffername)
      (set-buffer buffername)
      (if do-clear
          (erase-buffer))
      (goto-char (point-max))
      (insert (concat content "\n"))
      )))

(provide 'my-funs)

;;; Commentary:

;; microsoft windows os 向けの機能関数

;;; Code:

;;
;; ウィンドウズを最大化、元のサイズに戻すスイッチ
;;
;; -- windows 操作するコマンド番号
;; 61440 - resize the window via keyboard
;; 61456 - move window via keyboard
;; 61472 - minimize current frame
;; 61488 - maximize current frame
;; 61504 - next window (not very practical)
;; 61520 - previous window (not very practical)
;; 61536 - close the window (this will quit the application)
;; 61552 - vertical scroll – doesn’t seem to do anything for me
;; 61568 - horizontal scroll – doesn’t seem to do anything for me
;; 61584 - mouse menu(?) – doesn’t seem to do anything for me
;; 61696 - activate menubar (will not de-activate it, though)
;; 61712 - arrange(?) – doesn’t seem to do anything for me
;; 61728 - restore current frame
;; 61744 - simulate pressing Windows Start button
;; 61760 - activate screensaver
;; 61776 - hotkey(?) – doesn’t seem to do anything for me
(setq my-last-w32-toggle-fullscreen-command 61488)
(defun w32-toggle-fullscreen ()
  " Maximize or restore size frame on winodws"
  (interactive)
  (w32-send-sys-command my-last-w32-toggle-fullscreen-command)
  (if (eq my-last-w32-toggle-fullscreen-command 61488)
      (setq my-last-w32-toggle-fullscreen-command 61728)
      (setq my-last-w32-toggle-fullscreen-command 61488)))

;;; for linux
(defun x-toggle-fullscreen ()
  (interactive)
  (x-send-client-message nil 0 nil "_NET_WM_STATE" 32
                         '(2 "_NET_WM_STATE_FULLSCREEN" 0)))

(defun x-wmctrl-full-screen ()
  (interactive)
  (shell-command (concat "wmctrl -i -r " (frame-parameter nil 'outer-window-id)
                         " -btoggle,maximized_vert,maximized_horz")))

(defun x-toggle-maximize (&optional f)
  (interactive)
  (x-send-client-message nil 0 nil "_NET_WM_STATE" 32
                         '(2 "_NET_WM_STATE_MAXIMIZED_VERT" 0))
  (x-send-client-message nil 0 nil "_NET_WM_STATE" 32
                         '(2 "_NET_WM_STATE_MAXIMIZED_HORZ" 0)))

;;
;; OSがXPなのか調べる関数
;;
;;
(defun is-windows-xp ()
  "are you using windows XP?"
  (interactive)
  (let ((ver-result (shell-command-to-string "ver")))
    (string-match "XP" ver-result)
  ))

;;
;; get windows version number
;;
;; http://msdn.microsoft.com/en-us/library/windows/desktop/ms724832(v=vs.85).aspx
;;
;; | Operating system          | Version number |
;; |---------------------------+----------------|
;; | Windows 7                 |            6.1 |
;; | Windows Server 2008 R2    |            6.1 |
;; | Windows Server 2008       |            6.0 |
;; | Windows Vista             |            6.0 |
;; | Windows Server 2003 R2    |            5.2 |
;; | Windows Server 2003       |            5.2 |
;; | Windows XP 64-Bit Edition |            5.2 |
;; | Windows XP                |            5.1 |
;; | Windows 2000              |            5.0 |
(defun my-get-windows-version ()
  "get version number of microsoft windows [nt5.1, nt6.0 etc]"
  (interactive)
  (string-match "nt[1-9]" system-configuration)
  (substring system-configuration (match-beginning 0))
)


(provide 'my-windows-os)
;;; my-windows-os.el ends here

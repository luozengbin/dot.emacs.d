;;; Commentary:

;; window 表示の初期設定

;;; Code:
(require 'smartrep)

(message "init_window ...")

(require 'my-windows-os)
(require 'my-window)

;;
;; macのFinderから新しいファイルを開いた時にemacsを複数起動させない
;;______________________________________________________________________
(when ns-p
  (setq ns-pop-up-frames nil))

;;
;; win:resume-windows --> windows 状態保存と復元
;;______________________________________________________________________

;;; install
;; http://www.emacswiki.org/emacs/WindowsMode
;; http://www.gentei.org/~yuuji/software/
;; (install-elisp "http://www.gentei.org/~yuuji/software/windows.el")
;; (install-elisp "http://www.gentei.org/~yuuji/software/revive.el")

;;; windows.el の設定
;; 分割されたウィンドウを切り替えることができる．さらに，分割形態を保存することもできる．
(setq win:switch-prefix "\C-z")
;; resume file のパス名
(setq win:configuration-file (concat my-cache-dir ".windows"))
(require 'windows)
;; 新規にフレームを作らない
(setq win:use-frame nil)
(win:startup-with-window)
(define-key ctl-x-map "C" 'see-you-again)

;; 起動時状態を復元する
(add-hook 'after-init-hook (lambda() (run-with-idle-timer 0 nil 'my-resume-windows)))
(defun my-resume-windows ()
  "restore windows status ."
  (interactive)
   (resume-windows t)
   (clear-active-region-all-buffers))

;; 終了時状態を保存する
(add-hook 'kill-emacs-hook 'win-save-all-configurations)

;; 「M-数字」でwindowを切り替えるように変更する
(eval-when-compile (require 'cl))
(loop for i from 1 to 9 do
      (define-key esc-map (number-to-string i) 'win-switch-smartrep-map))

;; define smartrep-map for win witch call
(defvar win-switch-smartrep-map (loop for i from 1 to 9 collect
                                      (cons (number-to-string i)
                                            `(quote (lambda ()
                                                      (win-switch-to-window 0 ,i))))))
;; append [t] key strock for open anything buffer
(add-to-list 'win-switch-smartrep-map '("t" . 'my-anything))

(defun win-switch-smartrep-map ()
  (interactive)
  (switch-smartrep-map-append 'win-switch-to-window win-switch-smartrep-map))

;;
;; windowsの最大化
;;______________________________________________________________________
(defun my-toggle-fullscreen()
  "fullscreen/restore framesize"
  (interactive)
  (setq my-toggle-fullscreen-command (cond (windows-p 'w32-toggle-fullscreen)
                                        ((fboundp 'ns-toggle-fullscreen) 'ns-toggle-fullscreen)
                                        (t 'x-wmctrl-full-screen)))
  (call-interactively my-toggle-fullscreen-command)
  (message "toggle-fullscreen"))
(add-hook 'after-init-hook (lambda() (run-with-idle-timer 0 nil 'my-toggle-fullscreen)))
(global-set-key (kbd "<C-f11>") 'my-toggle-fullscreen)


;;
;; winner mode setting
;;______________________________________________________________________
;; windowの分割状態のundo, redoを有効化する 【Ctrl+c ←】 and 【Ctrl+c →】
(when (fboundp 'winner-mode) (winner-mode 1))

;;
;; windowsサイズ調整拡張
;;______________________________________________________________________
;; 参考：http://www.cnblogs.com/bamanzi/archive/2011/08/20/some-emacs-window-utils.html
;; (auto-install-from-url "http://www.cognition.ens.fr/~guerry/u/windresize.el")
;; (auto-install-from-url "http://www.emacswiki.org/emacs/download/windresize-extension.el")
(require 'windresize-extension)

;;
;; キーバンディング
;;______________________________________________________________________
(define-key global-map (kbd "C-z w") 'windresize)
(smartrep-define-key
    global-map "C-z" '(
                       ;; windows大きさの調整
                       ("C-+"             . 'outward-window)
                       ("C--"             . 'inward-window)
                       ("<C-kp-add>"      . 'outward-window)
                       ("<C-kp-subtract>" . 'inward-window)
                       ;; windows構成のundoとredo
                       ("<C-left>"        . 'winner-undo)
                       ("<C-right>"       . 'winner-redo)
                       ;; windows間移動
                       ("<M-left>"        . 'win-prev-window)
                       ("<M-right>"       . 'win-next-window)))

;; 以前の設定
;; (define-key global-map (kbd "C-z C-+") 'outward-window)
;; (define-key global-map (kbd "C-z C--") 'inward-window)

;;
;; popwin setteing
;; document--> (find-file "~/.emacs.d/lisp/popwin-el/README.markdown")
;;______________________________________________________________________
;; ヘルプバッファや補完バッファをポップアップで表示する
;; auto-install
;; git clone https://github.com/m2ym/popwin-el.git
;; last-update-date: 2012/03/07
(require 'popwin)
(setq display-buffer-function 'popwin:display-buffer)
;; (setq special-display-function 'popwin:special-display-popup-window)
;; popwin対象の設定
(setq popwin:special-display-config '(("*Help*")
                                      ("*Completions*" :noselect t)
                                      ("*compilation*" :noselect t)
                                      ;; ("*Occur*" :noselect t)
                                      ("*VC-log*")
                                      ("*Process List*")
                                      ;; ("*svn-info*")
                                      ))

;; keyマップのprefixキーの定義
;;| Key    | Command                    |
;;|--------+----------------------------|
;;| b, C-b | popwin:popup-buffer        |
;;| M-b    | popwin:popup-buffer-tail   |
;;| o, C-o | popwin:display-buffer      |
;;| p, C-p | popwin:display-last-buffer |
;;| f, C-f | popwin:find-file           |
;;| M-f    | popwin:find-file-tail      |
;;| s, C-s | popwin:select-popup-window |
;;| M-s    | popwin:stick-popup-window  |
;;| 0      | popwin:close-popup-window  |
;;| m, C-m | popwin:messages            |
(global-set-key (kbd "C-x p") popwin:keymap)


;;
;; key binding of windows function
;;______________________________________________________________________
;; window移動
(smartrep-define-key
    global-map "C-x" '(
                       ("<C-down>"   . 'windmove-down)
                       ("<C-up>"     . 'windmove-up)
                       ("<C-left>"   . 'windmove-left)
                       ("<C-right>"  . 'windmove-right)
                       ("<C-return>" . 'golden-ratio)
                       ))
;; 従来のやりかた
;; ウィンドウ移動
(global-set-key (kbd "C-x <down>")  'windmove-down)
(global-set-key (kbd "C-x <up>")    'windmove-up)
(global-set-key (kbd "C-x <left>")  'windmove-left)
(global-set-key (kbd "C-x <right>") 'windmove-right)
(global-set-key (kbd "C-x <C-return>") 'golden-ratio)

(global-set-key (kbd "C-x 4 4")  'split-window-4)
(global-set-key (kbd "C-x 4 3")  'split-window-3)
(global-set-key (kbd "C-x 4 c")  (quote change-split-type-3))
(global-set-key (kbd "C-x 4 r")  (quote roll-v-3))

;;; windmoveにより切り替え時にハイライトする
(defadvice windmove-do-window-select (after after-windmove-do-window-select-hl activate)
  (my-hl-current-window 0.3))

(provide 'init_window)
;;; init_window.el ends here

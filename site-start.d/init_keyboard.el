;;; Commentary:

;; keyboard & mouse 設定

;;; Code:

(message "init_keyboard ...")

;;
;; 一部のキーをwindowsに取れないようにする
;;______________________________________________________________________
;; (when (fboundp 'w32-register-hot-key) (w32-register-hot-key [M-tab]))

;;
;; MacOSXキーボードの設定
;;______________________________________________________________________

(when mac-p
  ;; macのmeta keyをcommandにする
  (setq ns-command-modifier (quote meta))
  (setq ns-alternate-modifier (quote super))

  ;; dndの動作を Emacs22と同じにする
  (define-key global-map [ns-drag-file] 'ns-find-file))

;;
;; マウス右クリックのカスタマイズ
;;______________________________________________________________________
(if window-system (progn
                    ;; 右ボタンの割り当て(押しながらの操作)をはずす。
                    (global-unset-key [down-mouse-3])

                    ;; マウスの右クリックメニューを出す(押して、離したときにだけメニューが出る)
                    (defun bingalls-edit-menu (event)
                      (interactive "e")
                      (popup-menu menu-bar-edit-menu))
                    (global-set-key [mouse-3] 'bingalls-edit-menu)
                    ))

;; Ctrlとマースの組み合わせでフォントのZoom In&Out
;; For Linux
(global-set-key (kbd "<C-mouse-4>") 'text-scale-increase)
(global-set-key (kbd "<C-mouse-5>") 'text-scale-decrease)
;; For Windows
(global-set-key (kbd "<C-wheel-up>") 'text-scale-increase)
(global-set-key (kbd "<C-wheel-down>") 'text-scale-decrease)

(provide 'init_keyboard)
;;; init_keyboard.el ends here

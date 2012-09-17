;;; Commentary:

;; カーソル動きの制、表示スタイルの設定

;;; Code:

(message "init_point ...")

;;
;; common setting
;;______________________________________________________________________
;; カーソル点滅表示
(blink-cursor-mode 0)

;; 非アクティブウィンドウのカーソルを非表示
(setq default-cursor-in-non-selected-windows nil)

;; スクロール時のカーソル位置の維持
(setq scroll-preserve-screen-position t)

;; カーソルの位置による、マウスの位置を自動的に調整する
;;(mouse-avoidance-mode 'animate)

;;
;; point undo
;;______________________________________________________________________
;; point-undo でカーソルの位置をもとに戻る
;; (install-elisp-from-emacswiki "point-undo.el")
(require 'point-undo)
(define-key global-map (kbd "<f7>") 'point-undo)
(define-key global-map (kbd "s-<f7>") 'point-redo)

;;
;; point bookmark
;;______________________________________________________________________
;; bmでカーソル位置を保存する、色を付けて見やすいようにする
;; (install-elisp "http://cvs.savannah.gnu.org/viewvc/*checkout*/bm/bm/bm.el")
(require 'bm)
;; セーブファイル名の設定
(setq bm-repository-file (my-cache-dir "bm-repository"))

;; 起動時に設定のロード
(setq bm-restore-repository-on-load t)

;; マーク位置の行に色を付ける
(setq-default bm-buffer-persistence t)

;; キーの設定
(global-set-key (kbd "C-`") 'bm-toggle)
(global-set-key (kbd "M-[") 'bm-previous)
(global-set-key (kbd "M-]") 'bm-next)

;; emacs起動時bm-repositoryをロードする
(add-hook 'after-init-hook 'bm-repository-load)
(add-hook 'find-file-hooks 'bm-buffer-restore)
(add-hook 'after-revert-hook 'bm-buffer-restore)

;; 設定ファイルのセーブ
(add-hook 'kill-buffer-hook 'bm-buffer-save)
(add-hook 'auto-save-hook 'bm-buffer-save)
(add-hook 'after-save-hook 'bm-buffer-save)
(add-hook 'vc-before-checkin-hook 'bm-buffer-save)

;; emacs終了時bm-repositoryを保存する
(add-hook 'kill-emacs-hook '(lambda nil
                              (bm-buffer-save-all)
                              (bm-repository-save)))

;;
;; goto change
;;______________________________________________________________________
;; goto-chg.el で最後編集した位置へ飛ぶ
;; (install-elisp-from-emacswiki "goto-chg.el")
(require 'goto-chg)
(define-key global-map (kbd "<f8>") 'goto-last-change)
(define-key global-map (kbd "s-<f8>") 'goto-last-change-reverse)

;;
;; cursor style change
;;______________________________________________________________________
;; カーソルののスタイルを動的に変更する
;; (install-elisp "httnp://www.emacswiki.org/emacs/download/cursor-chg.el")
;; (when windows-p
;;   (require 'cursor-chg)  ; Load the library
;;   (toggle-cursor-type-when-idle 1) ; Turn on cursor change when Emacs is idle
;;   (change-cursor-mode 1) ; Turn on change for overwrite, read-only, and input mode
;;   )

;;
;; yascroll-el
;;______________________________________________________________________
;; スクロールバーモード
;; git clone https://github.com/m2ym/yascroll-el.git
;; (install-elisp "https://github.com/m2ym/yascroll-el/raw/master/yascroll.el")
;; (require 'yascroll)
;; (global-yascroll-bar-mode 1)

;;
;; show-active-markers
;;______________________________________________________________________
;;; Emacsのマーク履歴にアイコン表示
;; http://dev.ariel-networks.com/Members/inoue/icon-on-emacs-marks/
(require 'my-active-markers)

;;
;; pop-mark
;;______________________________________________________________________
;;; 連続 pop-mark
;;; http://d.hatena.ne.jp/kbkbkbkb1/20111205/1322988550
(setq set-mark-command-repeat-pop t)

;;
;; customize scroll-up scroll-down
;;______________________________________________________________________
;; スクロール時画面にカーソルの位置を保持する
(defvar scroll-hold-cursor t)

(when scroll-hold-cursor
  (defadvice scroll-up (around scroll-up-relative activate)
    "Scroll up relatively without move of cursor."
    (if scroll-hold-cursor
        (let ((line (my-count-lines-window)))
          ad-do-it
          (move-to-window-line line))
      ad-do-it))

  (defadvice scroll-down (around scroll-down-relative activate)
    "Scroll down relatively without move of cursor."
    (if scroll-hold-cursor
        (let ((line (my-count-lines-window)))
          ad-do-it
          (move-to-window-line line))
      ad-do-it))

  (defadvice scroll-up-1 (around scroll-up-1-relative activate)
    (let ((scroll-hold-cursor nil))
      ad-do-it))

  (defadvice scroll-down-1 (around scroll-down-1-relative activate)
    (let ((scroll-hold-cursor nil))
      ad-do-it)))

(provide 'init_point)
;;; init_point.el ends here

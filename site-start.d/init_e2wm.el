;;; init_e2wm.el --- configuration for emacs windows manager(e2wm)

;; Copyright (C) 2012  LuoZengbin

;; Author: LuoZengbin <jalen.cn@gmail.com>
;; Keywords: 

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; 

;;; Code:

;;
;; e2wm セットアップ
;;http://d.hatena.ne.jp/kiwanami/20100528/1275038929
;;______________________________________________________________________
;; 最小の e2wm 設定例
(require 'e2wm)
;;(require 'e2wm-config)
(global-set-key (kbd "M-+") 'e2wm:start-management)

;; Diredを2画面ファイラ化するe2wmのパースペクティブ拡張
;; http://mikio.github.com//article/2012/04/11_emacsdired2e2wm.html
;; (install-elisp "https://raw.github.com/gist/2357888/e6fea3452290c7b73dbeb2fe6123211356594c66/e2wm-wfiler.el")
;; (require 'e2wm-wfiler)

(setq e2wm:prefix-key "C-c ;")

(global-set-key (kbd "M-+") 'e2wm:start-management)
(global-set-key (kbd "C-c 1") '(lambda () (interactive) (progn (e2wm:start-management) (e2wm:dp-code) (linum-on))))
(global-set-key (kbd "C-c 2") '(lambda () (interactive) (progn (e2wm:start-management) (e2wm:dp-two))))
(global-set-key (kbd "C-c 3") '(lambda () (interactive) (progn (e2wm:start-management) (e2wm:dp-doc))))
(global-set-key (kbd "C-c 4") '(lambda () (interactive) (progn (e2wm:start-management) (e2wm:dp-wfiler))))
(global-set-key (kbd "C-c 5") '(lambda () (interactive) (progn (e2wm:start-management) (e2wm:dp-magit))))
(global-set-key (kbd "C-c 6") '(lambda () (interactive) (progn (e2wm:start-management) (e2wm:dp-dashboard))))
(global-set-key (kbd "C-c 7") '(lambda () (interactive) (progn (e2wm:start-management) (e2wm:dp-array))))
(global-set-key (kbd "C-c Q") 'e2wm:stop-management)

;;; キーバンドのカスタマイズ
(e2wm:add-keymap
 e2wm:pst-minor-mode-keymap
 '(("C->"       . e2wm:pst-history-forward-command) ; 履歴を進む
   ("C-<"       . e2wm:pst-history-back-command) ; 履歴をもどる
   ("prefix L"  . ielm)
   ("M-m"       . e2wm:pst-window-select-main-command))
    e2wm:prefix-key)

(smartrep-define-key e2wm:pst-minor-mode-keymap
    "C-z" '(
            ("<C-left>"  . 'e2wm:dp-code)      ; codeへ変更
            ("<C-right>" . 'e2wm:dp-two)       ; twoへ変更
            ("<C-up>"    . 'e2wm:dp-doc)       ; docへ変更
            ("<C-down>"  . 'e2wm:dp-dashboard) ; dashboardへ変更
            ))

;; キーバインド
(e2wm:add-keymap
 e2wm:dp-two-minor-mode-map
 '(("prefix I" . info)
   ("C->"       . e2wm:dp-two-right-history-forward-command) ; 右側の履歴を進む
   ("C-<"       . e2wm:dp-two-right-history-back-command) ; 右側の履歴を進む
   ) e2wm:prefix-key)

;; キーバインド
(e2wm:add-keymap
 e2wm:dp-doc-minor-mode-map
 '(("prefix I" . info))
 e2wm:prefix-key)


;;
;; popwinとの統合する(暫定対応)
;; http://sheephead.homelinux.org/2012/03/08/6978/
;; e2wm の拡張集(ne2wm)を作ってみての提案など
;;    https://github.com/kiwanami/emacs-window-manager/issues/27
;;    https://github.com/tkf/ne2wm
;;    https://github.com/tkf/ne2wm/blob/master/ne2wm-popwin.el
;;______________________________________________________________________
;; (require 'ne2wm-popwin)
;; (defun e2wm:dp-code-popup-sub (buf)
;;   (ne2wm:popup-sub-appropriate-select buf))

;;; e2wm停止後popwinを復元する
(add-hook 'e2wm:post-stop-hook (lambda ()
                                 (setq display-buffer-function 'popwin:display-buffer)
                                 ;; 監視タイマー停止
                                 (e2wm:stop-close-popup-window-timer)))

;;;popupバッファーを閉じる監視タイマー機能の追加
(defadvice e2wm:override-special-display-function (after e2wm:override-special-display-function-after activate)
  (e2wm:start-close-popup-window-timer))

(defvar e2wm:close-popup-window-timer nil
  "Timer of closing the popup window.")

(defun e2wm:start-close-popup-window-timer ()
  (or e2wm:close-popup-window-timer
      (setq e2wm:close-popup-window-timer
            (run-with-timer popwin:close-popup-window-timer-interval
                            popwin:close-popup-window-timer-interval
                            'e2wm:close-popup-window-timer))))

(defun e2wm:close-popup-window-timer ()
  (condition-case var
      (e2wm:close-popup-window-if-necessary
       (e2wm:should-close-popup-window-p))
    (error (progn
             (e2wm:stop-close-popup-window-timer)   ;監視タイマーを停止する
             (message "e2wm:close-popup-window-timer: error: %s" var)))))

(defun e2wm:close-popup-window-if-necessary (&optional force)
  "Close the popup window if another window has been selected. If
FORCE is non-nil, this function tries to close the popup window
immediately if possible, and the lastly selected window will be
selected again."
  (when (wlf:get-window (e2wm:pst-get-wm) 'sub)
    (let* ((window (selected-window))
           (minibuf-window-p (eq window (minibuffer-window)))
           (other-window-selected
            (and (not (eq window (wlf:get-window (e2wm:pst-get-wm) 'sub)))
                 (not (eq window (wlf:get-window (e2wm:pst-get-wm) 'main))))))
      (when (and (not minibuf-window-p)
                 (or force other-window-selected))
        (wlf:hide (e2wm:pst-get-wm) 'sub)
        (e2wm:pst-window-select-main-command)
        (e2wm:stop-close-popup-window-timer)))))

(defun e2wm:should-close-popup-window-p ()
  "Return t if popwin should close the popup window
immediately. It might be useful if this is customizable
function."
  (and (wlf:get-window (e2wm:pst-get-wm) 'sub)
       (and (eq last-command 'keyboard-quit)
            (eq last-command-event ?\C-g))))

(defun e2wm:stop-close-popup-window-timer ()
  (when e2wm:close-popup-window-timer
    (cancel-timer e2wm:close-popup-window-timer)
    (setq e2wm:close-popup-window-timer nil)))

(defun e2wm:dp-code-popup-messages ()
  (interactive)
  (e2wm:dp-code-popup-sub "*Messages*")
  (e2wm:start-close-popup-window-timer)
  (e2wm:pst-window-select-main-command))

;;
;; バッファにアナログ時計を表示するsvg-clock.el
;; http://sheephead.homelinux.org/2012/02/15/6968/
;;______________________________________________________________________
;; (require 'svg-clock)

;; (defun e2wm:def-plugin-svg-clock (frame wm winfo)
;;   (let* ((buf (get-buffer-create "*clock*")))
;;     (with-current-buffer buf
;;       (unless svg-clock-timer
;;         (setq svg-clock-timer
;;               (run-with-timer 0 1 'svg-clock-update))
;;         (svg-clock-mode)))
;;     (wlf:set-buffer wm (wlf:window-name winfo) buf)))

;; (e2wm:plugin-register 'svg-clock
;;                       "SVG-clock"
;;                       'e2wm:def-plugin-svg-clock)

;; (defun e2wm:dp-code-toggle-svg-clock-command ()
;;   (interactive)
;;   (let* ((wm (e2wm:pst-get-wm))
;;          (prev (e2wm:pst-window-plugin-get wm 'history))
;;          (next (if (eq prev 'history-list)
;;                    'svg-clock 'history-list)))
;;     (e2wm:pst-window-plugin-set wm 'history next)
;;     (e2wm:pst-update-windows)))

(provide 'init_e2wm)
;;; init_e2wm.el ends here

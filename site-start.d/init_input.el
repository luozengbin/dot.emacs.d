;;; init_input.el --- configuration for input mothed

;; Copyright (C) 2012  LuoZengbin

;; Author: LuoZengbin <jalen.cn@gmail.com>
;; Keywords: im ibus mozc

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

;; only for linux

;;; Code:

;;
;; ibus.el
;;______________________________________________________________________
;;; home url --> http://www11.atwiki.jp/s-irie/?plugin=ref&serial=95
;;; http://skalldan.wordpress.com/2012/05/11/emacs-ibus-mozc-%E3%81%A7%E6%97%A5%E6%9C%AC%E8%AA%9E%E5%85%A5%E5%8A%9B/
(require 'ibus)
(setq ibus-python-shell-command-name "python2")
(add-hook 'after-init-hook 'ibus-mode-on)

;; C-SPC は Set Mark に使う
;; (ibus-define-common-key (kbd "C-SPC") nil)

;; C-/ は Undo に使う
(ibus-define-common-key (kbd "C-/") nil)

;; F7のibusキーバンドをクリアする
(ibus-define-common-key (kbd "<f7>") nil)

;; カーソル位置で予測候補ウィンドウを表示 (default はプリエディット領域の先頭位置に表示)
(setq ibus-prediction-window-position t)

;; IBusの状態によってカーソル色を変化させる ("on" "off" "disabled")
;; (setq ibus-cursor-color '("firebrick" "dark orange" "royal blue"))

;; すべてのバッファで入力状態を共有 (default ではバッファ毎にインプットメソッドの状態を保持)
;; (setq ibus-mode-local nil)

;; isearch 時はオフに
;; (ibus-disable-isearch)

;; mini buffer ではオフに
;; (add-hook 'minibuffer-setup-hook 'ibus-disable)

;; Keybindings
;; (global-set-key (kbd "M-SPC") 'ibus-toggle)
;; 入力エンジンの選択
(global-set-key (kbd "<C-zenkaku-hankaku>") 'ibus-enable-specified-engine)
(global-set-key (kbd "<C-henkan>") 'ibus-enable-specified-engine)
;; 単語登録
(global-set-key (kbd "C-<f7>")
                (lambda ()
                  (interactive)
                  (shell-command-to-string
                   "/usr/lib/mozc/mozc_tool --mode=word_register_dialog")))

;;
;; setting for google input mothed
;;______________________________________________________________________
;; (install-elisp "http://mozc.googlecode.com/svn/trunk/src/unix/emacs/mozc.el")
;; mozc入力設定
;; (when (require 'mozc nil t)
;;   (setq default-input-method "japanese-mozc")
;;   (global-set-key (kbd "<zenkaku-hankaku>") 'toggle-input-method))

(provide 'init_input)
;;; init_input.el ends here

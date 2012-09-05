;;; init_mew.el --- configuration for mew init

;; Copyright (C) 2011  LuoZengbin

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

;; mew 初期設定

;;; Code:

;; install
;; http://d.hatena.ne.jp/nishikawasasaki/20110315/1300205305
;; http://www.mew.org/ja/

;; Mew を使う為の設定
(autoload 'mew "mew" nil t)
(autoload 'mew-send "mew" nil t)

;; インストール時指定したiconフォルダー
(setq mew-icon-directory (concat user-emacs-directory "etc/mew"))

(defvar my-mew-config (concat my-private-emacs-path "mew-config/"))

;; mew初期設定ファイル
(setq mew-rc-file (concat my-mew-config "dot-mew.el"))

;; Optional setup (Read Mail menu for Emacs 21):
(if (boundp 'read-mail-command)
    (setq read-mail-command 'mew))

;; Optional setup (e.g. C-xm for sending a message):
(autoload 'mew-user-agent-compose "mew" nil t)
(if (boundp 'mail-user-agent)
    (setq mail-user-agent 'mew-user-agent))
(if (fboundp 'define-mail-user-agent)
    (define-mail-user-agent
      'mew-user-agent
      'mew-user-agent-compose
      'mew-draft-send-message
      'mew-draft-kill
      'mew-send-hook))

(setq mew-debug nil)

;;; windows の場合添付ファイルをcygstartで開く
(when windows-p
  (setq mew-w32-exec "cygstart"))

(provide 'init_mew)
;;; init_mew.el ends here

;;; init_tramp.el --- configuration for tramp

;; Copyright (C) 2012  LuoZengbin

;; Author: LuoZengbin <jalen.cn@gmail.com>
;; Keywords: tools

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

(require 'tramp)

;;; 参考サイト
;; http://skalldan.wordpress.com/2012/05/24/ntemacs-tramp-mode-on-windows7/
;; http://valvallow.blogspot.jp/2011/01/windows-emacs-tramp-sshplink.html

(when windows-p

  (setq tramp-debug-buffer t)
  (setq tramp-completion-without-shell-p t)
  (setq tramp-shell-prompt-pattern "^[ $]+")
  (setq tramp-default-method "plink-ms")

  ;; 秘密鍵のパスを格納する変数
  (defvar tramp-ssh-ppk nil)

  ;; plinkよりtramp接続する引数設定
  (defvar tramp-plink-ms
        `("plink-ms"
          (tramp-login-program "plink")
          (tramp-login-args
           (("-l" "%u")
            ("-P" "%p")
            ("-ssh")
            ("-i" ,tramp-ssh-ppk)
            ("%h")))
          (tramp-remote-shell "/bin/sh")
          (tramp-remote-shell-args ("-c"))
          (tramp-password-end-of-line "xy")
          (tramp-default-port 22)
          ))
  (add-to-list 'tramp-methods tramp-plink-ms))

;;; trampの挙動をカスタマイズする
(when (and windows-p (equal tramp-default-method "plink-ms"))
  (defadvice tramp-maybe-open-connection (after fix-tramp-process-coding activate)
    "windows環境でplinkプロセスとの通信コーディングシステムをUTF-8に変更する"
    (let* ((p (tramp-get-connection-process vec))
           (new-decoding 'utf-8-dos)
           (new-encoding 'utf-8-unix)
           (new-coding-system (cons new-decoding  new-encoding)))
      (when (and p (not (equal (process-coding-system p) new-coding-system)))
        (set-process-coding-system p new-decoding new-encoding)))))

(provide 'init_tramp)
;;; init_tramp.el ends here

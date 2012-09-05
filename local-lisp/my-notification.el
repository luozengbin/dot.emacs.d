;;; my-notification.el --- custom notification library for my os

;; Copyright (C) 2012  LuoZengbin

;; Author: LuoZengbin <jalen.cn@gmail.com>
;; Keywords: notification, growl, snarl

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

;; This is a notification package for emacs.
;; It work with
;;   Mac OSX  --> Growl
;;   Windows  --> Growl
;;   Windows  --> Snarl

;;; Code:

(require 'deferred)

;;; 通知機能トグル
(defvar my-notification-toggle nil)

;;; 通知コマンド
(defvar my-notification-command nil)

;;; 利用可能なアイコンの格納でディレクトリ
(defvar my-notification-icons-directory nil)

;;; メッセージ留まる時間：秒単位
(defvar my-notification-timeout 10)

;;; トグル関数
(defun my-notification-toggle ()
  (interactive)
  (setq my-notification-toggle
        (my-toggle-switch my-notification-toggle "Notification")))

;;; コマンド初期化処理
(defun my-notification-config ()
  ;;; OS毎に通知コマンドを切り替える
  (setq my-notification-command
        (case system-type
          (windows-nt "growlnotify")
          ;; (windows-nt "Snarl_CMD")
          (darwin "growlnotify")
          (t "/usr/bin/notify-send")))

  ;;; 通知コマンド利用可能の確認
  (setq my-notification-toggle (when (executable-find my-notification-command) t))
  (if (eq nil my-notification-toggle)
      (setq my-notification-command "")))

(defun my-notification-icon (icon)
  (expand-file-name icon my-notification-icons-directory))

(defun my-notification (title message &optional icon &optional time &optional sticky)
  (my-notification-1 nil title message icon time sticky))

(defun my-notification-1 (appname title message &optional icon &optional time &optional sticky)
  (when (and my-notification-toggle (not (string= my-notification-command "")))
    (apply 'start-process
           "my-notification"
           nil
           my-notification-command
           (my-notification-get-arguments appname title message icon time sticky))))

(defun my-notification-get-arguments (appname title message icon time sticky)
  (let ((appname (if (eq appname nil) "Emacs" appname))
        (title (if (eq title nil) "Emacs" title))
        (time (if (eq time nil) my-notification-timeout time))
        (icon (if (eq icon nil) (my-notification-icon "emacs.png") icon)))
    (case system-type
      ('windows-nt
       (cond
        ;; Snarlを使用する場合
        ((string= my-notification-command "Snarl_CMD")
              (list "snShowMessage" (if sticky "0" (int-to-string time)) title message icon))
             ((string= my-notification-command "growlnotify")
              (list (concat "/i:\"" icon "\"")
                    (if sticky "/s:true" "/s:false")
                    (concat "/t:\"" title "\"")
                    (concat  message )))))
      ('darwin (list title (if sticky "-s" "") "-n" appname "-m" message "--image" icon ))
      (t (list "-i" icon "-t"
               (if sticky "0" (int-to-string (* 1000 time)))
               title message)))))

(provide 'my-notification)
;;; my-notification.el ends here

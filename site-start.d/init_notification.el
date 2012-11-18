;;; init_notification.el --- configuration for mac notification tool growl

;; Copyright (C) 2011  Zouhin.Ro

;; Author: LuoZengbin <jalen.cn@gmail.com>
;; Keywords: growl, todochiku

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
;; 通用通知ライブラリ ToDoChiKu の設定
;; http://emacswiki.org/emacs/ToDoChiKu
;; For Mac -> http://growl.info/
;; For Windows -> http://snarl.fullphat.net/
;;                http://sourceforge.net/projects/mozillasnarls/files/
;;                http://tlhan-ghun.de/
;;______________________________________________________________________
;; (install-elisp "http://www.emacswiki.org/emacs/download/todochiku.el")
;; (require 'todochiku)

;;
;; my-notificationの設定
;;______________________________________________________________________
(require 'my-notification)

;;; アイコン
(setq my-notification-icons-directory (concat user-emacs-directory "etc/icons/notification/"))

;;; メッセージ溜まる時間：５秒
(setq my-notification-timeout 5)

;;; 初期化
(my-notification-config)

;; growl専用ライブラリのロード
;;______________________________________________________________________
;; (install-elisp "http://github.com/elim/emacs-growl/raw/master/growl.el")
;; (require 'growl nil t)

;;
;; ファイル保存通知
;;______________________________________________________________________
(when my-notification-toggle
  (defun notify-after-save-hook ()
    (my-notification "バッファを保存" (buffer-name (current-buffer)) nil 2 nil))
  ;; 関数をafter-save-hookに追加する
  ;;(add-hook 'after-save-hook 'notify-after-save-hook)
  )

;;
;; twittering-mode から Growl 通知
;; http://d.hatena.ne.jp/meech/20101230/1293735436
;;______________________________________________________________________
(defvar growl-notify-path (executable-find "growlnotify"))
(defvar twmode-growl-icon-path (concat user-emacs-directory "etc/icons/twitter-icon.png"))
(defvar twmode-growl-notify-icon-path-directory (concat my-cache-dir "twmode"))
(defvar twmode-growl-notify-icon-size-minimum 256)
(defvar twmode-growl-notify-tweets-count 10)
(defvar twmode-growl-notify-replies '(;;(home)
                                      (search "emacs")))
(defvar twmode-growl-notify-icon-mode 'normal)  ;text, simple, normal, fullimage
(if my-office-mode
    (setq twmode-growl-notify-icon-mode 'simple))

(eval-after-load "twittering-mode"
  '(progn
     (require 'deferred)

     ;; 通知トグル変数
     (defvar toggle-twmode-notify t)

     ;; 通知トグルＯＮ・ＯＦＦ切り替え
     (defun toggle-twmode-notify ()
       (interactive)
       (if toggle-twmode-notify
           (progn
             (ad-disable-advice 'twittering-add-statuses-to-timeline-data
                                'after 'twittering-add-statuses-to-timeline-data-after)
             (message "Turn OFF twmode notify")
             (setq toggle-twmode-notify nil))
         (ad-enable-advice 'twittering-add-statuses-to-timeline-data
                            'after 'twittering-add-statuses-to-timeline-data-after)
         (message "Turn ON twmode notify")
         (setq toggle-twmode-notify t)))

     (defadvice twittering-add-statuses-to-timeline-data (after twittering-add-statuses-to-timeline-data-after activate)
       (my-twmode-growl-notify statuses spec))

     ;; すべてのメッセージの通知Facade関数
     (defun my-twmode-growl-notify (&optional my-statuses &optional my-spec)
       (when (member my-spec twmode-growl-notify-replies)
         (when (> (list-length my-statuses) twmode-growl-notify-tweets-count)
           (message "tweets notify: %d/%d" twmode-growl-notify-tweets-count (list-length my-statuses))
           (setq my-statuses
                 (loop for i from 0 to (- twmode-growl-notify-tweets-count 1)
                       collect (nth i my-statuses))))
         (mapc (lambda (status)
                 (my-twmode-growl-notify-1 (cdr (assq 'user-screen-name status))
                                           (cdr (assq 'text status))
                                           my-spec
                                           (cdr (assq 'user-profile-image-url status))))
               my-statuses)))

     ;; twmode-growl-notify-icon-mode変数より異なる通知スタイル関数の定義を行う
     (case twmode-growl-notify-icon-mode
       ('text                           ;アイコン指定無しで表示する
        (defun my-twmode-growl-notify-1 (user text spec icon-uri)
          (cond
           ((not (string= user twittering-username))
            (with-temp-buffer
              (insert "@" user "\n" text)
              (my-notification-1 "twmode" nil (buffer-string))
              )))))
       ('simple                        ;twmodeの標準アイコンで表示する
        (defun my-twmode-growl-notify-1 (user text spec icon-uri)
          (cond
           ((not (string= user twittering-username))
            (with-temp-buffer
              (insert "@" user "\n" text)
              (my-notification-1 "twmode" nil (buffer-string) (expand-file-name twmode-growl-icon-path)))))))
       ('normal                   ; 発信したユーザのアイコンを表示する
        (defun my-twmode-growl-notify-1 (user text spec icon-uri)
          (cond
           ((not (string= user twittering-username))
            (mkdir twmode-growl-notify-icon-path-directory t)
            (lexical-let* ((suffix (ffap-file-suffix icon-uri))
                           (icon-base (expand-file-name
                                       (sha1 icon-uri)
                                       twmode-growl-notify-icon-path-directory))
                           (deferred-object
                             (if (file-exists-p icon-base)
                                 (deferred:apply 'ignore)
                               (deferred:process "wget" "-O" icon-base icon-uri)))
                           (user user)
                           (text text))
              (deferred:nextc deferred-object
                (lambda (x)
                  (my-notification-1 "twmode" (concat "@" user) text icon-base))))))))
       ('fullimage  ; 発信したユーザのアイコンをフルーサイズで表示する
        (defun my-twmode-growl-notify-1 (user text spec icon-uri)
          (cond
           ((not (string= user twittering-username))
            (mkdir twmode-growl-notify-icon-path-directory t)
            (lexical-let* ((icon-uri icon-uri)
                           (icon-base (expand-file-name
                                       (sha1 icon-uri)
                                       twmode-growl-notify-icon-path-directory))
                           (icon-path (concat icon-base ".png"))
                           (user user)
                           (text text))
              (deferred:$
                (deferred:next
                  (lambda (x)
                    (if (file-exists-p icon-path)
                        (deferred:apply 'ignore)
                      (deferred:$
                        (deferred:process "wget" "-O" icon-base icon-uri)
                        (deferred:nextc it
                          (lambda (x)
                            (with-temp-buffer
                              (call-process "identify"
                                            nil t nil
                                            icon-base)
                              (goto-char (point-min))
                              (re-search-forward "\\([0-9]+\\)x\\([0-9]+\\)")
                              (and (< (string-to-number (match-string 1))
                                      twmode-growl-notify-icon-size-minimum)
                                   (< (string-to-number (match-string 2))
                                      twmode-growl-notify-icon-size-minimum)))))
                        (deferred:nextc it
                          (lambda (need-scale)
                            (if need-scale
                                (deferred:process "convert"
                                  icon-base
                                  "-scale" (format "%dx%d"
                                                   twmode-growl-notify-icon-size-minimum
                                                   twmode-growl-notify-icon-size-minimum)
                                  (concat "png:" icon-path))
                              (deferred:apply 'ignore))))
                        (deferred:nextc it
                          (lambda (x)
                            (deferred:call 'delete-file icon-base)))))))
                (deferred:nextc it
                  (lambda (x)
                    (my-notification-1 "twmode" (concat "@" user) text icon-base)))))))))
       (t (message "my-twmode-growl-notify-1 not implement for this mode")))))

(provide 'init_notification)
;;; init_notification.el ends here

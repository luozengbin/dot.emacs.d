;;; init_social.el --- lisp code for social thing

;; Copyright (C) 2012  LuoZengbin

;; Author: LuoZengbin <jalen.cn@gmail.com>
;; Keywords: social

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
;; twittering-mode install
;;______________________________________________________________________
;; git clone https://github.com/hayamiz/twittering-mode.git
(autoload 'twit "twittering-mode" "Major mode for Twitte" t)

;;
;; twittering-mode setting
;;______________________________________________________________________
(eval-after-load "twittering-mode"
  '(progn
     ;; PINコード保存
     (setq twittering-use-master-password t)

     ;; パスワード保存ファイル
     (setq twittering-private-info-file (expand-file-name (concat my-cache-dir ".twittering-mode.gpg")))

     ;; 表示設定
     (twittering-enable-unread-status-notifier)

     ;; 表示設定
     (twittering-enable-unread-status-notifier)
     ;; officeモードiconを非表示
     (setq-default twittering-icon-mode (if (equal my-office-mode t) 'nil 't))

     ;; ssl通信を無効
     (setq twittering-allow-insecure-server-cert t)
     (setq twittering-oauth-use-ssl nil)
     (setq twittering-use-ssl nil)

     ;; プロキシ設定
     (cond ((equal my-local-proxy-enable t)
            (setq twittering-proxy-use t)
            (setq twittering-https-proxy-server my-local-http-proxy-host)
            (setq twittering-https-proxy-port my-local-http-proxy-port)
            (setq twittering-proxy-server my-local-https-proxy-host)
            (setq twittering-proxy-port my-local-https-proxy-port)
            ))

     ;; (setq twittering-initial-timeline-spec-string `(":home@sina"))

     ;; debugモードの有効
     ;; (setq twittering-debug-mode t)
     ))

;;
;; weibo install
;;______________________________________________________________________
;;; git submodule add https://github.com/austin-----/weibo.emacs.git lisp/weibo.emacs
(autoload 'weibo-timeline "weibo" nil t nil)
(eval-after-load "weibo"
  '(progn
     (setq weibo-directory (my-cache-dir ".t.weibo.emacs.d"))))

(provide 'init_social)
;;; init_social.el ends here

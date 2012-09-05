;;; init_edbi.el --- configuration for emacs dbi package

;; Copyright (C) 2012  Zouhin.Ro

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

;; DB操作ツール Emacs DBI の初期設定

;;; Code:

;; 導入
;;
;; 使い方：http://d.hatena.ne.jp/kiwanami/20120305/1330939440
;;______________________________________________________________________
;; auto-installを使う場合
;; (auto-install-from-url "https://github.com/kiwanami/emacs-deferred/raw/master/deferred.el")
;; (auto-install-from-url "https://github.com/kiwanami/emacs-deferred/raw/master/concurrent.el")
;; (auto-install-from-url "https://github.com/kiwanami/emacs-ctable/raw/master/ctable.el")
;; (auto-install-from-url "https://github.com/kiwanami/emacs-epc/raw/master/epc.el")
;; git clone https://github.com/kiwanami/emacs-edbi.git

(autoload 'edbi:open-db-viewer "edbi" "common database operation tool" t)

(eval-after-load "edbi"
  '(progn
     ;; 接続文字列履歴ファイル
     (setq edbi:ds-history-file (my-cache-dir ".edbi-ds-history"))
     ;; 履歴ファイルがうまくロードしない問題の対応
     (defun edbi:ds-history-load ()
       "[internal] Read the data source history file and store the data into `edbi:ds-history-list'."
       (let* ((coding-system-for-read 'utf-8)
              (file (expand-file-name edbi:ds-history-file)))
         (when (file-exists-p file)
           (let* ((buf (find-file-noselect file))
                  (buf-lisp (with-current-buffer buf (buffer-string)))
                  ret)
             (unwind-protect
                 (setq ret (loop for i in (read buf-lisp)
                                 collect
                                 (edbi:data-source (car i) (nth 1 i) "")))
               (kill-buffer buf))
             (print ret)
             (setq edbi:ds-history-list ret)))))))


;;
;; e2wmとの連携
;; edbi-e2wm.el : https://gist.github.com/1842966
;;______________________________________________________________________
;; (install-elisp "https://raw.github.com/gist/1842966/98b5f0596096b138009bffcd5d2e3609719fb5d5/e2wm-edbi-pre.el")
(require 'e2wm-edbi)
(global-set-key (kbd "C-c 8") '(lambda () (interactive) (progn (e2wm:start-management) (e2wm:dp-edbi))))

(provide 'init_edbi)
;;; init_edbi.el ends here

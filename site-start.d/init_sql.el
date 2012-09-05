;;; init_sql.el --- configuration for sql mode

;; Copyright (C) 2012  LuoZengbin

;; Author: LuoZengbin <jalen.cn@gmail.com>
;; Keywords: sql-mode

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
;; sql-mode
;; http://www.emacswiki.org/cgi-bin/wiki.pl?SqlMode
;; http://www.sixnine.net/roadside/sqlmode.html

;;; Code:

;;
;; sqlmode
;;______________________________________________________________________
;; (install-elisp "http://www.emacswiki.org/emacs/download/sql-indent.el")
;; (install-elisp "http://www.emacswiki.org/emacs/download/sql-transform.el")
;; (install-elisp "http://www.emacswiki.org/emacs/download/sql-complete.el")

;; SQL mode に入った時点で sql-indent / sql-complete を読み込む
(eval-after-load "sql"
  '(progn
     (load-library "sql-indent")
     (load-library "sql-complete")
     (load-library "sql-transform")))

;; SQL モードの雑多な設定
(defun init-sql-mode ()
  (setq sql-indent-offset 4)            ;インデント幅
  (setq sql-indent-maybe-tab nil)       ;タブ使用する？
  (local-set-key (kbd "C-c u")  'sql-to-update) ; sql-transform
  ;; SQLi の自動ポップアップ
  (setq sql-pop-to-buffer-after-send-region t))

(add-hook 'sql-mode-hook 'init-sql-mode)

;;
;; sql-mysql
;;______________________________________________________________________
;;; mysqlサーバーへ接続するためのデフォルト情報
;; (setq sql-user     "root"               ;ユーザ名
;;       sql-database "mysql"              ;データベース名
;;       sql-server   "localhost"          ;ホスト名
;;       sql-product  'mysql               ;データベースの種類
;;       )

;;; mysql 自動補完
;; (install-elisp "http://www.emacswiki.org/emacs/download/sql-completion.el")
;; (install-elisp "http://www.emacswiki.org/emacs/download/mysql.el")
(defun init-mysql-interactive-mode ()
  (when (eq sql-product 'mysql)
    (require 'sql-completion)
    (require 'mysql)
    (setq mysql-user sql-user)
    (setq mysql-password sql-password)
    (setq sql-mysql-exclude-databases (delete sql-database sql-mysql-exclude-databases))
    (define-key sql-interactive-mode-map (kbd "TAB") 'comint-dynamic-complete)
    (sql-mysql-completion-init)))
(add-hook 'sql-interactive-mode-hook 'init-mysql-interactive-mode)

;;
;; sql-oracle
;;______________________________________________________________________
(setenv "ORACLE_HOME" "/oracle/product/db")
;; (setq sql-user     "system"               ;ユーザ名
;;       sql-database "localhost/xdb"        ;データベース名
;;       sql-product  'oracle                ;データベースの種類
;;       )

(setq sql-data-dictionary-load-time 0.3)
(defun init-oracle-interactive-mode ()
  (when (eq sql-product 'oracle)
    (sql-oracle-data-dictionary)
    (define-key sql-interactive-mode-map (kbd "TAB") 'sql-complete)
    (define-key sql-mode-map (kbd "TAB") 'sql-complete)))

(add-hook 'sql-login-hook 'init-oracle-interactive-mode)

;;
;; sqlplus
;; http://www.emacswiki.org/emacs/SqlPlus
;;______________________________________________________________________
;; (install-elisp "http://www.emacswiki.org/emacs/download/sqlplus.el")
;; (install-elisp "http://www.emacswiki.org/emacs/download/plsql.el")

;; (require 'plsql)
;; (setq auto-mode-alist
;;       (append '(("\\.pls\\'" . plsql-mode) ("\\.pkg\\'" . plsql-mode)
;;                 ("\\.pks\\'" . plsql-mode) ("\\.pkb\\'" . plsql-mode)
;;                 ("\\.sql\\'" . plsql-mode) ("\\.PLS\\'" . plsql-mode)
;;                 ("\\.PKG\\'" . plsql-mode) ("\\.PKS\\'" . plsql-mode)
;;                 ("\\.PKB\\'" . plsql-mode) ("\\.SQL\\'" . plsql-mode)
;;                 ("\\.prc\\'" . plsql-mode) ("\\.fnc\\'" . plsql-mode)
;;                 ("\\.trg\\'" . plsql-mode) ("\\.vw\\'" . plsql-mode)
;;                 ("\\.PRC\\'" . plsql-mode) ("\\.FNC\\'" . plsql-mode)
;;                 ("\\.TRG\\'" . plsql-mode) ("\\.VW\\'" . plsql-mode))
;;               auto-mode-alist ))

(autoload 'sqlplus "sqlplus" "\
User friendly interface to SQL*Plus and support for PL/SQL compilation" t nil)

(autoload 'sqlplus-mode "sqlplus" "\
User friendly interface to SQL*Plus and support for PL/SQL compilation" t nil)

(add-to-list 'auto-mode-alist '("\\.sqp\\'" . sqlplus-mode))

(eval-after-load "sqlplus"
  '(progn
     (setq sqlplus-history-dir (my-cache-dir "sqlplus-history"))
     (setq sqlplus-html-output-file-name (my-work-dir "sqlplus_report.html"))
     ))

(provide 'init_sql)
;;; init_sql.el ends here

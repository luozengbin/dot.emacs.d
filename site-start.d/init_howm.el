;;; init_howm.el --- configuration for howm

;; Copyright (C) 2011  Zouhin.Ro

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

;; howm設定

;;; Code:
(require 'smartrep)

(message "init_howm ...")

;;
;; howmの設定
;;______________________________________________________________________
;; howm のキーを「C-c , □」から「C-z □」に変更
(setq howm-prefix "\C-z,")
(setq howm-menu-lang 'ja)

;; org-mode と howm を併用ための設定
(setq howm-view-title-header "*") ;; ← howm のロードより前に書くこと
(add-to-list 'auto-mode-alist '("\\.howm$" . org-mode))

(autoload 'howm-menu "howm-mode" "Hitori Otegaru Wiki Modoki" t)
;; howmカスタマイズ
(setq howm-directory (concat my-private-emacs-path "howm/"))
(setq howm-history-file (concat my-private-emacs-path "configuration/.howm-history"))
(setq howm-keyword-file (concat my-private-emacs-path "configuration/.howm-keys"))
;; howmのcodingと検索エンジンの設定
;; (setq howm-process-coding-system '(utf-8-unix . utf-8-unix))
;; (setq howm-view-use-grep t)

;;
;; anything-howm設定
;;______________________________________________________________________
;; (require 'anything-howm)
;; ;; 「最近のメモ」をいくつ表示するか
;; (setq anything-howm-recent-menu-number-limit 600)
;; ;; howm のデータディレクトリへのパス
;; (setq anything-howm-data-directory howm-directory)
;; ;; キーバンディングの定義
;; (define-key global-map (kbd "C-z h") 'anything-howm-menu-command)
;; ;; (define-key global-map (kbd "C-z c") 'anything-cached-howm-menu)

;;
;; helm-howm設定
;;______________________________________________________________________
;; (require 'helm-howm)
;; (setq hh:recent-menu-number-limit 600)
;; (global-set-key (kbd "C-z h") 'hh:menu-command)

;;
;; calfw-howmの設定
;;______________________________________________________________________
(eval-after-load "howm-mode"
  (progn

    ;; calfwと連携する
    (require 'calfw-howm)
    (cfw:install-howm-schedules)
    (define-key howm-mode-map (kbd "M-C") 'cfw:open-howm-calendar)
    (define-key cfw:howm-schedule-map (kbd "i") 'my-cfw-open-schedule-buffer)
    (define-key cfw:howm-schedule-inline-keymap (kbd "i") 'my-cfw-open-schedule-buffer)
    ;; 0000-00-00-000000.howmファイルに次の内容を埋め込むとカレンダーがInlineで表示される。
    ;; %here%(cfw:howm-schedule-inline)

    ;; howm and calendar framework
    (defvar my-howm-schedule-page "2011年予定") ; 予定を入れるメモのタイトル
    ))

;; TODO move this function to split el file
(defun my-cfw-open-schedule-buffer ()
  (interactive)
  (let*
      ((date (cfw:cursor-to-nearest-date))
       (howm-items
        (howm-folder-grep
         howm-directory
         (regexp-quote my-howm-schedule-page))))
    (cond
     ((null howm-items) ; create
      (howm-create-file-with-title my-howm-schedule-page nil nil nil nil))
     (t
      (howm-view-open-item (car howm-items))))
    (goto-char (point-max))
    (unless (bolp) (insert "\n"))
    (insert
     (format "[%04d-%02d-%02d]@ "
             (calendar-extract-year date)
             (calendar-extract-month date)
             (calendar-extract-day date)))))

(provide 'init_howm)
;;; init_howm.el ends here

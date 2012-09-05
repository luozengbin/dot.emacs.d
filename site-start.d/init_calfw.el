;;; init_calfw.el --- configuration for emacs-calfw

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

;; Emacs用カレンダー calfw 

;;; Code:

(message "init_calfw ...")

;; 参照
;;      v1.2 リリース http://d.hatena.ne.jp/kiwanami/20110723/1311434175
;;      https://github.com/kiwanami/emacs-calfw
;; インストール
;;      git clone https://github.com/kiwanami/emacs-calfw.git
(require 'calfw)
;; org-scheduleと連携する
(require 'calfw-org)
;; google calendarと連携する
(require 'calfw-ical)

;; プロキシ環境対応
(cond ((equal my-local-proxy-enable t)
       (setq cfw:ical-url-to-buffer-get 'cfw:ical-url-to-buffer-external)
       (setq cfw:ical-calendar-external-shell-command (concat "wget -e http_proxy=" my-local-http-proxy " -e https_proxy=" my-local-https-proxy " --no-check-certificate -q -O - "))
       ))

;; カスタマイズビューのの定義
(defun open-my-calendar ()
  (interactive)
  (cfw:open-calendar-buffer
   :view 'two-weeks                         ; month,two-weeks,week, day
   :contents-sources
   (list
    (cfw:ical-create-source "農歴" "https://www.google.com/calendar/ical/zh_tw.lunar%23holiday%40group.v.calendar.google.com/public/basic.ics" "peru")
    (cfw:ical-create-source "Google" "https://www.google.com/calendar/ical/jalen.cn%40gmail.com/private-0b6e8afb74da6ffc2bfe83d5e30b4b3e/basic.ics" "OrangeRed1")
    (cfw:org-create-source "DeepSkyBlue1") ;org 用のソース生成関数
    (cfw:howm-create-source)               ;howm 用のソース生成関数
    )))
(global-set-key (kbd "C-<f6>") 'open-my-calendar)

;; 月表示定義
(setq calendar-month-name-array
      ["1月" "2月" "3月"     "4月"   "5月"      "6月"
       "7月"    "8月"   "9月" "10月" "11月" "12月"])

;; 曜日表示定義
(setq calendar-day-name-array
      ["日" "月" "火" "水" "木" "金" "木"])

;; 週の先頭の曜日
(setq calendar-week-start-day 0) ; 日曜日は0, 月曜日は1

;; faces定義
(custom-set-faces
 '(cfw:face-header ((t :foreground "maroon2")))
 '(cfw:face-day-title ((t :foreground "#f8f9ff" :background "black")))
 '(cfw:face-select ((t :background "RoyalBlue3")))
 '(cfw:face-today-title ((t :background "red4")))
 '(cfw:face-today ((t :background "#fff7d7")))
 '(cfw:face-saturday ((t :foreground "sienna1" :background "black" :weight bold)))
 '(cfw:face-sunday ((t :foreground "red" :background "black" :weight bold)))
 ;; '(cfw:face-holiday ((t :foreground "red" :background "black" :weight bold)))
 '(cfw:face-toolbar ((t :foreground "Steelblue4")))
 '(cfw:face-toolbar-button-on ((t :foreground "maroon2")))
 '(cfw:face-toolbar-button-off ((t :foreground "grey")))
 )

(provide 'init_calfw)
;;; init_calfw.el ends here

;;; init_calendar.el --- configuration for calendar

;; Copyright (C) 2011  Zouhin.Ro

;; Author: LuoZengbin <jalen.cn@gmail.com>
;; Keywords: calendar

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

;; カレンダーの設定

;;; Code:

(message "init_calendar ...")

(require 'calendar)

;;;; Calendar
(setq mark-holidays-in-calendar t)
(setq calendar-weekend '(0 6))

;; 観測地点を東京に設定
(setq calendar-latitude 35.35)
(setq calendar-longitude 139.44)
(setq calendar-location-name "Tokyo, JP")

;; タイムゾーン
(setq calendar-time-zone +540)
(setq calendar-standard-time-zone-name "JST")
(setq calendar-daylight-time-zone-name "JST")

;; ;; カレンダー見た目を変える
(custom-set-faces
 '(calendar-today ((t (:background "sienna1"))))
 '(holiday ((((class color) (background dark)) (:foreground "red"))))
 )
;; キーバンドの定義
(global-set-key [f6] 'calendar)
(define-key calendar-mode-map "\C-f" 'calendar-forward-week)
(define-key calendar-mode-map "\C-b" 'calendar-backward-week)
(define-key calendar-mode-map "f" 'calendar-forward-month)
(define-key calendar-mode-map "b" 'calendar-backward-month)
(define-key calendar-mode-map "\C-cf" 'calendar-forward-year)
(define-key calendar-mode-map "\C-cb" 'calendar-backward-year)
(define-key calendar-mode-map [f6] 'exit-calendar)

;; 日本祝日
;; (install-elisp "http://www.meadowy.org/meadow/netinstall/export/799/branches/3.00/pkginfo/japanese-holidays/japanese-holidays.el")
;; 参照リンク: http://d.hatena.ne.jp/rubikitch/20090216/1234746280
;;             http://d.hatena.ne.jp/rubikitch/20090216/1234750398
;;             http://blog.livedoor.jp/tek_nishi/archives/3027665.html
;; (require 'japanese-holidays)
;; (setq calendar-holidays
;;       (append japanese-holidays local-holidays other-holidays))

;; (add-hook 'today-visible-calendar-hook 'calendar-mark-today)
;; (add-hook 'today-visible-calendar-hook 'calendar-mark-weekend)
;; (add-hook 'today-invisible-calendar-hook 'calendar-mark-weekend)


(eval-after-load "holidays"
  '(progn
     (require 'japanese-holidays)
     (setq calendar-holidays ; 他の国の祝日も表示させたい場合は適当に調整
           (append japanese-holidays holiday-local-holidays holiday-other-holidays))
     (setq mark-holidays-in-calendar t) ; 祝日をカレンダーに表示
     ;; 土曜日・日曜日を祝日として表示する場合、以下の設定を追加します。
     ;; デフォルトで設定済み
     (setq japanese-holiday-weekend '(0 6)     ; 土日を祝日として表示
           japanese-holiday-weekend-marker     ; 土曜日を水色で表示
           '(holiday nil nil nil nil nil japanese-holiday-saturday))
     (add-hook 'calendar-today-visible-hook 'japanese-holiday-mark-weekend)
     (add-hook 'calendar-today-invisible-hook 'japanese-holiday-mark-weekend)))

;; “きょう”をマークするには以下の設定を追加します。
(add-hook 'calendar-today-visible-hook 'calendar-mark-today)

(provide 'init_calendar)
;;; init_calendar.el ends here

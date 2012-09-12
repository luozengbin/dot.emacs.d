;;; init_clmemo.el --- clmemo package take one file note

;; Copyright (C) 2012  LuoZengbin

;; Author: LuoZengbin <jalen.cn@gmail.com>
;; Keywords: docs

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
;; New clmemo
;; http://at-aka.blogspot.jp/2012/09/clmemo-blgrep-github.html
;; http://at-aka.blogspot.jp/p/change-log.html
;;______________________________________________________________________
(autoload 'clmemo "clmemo" "ChangeLog MEMO mode." t)
;; (define-key ctl-x-map "M" 'clmemo)
(setq clmemo-file-name (my-private-file "myfiles/clmemo.txt"))
(setq add-log-mailing-address user-mail-address)
(setq add-log-full-name user-full-name)

;;
;; blgrep (clgrep.el)
;;______________________________________________________________________
(require 'blg-autoloads)
(add-hook 'clmemo-mode-hook
          '(lambda ()
             (define-key clmemo-mode-map (kbd "C-c C-g") 'clgrep)
             (define-key clmemo-mode-map (kbd "C-c ,") 'quasi-howm)))

(add-hook 'change-log-mode-hook
          '(lambda ()
             (define-key change-log-mode-map (kbd "C-c C-g") 'blg-changelog)
             (define-key change-log-mode-map (kbd "C-c C-i") 'blg-changelog-item-heading)
             (define-key change-log-mode-map (kbd "C-c C-d") 'blg-changelog-date)))

;; (add-hook 'outline-mode-hook
;;           '(lambda ()
;;              (define-key outline-mode-map (kbd "C-c C-g") 'blg-outline)
;;              (define-key outline-mode-map (kbd "C-c 1") 'blg-outline-line)))
;; (add-hook 'outline-minor-mode-hook
;;           '(lambda ()
;;              (define-key outline-minor-mode-map (kbd "C-c C-g") 'blg-outline)
;;              (define-key outline-minor-mode-map (kbd "C-c 1") 'blg-outline-line)))

;;
;; quasi-howm
;; http://at-aka.blogspot.jp/2005/06/changelog-howm-quasi-howm.html
;;______________________________________________________________________
;; (setq quasi-howm-dir "~/personal/memo/howm/")
;; (setq quasi-howm-file-name-format "%Y-%m/%Y%m%d-%H%M%S")

(provide 'init_clmemo)
;;; init_clmemo.el ends here

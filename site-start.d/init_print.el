;;; init_print.el --- configuration for print service

;; Copyright (C) 2013  LuoZengbin

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

;; init_print

;;; Code:



;;
;; windows 環境の印刷設定
;;______________________________________________________________________
;; 参考：http://aikotobaha.blogspot.com/2010/09/emacs_2374.html
;;  Ghostscriptが必要
;;   http://auemath.aichi-edu.ac.jp/~khotta/ghost/
;;  BoldFontが必要
;;   http://ftp.yz.yamagata-u.ac.jp/pub/GNU/intlfonts/intlfonts-1.2.1.tar.gz
;;
;;     M-x ps-print-buffer           バッファを白黒印刷
;;     M-x ps-print-buffer-with-face バッファをカラー印刷
;;     M-x ps-print-region           リージョンを白黒印刷
;;     M-x ps-print-region-with-face リージョンをカラー印刷
;;

(global-set-key (kbd "C-z p") 'ps-print-buffer)
(global-set-key (kbd "C-z P") 'ps-print-region)

(when windows-p
  (progn
    (defun listsubdir (basedir)
      (remove-if (lambda (x) (not (file-directory-p x)))
                 (directory-files basedir t "^[^.]")))

    ;; フォントパスを指定
    (setq bdf-directory-list
          (listsubdir "C:/ProgramData/emacs-utils/intlfonts-1.2.1"))

    ;; ghostscriptの実行コマンド場所を指定
    (setq ps-print-color-p t
          ps-lpr-command "C:/ProgramData/emacs-utils/gs/gs9.07/bin/gswin32c.exe"
          ps-multibyte-buffer 'non-latin-printer
          ps-lpr-switches '("-sDEVICE=mswinpr2" "-dNOPAUSE" "-dBATCH" "-dWINKANJI")
          printer-name nil
          ps-printer-name nil
          ps-printer-name-option nil
          ps-print-header t             ; ヘッダの非表示
          )))

(provide 'init_print)
;;; init_print.el ends here

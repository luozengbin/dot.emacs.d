;;; my-ac-source.el --- custom auto-complete source

;; Copyright (C) 2011  LuoZengbin

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

;; カスタマイズauto-completeソースの定義

;;; Code:

(require 'thing-opt)

;; 英語辞書の位置情報
(setq my/ac-en-dict-dir nil)

;; 英語辞書による補完
(defun ac-expand-english-words ()
  "英語補完"
  (interactive)
  (let (
        (target-word (thing-at-point 'word))
        (en-dict-path my/ac-en-dict-dir)
        (dict-file nil)
        )
    (cond ((string-match "[A-Za-z]" target-word)
           (setq dict-file (concat "en-" (char-to-string (car (string-to-list target-word))) ".dict"))
           (cond ((eq (get-buffer dict-file) nil)
                  (message (concat "open dict file for auto complete english words. -> " (concat en-dict-path  dict-file)))
                  (find-file-noselect (concat en-dict-path dict-file))
                  ))
           (call-interactively 'ac-complete-words-in-all-buffer)
           ))
    )
  )

;; 中国語単語、詩の補完
(defun ac-expand-chinese-words ()
  "中国語単語、詩の補完"
  (interactive)
  (let ((cn-dict-path my/ac-cn-dict-dir))
    (loop for x in (directory-files cn-dict-path)
          do (if (string-match ".+[.]dict$" x)
                  (progn
                    (find-file-noselect (concat cn-dict-path x))
                    (message (concat "open dict file for auto complete chinese words. -> " (concat cn-dict-path x)))
                    )))
    (call-interactively 'ac-complete-words-in-all-buffer)
    )
  )

(provide 'my-ac-source)
;;; my-ac-source.el ends here

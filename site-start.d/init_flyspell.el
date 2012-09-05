;;; init_flyspell.el --- flyspell configuration file

;; Copyright (C) 2011  LuoZengbin

;; Author: LuoZengbin <jalen.cn@gmail.com>
;; Keywords: spell, aspell

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

;; flymake文法チェック初期設定

;;; Code:

(message "init_flyspell ...")

;;
;; 基本設定
;;______________________________________________________________________
;; スペースチェックプログラムの指定
;; (setq ispell-program-name "aspell")
;; スペースチェック訂正候補出力ツールの指定
;; (setq ispell-grep-command "grep")
;; 補完辞書の指定
;; 辞書を集めたサイト → http://wordlist.sourceforge.net/
(setq ispell-alternate-dictionary (concat user-emacs-directory "share/miscfiles-1.5/web2"))
;; (setq ispell-complete-word-dict )


;; ----> 確認したが、いらないようです。
;; 日本語混じりの TeX 文書のスペルをチェックしたい場合
;; (eval-after-load "ispell"
;;    '(add-to-list 'ispell-skip-region-alist '("[^\000-\377]+")))

;; flyspell-mode の修正候補を表示する
;; 参照リンク:
;;      http://d.hatena.ne.jp/mooz/20100423/p1
(defun flyspell-correct-word-popup-el ()
  "Pop up a menu of possible corrections for misspelled word before point."
  (interactive)
  ;; use the correct dictionary
  (flyspell-accept-buffer-local-defs)
  (let ((cursor-location (point))
        (word (flyspell-get-word nil)))
    (if (consp word)
        (let ((start (car (cdr word)))
              (end (car (cdr (cdr word))))
              (word (car word))
              poss ispell-filter)
          ;; now check spelling of word.
          (ispell-send-string "%\n")	;put in verbose mode
          (ispell-send-string (concat "^" word "\n"))
          ;; wait until ispell has processed word
          (while (progn
                   (accept-process-output ispell-process)
                   (not (string= "" (car ispell-filter)))))
          ;; Remove leading empty element
          (setq ispell-filter (cdr ispell-filter))
          ;; ispell process should return something after word is sent.
          ;; Tag word as valid (i.e., skip) otherwise
          (or ispell-filter
              (setq ispell-filter '(*)))
          (if (consp ispell-filter)
              (setq poss (ispell-parse-output (car ispell-filter))))
          (cond
           ((or (eq poss t) (stringp poss))
            ;; don't correct word
            t)
           ((null poss)
            ;; ispell error
            (error "Ispell: error in Ispell process"))
           (t
            ;; The word is incorrect, we have to propose a replacement.
            (flyspell-do-correct (popup-menu* (car (cddr poss)) :scroll-bar t :margin t)
                                 poss word cursor-location start end cursor-location)))
          (ispell-pdict-save t)))))

;; 修正したい単語の上にカーソルをもっていき, C-M-return を押すことで候補を選択
(add-hook 'flyspell-mode-hook
          (lambda ()
            (define-key flyspell-mode-map (kbd "<C-M-return>") 'flyspell-correct-word-popup-el)
            ))

;; flyspell-mode を自動的に開始させたいファイルを指定 (お好みでアンコメントするなり, 変更するなり)
;; (add-to-list 'auto-mode-alist '("\\.txt" . flyspell-mode))
;; (add-to-list 'auto-mode-alist '("\\.properties" . flyspell-mode))

(provide 'init_flyspell)
;;; init_flyspell.el ends here

;;; init_pgsupport.el --- configuration for running/testing program

;; Copyright (C) 2011  Zouhin.Ro

;; Author: LuoZengbin <jalen.cn@gmail.com>
;; Keywords: flymake, quickrun

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
;; flymake
;; http://www.emacswiki.org/emacs/FlyMake
;;______________________________________________________________________
(require 'flymake)

;; flymake文法チェックでエラー箇所を見やすくする
;; (install-elisp "http://www.emacswiki.org/emacs/download/rfringe.el")
;; (install-elisp "http://www.emacswiki.org/emacs/download/flymake-cursor.el")
(require 'rfringe)
;; (require 'flymake-cursor)

;; flymake 現在行のエラーをpopup.elのツールチップで表示する
(defun my-flymake-popup-display-error ()
  "show error/warring message with popup tooltip"
  (interactive)
  (let* ((line-no             (flymake-current-line-no))
         (line-err-info-list  (nth 0 (flymake-find-err-info flymake-err-info line-no)))
         (count               (length line-err-info-list))
         (menu-item-text-list '()))
    (while (and line-err-info-list (> count 0))
      (let* ((line-err-info (nth (1- count) line-err-info-list))
             (file          (flymake-ler-file line-err-info))
             (full-file     (flymake-ler-full-file line-err-info))
             (text          (flymake-ler-text line-err-info))
             (line          (flymake-ler-line line-err-info)))
        (add-to-list 'menu-item-text-list (format "[%s] %s" line text)))
      (setq count (1- count)))
    (if menu-item-text-list
        (popup-tip (mapconcat '(lambda (x) x) menu-item-text-list "\n")))))

;;; flymake 現在行のエラーをpopup.elのツールチップで表示する
(defun my-flymake-minibuffer-display-error ()
"show flymake current message in minibuffer"
  (when (get-char-property (point) 'flymake-overlay)
    (let ((help (get-char-property (point) 'help-echo)))
      (if help (message "%s" help)))))

(defun my-flymake-display-error ()
  (interactive)
  (my-flymake-minibuffer-display-error)
  (my-flymake-popup-display-error))

(eval-after-load "flymake"
  '(progn
     (defadvice flymake-goto-next-error (after flymake-goto-next-error-display-message activate compile)
       "Display the error in the mini-buffer rather than having to mouse over it"
       (my-flymake-display-error))

     (defadvice flymake-goto-prev-error (after flymake-goto-prev-error-display-message activate compile)
       "Display the error in the mini-buffer rather than having to mouse over it"
       (my-flymake-display-error))

     ;; キーバンド
     (defadvice flymake-mode (after flymake-mode-after-init activate compile)
       "init flymake keybinding for flymake-mode"
       (cond
        (flymake-mode
         (let ((map (current-local-map)))
           (smartrep-define-key
               map
               "C-z" '(("M-p"      . 'flymake-goto-prev-error)
                       ("M-n"      . 'flymake-goto-next-error)
                       ("x"        . 'my-flymake-display-error)))))
        (t
         (let ((map (current-local-map)))
           (define-key map (kbd"C-z M-n") nil)
           (define-key map (kbd"C-z M-p") nil)
           (define-key map (kbd"C-z x") nil)))))))

;;
;; flymake face customize
;;______________________________________________________________________
;;; http://d.hatena.ne.jp/kitokitoki/20101230/p2
;; http://nschum.de/src/emacs/fringe-helper/
(require 'fringe-helper)
(set-face-background 'flymake-errline nil)    ;既存のフェイスを無効にする
(set-face-foreground 'flymake-errline nil)
;;(set-face-underline-p 'flymake-errline t)
(set-face-underline 'flymake-errline "tomato")
(set-face-background 'flymake-warnline nil)
(set-face-foreground 'flymake-warnline nil)
;;(set-face-underline-p 'flymake-warnline t)
(set-face-underline 'flymake-warnline "yellow")

(make-face 'my-flymake-warning-face)
(set-face-foreground 'my-flymake-warning-face "yellow")
(set-face-background 'my-flymake-warning-face "black")
(setq my-flymake-warning-face 'my-flymake-warning-face)

(defvar flymake-fringe-overlays nil)
(make-variable-buffer-local 'flymake-fringe-overlays)

(defadvice flymake-make-overlay (after add-to-fringe first
                                       (beg end tooltip-text face mouse-face)
                                       activate compile)
  (push (fringe-helper-insert-region
         beg end
         (fringe-lib-load (if (eq face 'flymake-errline)
                              fringe-lib-exclamation-mark
                            fringe-lib-question-mark))
         'left-fringe 'my-flymake-warning-face)
        ;; 'left-fringe 'font-lock-warning-face)
        flymake-fringe-overlays))

(defadvice flymake-delete-own-overlays (after remove-from-fringe activate
                                              compile)
  (mapc 'fringe-helper-remove flymake-fringe-overlays)
  (setq flymake-fringe-overlays nil))

;;
;; flymake-anything
;;______________________________________________________________________
(eval-when-compile (require 'cl))
(require 'anything)
(require 'flymake)

(defvar anything-flymake-err-list nil)

(defvar anything-c-source-flymake
  '((name . "Flymake")
    (init . (lambda ()
              (setq anything-flymake-err-list
                    (loop for err-info in flymake-err-info
                          for err = (nth 1 err-info)
                          append err))))
    (candidates . anything-get-flymake-candidates)
    (action
     . (("Goto line" . (lambda (candidate) (goto-line (flymake-ler-line candidate) anything-current-buffer)))))))

(defface anything-flymake-errline
  '((((class color) (background dark)) (:background "Firebrick4"))
    (((class color) (background light)) (:background "LightPink"))
    (t (:bold t)))
  "Face used for marking error lines."
  :group 'anything)

(defface anything-flymake-warnline
  '((((class color) (background dark)) (:background "DarkBlue"))
    (((class color) (background light)) (:background "LightBlue2"))
    (t (:bold t)))
  "Face used for marking warning lines."
  :group 'anything)

(defun anything-get-flymake-candidates ()
  (mapcar
   (lambda (err)
     (let* ((type (flymake-ler-type err))
            (text (flymake-ler-text err))
            (line (flymake-ler-line err)))
       (cons (propertize
              (format "[%s] %s" line text)
              'face (if (equal type "e") 'anything-flymake-errline 'anything-flymake-warnline))
             err)))
   anything-flymake-err-list))

(defun anything-flymake ()
  (interactive)
  (anything-other-buffer 'anything-c-source-flymake "*anything flymake*"))

;;
;; quickrun
;;______________________________________________________________________

;; ソース：https://github.com/syohex/emacs-quickrun
;; 開発者サイト：http://d.hatena.ne.jp/syohex/
;; 紹介記事：http://d.hatena.ne.jp/syohex/20111201/1322665378
;;         http://syohex.github.com/talks/20120428-kansai-emacs5-quickrun/#/title
;; インストール
;; (install-elisp "https://raw.github.com/syohex/emacs-quickrun/master/quickrun.el")

;; Usage
;; | M-x quickrun          | Run command, compiling, linking, executing. |
;; | M-x quickrun-with-arg | Run command with arguments.                 |
;; | M-x quickrun-lang     | Run command by specified language           |
(autoload 'quickrun "quickrun" nil t)
;; 結果の出力バッファと元のバッファを行き来したい場合は
;; ':stick t'の設定をするとよいでしょう
(push '("*quickrun*") popwin:special-display-config)
;; よく使うならキーを割り当てるとよいでしょう
(global-set-key (kbd "<f5>") 'quickrun)

;;; 新しい言語の対応
;; (quickrun-add-command "tora" '((:command . "tora")))
;; (add-to-list 'quickrun-file-alist '("\\.tra$" . "tora"))

;; C++11の例
;; (quickrun-add-command "c++/c++11"
;;                       '((:command . "g++")
;;                         (:exec    . ("%c -std=c++0x %o -o %n %s"
;;                                      "%n %a"))
;;                         (:remove  . ("%n")))
;;                       :default "c++")



(provide 'init_pgsupport)
;;; init_pgsupport.el ends here

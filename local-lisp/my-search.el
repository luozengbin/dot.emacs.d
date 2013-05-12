;;; my-search.el --- customize search function defination

;; Copyright (C) 2011  Zouhin.Ro

;; Author: Zouhin.Ro <jalen.cn@gmail.com>
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

;; 検索拡張関数
;; 参考情報：http://skalldan.wordpress.com/2011/11/09/ntemacs-%E3%81%A7-utf-8-%E3%81%AA%E7%92%B0%E5%A2%83%E6%A7%8B%E7%AF%89%E3%82%92%E8%A9%A6%E8%A1%8C%E9%8C%AF%E8%AA%A4/

;;; Code:

(require 'my-lisp-utils)

;;
;; grep拡張
;;______________________________________________________________________
(defun my-lgrep (regexp &optional files dir confirm)
  "lgrepのマルチバイト強化版"
  (interactive
   (progn
     (grep-compute-defaults)
     (cond
      ((and grep-find-command (equal current-prefix-arg '(16)))
       (list (read-from-minibuffer "Run: " grep-find-command
                                   nil nil 'grep-find-history)))
      ((not grep-find-template)
       (error "grep.el: No `grep-find-template' available"))
      (t (let* ((regexp (grep-read-regexp))
                (files (grep-read-files regexp))
                (dir (read-directory-name "Base directory: "
                                          nil default-directory t))
                (confirm (equal current-prefix-arg '(4))))
           (list regexp files dir confirm))))))
  (let ((grep-find-template (concat "find . -maxdepth 1 <X> -type f <F> -print0 | xargs -0 lgrep -n " (computeGrepOutputCodingOption) " -Ia <R> | grep <C> \"" regexp "\" --color=always ")))
    (rgrep regexp files dir confirm)))

(defun my-rgrep (regexp &optional files dir confirm)
  "rgrepのマルチバイト強化版"
  (interactive
   (progn
     (grep-compute-defaults)
     (cond
      ((and grep-find-command (equal current-prefix-arg '(16)))
       (list (read-from-minibuffer "Run: " grep-find-command
                                   nil nil 'grep-find-history)))
      ((not grep-find-template)
       (error "grep.el: No `grep-find-template' available"))
      (t (let* ((regexp (grep-read-regexp))
                (files (grep-read-files regexp))
                (dir (read-directory-name "Base directory: "
                                          nil default-directory t))
                (confirm (equal current-prefix-arg '(4))))
           (list regexp files dir confirm))))))
  (let ((grep-find-template (concat "find . <X> -type f <F> -print0 | xargs -0 lgrep -n  " (computeGrepOutputCodingOption) " -Ia <R> | grep <C> \"" regexp "\" --color=always ")))
    (rgrep regexp files dir confirm)))

(defun computeGrepOutputCodingOption ()
  "Process I/Oのコーディング値よりgrep出力コーディングオプションを決定する"
  (let (option-value)
    (if (string-match "utf" (symbol-name (car default-process-coding-system)))
        (setq option-value " -Ou ")
      (setq option-value " -Ou ") ;;(setq option-value " -Os ")
      )))

;; ;; Grep
;; (defadvice grep (around grep-coding-setup activate)
;;   (let ((coding-system-for-read 'utf-8))
;;     ad-do-it))

;;
;; 置換拡張
;;______________________________________________________________________
(defvar my-replace-auto-prepare-toggle t)
(defvar my-replace-auto-complete-toggle nil)
(defvar my-replace-lazy-highlight-toggle t)

(defun my-replace-auto-prepare-toggle ()
"置換パターンの自動設定を自動化するトグル関数"
  (interactive)
  (setq my-replace-auto-prepare-toggle
        (my-toggle-switch my-replace-auto-prepare-toggle "prepare auto replcement")))

(defun my-replace-auto-complete-toggle ()
  "置換文字列補完自動化するトグル関数"
  (interactive)
  (setq my-replace-auto-complete-toggle
        (my-toggle-switch my-replace-auto-complete-toggle "auto complete replcement")))

(defun my-replace-lazy-highlight-toggle ()
  "置換された文字をハイライトする機能のトグル関数"
  (interactive)
  (setq my-replace-auto-prepare-toggle
        (my-toggle-switch my-replace-auto-prepare-toggle "prepare auto replcement")))

(defun my-prepare-replace-from-string ()
  "置換パターンの自動展開。From: 選択された文字列、To: kill-ringに先頭の文字列"
  (when my-replace-auto-prepare-toggle
    (let ((replace-from (my-thing-at-point))
          (replace-to (car kill-ring)))
      (if (and replace-from replace-to)
          (setq query-replace-defaults
                (cons replace-from
                      (substring-no-properties replace-to)))))))

(defun my-replace-string (from-string to-string &optional delimited start end)
"バッファー内の文字列置換関数、置換対象の自動展開や入力補完ができます。"
  (interactive
   (let ((dummy (my-replace-highlight-cleanup))
         (common
          (my-query-replace-read-args
           (concat "Replace"
                   (if current-prefix-arg " word" "")
                   " string"
                   (if (and transient-mark-mode mark-active) " in region" ""))
           nil)))
     (list (nth 0 common) (nth 1 common) (nth 2 common)
           (if (and transient-mark-mode mark-active)
               (region-beginning))
           (if (and transient-mark-mode mark-active)
               (region-end)))))
  (cond (my-replace-lazy-highlight-toggle ;ハイライト機能有効の場合
         (let (start-point)
           ;; ハイライトための事前処理
           (setq start-point (my-replace-mark-exsits-to-text to-string))
           ;; 置換を行う
           (perform-replace from-string to-string nil nil delimited nil nil start end)
           ;; ハイライト処理
           (my-replace-highlight-to-text to-string start-point)))
        (t
         ;; 置換を行う
         (perform-replace from-string to-string nil nil delimited nil nil start end))))

(defun my-replace-mark-exsits-to-text (target-text)
  "カレントバッファーに指定した文字列にmy-replace-exsits-flag属性を追加する"
  (with-current-buffer (window-buffer (minibuffer-selected-window))
    (save-excursion
      (while (search-forward target-text nil t)
        (put-text-property (match-beginning 0) (1+ (match-beginning 0)) 'my-replace-exsits-flag t)))
    (point)))

(defun my-replace-highlight-to-text (target-text start-point)
"置換された文字列をハイライトする処理"
  (let (match-beg match-end replace-overlay
                  (properties '(my-replace-exsits-flag t)))
    (save-excursion
      (with-current-buffer (window-buffer (minibuffer-selected-window))
        (goto-char start-point)
        (my-replace-highlight-cleanup)
        (while (search-forward target-text nil t)
          (progn
            (setq match-beg (match-beginning 0))
            (setq match-end (match-end 0))
            (cond ((get-text-property match-beg 'my-replace-exsits-flag)
                   (remove-text-properties match-beg (1+ match-beg) properties))
                  ;; ハイライトレベルが２以上なら、書き換えられた単語にフェースを適用する
                  (my-replace-lazy-highlight-toggle
                   (setq replace-overlay (make-overlay match-beg match-end))
                   (overlay-put replace-overlay 'priority 1001)
                   (overlay-put replace-overlay 'face 'query-replace)
                   (push replace-overlay  my-replace-highlight-overlay-list)))))))))

(defun my-replace-highlight-cleanup ()
"置換処理起動されたハイライトを消す処理"
  (interactive)
  (when (not (boundp 'my-replace-highlight-overlay-list))
    (make-variable-buffer-local 'my-replace-highlight-overlay-list)
    (setq my-replace-highlight-overlay-list nil))
  (dolist (o my-replace-highlight-overlay-list)
    (delete-overlay o))
  (setq my-replace-highlight-overlay-list nil))

(defun my-query-replace-read-args (prompt regexp-flag &optional noerror)
"置換引数代入処理"
  (unless noerror
    (barf-if-buffer-read-only))
  (let* ((from (my-query-replace-read-from prompt regexp-flag))
         (to (if (consp from) (prog1 (cdr from) (setq from (car from)))
               (my-query-replace-read-to from prompt regexp-flag))))
    (list from to current-prefix-arg)))

(defun my-query-replace-read-from (prompt regexp-flag)
  "Query and return the `from' argument of a query-replace operation.
The return value can also be a pair (FROM . TO) indicating that the user
wants to replace FROM with TO."
  (if query-replace-interactive
      (car (if regexp-flag regexp-search-ring search-ring))

    ;; 置換パターンの代入
    (my-prepare-replace-from-string)

    (let* ((history-add-new-input nil)
           ;; 置換From文字列の取得
           (from
            ;; The save-excursion here is in case the user marks and copies
            ;; a region in order to specify the minibuffer input.
            ;; That should not clobber the region for the query-replace itself.
            (save-excursion
              (let ((echo-prompt
                     (if query-replace-defaults
                         ;; TODO: 出力の高さを制約する
                         (format "%s (default %s -> %s): " prompt
                                 (query-replace-descr (car query-replace-defaults))
                                 (query-replace-descr (cdr query-replace-defaults)))
                       (format "%s: " prompt))))
                (if my-replace-auto-complete-toggle
                    (completing-read
                     echo-prompt
                     ;; auto-complete経由で補完リストを取得する
                     (with-current-buffer (window-buffer (minibuffer-selected-window))
                       (let ((ac-prefix "")
                             (ac-point (point)))
                         (ac-word-candidates)))
                     nil nil
                     nil
                     query-replace-from-history-variable
                     nil t)
                  (read-from-minibuffer
                   echo-prompt
                   nil nil nil
                   query-replace-from-history-variable
                   nil t)
                  )))))

      (if (and (zerop (length from)) query-replace-defaults)
          (cons (car query-replace-defaults)
                (query-replace-compile-replacement
                 (cdr query-replace-defaults) regexp-flag))
        (add-to-history query-replace-from-history-variable from nil t)
        ;; Warn if user types \n or \t, but don't reject the input.
        (and regexp-flag
             (string-match "\\(\\`\\|[^\\]\\)\\(\\\\\\\\\\)*\\(\\\\[nt]\\)" from)
             (let ((match (match-string 3 from)))
               (cond
                ((string= match "\\n")
                 (message "Note: `\\n' here doesn't match a newline; to do that, type C-q C-j instead"))
                ((string= match "\\t")
                 (message "Note: `\\t' here doesn't match a tab; to do that, just type TAB")))
               (sit-for 2)))
        from))))

(defun my-query-replace-read-to (from prompt regexp-flag)
  "Query and return the `to' argument of a query-replace operation."
  (query-replace-compile-replacement
   (save-excursion
     (let* ((history-add-new-input nil)
            (echo-prompt (format "%s %s with: " prompt (query-replace-descr from)))
            (to (if my-replace-auto-complete-toggle
                    (completing-read
                     echo-prompt
                     ;; auto-complete経由で補完リストを取得する
                     (with-current-buffer (window-buffer (minibuffer-selected-window))
                       (let ((ac-prefix "")
                             (ac-point (point)))
                         (ac-word-candidates)))
                     nil nil
                     nil
                     query-replace-from-history-variable
                     nil t)
                  (read-from-minibuffer
                   echo-prompt
                   nil nil nil
                   query-replace-to-history-variable from t)
                  )))
       (add-to-history query-replace-to-history-variable to nil t)
       (setq query-replace-defaults (cons from to))
       to)
     )
   regexp-flag))


(provide 'my-search)
;;; my-search.el ends here

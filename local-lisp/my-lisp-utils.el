;;; my-lisp-utils.el --- util function for emacs lisp

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

;;

;;; Code:

;; 文字列を評価する関数
(defun my-util-eval-string (str)
  (eval (with-temp-buffer
          (insert str)
          (read (buffer-string)))))

;; straight-forward solution doing just string manipulation
;; it's rather heavy handed
(defun string-replace (from to string &optional re)
  "Replace all occurrences of FROM with TO in STRING.
All arguments are strings.
When optional fourth argument is non-nil, treat the from as a regular expression."
  (let ((pos 0)
        (res "")
        (from (if re from (regexp-quote from))))
    (while (< pos (length string))
      (if (setq beg (string-match from string pos))
          (progn
            (setq res (concat res
                              (substring string pos (match-beginning 0))
                              to))
            (setq pos (match-end 0)))
        (progn
          (setq res (concat res (substring string pos (length string))))
          (setq pos (length string)))))
    res))

;; the more emacs way to do it is to use
;; string-replace - which has the drawback of not knowing *where*
;; the replacement was done, so if you apply this technique to strings
;; you can end up in an infinite loop
;; try:   (string-replace "a" "aa" "a string contains a")
;; the "trick" is to put the string into a temporary buffer, like so:

(defun string-replace-2 (this withthat in)
  "replace THIS with WITHTHAT' in the string IN"
  (with-temp-buffer
    (insert in)
    (goto-char (point-min))
    (while (search-forward this nil t)
      (replace-match withthat nil t))
    (buffer-substring (point-min) (point-max))))

(defun toggle-letter-case ()
  "Toggle the letter case of current word or text selection.
Toggles between: “all lower”, “Init Caps”, “ALL CAPS”."
  (interactive)
  (let (p1 p2 (deactivate-mark nil) (case-fold-search nil))
    (if (region-active-p)
        (setq p1 (region-beginning) p2 (region-end))
      (let ((bds (bounds-of-thing-at-point 'word) ) )
        (setq p1 (car bds) p2 (cdr bds)) ) )

    (when (not (eq last-command this-command))
      (save-excursion
        (goto-char p1)
        (cond
         ((looking-at "[[:lower:]][[:lower:]]") (put this-command 'state "all lower"))
         ((looking-at "[[:upper:]][[:upper:]]") (put this-command 'state "all caps") )
         ((looking-at "[[:upper:]][[:lower:]]") (put this-command 'state "init caps") )
         ((looking-at "[[:lower:]]") (put this-command 'state "all lower"))
         ((looking-at "[[:upper:]]") (put this-command 'state "all caps") )
         (t (put this-command 'state "all lower") ) ) ) )

    (cond
     ((string= "all lower" (get this-command 'state))
      (upcase-initials-region p1 p2) (put this-command 'state "init caps"))
     ((string= "init caps" (get this-command 'state))
      (upcase-region p1 p2) (put this-command 'state "all caps"))
     ((string= "all caps" (get this-command 'state))
      (downcase-region p1 p2) (put this-command 'state "all lower")) )
    ) )

;; make windows happy
(defun my-shell-command-to-single-line (command-line)
  "execute shell command with single line response"
  (interactive)
   (replace-regexp-in-string
    "\n" ""
    (shell-command-to-string command-line)))

;;; cygpathコマンドでdosスタイルパスの取得
(defun my-dos-path (win-path)
  (my-shell-command-to-single-line
   (concat "cygpath --dos '" win-path "' | xargs -0 cygpath")))

;; PATH環境変数に値を追加する関数
(defun append-dirs-to-env-path (dirs)
  (dolist (dir (reverse dirs))
    (when (and (file-exists-p dir) (not (member dir exec-path)))
      (setenv "PATH" (concat dir path-separator (getenv "PATH")))
      (setq exec-path (append (list dir) exec-path)))))

(defun set-exec-path-from-shell-PATH ()
  (let ((path-from-shell (replace-regexp-in-string
                          "[ \t\n]*$" ""
                          (replace-regexp-in-string
                           "bash: .*$"
                           ""
                           (shell-command-to-string "$SHELL --login -i -c 'echo $PATH'")))))
    (setenv "PATH" path-from-shell)
    (dolist (path-entry (split-string path-from-shell path-separator))
      (setq exec-path (append exec-path (list path-entry))))))

;; 指定したシステム環境変数に値を追加する関数
(defun append-varlist-to-env (varlist env-key)
  (let ((path-sperator (if (eq system-type 'windows-nt) ";" ":")) )
    (dolist (current-var (reverse varlist))
      (setenv env-key (concat current-var path-sperator (getenv env-key))))))

(defun my-toggle-switch (toggle-var toggle-name)
"トグル変数を変更する関数"
  (message "Turn %s %s." (if toggle-var "Off" "On") toggle-name)
  (if toggle-var
      (setq toggle-var nil)
    (setq toggle-var t))
  )

(defun my-thing-at-point()
  "ポインターの上下文から取得可能な文字列を取得する関数"
  (interactive)
  (let ((string-at-point
         (if (region-active-p)
             (buffer-substring (region-beginning) (region-end))
           (if (thing-at-point 'symbol)
               (thing-at-point 'symbol)
             (thing-at-point 'word)))))
    (if string-at-point
        (substring-no-properties string-at-point))))

(defun my-string-trim (txt)
"文字列の先頭と後尾の空白文字を削る"
  (let ((ret txt))
    (setq ret (if (string-match "^\\s-*" ret)
                  (substring ret (match-end 0))
                ret))
    (or
     (loop for i downfrom (1- (length ret)) downto 0 do
           (if (/= 32 (char-syntax (aref ret i)))
               (return (substring ret 0 (1+ i)))))
     "")))

(defun smb-file-backslash-to-slash (smb-file-path)
  "バックスラッシュをスラッシュに変換する"
  (or (if (string-match "^\\\\\\\\.+" smb-file-path)
          (replace-regexp-in-string "\\\\" "/" smb-file-path t t nil 1))
      smb-file-path))

(defun my-unix-to-dos-filename (file)
  (replace-regexp-in-string "/" "\\\\" file))

(defun my-get-real-file-path ()
  "OSソフトが扱える物理パスを取得する"
  (interactive)
  (let ((file-path
         (case major-mode
           ('dired-mode
            (condition-case nil
                (dired-get-filename)
              (error (dired-current-directory))))
           (t
            (buffer-file-name)))))
    (if windows-p
        ;; windowsの場合/ → \ へ変換する
        (convert-standard-filename file-path)
      file-path)))

(defun my-kill-real-file-path ()
   "物理パスをkillリングに挿入する"
  (interactive)
  (kill-new (my-get-real-file-path)))

;;; 正規表現で関数をトレースする
(defun trace-function-regexp (regexp &optional buffer)
  (interactive
   (list
    (read-string "Trace function regexp: ")
    (read-buffer "Output to buffer: " trace-buffer)))
  (mapc 'trace-function (apropos-internal regexp 'fboundp)))

(defun trace-function-background-regexp (regexp &optional buffer)
  (interactive
   (list
    (read-string "Trace function background regexp: ")
    (read-buffer "Output to buffer: " trace-buffer)))
  (mapc 'trace-function-background (apropos-internal regexp 'fboundp)))


(defun my-log (log-bn &rest msgs)
  "ログ出力関数"
  (with-current-buffer (get-buffer-create log-bn)
    (goto-char (point-max))
    (insert (format "[%s] " (format-time-string "%Y/%m/%d %H:%M:%S")))
    (dolist (msg msgs)
      (insert (format "%s " msg)))
    (insert "\n")))


(defun my-cancel-timer-by-funcname (func-name)
  (loop for x in timer-list do
        (if (string-match (format ".*%s.*" (symbol-name func-name)) (prin1-to-string x))
            (cancel-timer x))))

;; 指定したファイルを dir を起点に探す為の関数
(defun find-file-upward (name &optional dir)
  (setq dir (file-name-as-directory (or dir default-directory)))
  (cond
   ((string= dir (directory-file-name dir))
    nil)
   ((file-exists-p (concat dir name))
    (expand-file-name name dir))
   (t
    (find-file-upward name (expand-file-name ".." dir)))))

(defun my-count-lines-window ()
  "Count lines relative to the selected window. The number of lines begins 0."
  (interactive)
  (let* ((window-string (buffer-substring-no-properties (window-start) (point)))
         (line-string-list (split-string window-string "\n"))
         (line-count 0)
         line-count-list)
    (setq line-count (1- (length line-string-list)))
    (unless truncate-lines      ; consider folding back
      ;; `line-count-list' is list of the number of physical lines which each logical line has.
      (setq line-count-list (mapcar '(lambda (str)
                                       (/ (my-count-string-columns str) (window-width)))
                                    line-string-list))
      (setq line-count (+ line-count (apply '+ line-count-list))))
    line-count))

(defun my-count-string-columns (str)
  "Count columns of string. The number of column begins 0."
  (with-temp-buffer
    (insert str)
    (current-column)))

;;; ----- copy & paste text with register
(defun copy-to-register-1 ()
  "Copy current line or text selection to register 1.
See also: `paste-from-register-1', `copy-to-register'."
  (interactive)
  (let ((inputStr
         (if (region-active-p)
             (substring-no-properties (buffer-string) (region-beginning) (region-end))
           (thing-at-point 'line))))
    (with-temp-buffer
      (insert inputStr)
      (copy-to-register ?1 (point-min) (point-max))
      (message "copied to register 1."))))

(defun paste-from-register-1 ()
  "paste text from register 1.
See also: `copy-to-register-1', `insert-register'."
  (interactive)
  (insert-register ?1 t))

;;; --- timer utils
(defun push-to-timer-queue (timer-queue-s delay-time interval-time form)
  (setf (symbol-value timer-queue-s)
        (append (symbol-value timer-queue-s)
                (list (run-with-timer delay-time interval-time form)))))

(defun pop-from-timer-queue (timer-queue-s &optional cleanup-form)
  (let* ((timer-queue (symbol-value timer-queue-s))
         (len (length timer-queue))
         (target-timer (nth (- len 1) timer-queue)))
    (cancel-timer target-timer)
    (setf (symbol-value timer-queue-s) (butlast timer-queue 1))
    (if cleanup-form
        (eval cleanup-form))))


;;; hiddenバッファー
(defun my-hidden-buffer-list ()
  (delq nil (mapcar '(lambda (x)
                       (if (string-match "^ \\*.*" (buffer-name x))
                           (buffer-name x))) (buffer-list))))

(provide 'my-lisp-utils)
;;; my-lisp-utils.el ends here

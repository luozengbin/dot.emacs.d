;;; fcopy.el --- Funny Copy mode -*-emacs-lisp-*-

;; Copyright (c) 1998-2003, 2012 Masayuki Ataka <masayuki.ataka@gmail.com>

;; Author: Masayuki Ataka <masayuki.ataka@gmail.com>
;; Keywords: convenience

;; This file is not part of GNU Emacs.

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 2, or (at your option)
;; any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program; if not, you can either send email to this
;; program's maintainer or write to: The Free Software Foundation,
;; Inc.; 59 Temple Place, Suite 330; Boston, MA 02111-1307, USA.

;;; Commentary:

;; Funny Copy (Fcopy) is a minor mode to copy text; first, set the
;; paste point, and next look for the text to copy.  The past point is
;; the point where fcopy-mode start.  One stroke commands are prepared
;; to search and copy the text.  Copy commands automatically take the
;; cursor back to the past point, insert the text, and exit
;; fcopy-mode.

;; `q' and `C-g' is for exit fcopy-mode.  `?' for more help.

;; If you want to move (cut) text, not to copy, type `C-d' to toggle
;; on delete flag.  If the buffer is originally read only, deleting
;; and copying will fail.

;; If some scratches are in your copy text, you can modify it before
;; paste.  Before the copy command, type `m' to toggle on modify flag.
;; It prepares modify buffer, that you can modify the text with
;; replacement or overwrite.  See `fmodify-default-mode' or `C-h m' in
;; the modify buffer.  To insert modified text, type `C-cC-c'.
;; `C-cC-q' for quit modifing, and paste nothing.

;; forward   backward   Unit of Moving
;; --------  --------   --------
;;  C-f       C-b       character
;;   f         b        word
;;   a         e        line (beginning or end)
;;   n         p        line (next or previous)
;;   A         E        sentence (beginning or end)
;;   N         P        paragraph
;;   v         V        scroll (up or down)
;; [space]  [backspace] scroll (up or down)
;;   s         r        incremental search
;;   S         R        incremental search with regexp
;;   <         >        buffer (beginning or end)
;;
;;
;; Jump Commands
;; --------
;;  g  Go to line
;;  j  Jump to register
;;  o  To other window
;;  x  Exchange point and mark
;;  ,  Pop mark ring
;;
;;
;; Copy Commands
;; --------
;;  .        Set mark
;;  c        Copy character
;;  C        Copy block
;;  w        Copy word
;;  W        Copy word (before copy, back to the beginning of word).
;;  k        Copy line behind point like kill-line
;; [return]  Copy region (if there is), or kill whole line
;;  (        Copy text between pair (...) chars.
;;  )        Likewise, but not copy pair chars.
;; C-c (     Copy text between parens.
;; C-c )     Likewise, but not copy parens.
;;
;;  m        Toggle modify flag.
;; C-d       Toggle delete flag.

;; The latest fcopy.el is available at:
;;
;;   https://github.com/ataka/fcopy
;;

;; The other simple copy command is destributed with Emacs.  See
;; misc.el in your lisp directory.  It copies characters from previous
;; nonblank line, starting just above point.  But remmember, fcopy has
;; no influences from misc.el.

;;; How to install:

;; To install, put this in your .emacs file:
;;
;;  (autoload 'fcopy-mode "fcopy" "copy lines or region without editing." t)
;;
;; And bind it to any key you like:
;;
;;  (define-key mode-specific-map "k" 'fcopy-mode)  ; C-c k for fcopy-mode
;;

;;; Version and ChangeLog:

(defconst fcopy-version "6.0"
  "Version numbers of this version of Funny Copy.")

;; ver 6.0
;; * Hosted at github.
;; * Support utf-8 (unsupport EUC-JP).

;; ver 5.2.6  (Rev. 2.43)
;; * fcopy skips black lines in line moving commands.
;;   If mark is active, they does not skip blank lines.
;; * New function fmodify-query-replace-regexp is binded to [M-RET].
;; * Fixed problem for negative and zero argument in line moving commands.
;; * Fixed bug of misscounting paren when copying text between parens.

;; ver 5.2.5  (Rev. 2.35)  2003/07/09 01:45:26
;; * fcopy now go back to the correct paste point when deleting before
;;   fcopy-point.

;; ver 5.2.4  (Rev. 2.32)  2003/06/16 10:45:47
;; * Fix for XEmacs.
;; * Find propper paren pair even the point is in the multiple parens.

;; ver 5.2.3  (Rev. 2.26)  2002/12/02 14:20:41
;; * Support move mode; delete text and copy it.
;; * [rutern] is to replace command, in fmodify edit mode.

;; ver 5.2.2  (Rev. 2.20)  2002/11/17 21:56:09  
;; * Fix problem that function regexp-opt in Emacs 20 caused error
;;   when strings contains Japanese character.

;; ver 5.2.1  (Rev. 2.16)  2002/11/12 01:27:27
;; * Change function of [space] to scroll-up.
;;   Use `.' to set mark.
;; * Change URL of Funny Copy support page.
;; * `(' now copy text between paired-strings like (...).
;;   `)' likewise, but does not copy the paired-strings.
;; * `;' copy comment text depending on major mode.

;; ver 5.2  2002/11/10 10:40:59  Masayuki Ataka
;; Minor version up of Funny Copy.  Merge fmodify.el.
;; Usage is in commentary section.

;; ver 5.1  2002/10/13 06:24:19  Masayuki Ataka
;; Minor version up of Funny Copy.  Use minor mode instead of major
;; mode.

;; ver 5.0  2002/09/06 05:54:06  Masayuki Ataka
;; The Fifth version of Funny Copy.  Remove tedious codes, like
;; `funny-copy-show-kill-ring', support of custom package, and a lot
;; of user options.  Make it sure to work with Emacs 19.

;; ver 4.0  2000/02/22 22:41:02  Masayuki Ataka
;; The Fourth version of Funny Copy.  Support Funny Modify mode.
;; New function nawe was `funny-copy-mode', binded to `C-c k'

;; ver 3.0  1999/04/24 00:17:33  Masayuki Ataka
;; Third version of Funny Copy.  Rewrite code from full scratch,
;; implemented with major mode.  New function nawe was
;; `MA-Special-copy-mode', means Masayuki Ataka special copy mode.
;; Also support seeing the inside of kill-ring.

;; ver 2.0  1998/09/??  Masayuki Ataka
;; Second version of Funny Copy.  Code name was `lupin'.  Copy text
;; interactively using cond.

;; ver 1.0  1998/08/??  Masayuki Ataka
;; First version of Funny Copy.  Just copy above line.  Command name
;; is `kill-above', and binded to `C-S-k'

;;; Code:

;;
;; User Option.
;;

(defvar fcopy-point-string "-!-"
  "*String where the point was.")

(defvar fcopy-pair-string-alist
  '(("(" . ")")
    ("{" . "}")
    ("[" . "]")
    ("<" . ">")
    ("「" . "」")
    ("『" . "』")
    ("/*" . "*/"))
   "*Alist of pair strings to copy between them.
Car is left string and cdr is right.

You should reflect the change to `fcopy-pair-regexp'.")

(defvar fcopy-spair-string-list
  '("'" "\"" "$" "|")
  "*List of one character string to copy between them.

You should reflect the change to `fcopy-spair-regexp'.")

(defvar fmodify-replace-copied-text nil
  "*t replace copied text modified one.
nil just append modified text to kill-ring.")

(defvar fmodify-default-mode 'edit
  "*Default mode in fmodify buffer.
symbols are 'edit or 'overwrite.")

(defvar fmodify-modify-buffer " *modify*"
  "Name of modify buffer.")

;;
;; System variables.
;;

(defvar fcopy-window nil)
(defvar fcopy-line   nil)
(defvar fcopy-column nil)
(defvar fcopy-point  nil)
(defvar fcopy-history-list nil)
(defvar fcopy-modify nil)
(defvar fcopy-delete nil)
(defvar fcopy-back   nil)

(defvar fcopy-buffer-read-only nil)
(make-variable-buffer-local 'fcopy-buffer-read-only)


;;;
;; Funny Copy
;;;


;;;###autoload
(defvar fcopy-mode nil
  "Toggle fcopy-mode.
Setting this variable directly does not take effect;
use the function `fcopy'.")
(make-variable-buffer-local 'fcopy-mode)

(unless (assq 'fcopy-mode minor-mode-alist)
  (setq minor-mode-alist
	(cons '(fcopy-mode fcopy-mode) minor-mode-alist)))


;;; key map

(defvar fcopy-mode-map nil)
(if fcopy-mode-map
    nil
  (let ((map (make-keymap))
	(key ?!))
    ;; destroy default keymap
    (while (<= key ?~)
      (define-key map
	(char-to-string key) 'fcopy-undefined)
      (setq key (1+ key)))
    ;; digit argument
    (define-key map "0" 'digit-argument)
    (define-key map "1" 'digit-argument)
    (define-key map "2" 'digit-argument)
    (define-key map "3" 'digit-argument)
    (define-key map "4" 'digit-argument)
    (define-key map "5" 'digit-argument)
    (define-key map "6" 'digit-argument)
    (define-key map "7" 'digit-argument)
    (define-key map "8" 'digit-argument)
    (define-key map "9" 'digit-argument)
    (define-key map "-" 'negative-argument)
    ;; quit and exit.
    (define-key map "q"    'fcopy-exit)
    (define-key map "\C-g" 'fcopy-quit)
    ;; copy region, line, and words
					;   (define-key map [return] 'fcopy-region-or-line)
    (define-key map "\C-m" 'fcopy-region-or-line)
    (define-key map "\e\C-m" 'fcopy-rectangle)
    (define-key map "k"  'fcopy-line)
					;   (define-key map "l"  'fcopy-whole-line)
    (if (featurep 'xemacs)
	(define-key map '(shift space) 'fcopy-block)
      (define-key map [?\S- ] 'fcopy-block))
    (define-key map "C"  'fcopy-block)
    (define-key map "w"  'fcopy-word)
    (define-key map "W"  'fcopy-entire-word)
    (define-key map "c"  'fcopy-char)
    ;; other file, buffer, and window.
    (substitute-key-definition 'find-file 'fcopy-find-file map global-map)
    (substitute-key-definition 'switch-to-buffer 'fcopy-switch-to-buffer map global-map)
    (substitute-key-definition 'other-window 'fcopy-other-window map global-map)
    (define-key map "o"  'fcopy-other-window)
    (define-key map "."  'fcopy-find-tag)
    (define-key map "l"  'fcopy-recenter)
    (substitute-key-definition 'recenter 'fcopy-recenter map global-map)
    (define-key map "("      'fcopy-between-pair)
    (define-key map ")"      'fcopy-between-pair-without-enclosure)
    (define-key map "'"      'fcopy-between-spair)
    (define-key map "\""     'fcopy-between-spair-without-enclosure)
    (define-key map ";"      'fcopy-comment)
    (define-key map "\C-c("  'fcopy-between-paren)
    (define-key map "\C-c)"  'fcopy-between-paren-without-enclosure)
    (define-key map "\C-c{"  'fcopy-between-brace)
    (define-key map "\C-c}"  'fcopy-between-brace-without-enclosure)
    (define-key map "\C-c["  'fcopy-between-bracket)
    (define-key map "\C-c]"  'fcopy-between-bracket-without-enclosure)
    (define-key map "\C-c<"  'fcopy-between-tag)
    (define-key map "\C-c$"  'fcopy-between-dollar)
    (define-key map "\C-c'"  'fcopy-between-quote)
    (define-key map "\C-c\"" 'fcopy-between-double-quote)
    (define-key map "\C-c`"  'fcopy-between-backquote)
    (define-key map "\C-c\\" 'fcopy-between-japanese-quote)
    (define-key map "\C-cL"  'fcopy-between-latex-env)
    ;; mark
    (define-key map "."  'set-mark-command)
    (define-key map "@"  'set-mark-command)
    (define-key map "h"  'mark-paragraph)
    (define-key map "^"  'fcopy-pop-mark-ring)
    (define-key map ","  'fcopy-pop-mark-ring)
    (define-key map "x"  'exchange-point-and-mark)
    ;; move
    (substitute-key-definition 'forward-char  'fcopy-forward-char  map global-map)
    (substitute-key-definition 'backward-char 'fcopy-backward-char map global-map)
    (define-key map "f"  'fcopy-forward-word)
    (define-key map "b"  'fcopy-backward-word)
    (define-key map "a"  'fcopy-beginning-of-line)
    (define-key map "e"  'fcopy-end-of-line)
    (define-key map "A"  'backward-sentence)
    (define-key map "E"  'forward-sentence)
    (define-key map "n"  'fcopy-next-line)
    (define-key map "p"  'fcopy-previous-line)
    (define-key map "N"  'forward-paragraph)
    (define-key map "P"  'backward-paragraph)
    (define-key map "v"  'scroll-up)
    (define-key map "V"  'scroll-down)
    (define-key map " "  'scroll-up)
    (define-key map [backspace] 'scroll-down)
    (define-key map "<"  'beginning-of-buffer)
    (define-key map ">"  'end-of-buffer)
    ;; jump
    (define-key map "g"  'goto-line)
    (define-key map "j"  'jump-to-register)
    (define-key map "s"  'isearch-forward)
    (define-key map "r"  'isearch-backward)
    (define-key map "S"  'isearch-forward-regexp)
    (define-key map "R"  'isearch-backward-regexp)
    (define-key map "O"  'occur)
    ;; help and toggle
    (define-key map "?"    'describe-mode)
    (define-key map "m"    'fcopy-toggle-modify)
    (define-key map "\C-d" 'fcopy-toggle-delete)
    (setq fcopy-mode-map map)))

(unless (assq 'fcopy-mode minor-mode-map-alist)
  (setq minor-mode-map-alist
	(cons (cons 'fcopy-mode fcopy-mode-map) minor-mode-map-alist)))

;;; Commands

;;;###autoload
(defun fcopy-mode (&optional arg)
  "Minor mode for copying text but not editing it.
Letters do not insert themselves.  Instead following commands are
provided.  Most commands take prefix arguments.

\\{fcopy-mode-map}

Entry to this mode calls the value of `fcopy-mode-hook' if that value
is non-nil."
  (interactive "*P")
  (if (and arg (< (prefix-numeric-value arg) 0))
      ;; Toggle off funny copy.
      (call-interactively 'fcopy-exit)
    ;; Toggle on funny copy.
    (unless fcopy-mode
      (setq fcopy-modify nil
	    fcopy-delete nil)
      (setq fcopy-window (current-window-configuration)
	    fcopy-column (current-column)
	    fcopy-point  (point)
	    fcopy-line   (save-excursion
			   (concat
			    (buffer-substring
			     (progn (forward-line 0) (point))
			     fcopy-point)
			    fcopy-point-string
			    (buffer-substring
			     fcopy-point
			     (progn (end-of-line) (point))))))
      ;; Main body
      (fcopy-enable)
      (run-hooks 'fcopy-mode-hook)
      (fcopy-show-line))))

(defun fcopy-enable ()
  "Turn on Fcopy mode."
  (unless fcopy-mode
    (setq fcopy-mode " FC"
	  fcopy-history-list (cons (current-buffer) fcopy-history-list))
    (if buffer-read-only
	(setq fcopy-buffer-read-only t)
      (setq buffer-read-only t))
    (force-mode-line-update))
  (fcopy-show-line))

(defun fcopy-disable ()
  "Turn off Fcopy mode."
  (fcopy-toggle-modify -1)
  (fcopy-toggle-delete -1)
  (save-excursion
    (while fcopy-history-list
      (set-buffer (car fcopy-history-list))
      (setq fcopy-mode nil
	    fcopy-history-list (cdr fcopy-history-list))
      (if fcopy-buffer-read-only
	  (setq fcopy-buffer-read-only nil)
	(setq buffer-read-only nil))))
  (setq fcopy-mode nil)
  (force-mode-line-update))

(defun fcopy-reset ()
  "Reset Fcopy variables."
  (setq fcopy-window nil
	fcopy-column nil
	fcopy-point  nil
	fcopy-line   nil))

(defun fcopy-undo-boundary ()
  "Set undo boundary where the point is."
  (undo-boundary)
  (setq buffer-undo-list (cons (point) buffer-undo-list)))

(defun fcopy-show-line ()
  "Show where to paste copied text."
  (message "Copy to: %s" fcopy-line))

(defun fcopy-undefined ()
  (interactive)
  (ding)
  (message "Undefined."))


;;; Quit and Exit.

(defun fcopy-exit (&optional interactive-p)
  "Exit fcopy-mode without point move.
If optional arg INTERACTIVE-P is nil, return window configuretion.
\\[fcopy-quit] move point back ot where fcopy start."
  (interactive '(t))
  (fcopy-disable)
  (unless interactive-p
    (set-window-configuration fcopy-window)
    (goto-char fcopy-point))
  (fcopy-reset))

(defun fcopy-quit ()
  "Exit fcopy-mode and back to where fcopy start.
\\[fcopy-exit] does not move point and exit fcopy."
  (interactive)
  (unwind-protect
      (keyboard-quit)
    (fcopy-exit)
    (when (not (pos-visible-in-window-p))
      (recenter))))


;;; Copy

(defun fcopy-append-to-kill-ring (beg end &optional replace delete)
  "Save text from BEG to END into kill-ring.
Optional third argument REPLACE non-nil means that STRING will replace
the front of the kill ring, rather than being added to the list.
If optional forth argument DELETE is non-nil, cut text and paste it."
  (kill-new (buffer-substring beg end) replace)
  (when fcopy-delete
    (when (eq fcopy-buffer-read-only t)
      (error "Buffer is read only."))
    (when (and (equal (car fcopy-history-list) (current-buffer))
	       (< beg fcopy-point))
      (if (< end fcopy-point)
	  (setq fcopy-point (- fcopy-point (- end beg)))
	(setq fcopy-back  (- end fcopy-point)
	      fcopy-point beg)))
    (let ((buffer-read-only nil))
	(delete-region beg end))))

(defun fcopy-insert ()
  "Exit fcopy and insert saved text."
  (if fcopy-modify
      (progn
	(fcopy-disable)
	(set-window-configuration fcopy-window)
	(goto-char fcopy-point)
	(fmodify-mode))
    ;; No modify prefix
    (fcopy-exit)
    (fcopy-undo-boundary)
    (insert (car kill-ring))
    (when fcopy-back
      (backward-char fcopy-back)
      (setq fcopy-back nil))))

(defun fcopy-line ()
  "Copy line behind point like `kill-line'.
Called just after `fcopy-mode', copy above line behind save column number."
  (interactive)
  (when (and (= (point) fcopy-point)
	     (= (length fcopy-history-list) 1))
    (forward-line -1)
    (move-to-column fcopy-column))
  (if (eolp)
      (progn
	(ding)
	(message "Failing fcopy.  It is end of line.")
	(goto-char fcopy-point))
    (let ((beg (point))
	  (end (progn (end-of-line) (point))))
      (fcopy-append-to-kill-ring beg end)
      (fcopy-insert))))

(defun fcopy-whole-line (&optional blank)
  "Copy whole line.
If optional argument BLANK is toggled, remove white spaces around line."
  (interactive "P")
  (let ((beg (progn
	       (forward-line 0)
	       (and blank (skip-chars-forward " \t"))
	       (point)))
	(end (progn
	       (end-of-line)
	       (and blank (skip-chars-backward " \t"))
	       (point))))
    (fcopy-append-to-kill-ring beg end)
    (fcopy-insert)))

(defun fcopy-word (&optional arg)
  "Copy ARG's forward words after point."
  (interactive "p")
  (let ((beg (point))
	(end (progn (forward-word arg) (point))))
    (fcopy-append-to-kill-ring beg end)
    (fcopy-insert)))

(defun fcopy-entire-word (&optional arg)
  "Copy ARG's forward words; if cursor is not beginning of word, back to the beginning."
  (interactive "p")
  (let ((beg (re-search-backward "\\w" nil t))
	(end (progn (forward-word arg) (point))))
    (fcopy-append-to-kill-ring beg end)
    (fcopy-insert)))

(defun fcopy-char (&optional arg)
  "Copy APG's forward charactors after point."
  (interactive "p")
  (let ((beg (point))
	(end (progn (forward-char arg) (point))))
    (fcopy-append-to-kill-ring beg end)
    (fcopy-insert)))

(defun fcopy-region-or-line ()
  "If mark is active call `fcopy-region', otherwise `fcopy-whole-line'."
  (interactive)
  (if (fcopy-mark-active-p)
      (call-interactively 'fcopy-region)
    (call-interactively 'fcopy-whole-line)))

(defun fcopy-region (beg end &optional blank)
  "Copy region from BEG to END.
If optional argument BLANG is toggled, shrink white spaces into one
space and remove line feed."
  (interactive "r\nP")
  (if blank
      (let ((buf (current-buffer)))
	(save-excursion
	  (with-temp-buffer
	    (insert-buffer-substring buf beg end)
	    (goto-char (point-min))
	    (save-excursion
	      (while (re-search-forward "[\n\t ]+" nil t)
		(replace-match " ")))
	    ;; Thanks to chiyu [15-05-2000].
	    ;; Omit spaces between Japanese 2 bites.
	    (while (re-search-forward
		    "\\(\\cj\\|\\ck\\) \\(\\cj\\|\\ck\\)" nil t)
	      (replace-match "\\1\\2"))
	    (fcopy-append-to-kill-ring (point-min) (point-max)))))
    (fcopy-append-to-kill-ring beg end))
  (fcopy-insert))

(defun fcopy-rectangle (beg end)
  "Copy rectangle from BEG to END."
  (interactive "r")
  (let ((rect (extract-rectangle beg end)))
    (fcopy-exit)
    (fcopy-undo-boundary)
    (insert-rectangle rect)))

(defun fcopy-block ()
  "Copy continuous block text.
The end of the continuous block text is blanks (space, tab, or newline).
If the point is in the blocks, skip blakns backward and copy block."
  (interactive)
  (let ((beg (progn
	       (when (looking-at "[ \t\n]")
		 (skip-chars-backward " \t\n"))
	       (skip-chars-backward "^ \t\n")
	       (point)))
	(end (progn (skip-chars-forward  "^ \t\n") (point))))
    (fcopy-append-to-kill-ring beg end)
    (fcopy-insert)))


;; Copy between pair strings and comments

(defvar fcopy-pair-regexp
  (if (or (< emacs-major-version 20) (featurep 'xemacs))
      ;; Function regexp-opt in Emacs 20.7 or XEmacs 21 fails to
      ;; produce correct regexp when the strings are mixed with
      ;; Japanese and English.
      "\\*/\\|/\\*\\|[]()<>[{}「-』]"
    (regexp-opt (append (mapcar (lambda (x) (car x)) fcopy-pair-string-alist)
			(mapcar (lambda (x) (cdr x)) fcopy-pair-string-alist)))))

(defun fcopy-between-pair (&optional arg without-enclosure)
  "Copy text between pair strings.

With prefix arg ARG, jump back ARG'th pair strings.
If the optional second argument WITHOUT-ENCLOSURE is non-nil,
do not copy pair strings and the blanks between copy text.

The pair strings are specified in variable `fcopy-pair-string-alist'.
Variable `fcopy-pair-regexp' which is automatically constructed from
`fcopy-pair-string-alist' is used to search one of the pair string.

*CAUTION*

If your Emacs is XEmacs or Emacs version is 19 or less, variable
`fcopy-pair-egexp' is not updated automatically.  So You shold edit
the variable when the value of `fcopy-pair-string-alist' is changed.
The regexp should match all strings in `fcopy-pair-string-alist'."
  (interactive "p")
  (unless arg (setq arg 1))
  (let ((pos (point))
	beg end
	match
	(count arg))
    ;; Left paren
    (while (> count 0)
      (unless (re-search-backward fcopy-pair-regexp nil t)
	(goto-char pos)
	(error "Not match left pattern of pair"))
      (setq match (match-string 0))
      (if (assoc match fcopy-pair-string-alist)
	  (setq count (1- count))
	(setq count (1+ count))))
    (when without-enclosure
      (forward-char (length match))
      (skip-chars-forward " \t\n"))
    (save-excursion
      (skip-chars-backward "\\\\")
      (setq beg (point)))
    ;; Right paren
    (if without-enclosure
	(goto-char beg)
      (forward-char 1))
    (setq count 1)
    (while (> count 0)
      (unless (re-search-forward fcopy-pair-regexp nil t)
	(goto-char pos)
	(error "Not match right pattern of pair"))
      (setq match (match-string 0))
      (if (rassoc match fcopy-pair-string-alist)
	  (setq count (1- count))
	(setq count (1+ count))))
    (when without-enclosure
      (backward-char (length match))
      (skip-chars-backward "\\\\ \t\n"))
    (setq end (point))
    ;; Fcopy insert
    (fcopy-append-to-kill-ring beg end)
    (fcopy-insert)))

(defun fcopy-between-pair-without-enclosure (&optional arg)
  "Copy text between pair strings (not include pair string).
With prefix arg ARG, jump back ARG'th pair strings.

See function `fcopy-between-pair' for more informatio."
  (interactive "p")
  (unless arg (setq arg 1))
  (fcopy-between-pair arg t))


(defvar fcopy-spair-regexp
  (if (fboundp 'regexp-opt)
      (regexp-opt fcopy-spair-string-list)
    "[\"$'|]"))

(defun fcopy-between-spair (&optional without-enclosure)
  "Copy text between single pair character.

If the optional argument WITHOUT-ENCLOSURE is non-nil,
do not copy pair strings and the blanks between copy text.

The single pair character is specified in variable
`fcopy-spair-string-list'.  Variable `fcopy-spair-regexp' which is
automatically constructed from `fcopy-spair-regexp' is used to search
one of the single pair character.

*CAUTION*
If your Emacs version is 19 or less, var `fcopy-spair-regexp' is not
updated automatically.  So You shold edit the variable when the value
of `fcopy-spair-string-list' is changed.  The regexp should match
all characters in `fcopy-spair-string-list'."
  (interactive)
  (let ((pos (point)) beg end left)
    ;; Search Left
    (unless (re-search-backward fcopy-spair-regexp nil t)
      (goto-char pos)
      (error "No match single pair"))
    (setq left (match-string 0))
    (when without-enclosure
      (forward-char 1)
      (skip-chars-forward " \t\n"))
    (save-excursion
      (skip-chars-backward "\\\\")
      (setq beg (point)))
    ;; Search right
    (forward-char 1)
    (unless (search-forward left nil t)
      (goto-char pos)
      (error "No match single pair"))
    (when without-enclosure
      (backward-char 1)
      (skip-chars-backward "\\\\ \t\n"))
    (setq end (point))
    ;; Fcopy insert
    (fcopy-append-to-kill-ring beg end)
    (fcopy-insert)))

(defun fcopy-between-spair-without-enclosure ()
  "Copy text between single pair string (not include pair character).
With prefix arg ARG, jump back ARG'th pair strings.

See function `fcopy-between-spair' for more information."
  (interactive)
  (fcopy-between-spair t))


(defun fcopy-comment (&optional no-comment-str)
  "Copy comments depending on the major mode.
Use var `comment-start' and `comment-end' to know the comment pattern.
If `comment-end' is empty, copy from comment-start till end-of-line.

If optional argument NO-COMMENT-STR is non-nil, does not copy
`comment-start', `comment-end', and the blans around comments."
  (interactive "P")
  (let* ((cstart comment-start)
	 (cend   comment-end)
	 (pos    (point))
	 (cerr  '(lambda () (goto-char pos) (error "No comment")))
	 beg end)
    ;; Search beginning of comment
    (if (string= cend "")
	(if (search-backward cstart nil t)
	    (progn
	      (forward-line 0)
	      (search-forward cstart)
	      (if no-comment-str
		  (skip-chars-forward (concat cstart " \t"))
		(backward-char (length cstart))))
	  (funcall cerr))
      (if (search-backward cstart nil t)
	  (when no-comment-str
	    (forward-char (length cstart))
	    (skip-chars-forward " \t\n"))
	(funcall cerr)))
    (setq beg (point))
    ;; Search end of comment
    (if (string= cend "")
	(end-of-line)
      (if (search-forward cend nil t)
	  (when no-comment-str
	    (backward-char (length cend))
	    (skip-chars-backward " \t\n"))
	  (funcall cerr)))
    (setq end (point))
    ;; Copy command
    (fcopy-append-to-kill-ring beg end)
    (fcopy-insert)))


(defun fcopy-between-* (left right arg without-enclosure)
  "Copy region between regexp LEFt and RIGHT.
If fourth argument WITHOUT-ENCLOSURE is nil, copy also LEFT and RIGHT.
Otherwise, does not copy them."
  (let (beg end)
    (save-excursion
      ;; Left
      (unless (re-search-backward left nil t arg)
	(error "No match %s" left))
      ;; Why Emacs mis-match \\\\*( in backward search??
      (when without-enclosure
	(forward-char (length (match-string 0)))
	(skip-chars-forward " \t\n"))
      (save-excursion
        (skip-chars-backward "\\\\")
	(setq beg (point)))
      ;; Right
      (forward-char 1)
      (unless (re-search-forward right nil t arg)
	(error "No match %s" right))
      (when without-enclosure
	(backward-char (length (match-string 0)))
	(skip-chars-backward "\\\\ \t\n"))
      (setq end (point)))
    (fcopy-append-to-kill-ring beg end)
    (fcopy-insert)))

(defun fcopy-between-paren (arg)
  "Copy text between `(' and `)'."
  (interactive "p")
  (fcopy-between-* "(" ")" arg nil))
(defun fcopy-between-paren-without-enclosure (arg)
  "Copr text betwenn `(' and `)' without pair of enclusurs."
  (interactive "p")
  (fcopy-between-* "(" ")" arg t))

(defun fcopy-between-brace (arg)
  "Copy text between `{' and `}'."
  (interactive "p")
  (fcopy-between-* "{" "}" arg nil))
(defun fcopy-between-brace-without-enclosure (arg)
  "Copr text betwenn `{' and `}' without pair of enclusurs."
  (interactive "p")
  (fcopy-between-* "{" "}" arg t))

(defun fcopy-between-bracket (arg)
  "Copy text between `[' and `]'."
  (interactive "P")
  (fcopy-between-* "\\[" "\\]" arg nil))
(defun fcopy-between-bracket-without-enclosure (arg)
  "Copr text betwenn `[' and `]' without pair of enclusurs."
  (interactive "p")
  (fcopy-between-* "\\[" "\\]" arg t))

(defun fcopy-between-tag (&optional without-enclosure)
  "Copy text between `<' and `>'.
If optional argument WITHOUT-ENCLOSURE is nil, copy `<' and `>', too."
  (interactive "P")
  (fcopy-between-* "<" ">" 1 without-enclosure))
(defun fcopy-between-dollar (&optional without-enclosure)
  "Copy text between dollars.
If optional argument WITHOUT-ENCLOSURE is nil, copy `$', too."
  (interactive "P")
  (fcopy-between-* "$" "$" 1 without-enclosure))

(defun fcopy-between-quote (&optional without-enclosure)
  "Copy text between single quotations.
If optional argument WITHOUT-ENCLOSURE is nil, copy citation mark, too."
  (interactive "P")
  (fcopy-between-* "'" "'" 1 without-enclosure))
(defun fcopy-between-double-quote (&optional without-enclosure)
  "Copy text between double quotations.
If optional argument WITHOUT-ENCLOSURE is nil, copy citation mark, too."
  (interactive "P")
  (fcopy-between-* "\"" "\"" 1 without-enclosure))
(defun fcopy-between-backquote (&optional without-enclosure)
  "Copy text between ``' and `''.
If optional argument WITHOUT-ENCLOSURE is nil, copy ``' and `'', too."
  (interactive "P")
  (fcopy-between-* "`" "'" 1 without-enclosure))
(defun fcopy-between-japanese-quote (&optional without-enclosure)
  "Copy text between `「' and `」'.
If optional argument WITHOUT-ENCLOSURE is nil, copy `「' and `」', too."
  (interactive "P")
  (fcopy-between-* "「" "」" 1 without-enclosure))

(defun fcopy-between-latex-env (&optional without-enclosure)
  "Copy text between `\\begin{...}' and `\\end{...}'.
If optional argument WITHOUT-ENCLOSURE is nil, copy LaTeX commad, too."
  (interactive "P")
  (fcopy-between-* "\\\\begin{.+}" "\\\\end{.+}" 1 without-enclosure))


;;; Other file, buffer, and window

(defun fcopy-find-file (file)
  "Find file FILE and enter fcopy."
  (interactive "ffind file: ")
  (find-file file)
  (fcopy-enable))

(defun fcopy-switch-to-buffer (buf)
  "Switch to buffer BUF and enter fcopy."
  (interactive "Bjumb to buffer: ")
  (let ((pop-up-windows t))
    (pop-to-buffer buf t)
    (fcopy-enable)))

(defun fcopy-other-window (&optional arg)
  "Select the ARG'th different window on this frame and enter fcopy."
  (interactive "p")
  (other-window arg)
  (fcopy-enable))

(autoload 'find-tag-interactive "etags" nil t)
(defun fcopy-find-tag (tag &optional next-p regexp-p)
  "Find tag (in current tags table) and enter fcopy."
  (interactive (find-tag-interactive "Find tag:"))
  (switch-to-buffer (find-tag-noselect tag next-p regexp-p))
  (fcopy-enable))

(defun fcopy-recenter (&optional arg)
  "Center point in window and redisplay frame
With prefix argument ARG, recenter putting point on screen line ARG
relative to the current window.  If ARG is negative, it counts up from the
bottom of the window.  (ARG should be less than the height of the window.)"
  (interactive "p")
  (recenter arg)
  (fcopy-show-line))


;;; mark

(defun fcopy-set-mark ()
  "Set mark where point is."
  (interactive)
  (push-mark nil t t)
  (fcopy-show-line))

(defun fcopy-pop-mark-ring ()
  "Jump to mark."
  (interactive)
  (if (fboundp 'pop-to-mark-command)
      (pop-to-mark-command)
    ;; Command pop-to-mark-command is first defined on [2002-04-14].
    ;; Following code is copied from simple.el on [2002-12-22].
    (if (null (mark t))
	(error "No mark set in this buffer")
      (goto-char (mark t))
      (pop-mark)))
  (fcopy-show-line))


;;; Move

(defun fcopy-step-char (arg)
  (forward-char arg)
  (fcopy-show-line))
(defun fcopy-forward-char (&optional arg)
  (interactive "p")
  (fcopy-step-char arg))
(defun fcopy-backward-char (&optional arg)
  (interactive "p")
  (fcopy-step-char (- arg)))

(defun fcopy-step-word (arg)
  ;; XEmacs automatically turn off region highlight.
  (if (boundp 'zmacs-region-stays)
      (setq zmacs-region-stays t))
  (forward-word arg)
  (fcopy-show-line))
(defun fcopy-forward-word (&optional arg)
  (interactive "p")
  (fcopy-step-word arg))
(defun fcopy-backward-word (&optional arg)
  (interactive "p")
  (fcopy-step-word (- arg)))

(defun fcopy-beginning-of-line (&optional arg)
  (interactive "p")
  ;; XEmacs automatically turn off region highlight.
  (if (boundp 'zmacs-region-stays)
      (setq zmacs-region-stays t))
  (beginning-of-line arg)
  (fcopy-show-line))
(defun fcopy-end-of-line (&optional arg)
  (interactive "p")
  ;; XEmacs automatically turn off region highlight.
  (if (boundp 'zmacs-region-stays)
      (setq zmacs-region-stays t))
  (end-of-line arg)
  (fcopy-show-line))

(defun fcopy-forward-line (arg)
  ;; XEmacs automatically turn off region highlight.
  (if (boundp 'zmacs-region-stays)
      (setq zmacs-region-stays t))
  (forward-line arg)
  (unless (fcopy-mark-active-p)
    (cond 
     ((= arg 0))			; If arg==0, do nothing.
     ((> arg 0) (skip-chars-forward " \t\n"))
     (t (end-of-line)
	(skip-chars-backward " \t\n"))))
  (move-to-column fcopy-column)
  (fcopy-show-line))
(defun fcopy-next-line (&optional arg)
  (interactive "p")
  (fcopy-forward-line arg))
(defun fcopy-previous-line (&optional arg)
  (interactive "p")
  (fcopy-forward-line (- arg)))


;;; Funny Copy Version

(defun fcopy-version (&optional here)
  "Return string describing the version of Funny Copy.
If optional argument HERE is non-nil, insert string at point."
  (interactive "P")
  (let ((version-string
	 (format "Funny Copy ver. %s."
		 fcopy-version)))
    (if here
	(insert version-string)
      (if (interactive-p)
	  (message "%s" version-string)
	version-string))))


;;; Toggle Functions

(defun fcopy-toggle-modify (&optional arg)
  "Toggle modify text or not."
  (interactive "P")
  (if (or fcopy-modify
	  (< (prefix-numeric-value arg) 0))
      (setq fcopy-modify nil)
    (setq fcopy-modify t))
  (fcopy-mode-line-update))

(defun fcopy-toggle-delete (&optional arg)
  "Toggle delete text or not."
  (interactive "P")
  (if (or fcopy-delete
	  (< (prefix-numeric-value arg) 0))
      (setq fcopy-delete nil)
    (setq fcopy-delete t))
  (fcopy-mode-line-update))

(defun fcopy-mode-line-update ()
  "Redisplay mode line identifier."
  (let ((mode 0))
    (when fcopy-modify (setq mode (+ mode 2)))
    (when fcopy-delete (setq mode (+ mode 1)))
    (cond
     ((= mode 0) (setq fcopy-mode " FC"))
     ((= mode 1) (setq fcopy-mode " FC:d"))
     ((= mode 2) (setq fcopy-mode " FC:m"))
     ((= mode 3) (setq fcopy-mode " FC:dm")))
    (force-mode-line-update)))

;;;
;; Funny Modify
;;;

;;; Commentary:
;;
;; Funny Modify (Fmodify) has two major modes to modify
;; text. `edit-mode' and `ovrewrite-mode'.
;;
;; Edit mode (replace)
;; ---------
;; C-c C-i   Insert modified text
;; C-c C-c   Insert modified text
;; C-c C-q   Quit fmodify mode
;;  o        To overwrite-mode
;;  r        show prompt for replace commands
;; [return]  replace region (if mark is active), or query replace
;; M-RET     query replace with regexp
;;  .        set mark
;;  
;;  ;        query replace
;;  :        query replae with regexp
;;  ,        query replace in the region
;;  +        replace string
;;  *        replace regexp
;;  m        replace only math number
;;
;;  c        capitalize word
;;  u        upcase word
;;  l        downcase word
;;
;;  d        delete character
;;  h        backward delete character with untabify
;;  D        delete word
;;  k        delete line after the point
;;  z        zap to character
;;
;;
;; Overwrite mode
;; ---------
;; C-c C-i   Insert modified text
;; C-c C-c   Insert modified text
;; C-c C-q   Quit fmodify mode
;; C-c C-e   To edit-mode
;;


;;;###autoload
(defun fmodify-mode ()
  "Major mode for edit copied text.
fmodify has two major mode; Edit mode and Overwrite mode.

If called directly, modified text is the last kill-ring element."
  (interactive "*")
  ;; Case of fmodify called directly; Without fcopy.
  ;; And if kill-ring is nil, then error message displays.
  (if (null kill-ring)
      (error "kill-ring is empty, Funny Modify doesn't work."))

  (if (interactive-p)
      (setq fcopy-window (current-window-configuration)
	    fcopy-point  (point)))
  (let ((mode fmodify-default-mode))
    (fmodify-pop-to-buffer)
    (cond
     ((eq mode 'edit)        (fmodify-edit-mode))
     ((eq mode 'overwrite)   (fmodify-overwrite-mode))
     (t  (unwind-protect
	     (error "Funny Modify failed.  Theres is no text in kill-ring.")
	   (fcopy-exit))))))

(defun fmodify-pop-to-buffer ()
  (pop-to-buffer fmodify-modify-buffer)
  (erase-buffer)
  (insert (car kill-ring))
  (set-buffer-modified-p nil)
  (goto-char (point-min))
  ;; resize window
  (let* ((lines  (count-lines (point-min) (point-max)))
	 (height (window-height))
	 (diff   (- height lines))
	 (min    (1+ window-min-height)))
    (if (< lines height)
	(if (< min diff)
	    (enlarge-window (- min height))
	  (enlarge-window (- diff))))))

(defun fmodify-insert ()
  "Insert modified text to original position where Funny Copy is done."
  (interactive)
  (fcopy-append-to-kill-ring (point-min) (point-max)
			     fmodify-replace-copied-text)
  (fcopy-insert))

(defun fmodify-quit ()
  "Exit fmodify mode."
  (interactive)
  (if (equal (buffer-name (current-buffer)) fmodify-modify-buffer)
      (kill-buffer fmodify-modify-buffer))
  (fcopy-exit))


;;; Edit mode

(defvar fmodify-edit-mode-map nil "Used in fmodify-edit mode")
(if fmodify-edit-mode-map
    nil
  (let ((map (make-keymap))
	(key ?!))
    ;; destroy default keymap
    (while (<= key ?~)
      (define-key map
	(char-to-string key) 'undefined)
      (setq key (1+ key)))
    (define-key map "\C-i"     'fmodify-insert)
    (define-key map "\C-c\C-i" 'fmodify-insert)
    (define-key map "\C-c\C-c" 'fmodify-insert)
    (define-key map "\C-c\C-q" 'fmodify-quit)
    (define-key map "\C-c\C-o" 'fmodify-overwrite-mode)
    (define-key map "o"        'fmodify-overwrite-mode)
    ;; digit argument
    (define-key map "0" 'digit-argument)
    (define-key map "1" 'digit-argument)
    (define-key map "2" 'digit-argument)
    (define-key map "3" 'digit-argument)
    (define-key map "4" 'digit-argument)
    (define-key map "5" 'digit-argument)
    (define-key map "6" 'digit-argument)
    (define-key map "7" 'digit-argument)
    (define-key map "8" 'digit-argument)
    (define-key map "9" 'digit-argument)
    (define-key map "-" 'negative-argument)
    ;; Move
    (define-key map "f" 'forward-word)
    (define-key map "b" 'backward-word)
    (define-key map "F" 'forward-sexp)
    (define-key map "B" 'backward-sexp)
    (define-key map "a" 'beginning-of-line)
    (define-key map "e" 'end-of-line)
    (define-key map "n" 'next-line)
    (define-key map "p" 'previous-line)
    (define-key map "A" 'backward-sentence)
    (define-key map "E" 'forward-sentence)
    (define-key map "N" 'forward-paragraph)
    (define-key map "P" 'backward-paragraph)
    (define-key map "<" 'beginning-of-buffer)
    (define-key map ">" 'end-of-buffer)

    (define-key map "r" 'fmodify-replace-prompt)
    (define-key map "\C-m" 'fmodify-query-replace)
    (define-key map "\e\C-m" 'fmodify-query-replace-regexp)
    (define-key map "w" 'fmodify-replace-word)
    (define-key map ";" 'query-replace)
    (define-key map ":" 'query-replace-regexp)
    (define-key map "+" 'replace-string)
    (define-key map "*" 'replace-regexp)
    (define-key map "," 'fmodify-replace-region)
    (define-key map "m" 'fmodify-math-replace)

    (define-key map "c" 'capitalize-word)
    (define-key map "u" 'upcase-word)
    (define-key map "l" 'downcase-word)

    (define-key map "." 'fcopy-set-mark)
    (define-key map "@" 'fcopy-set-mark)
    (define-key map "^" 'fcopy-pop-mark-ring)
    (define-key map "x" 'exchange-point-and-mark)

    (define-key map "i" 'fmodify-insert-from-minibuffer)

    (define-key map "d" 'delete-char)
    (define-key map "h" 'backward-delete-char-untabify)
    (define-key map "D" 'fmodify-delete-word)
    (define-key map "k" 'fmodify-kill-line)
    (define-key map "z" 'zap-to-char)

    (define-key map "?" 'describe-mode)
    (setq fmodify-edit-mode-map map)))


(defun fmodify-edit-mode ()
  "Major mode for editing copied text without inserting.

The other major mode is overwrite mode.  To enter overwrite mode,
type \\[fmodify-overwrite-mode].

Edit mode is easy to call replace command.  For exapmple,
\\[query-replace] is for `query-replace' and \\[query-replace-regexp]
is for `query-replace-regexp'.

When editing was finished, type \\[fmodify-insert] to insert modified
text to position where fcopy starts.

\\{fmodify-edit-mode-map}

Turning on Funny Modify overwrite mode runs the normal hook
`fmodify-overwrite-mode-hook'."
  (interactive)
  (overwrite-mode -1)
  (setq major-mode 'fmodify-edit-mode
	mode-name  "Funny Modify edit")
  (use-local-map fmodify-edit-mode-map)
  (message "Type C-c C-c to insert.  C-c C-q to quit.  C-c C-o to Overwrite mode."))


(defun fmodify-replace-prompt (replace)
  "Provide many replacement commands with one stroke.
key  Command
---  ------
m    fmodify-math-replace
r    fmodify-replace-region
w    fmodify-replace-word
s    replace-string
q    query-replace

Capital letter -- S and Q -- do replacement with REGEXP."
  (interactive "cReplace:  M)ath  W)ord  R)egion  S)tring  Q)uery  -- Capital for REGEXP")
  (cond
   ((eq replace ?m) (fmodify-math-replace))
   ((eq replace ?n) (fmodify-math-replace))
   ((eq replace ?-) (fmodify-math-replace))
   ((eq replace ?r) (call-interactively 'fmodify-replace-region))
   ((eq replace ? ) (call-interactively 'fmodify-replace-region))
   ((eq replace ?w) (fmodify-replace-word))
   ((eq replace ?s) (call-interactively 'replace-string))
   ((eq replace ?S) (call-interactively 'replace-regexp))
   ((>= replace ?a) (call-interactively 'query-replace))
   ((<= replace ?Z) (call-interactively 'query-replace-regexp))
   ))


(defun fmodify-kill-line (&optional arg)
  "Kill the rest of the current line.
With prefix argument, kill that many lines from point.
Negative arguments kill lines backward.

fmodify-kill-line kills the whole line including its terminating
newline, when used at the beginning of a line with no argument.  As a
consequence, you can always kill a whole line by typing `a C-k'"
  (interactive "p")
  (cond
   ((not arg) (setq arg 1))
   ((< arg 0) (setq arg (1+ arg)))
   ((= arg 0) (setq arg 1)))
  (delete-region (point) (progn (end-of-line arg) (point))))

(defun fmodify-insert-from-minibuffer (string)
  "Insert STRING from minibuffer in fmodify-edit-mode.
If you want to insert in overwrite mode, type `M-x overwrite-mode'.
Overwrite mode is turn off so that is to say, this is text mode."
  (interactive "sinsert: ")
  (insert string))

(defun fmodify-delete-word (arg)
  "Kill characters forward until encountering the end of a word.
With argument, do this that many times."
  (interactive "p")
  (delete-region (point) (progn (forward-word arg) (point))))

(defun fmodify-query-replace (arg)
  "If mark is active call `fmodify-replace-region', otherwise `query-replace'.
With prefix arg, use `replace-string' instead of `query-replace'.
Use \\[query-replace] if you hope the mark restrict the region of replacement."
  (interactive "P")
  (if (fcopy-mark-active-p)
      (call-interactively 'fmodify-replace-region)
    (if arg
	(call-interactively 'replace-string)
      (call-interactively 'query-replace))))

(defun fmodify-query-replace-regexp (arg)
  "Do `query-replace-regexp', or `replace-regexp' if called with prefix arg."
  (interactive "P")
  (if arg
      (call-interactively 'replace-regexp)
    (call-interactively 'query-replace-regexp)))

(defun fmodify-replace-region (beg end &optional all)
  "Replace string in region to TO-STRING.
With prefix argument, replace all strings with query."
  (interactive "r\nP")
  (let* ((from-string (buffer-substring beg end))
	 (to-string   (read-string
		       (format "Replace \"%s\" with: " from-string))))
    (if all
	(progn
	  (goto-char (point-min))
	  (query-replace from-string to-string))
      (delete-region beg end)
      (insert to-string))))

(defun fmodify-replace-word (&optional arg)
  "Replace ARG's word with TO-STRING.
Used from `fmodify-replace-prompt', Prefix argument can't work."
  (interactive "P")
  (let* ((arg (if arg arg 1))
	 (beg (point))
	 (end (progn (forward-word arg) (point)))
	 (from-string (buffer-substring beg end))
	 (to-string (read-string
		     (format "Replace \"%s\" with: " from-string))))
    (delete-region beg end)
    (insert to-string)))

(defun fmodify-math-replace ()
  "Search to numeric number and replace it"
  (interactive)
  (catch 'math-quit
    (while (re-search-forward "[+-＋−]?[0-9０-９,，]+[.．]?[0-9０-９]*" nil t)
      (let*
	  ((beg    (match-beginning 0))
	   (end    (match-end 0))
	   (string (buffer-substring beg end))
	   (char   (progn
		     (message "S)kip  Q)uit  Replace:  %s -> " string)
		     (read-char))))
	(cond
	 ((or (equal char ?-) (equal char ?+) (and (>= char ?0) (<= char ?9)))
	  (let
	      ((to-string
		(read-string
		 (format "Replace: %s -> " string)
		 (char-to-string char))))
	    (delete-region beg end)
	    (insert to-string)))
	 ;; N)ot reploce
	 ((equal char ?n)  nil)
	 ;; S)kip replace
	 ((equal char ?s)  nil)
	 ;; Q)uit math replaec
	 ((equal char ?q)
	  (throw 'math-quit t))
	 (t (error "Failed math replacement."))) ;exit cond block
	))))


;;; Overwrite mode

(defvar fmodify-overwrite-mode-map nil
  "Used in fmodify-overwrite mode")
(if fmodify-overwrite-mode-map
    nil
  (let ((map (copy-keymap text-mode-map)))
    (define-key map "\C-c\C-i" 'fmodify-insert)
    (define-key map "\C-c\C-c" 'fmodify-insert)
    (define-key map "\C-c\C-q" 'fmodify-quit)
    (define-key map "\C-c\C-e" 'fmodify-edit-mode)
    (define-key map " " 'fmodify-insert-space)
    (setq fmodify-overwrite-mode-map map)))


(defun fmodify-overwrite-mode ()
  "Major mode for modify copied text in overwrite minor mode.

The other major mode is edit mode.  To enter edit mode, type
\\[fmodify-edit-mode].

In overwrite mode, every command but [space] overwrite char.  [space]
do not overwrite but insert itself.

When modifing was finished, type \\[fmodify-insert] to insert modified
text to position where fcopy starts.

\\{fmodify-overwrite-mode-map}

Turning on Funny Modify overwrite mode runs the normal hook
`fmodify-overwrite-mode-hook'."
  (interactive)
  (overwrite-mode 1)
  (setq major-mode 'text-mode
	mode-name  "Funny Modify overwrite")
  (use-local-map fmodify-overwrite-mode-map)
  (run-hooks 'fmodify-overwrite-mode-hook)
  (message "Type C-c C-c to insert.  C-c C-q to quit.  C-c C-e to Edit mode."))


(defun fmodify-insert-space (&optional arg)
  "insert ARG's space to overwrite mode buffer."
  (interactive "p")
  (unless arg (setq arg 1))
  (let ((overwrite-mode nil))
    (insert-char ? arg)))


;;;
;; Codes to absorb system and version dependencies.
;;;

(defun fcopy-mark-active-p ()
  "Return non-nil if mark is active."
  (if (boundp 'mark-active)
      mark-active
    (region-exists-p)))

;;;
(provide 'fcopy)

;;; End of fcopy.el
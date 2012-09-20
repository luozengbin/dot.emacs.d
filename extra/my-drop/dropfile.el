;;; dropfile.el --- Drag and Drop a file

;; Author: Yuuichi Teranishi <teranisi@gohome.org>
;; Keywords: Windows, Icon

;; Copyright (C) 2004 Yuuichi Teranishi <teranisi@gohome.org>

;; This file is not part of GNU Emacs

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 2, or (at your option)
;; any later version.
;;
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs; see the file COPYING.  If not, write to the
;; Free Software Foundation, Inc., 59 Temple Place - Suite 330,
;; Boston, MA 02111-1307, USA.
;;

;;; Commentary:
;;

;;; History:
;;

;;; Code:
(eval-when-compile (require 'cl))

(defgroup dropfile nil
  "Drag and Drop a file."
  :group 'image)

(defcustom dropfile-program "dropfile.exe"
  "Program name of dropfile."
  :type 'file
  :group 'dropfile)

(defcustom dropfile-temporary-directory (or temporary-file-directory
					    (getenv "TEMP"))
  "Temporary file directory."
  :type 'file
  :group 'dropfile)

(defcustom dropfile-work-directory "dropfile"
  "Working directory under temporary file directory."
  :type 'file
  :group 'dropfile)

(defun dropfile-work-directory ()
  "Get temporary working directory dropfile."
  (let ((workdir (expand-file-name dropfile-work-directory
				   dropfile-temporary-directory)))
    (unless (file-directory-p workdir)
      (make-directory workdir))
    workdir))

(defun dropfile-make-file (file)
  "Make temporary file named FILE with current buffer content.
Return the full-path."
  (let ((coding-system-for-write 'binary)
	(outfile (expand-file-name (file-name-nondirectory file)
				   (dropfile-work-directory)))
	(write t)
	elem last-modtime cur-modtime)
    (when (file-exists-p outfile)
      (if (setq elem (assoc outfile dropfile-temporary-files))
	  (progn
	    (setq last-modtime (cdr elem)
		  cur-modtime (nth 5 (file-attributes (car elem))))
	    (when (or (> (car cur-modtime) (car last-modtime))
		      (and (= (car cur-modtime) (car last-modtime))
			   (> (cadr cur-modtime) (cadr last-modtime))))
	      (unless (yes-or-no-p "File is modified by last drop. override?")
		(setq write nil))))
	;; Another emacs is running...?
	(error "Temporary file '%s' already exists (remove it first to drop)"
	       outfile)))
    (when write
      (write-region (point-min) (point-max) outfile nil 'silent))
    outfile))

(defun dropfile-make-directory (dir)
  "Make temporary directory named FILE.
Return the full-path."
  (setq dir (directory-file-name (file-name-as-directory dir)))
  (let ((coding-system-for-write 'binary)
	(outdir (expand-file-name (file-name-nondirectory dir)
				  (dropfile-work-directory)))
	(copy t)
	elem last-modtime cur-modtime)
    (when (file-exists-p outdir)
      (if (setq elem (assoc outdir dropfile-temporary-files))
	  (progn
	    (setq last-modtime (cdr elem)
		  cur-modtime (nth 5 (file-attributes (car elem))))
	    (when (or (> (car cur-modtime) (car last-modtime))
		      (and (= (car cur-modtime) (car last-modtime))
			   (> (cadr cur-modtime) (cadr last-modtime))))
	      (unless (yes-or-no-p "File is modified by last drop. override?")
		(setq copy nil))))
	;; Another emacs is running...?
	(error "Temporary file '%s' already exists (remove it first to drop)"
	       outdir)))
    (when copy
      (cond
       ((and (file-regular-p outdir) (file-writable-p outdir))
	(delete-file outdir))
       ((file-directory-p outdir)
	(delete-directory outdir)))
      (require 'dired-aux)
      (let ((dired-recursive-copies 'top)
	    (dired-copy-preserve-time t))
	(dired-copy-file dir outdir 'ok)))
    outdir))

(defvar dropfile-temporary-files nil)

(defun dropfile-cleanup-temporary-files ()
  (let (removed)
    (dolist (elem dropfile-temporary-files)
      (if (file-exists-p (car elem))
	  (let ((cur-modtime (nth 5 (file-attributes (car elem))))
		(last-modtime (cdr elem)))
	    (when (or (and (= (car cur-modtime) (car last-modtime))
			   (= (cadr cur-modtime) (cadr last-modtime)))
		      (and (or (> (car cur-modtime) (car last-modtime))
			       (and (= (car cur-modtime)
				       (car last-modtime))
				    (> (cadr cur-modtime)
				       (cadr last-modtime))))
			   (y-or-n-p
			    (format
			     "Temporary file '%s' is modified. remove?"
			     (car elem)))))
	      (ignore-errors
		(cond
		 ((file-directory-p (car elem))
		  (delete-directory (car elem)))
		 ((file-writable-p (car elem))
		  (delete-file (car elem))))
		(setq removed (cons elem removed)))))
	(setq removed (cons elem removed))))
    (dolist (elem removed)
      (setq dropfile-temporary-files (delq elem dropfile-temporary-files)))))

;; (eval-and-compile
;;   (if (fboundp 'unix-to-dos-filename)
;;       (defalias 'dropfile-unix-to-dos-filename 'unix-to-dos-filename)
;;     (defun dropfile-unix-to-dos-filename (file)
;;       (with-temp-buffer
;; 	(insert file)
;; 	(goto-char (point-min))
;; 	(while (search-forward "/" nil t)
;; 	  (replace-match "\\" nil t))
;; 	(buffer-string)))))

(defun dropfile-unix-to-dos-filename (file)
  (with-temp-buffer
    (insert file)
    (goto-char (point-min))
    (while (search-forward "/" nil t)
      (replace-match "\\" nil t))
    (buffer-string)))

;;; dropfile API.
(defun dropfile (file &optional buffer)
  "Drag and Drop a FILE.
If BUFFER is specified, a file named FILE with BUFFER content is dropped.
If TIMEOUT is specified, dragging starts after TIMEOUT miliseconds.
In this case, return value is the timer object."
  (cond
   (buffer
    (setq file (with-current-buffer buffer (dropfile-make-file file))))
   ((and (not (string-match "^[a-zA-Z]:/" (expand-file-name file)))
	 (not (string-match "^//[^/]" (expand-file-name file)))
	 (file-directory-p (expand-file-name file)))
    (setq file (dropfile-make-directory file))
    (setq buffer t))
   ((and (not (string-match "^[a-zA-Z]:/" (expand-file-name file)))
	 (not (string-match "^//[^/]" (expand-file-name file))))
    (with-temp-buffer
      (let ((coding-system-for-read 'binary))
	(insert-file-contents file)
	(setq file (with-current-buffer (current-buffer)
		     (dropfile-make-file file))))
      (setq buffer t))))
  (unwind-protect
      (call-process dropfile-program nil nil nil
		    (dropfile-unix-to-dos-filename file))
    (when buffer
      (let ((match (assoc file dropfile-temporary-files)))
	(when match
	  (setq dropfile-temporary-files (delq match
					       dropfile-temporary-files))))
      (setq dropfile-temporary-files
	    (cons (cons file (nth 5 (file-attributes file)))
		  dropfile-temporary-files)))))

(add-hook 'kill-emacs-hook 'dropfile-cleanup-temporary-files)

(provide 'dropfile)

;;; dropfile.el ends here

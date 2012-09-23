;;; dired-dispicon.el --- dispicon & dropfile on dired

;; Author: Hideyuki SHIRAI <shirai@meadowy.org>
;;         Yuuichi Teranishi <teranisi@gohome.org>
;; Keywords: Windows, Icon

;; Copyright (C) 2005 Hideyuki SHIRAI <shirai@meadowy.org>
;;                    Yuuichi Teranishi <teranisi@gohome.org>

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
;; Put following on your '.emacs' file.
;;
;; (autoload 'dired-dispicon-setup
;;           "dired-dispicon" "dispicon & dropfile on dired" t)
;; (add-hook 'dired-mode-hook
;;	  (lambda ()
;;	    (define-key dired-mode-map "\C-c\C-d" 'dired-dispicon-toggle)
;;	    (define-key dired-mode-map "\C-c\C-t" 'dired-dispicon-toggle-type)
;;	    (define-key dired-mode-map "\C-c\C-v" 'dired-dispicon-do-view-thumbnail)
;;	    (dired-dispicon-setup)))

;;; History:
;;
;; Appeared on Hideyuki SHIRAI's blog on June 2005.
;;

;;; Code:
(require 'dired)
(require 'dispicon)
(require 'dropfile)

(defcustom dired-dispicon-default-display-icon nil
  "*Non-nil forces display icon by default."
  :group 'dired
  :type 'boolean)

(defcustom dired-dispicon-default-display-type 'small
  "*The icon type by default."
  :group 'dired
  :type '(choice (const :tag "Small Icon" small)
		 (const :tag "Large Icon" large)))


(defcustom dired-dispicon-display-type-candidates '(small large)
  "*A candidate list of the icon type."
  :group 'dired
  :type '(repeat (choice (const :tag "Small Icon" small)
			 (const :tag "Large Icon" large))))
                      ;; (const :tag "Thumbnail" thumbnail))))

(defcustom dired-dispicon-large-size 32
  "*The size of the large icon."
  :group 'dired
  :type 'integer)

(defcustom dired-dispicon-thumbnail-size 96
  "*The size of the thumbnail."
  :group 'dired
  :type 'integer)

(defcustom dired-dispicon-inhibit-stealth-fontify t
  "*Non-nil inhibits stealth fontifiy."
  :group 'dired
  :type 'boolean)

(defconst dired-dispicon-display-types '(small large thumbnail))

;; Buffer local variable.
(make-variable-buffer-local 'dired-dispicon-display-icon)
(defvar dired-dispicon-display-icon nil)
(make-variable-buffer-local 'dired-dispicon-display-type)
(defvar dired-dispicon-display-type nil)

;; Icon cache.
(defvar dired-dispicon-icon-alist nil)
(defvar dired-dispicon-icon-alist-length 1024)

;; Advice for jit-lock-stealth-fontify...
(defadvice jit-lock-stealth-fontify (around
				     jit-lock-stealth-fontify-dired-dispicon
				     activate)
  (message "xxxx")
  (when (or (not (eq major-mode 'dired-mode))
	    (not dired-dispicon-inhibit-stealth-fontify))
    ad-do-it))

(defun dired-dispicon-setup ()
  "Setup function for `dired-dispicon'."
  (interactive)
  (setq dired-dispicon-display-icon dired-dispicon-default-display-icon)
  (setq dired-dispicon-display-type dired-dispicon-default-display-type)
  (jit-lock-register 'dired-dispicon-fontify-region))

(defun dired-dispicon-toggle (&optional args)
  "Toggle display icons.
If optional ARGS are non-nil, force display icons."
  (interactive "P")
  (when (eq major-mode 'dired-mode)
    (setq dired-dispicon-display-icon (or args
					  (not dired-dispicon-display-icon)))
    (message "Dired dispicon: %s" (if dired-dispicon-display-icon "ON" "off"))
    (revert-buffer)))

(defun dired-dispicon-toggle-type (&optional ask)
  "Toggle display icon type.
If optional ASK is non-nil, ask the type."
  (interactive "P")
  (let ((candidates dired-dispicon-display-type-candidates)
	match ovls ovl)
    (when (eq major-mode 'dired-mode)
      (setq dired-dispicon-display-type
	    (cond
	     (ask
	      (intern
	       (completing-read "Type: "
				(mapcar (lambda (c)
					  (list (symbol-name c)))
					dired-dispicon-display-types)
				nil t)))
	     ((and (catch 'loop
		     (setq ovls (overlays-in (point-min) (point-max)))
		     (while (setq ovl (car ovls))
		       (setq ovls (cdr ovls))
		       (when (eq (overlay-get ovl 'dispicon) 'thumbnail)
			 (throw 'loop t))))
		   (not (eq dired-dispicon-display-type 'thumbnail)))
	      dired-dispicon-display-type)
	     (t
	      (or (if (setq match (memq dired-dispicon-display-type
					candidates))
		      (nth 1 match))
		  (car candidates)))))
      (revert-buffer))))

(defun dired-dispicon-do-view-thumbnail (&optional arg)
  "View thumbnails."
  (interactive "P")
  (let ((dired-no-confirm t))
    (dired-map-over-marks-check
     'dired-dispicon-view-thumbnail arg 'view-thumbnal nil)))

(defun dired-dispicon-view-thumbnail ()
  (let (file)
    (condition-case err
	(let ((buffer-read-only nil)
	      (inhibit-read-only t)
	      (after-change-functions nil)
	      (inhibit-point-motion-hooks t)
	      (type 'thumbnail)
	      (fail t)
	      oldtype beg end ovls ovl map)
	  (when (and (dired-move-to-filename)
		     (get-text-property (point) 'dropfile))
	    (setq beg (point))
	    (dired-move-to-end-of-filename)
	    (setq end (point))
	    ;; Error occur ".", ".." in dired-get-filename()
	    (setq file (expand-file-name (buffer-substring beg end)
					 dired-directory))
	    (setq ovls (overlays-in beg end))
	    (setq fail
		  (catch 'loop
		    (while (setq ovl (car ovls))
		      (setq ovls (cdr ovls))
		      (setq oldtype (overlay-get ovl 'dispicon))
		      (when oldtype
			(setq map (overlay-get ovl 'keymap))
			(when (eq oldtype 'thumbnail)
			  (setq type
				(or (and (eq dired-dispicon-display-type
					     'thumbnail)
					 (car dired-dispicon-display-type-candidates))
				    dired-dispicon-display-type)))
			(delete-overlay ovl)
			(throw 'loop nil)))))
	    (unless fail
	      (setq ovl (make-overlay beg end))
	      (overlay-put ovl 'before-string
			   (propertize
			    (dired-dispicon
			     file
			     type
			     (cond
			      ((eq type 'thumbnail)
			       dired-dispicon-thumbnail-size)
			      ((eq type 'large)
			       dired-dispicon-large-size)
			      (t
			       (aref (font-info
				      (face-font 'default (selected-frame)))
				     3))))
			    'keymap map))
	      (overlay-put ovl 'keymap map)
	      (overlay-put ovl 'dispicon type)
	      (overlay-put ovl 'evaporate t)))
	  fail)
      (error
       (dired-log "View thumbnail error for %s %s"
		  (or file (dired-get-filename)) err)
       (dired-make-relative (or file (dired-get-filename)))))))

(defun dired-dispicon-fontify-region (&optional beg end)
  "A function for `jit-lock-register'.
A region specified by BEG and END is fontified."
  (let ((buffer-read-only nil)
        (inhibit-read-only t)
        (after-change-functions nil)
        (inhibit-point-motion-hooks t))
    (save-excursion
      (setq beg (or beg (point-min)))
      (setq end (or end (point-max)))
      (goto-char beg)
      (while (< (point) end)
        (condition-case nil
            (when (dired-move-to-filename)
              (unless (get-text-property (point) 'dropfile)
                (let ((beg (point))
                      end file map)
                  (add-text-properties
                   beg
                   (setq end (save-excursion
                               (dired-move-to-end-of-filename)
                               (point)))
                   '(
                     ;; mouse-face highlight
                     ;; help-echo "mouse-1: visit this file in other window"
                     dropfile t))
                  (setq file (buffer-substring beg end)
                        file (expand-file-name file dired-directory)
                        map (make-sparse-keymap))
                  (define-key map [down-mouse-1] `(lambda ()
                                                    (interactive)
                                                    (dropfile ,file)))
                  (let ((ovl (make-overlay beg end))
                        (ddir (expand-file-name dired-directory)))
                    (if (and dired-dispicon-display-icon
                             ;; (or (string-match "^[a-zA-Z]:" ddir)
                             ;;     (string-match "^//[^/]" ddir))
                             )
                        (message "xxx")
                      (overlay-put ovl 'before-string
                                   (propertize
                                    (dired-dispicon
                                     file
                                     dired-dispicon-display-type
                                     (cond
                                      ((eq dired-dispicon-display-type
                                           'thumbnail)
                                       dired-dispicon-thumbnail-size)
                                      ((eq dired-dispicon-display-type
                                           'large)
                                       dired-dispicon-large-size)
                                      (t
                                       (aref (font-info
                                              (face-font
                                               'default (selected-frame)))
                                             3))))
                                    'keymap map)))
                    (overlay-put ovl 'keymap map)
                    (overlay-put ovl 'dispicon dired-dispicon-display-type)
                    (overlay-put ovl 'evaporate t)))))
          (error nil))
        (forward-line 1))
      (set-buffer-modified-p nil))))

(defun dired-dispicon (filename &optional type
				size depth bgcolor ignore-errors)
  "Wrapper function of `dispicon' which caches mini icons.
FILENAME, TYPE, SIZE, DEPTH, BGCOLOR, IGNORE-ERRORS are passed to `dispicon'."
  (let* ((name (downcase filename))
	 (nondir (file-name-nondirectory name))
	 ext iconkey icon)
    (setq type (or type dispicon-default-type))
    (setq size (or size dispicon-default-size))
    (cond
     ((or (file-directory-p filename)
	  (string= nondir ""))
      (setq ext "DIR"))
     ((or (not (string-match "\\." nondir))
	  (string-match "\\.$" nondir))
      (setq ext "TXT"))
     ((string-match "\\.\\([^.]+\\)$" nondir)
      (setq ext (match-string 1 nondir))
      (when (member ext '("exe" "dll" "ico" "bmp"))
	(setq ext name)))
     (t
      (setq ext "TXT")))
    (if (eq type 'thumbnail)
	(setq icon (dispicon filename type size depth bgcolor ignore-errors))
      (setq iconkey (format "%s:%s:%d" ext type size))
      (setq icon (cdr (assoc iconkey dired-dispicon-icon-alist)))
      (if icon
	  (setq dired-dispicon-icon-alist
		(delete (cons iconkey icon) dired-dispicon-icon-alist))
	(setq icon (dispicon filename type size depth bgcolor ignore-errors)))
      (setq dired-dispicon-icon-alist
	    (cons (cons iconkey icon) dired-dispicon-icon-alist)))
    (when (> (length dired-dispicon-icon-alist)
	     dired-dispicon-icon-alist-length)
      (setcdr (nthcdr (1- dired-dispicon-icon-alist-length)
		      dired-dispicon-icon-alist) nil))
    icon))

(provide 'dired-dispicon)

;;; dired-dispicon.el ends here

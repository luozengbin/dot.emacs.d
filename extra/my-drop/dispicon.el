;;; dispicon.el --- Display an icon which associates to the file.

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

;;; User variables.
(defgroup dispicon nil
  "Display an Windows icon."
  :group 'image)

(defcustom dispicon-default-type 'large
  "Default type of dispicon."
  :type '(choice (const :tag "Large Icon" 'large)
		 (const :tag "Small Icon" 'small))
  :group 'dispicon)

(defcustom dispicon-default-size 32
  "Default size of dispicon (width and height)."
  :type 'integer
  :group 'dispicon)

(defcustom dispicon-default-depth 24
  "Default depth of dispicon."
  :type 'integer
  :group 'dispicon)

(defcustom dispicon-default-bgcolor nil
  "Default background color of dispicon.
nil means to use the default face background."
  :type 'integer
  :group 'dispicon)

(defcustom dispicon-program "dispicon.exe"
  "Program name of dispicon."
  :type 'file
  :group 'dispicon)

(defcustom dispicon-image-type 'bmp
  "Image type of `dispicon-program' output."
  :type 'symbol
  :group 'dispicon)

(defun dispicon-default-background ()
  "Obtain background color of default face."
  (let ((rgb (color-values (or (frame-parameter
				(selected-frame) 'background-color)
			       "White"))))
    (format "#%02X%02X%02X"
	    (* 255 (/ (float (nth 2 rgb)) 65535))
	    (* 255 (/ (float (nth 1 rgb)) 65535))
	    (* 255 (/ (float (nth 0 rgb)) 65535)))))

;; (eval-and-compile
;;   (if (fboundp 'unix-to-dos-filename)
;;       ;; Meadow
;;       (defalias 'dispicon-unix-to-dos-filename 'unix-to-dos-filename)
;;     ;; NTEmacs
;;     (defun dispicon-unix-to-dos-filename (file)
;;       (with-temp-buffer
;; 	(insert file)
;; 	(goto-char (point-min))
;; 	(while (search-forward "/" nil t)
;; 	  (replace-match "\\" nil t))
;; 	(buffer-string)))))

(defun dispicon-unix-to-dos-filename (file)
  (with-temp-buffer
    (insert file)
    (goto-char (point-min))
    (while (search-forward "/" nil t)
      (replace-match "\\" nil t))
    (buffer-string)))

;;; dispicon API.
(defun dispicon-meadow-internal (filename &optional type size depth bgcolor ignore-errors)
  (let ((size (or size dispicon-default-size))
        (icontype (or type dispicon-default-type))
        (shgfi '(SHGFI_ICON))
        file-attrib blob image)
    (setq shgfi
          (cons (if (eq icontype 'small) 'SHGFI_SMALLICON 'SHGFI_LARGEICON)
                shgfi))
    (unless (file-exists-p filename)
      (setq file-attrib 'FILE_ATTRIBUTE_NORMAL)
      (setq shgfi (cons 'SHGFI_USEFILEATTRIBUTES shgfi)))
    (setq blob (car (mw32-sh-get-file-info
                     (dispicon-unix-to-dos-filename filename) file-attrib shgfi)))
    (cond
     (blob
      (setq image (create-image blob nil t :ascent 90))
      (unless (and (eq (car (image-size image t)) size)
                   (eq (cdr (image-size image t)) size))
        (setq blob (mw32-magick-scale-image blob size size))
        (setq image (create-image blob nil t :ascent 90)))
      (propertize " " 'display image 'invisible t))
     (ignore-errors
       (propertize " " 'display nil 'invisible t))
     (t
      (error "Error dispicon")))))

(defun dispicon-with-dispicon (filename &optional type size depth bgcolor ignore-errors)
  (let ((args `("-s" ,(number-to-string (or size dispicon-default-size))
		"-b" ,(or bgcolor dispicon-default-bgcolor
			  (dispicon-default-background))
		"-d" ,(number-to-string (or depth dispicon-default-depth))
		,(dispicon-unix-to-dos-filename filename)))
	stat image icontype)
    (when (file-exists-p filename)
      (setq args (append '("-f") args)))
    (with-temp-buffer
      (set-buffer-multibyte nil)
      (setq icontype (or type dispicon-default-type))
      (when (eq icontype 'large)
	(setq args (append '("-l") args)))
      (when (eq icontype 'thumbnail)
	(setq args (append '("-t") args)))
      (setq stat (apply 'call-process
			dispicon-program nil (current-buffer) t
			args))
      (if (numberp stat)
	  (if (eq stat 0)
	      (setq image
		    (find-image `((:type ,dispicon-image-type
					 :data ,(buffer-string)
					 :ascent 90))))
	    (unless ignore-errors
	      (error "Error while processing dispicon")))
	(if (stringp stat)
	    (unless ignore-errors
	      (error stat)))))
    (propertize " " 'display image 'invisible t)))

(defun dispicon-local-internal (filename &optional ignore-errors)
  (lexical-let* ((icon-folder (expand-file-name (my-cache-dir "disp-icons")))
                 (temp-buffer (get-buffer-create " *GetFileIcon*"))
                 (icon-file nil)
                 (image nil))
    (cond
     ((file-exists-p filename)
      (with-current-buffer temp-buffer
        (erase-buffer)
        ;; 同期プロセスでファイルアイコンのパスをゲットする
        (case system-type
          ('gnu/linux
           (message (concat "filename -> " filename))
           (call-process "GetFileIcon" nil temp-buffer nil filename "16")
           (goto-char (point-min))
           (when (re-search-forward ">>>\\(.+\\)<<<" nil t)
             (setq icon-file (match-string 1))))
          ('windows-nt
           (setq filename (dispicon-unix-to-dos-filename filename))
           (setq icon-folder (dispicon-unix-to-dos-filename icon-folder))
           (call-process "GetFileIcon" nil temp-buffer nil filename icon-folder)
           (setq icon-file (buffer-substring (point-min) (- (point-max) 1))))))
      (message (concat "icon-file -> " icon-file))
      (setq image (create-image icon-file nil nil :ascent 90))
      (propertize " " 'display image 'invisible t))
     (ignore-errors
       (propertize " " 'display nil 'invisible t))
     (t
      (error "Error dispicon"))
     )))

(defun dispicon (filename &optional type size depth bgcolor ignore-errors)
  "Obtain an icon which associates to FILENAME.
If optional TYPE is specified, icon type is changed.
It is a symbol of `small' or `large' or `thumbnail'.
If second optional SIZE is specified, it is used as width and height of
the icon.
If third optional DEPTH is specified, it is used as the depth of the icon.
If fourth optional BGCOLOR is specified, it is used as the default bgcolor.
If fifth optional IGNORE-ERRORS is specified, error is ignored."

  (dispicon-local-internal filename ignore-errors)

  ;; (if (and (fboundp 'mw32-sh-get-file-info)
  ;;      (not (eq type 'thumbnail)))
  ;;     (dispicon-meadow-internal filename type size depth bgcolor ignore-errors)
  ;;   (dispicon-with-dispicon filename type size depth bgcolor ignore-errors))
  )

(provide 'dispicon)

;;; dispicon.el ends here

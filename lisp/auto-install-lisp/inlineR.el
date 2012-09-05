;;; inlineR.el --- insert Tag for inline image of R graphics

;; Author: myuhe <yuhei.maeda_at_gmail.com>
;; URL: https://github.com/myuhe/e2wm-bookmark.el
;; Version: 0.2
;; Maintainer: myuhe
;; Copyright (C) :2010, myuhe , all rights reserved.
;; Created: :11-02-08
;; Keywords: convenience, iimage.el, cacoo.el

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published byn
;; the Free Software Foundation; either version 3, or (at your option)
;; any later version.

;; This file is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs; see the file COPYING. If not, write to
;; the Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
;; Boston, MA 0:110-1301, USA.

;;; Commentary:

;; cacoo.el is very cool.
;; You should install cacoo.el.
;; In detail, 
;; https://github.com/kiwanami/emacs-cacoo

;;; Installation:
;;
;; Put the inlineR.el to your
;; load-path.
;; Add to .emacs:
;; (require 'inlineR)
;;
;;; Changelog:
;; 2011/07/11 if inlineR-cairo-p is t, load Cairo Package automatically.

(require 'ess-site)

(defvar inlineR-re-funcname "plot\\|image\\|hist\\|matplot\\|barplot\\|pie\\|boxplot\\|pairs\\contour\\|persp")
(defvar inlineR-default-image "png")
(defvar inlineR-default-dir nil)
(defvar inlineR-cairo-p nil)
(defvar inlineR-thumnail-dir ".Rimg/")
(defvar inlineR-img-dir-ok nil)
(defun inlineR-get-start ()
  (if (region-active-p)
      (mark)
    (re-search-backward inlineR-re-funcname)))

(add-hook 'ess-post-run-hook 
          (lambda ()
            (when inlineR-cairo-p
              (ess-execute "if(!require(Cairo)){install.packages(\"Cairo\")}\n library(\"Cairo\")\n"))))

(defun inlineR-get-end ()
  (if (region-active-p)
      (point)
    (re-search-forward ".*(.*)")))

(defun inlineR-dir-concat (file)
  (if inlineR-default-dir
      (concat  inlineR-default-dir file) 
    file))

(defun inlineR-fix-directory ()
  ;;バッファのカレントディレクトリに保存先ディレクトリを作る
  ;;一応作って良いかどうか聞く
  (let* ((img-dir (inlineR-get-dir)))
    (unless (file-directory-p img-dir)
      (when (or inlineR-img-dir-ok 
                (y-or-n-p 
                 (format "Image directory [%s] not found. Create it ?" 
                         inlineR-thumnail-dir)))
        (make-directory img-dir))

      (unless (file-directory-p img-dir)
        (error "Could not create a image directory.")))
    img-dir))

(defun inlineR-tag-concat (file)
(if inlineR-default-dir 
    (if (boundp 'cacoo-minor-mode)
        (concat "\n##[img:" inlineR-default-dir file "]")
      (concat "\n##[[" inlineR-default-dir file "]]"))
  (if (boundp 'cacoo-minor-mode)
      (concat "\n##[img:./" inlineR-thumnail-dir file "]")
    (concat "\n##[[./" inlineR-thumnail-dir file "]]"))))

(defun inlineR-get-dir ()
  (concat
  (if inlineR-default-dir
    inlineR-default-dir
    (file-name-directory (buffer-file-name)))
    inlineR-thumnail-dir))

(defun inlineR-execute (format fun)
  (if inlineR-cairo-p
      (cond
       ((string= format "svg")  
        (ess-command 
         (concat 
          "CairoSVG(\"" inlineR-default-dir filename "." format "\", 3, 3)\n"
          fun "\n"
          "dev.off()\n")))
       (t (ess-command
           (concat
            "Cairo(600, 600, \"" (inlineR-get-dir) filename "." format "\", type=\"" format "\", bg =\"white\" )\n"
            fun "\n"
            "dev.off()\n"))))
    (ess-command
     (concat
      format "(\"" (inlineR-get-dir) filename "." format "\")\n"
      fun "\n"
      "dev.off()\n"))))

(defun inlineR-format-alist (pred)
  (if pred
      '(("png" 1) ("jpeg" 2) ("svg" 3))
    '(("png" 1) ("jpeg" 2) ("bmp" 3))))

(defun inlineR-insert-tag ()
  "insert image tag"
  (interactive)
  (let* ((start (inlineR-get-start))
         (end (inlineR-get-end))
         (fun (buffer-substring start end))
         (format 
          (completing-read
           "Image format: "
           (inlineR-format-alist inlineR-cairo-p) nil t inlineR-default-image))
         (filename (read-string "filename: " nil))
         (file (concat filename "." format)))
    (inlineR-fix-directory)
    (inlineR-execute format fun)
    (insert (inlineR-tag-concat file))))

(provide 'inlineR)

;;; inlineR.el ends here

;;;; color-theme-espresso.el
;; -*- mode: elisp -*-
;;
;; Based on Espresso Tutti Colori, the default theme for Espresso,
;; by MacRabbit.
;; Source: <http://macrabbit.com/espresso>
;; Ported to Emacs by Martin Kühl <purl.org/net/mkhl>
;;

(eval-when-compile
  (require 'color-theme))

;;; TODO: More faces? `list-faces-display'.

;;;###autoload
(defun color-theme-espresso ()
  "Espresso Tutti Colori.

Port of the default theme for Espresso on Mac OS X."
  (interactive)
  (let ((selection-color (if (featurep 'ns) "ns_selection_color" "#C9D0D9"))
        (highlight-color "#EEE00A")
        (secondary-color "#FBE9AD")
        (active-color "#EEEEEE")
        (passive-color "#AAAAAA")
        (subtle-color "#EEEEEE")
        (error-color "#F93232"))
    (color-theme-install
     `(color-theme-espresso
       ((background-color . "grey99")
        (background-mode . light)
        (border-color . "black")
        (cursor-color . "black")
        (foreground-color . "black"))

       ;; Basics
       (default ((t (nil))))
       (blue ((t (:foreground "blue"))))
       (bold ((t (:bold t))))
       (bold-italic ((t (:italic t :bold t))))
       (border-glyph ((t (nil))))
       (green ((t (:foreground "green"))))
       (info-node ((t (:italic t :bold t))))
       (info-xref ((t (:bold t))))
       (italic ((t (:italic t))))
       (left-margin ((t (nil))))
       (pointer ((t (nil))))
       (red ((t (:foreground "red"))))
       (right-margin ((t (nil))))
       (underline ((t (:underline t))))
       (yellow ((t (:foreground "yellow"))))

       ;; Parens
       (show-paren-match ((t (:background ,passive-color))))
       (show-paren-mismatch ((t (:foreground "#F9F2CE" :background ,error-color))))

       ;; Highlighting
       (hl-line ((t (:background ,active-color))))
       (highline-face ((t (:background ,active-color))))
       (highlight ((t (:background ,highlight-color))))
       (highlight-symbol-face ((t (:background ,secondary-color))))
       (isearch ((t (:background ,highlight-color))))
       (lazy-highlight ((t (:background ,secondary-color))))
       (primary-selection ((t (:background ,selection-color))))
       (region ((t (:background ,selection-color))))
       (secondary-selection ((t (:background ,secondary-color))))
       (shadow ((t (:foreground "grey50" :background ,subtle-color))))
       (text-cursor ((t (:background "black" :foreground ,passive-color))))
       (zmacs-region ((t (:background ,selection-color))))

       ;; More
       (mumamo-background-chunk-submode ((t (:background "#EAEBE6"))))

       ;; Font-lock
       (font-lock-builtin-face ((t (:foreground "#626FC9"))))
       (font-lock-comment-face ((t (:foreground "#7F7F7F"))))
       (font-lock-constant-face ((t (:foreground "#7653C1" :background "#F3F2FF"))))
       (font-lock-doc-string-face ((t (:foreground "#1A93AE" :background "#F4F9FE"))))
       (font-lock-function-name-face ((t (:foreground "#4E279A"))))
       (font-lock-keyword-face ((t (:foreground "#6700B9"))))
       (font-lock-preprocessor-face ((t (:foreground "#434343"))))
       (font-lock-reference-face ((t (:foreground "#4E279A" :background "#F3F2FF"))))
       (font-lock-string-face ((t (:foreground "#BC670F" :background "#FDFBF5"))))
       (font-lock-type-face ((t (:foreground "#699D36"))))
       (font-lock-variable-name-face ((t (:foreground "#7B8C4D"))))
       (font-lock-warning-face ((t (:foreground "#F93232"))))

       ;; Diff Mode
       (diff-file-header ((t (:bold t :inherit diff-header))))
       (diff-header ((t (:background "#DDDDFF" :foreground "grey20"))))
       (diff-added ((t (:background "#DDFFDD"))))
       (diff-removed ((t (:background "#FFDDDD"))))
       (diff-changed ((t (:background "#FFFFDD"))))
       (diff-refine-change ((t (:background "#DDDDFF"))))

       ;; Magit
       (magit-diff-file-header ((t (:bold t :inherit diff-header))))
       (magit-diff-hunk-header ((t (:inherit diff-header))))
       (magit-diff-add ((t (:inherit diff-added :foreground "grey20"))))
       (magit-diff-del ((t (:inherit diff-removed :foreground "grey20"))))
       (magit-diff-none ((t (:inherit diff-context :foreground "grey20"))))
       (magit-item-highlight ((t (:background nil :foreground "black"))))

       ;; Done
       ))))

(add-to-list 'color-themes
             '(color-theme-espresso "Espresso Tutti Colori" "Martin Kuehl"))

(provide 'color-theme-espresso)

;;;; color-theme-quiet-light.el
;; -*- mode: elisp -*-
;;
;; Based on the Quiet Light foam for Espresso, by Ian Beck
;; Source: <http://github.com/onecrayon/quiet-light.foam>
;; Ported to Emacs by Martin Kühl <purl.org/net/mkhl>
;;

(eval-when-compile
  (require 'color-theme))

;;; TODO: More faces? `list-faces-display'.

;;;###autoload
(defun color-theme-quiet-light ()
  "Quiet Light Color Theme.

Port of the eponymous theme for Espresso on Mac OS X."
  (interactive)
  (let ((selection-color (if (featurep 'ns) "ns_selection_color" "#C9D0D9"))
        (highlight-color "#EEE00A")
        (secondary-color "#D3E1CD")
        (active-color "#FFFEDB")
        (passive-color "#CCCCCC")
        (subtle-color "#E8E8E8")
        (error-color "#EEE3E3"))
    (color-theme-install
     `(color-theme-quiet-light
       ((background-mode . light)
        (background-color . "#F5F5F5")
        (border-color . "black")
        (cursor-color . "black")
        (foreground-color . "#333333"))

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
       (show-paren-mismatch ((t (:foreground ,error-color :background "#660000"))))

       ;; Highlighting
       (hl-line ((t (:background ,active-color))))
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
       (font-lock-builtin-face ((t (:foreground "#91B3E0"))))
       (font-lock-comment-face ((t (:italic t :foreground "#AAAAAA"))))
       (font-lock-comment-delimiter-face ((t (:italic nil :foreground "#AAAAAA"))))
       (font-lock-constant-face ((t (:foreground "#AB6526"))))
       (font-lock-doc-string-face ((t (:foreground "#448C27"))))
       (font-lock-function-name-face ((t (:foreground "#AA3731"))))
       (font-lock-keyword-face ((t (:foreground "#4B83CD"))))
       (font-lock-preprocessor-face ((t (:foreground "#434343"))))
       (font-lock-reference-face ((t (:foreground "#AB6526"))))
       (font-lock-string-face ((t (:foreground "#448C27"))))
       (font-lock-type-face ((t (:foreground "#7A3E9D"))))
       (font-lock-variable-name-face ((t (:foreground "#7A3E9D"))))
       (font-lock-warning-face ((t (:foreground "#660000" :background "#EEE3E3"))))

       ;; Diff Mode
       (diff-file-header ((t (:bold t :inherit diff-header))))
       (diff-header ((t (:background "#DDDDFF" :foreground "#434343"))))
       (diff-added ((t (:background "#DDFFDD"))))
       (diff-removed ((t (:background "#FFDDDD"))))
       (diff-changed ((t (:background "#FFFFDD"))))
       (diff-refine-change ((t (:background "#DDDDFF"))))

       ;; Magit
       (magit-diff-file-header ((t (:bold t :inherit diff-header))))
       (magit-diff-hunk-header ((t (:inherit diff-header))))
       (magit-diff-add ((t (:inherit diff-added :foreground "#434343"))))
       (magit-diff-del ((t (:inherit diff-removed :foreground "#434343"))))
       (magit-diff-none ((t (:inherit diff-context :foreground "#434343"))))
       (magit-item-highlight ((t (:background nil :foreground "#232323"))))

       ;; Done
       ))))

(add-to-list 'color-themes
             '(color-theme-quiet-light "Quiet Light" "Martin Kühl"))

(provide 'color-theme-quiet-light)

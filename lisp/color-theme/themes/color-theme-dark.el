(eval-when-compile
  (require 'color-theme))

(defvar mark-tabs-face 'mark-tabs-face)
(defface mark-tabs-face
  '((((class color))
     (:foreground "red" :underline t)))
  nil
  :group 'face)
(defvar mark-whitespace-face 'mark-whitespace-face)
(defface mark-whitespace-face
  '((((class color))
     (:background "gray")))
  nil
  :group 'face)
(defvar mark-lineendspaces 'mark-lineendspaces-face)
(defface mark-lineendspaces-face
  '((((class color))
     (:foreground "SteelBlue" :underline t)))
  nil
  :group 'face)
(defvar brackets-face 'brackets-face)
(defface brackets-face
  '((((class color))
     (:foreground "#e9b96e")))
  "Face for displaying a brackets.
UK
[ ]:square brackets
( ):round brackets
{ }:curly brackets
< >:angle brackets
USA
[ ]:brackets
( ):parentheses
{ }:brace
< >:angle brackets
"
  :group 'faces)

(defvar operator-face 'operator-face)
(defface operator-face
  '((((class color))
     (:foreground "#ffa500")))
  "Face for displaying a operator.|&!.+=-/%*,"
  :group 'faces)

(defadvice font-lock-mode (before my-font-lock-mode ())
  (font-lock-add-keywords
   major-mode
   '(
     ("\t" 0 mark-tabs-face append)
     ("　" 0 mark-whitespace-face append)
     ;; ("[ \t]+$" 0 my-mark-lineendspaces append)
     ("(\\|)\\|{\\|\\}\\|\\[\\|\\]" 0 brackets-face append)
     ;; ("[|!\\.\\+\\=\\&]\\|-\\|\\/\\|\\:\\|\\%\\|\\*\\|\\," 0 operator-face append)
     ("[|!\\.\\+\\=\\&]\\|\\/\\|\\:\\|\\%\\|\\*\\|\\," 0 operator-face append)

     )))
(ad-enable-advice 'font-lock-mode 'before 'my-font-lock-mode)
(ad-activate 'font-lock-mode)

;;;###autoload
(defun color-theme-dark ()
   "Color theme by Tomas Cerha, created 2001-11-13. color-theme-deep-blue"
   (interactive)

   (let* ((color-bg3  "#002b36")
          (color-bg2  "#073642")
          (color-bg1  "#586e75")
          (color-bg0  "#657b83")
          (color-fg0  "#839496")
          (color-fg1  "#93a1a1")
          (color-fg2  "#eee8d5")
          (color-fg3  "#fdf6e3")
          (yellow     "#b58900")
          (orange     "#cb4b16")
          (red        "#dc322f")
          (magenta    "#d33682")
          (violet     "#6c71c4")
          (blue       "#268bd2")
          (cyan       "#2aa198")
          (green      "#859900")
          ;; custom
          (green1     "#8ae234")
          (green2     "#73d216")
          (green3     "#4fcfc5")
          (green4     "#00cc00")
          (blue1      "#0046ff")
          (blue2      "#729fcf")
          (skyblue    "DeepSkyBlue1")
          (yellow1    "#ffff00")
          (lightyellow "#fce94f")
          (orange1    "#f57900")
          (orange2    "#ffa500")
          (orange3    "#fcaf3e")
          (orange4    "#e9b96e")
          )

   (color-theme-install
    (append
     (list
      'color-theme-dark
      `((background-color . ,color-bg3)
        (foreground-color . ,color-fg3)
        (background-mode . dark)
        (border-color . ,color-bg3)
        (cursor-color . ,red)
        (mouse-color . ,color-fg3)
        (vc-annotate-very-old-color . ,blue1)
        (browse-kill-ring-separator-face . bold)
        (help-highlight-face . underline)
        (list-matching-lines-face . secondary-selection)
        (display-time-mail-face . mode-line)
        (view-highlight-face . highlight)
        (widget-mouse-face . highlight))

      `(default ((t (:background ,color-bg3 :foreground ,color-fg3))))

      `(bold ((t (:bold t :weight bold :height 1.1))))
      `(italic ((t (:italic t :slant italic :height 1.1))))
      `(bold-italic ((t (:italic t :bold t :slant italic :weight bold :height 1.1))))
      ;;`(fixed-pitch ((t (:family "September"))))
      ;;`(variable-pitch ((t (:family "September"))))
      `(underline ((t (:underline t))))
      ;;`(menu ((t (:background ,color-bg0 :foreground ,color-fg0 :family "September"))))
      `(border ((t (:background ,color-bg3))))
      `(cursor ((t (:background ,green))))
      `(fringe ((t (:background ,color-bg0))))
      `(mouse ((t (:background ,color-fg3))))
      ;; `(region ((t (:background ,color-bg2 :foreground ,color-fg1))))
      `(region ((t (:background ,color-bg0 )))) ;;DarkSlateGrey
      `(secondary-selection ((t (:background ,yellow1 :foreground ,color-fg2))))
      `(scroll-bar ((t (:background ,color-bg0 :foreground ,color-fg0))))
      `(tool-bar ((t (:background ,color-bg0 :foreground ,color-fg0 :box (:line-width 1 :style released-button)))))
      `(tooltip ((t (:background ,lightyellow :foreground ,color-fg0))))
      `(header-line ((t (:box (:line-width 2 :style released-button) :background ,color-bg2 :foreground ,cyan :box nil))))

      `(highlight ((t (:background ,color-bg0 )))) ;;:foreground ,color-fg2
      `(highlight-current-line ((t (:background ,color-bg0))))
      `(hl-line ((t (:background "SlateBlue4"))))
      `(lazy-highlight ((t (:background ,color-bg0 :foreground ,color-fg2))))

      ;; isearch
      `(isearch ((t (:background ,magenta :foreground ,color-fg3))))
      `(isearch-lazy-highlight ((t (:background ,magenta))))

      ;; whitespcae
      `(whitespace-space ((t (:foreground ,cyan))))
      `(whitespace-tab ((t (:foreground ,cyan))))
      ;; 行末半角スペース
      `(trailing-whitespace ((t (:underline ,blue))))

      ;; info
      `(Info-title-1-face ((t (:bold t :weight bold :height 1.728))))
      `(Info-title-2-face ((t (:bold t :weight bold :height 1.44))))
      `(Info-title-3-face ((t (:bold t :weight bold :height 1.2))))
      `(Info-title-4-face ((t (:bold t :weight bold ))))

      `(info-header-node ((t (:foreground ,skyblue))))
      `(info-header-xref ((t (:bold t :weight bold :foreground ,green4))))
      `(info-menu-5 ((t (:foreground ,orange))))
      `(info-menu-header ((t (:bold t :weight bold))))
      `(info-node ((t (:foreground ,skyblue))))
      `(info-xref ((t (:bold t :foreground ,green4 :weight bold))))

      ;; change-log
      `(change-log-acknowledgement-face ((t (:italic t :slant italic :foreground ,blue))))
      `(change-log-conditionals-face ((t (:foreground ,green4))))
      `(change-log-date-face ((t (:foreground ,orange))))
      `(change-log-email-face ((t (:foreground ,green4))))
      `(change-log-file-face ((t (:bold t :weight bold :foreground ,red))))
      `(change-log-function-face ((t (:foreground ,green4))))
      `(change-log-list-face ((t (:bold t :weight bold :foreground ,skyblue))))
      `(change-log-name-face ((t (:foreground ,lightyellow))))

      ;; comint
      `(comint-highlight-input ((t (:bold t :weight bold))))
      `(comint-highlight-prompt ((t (:foreground ,cyan))))

      ;; cvs
      `(cvs-filename-face ((t (:foreground ,cyan))))
      `(cvs-handled-face ((t (:foreground ,magenta))))
      `(cvs-header-face ((t (:bold t :foreground ,lightyellow :weight bold))))
      `(cvs-marked-face ((t (:bold t :foreground ,green :weight bold))))
      `(cvs-msg-face ((t (:italic t :slant italic))))
      `(cvs-need-action-face ((t (:foreground ,orange))))
      `(cvs-unknown-face ((t (:foreground ,red))))

      ;; calendar
      `(calendar-today-face ((t (:background ,blue))))
      `(diary-face ((t (:foreground ,orange))))
      `(holiday-face ((t (:foreground ,green))))

      ;; diff
      `(diff-added ((t (:foreground ,lightyellow :inverse-video t))))
      `(diff-removed ((t (:foreground ,skyblue :inverse-video t))))
      `(diff-changed ((t (:foreground ,skyblue :inverse-video t))))
      `(diff-context ((t (:foreground ,color-fg0))))
      `(diff-file-header ((t (:bold t :background ,color-bg0 :foreground ,yellow1 :weight bold))))
      `(diff-function ((t (:foreground ,color-fg0))))
      `(diff-header ((t (:background ,color-bg0))))
      `(diff-hunk-header ((t (:background ,color-bg0 :foreground ,magenta))))
      `(diff-index ((t (:bold t :weight bold :background ,color-bg0 :foreground ,violet))))
      `(diff-nonexistent ((t (:bold t :weight bold :background ,color-bg0))))

      ;; latex
      `(font-latex-bold-face ((t (:bold t :foreground ,green :weight bold))))
      `(font-latex-italic-face ((t (:italic t :foreground ,green :slant italic))))
      `(font-latex-math-face ((t (:foreground ,red))))
      `(font-latex-sedate-face ((t (:foreground ,color-fg3))))
      `(font-latex-string-face ((t (:foreground ,orange))))
      `(font-latex-warning-face ((t (:bold t :foreground ,magenta :weight bold))))

      ;; font-lock
      `(font-lock-builtin-face ((t (:foreground ,red))))
      `(font-lock-comment-face ((t (:slant italic :foreground ,color-fg1))))
      `(font-lock-constant-face ((t (:foreground ,lightyellow))))
      `(font-lock-doc-face ((t (:foreground ,green1))))
      `(font-lock-doc-string-face ((t (:foreground ,color-fg3))))
      `(font-lock-function-name-face ((t (:foreground ,yellow1))))
      `(font-lock-keyword-face ((t (:bold t :foreground ,skyblue :weight bold))))
      `(font-lock-preprocessor-face ((t (:foreground ,lightyellow))))
      `(font-lock-reference-face ((t (:foreground ,red))))
      `(font-lock-string-face ((t (:foreground ,green1))))
      `(font-lock-type-face ((t (:foreground ,yellow1))))
      `(font-lock-variable-name-face ((t (:foreground ,green4))))
      `(font-lock-warning-face ((t (:foreground ,yellow1))))
      ;; regex
      `(font-lock-regexp-grouping-backslash ((t (:foreground ,color-fg0))))
      `(font-lock-regexp-grouping-construct ((t (:foreground ,orange))))

      `(action-lock-face ((t (:bold t :weight bold :underline t :foreground ,cyan ))))

      ;; mode-line
      `(mode-line ((t (:foreground ,color-fg1 :background ,color-bg2 :box (:line-width 1 :color nil :style released-button)))))
      `(mode-line-inactive ((t (:foreground ,color-fg2 :background ,color-bg1))))
      `(mode-line-buffer-id ((t (:bold t :foreground ,orange2))))

      ;; show-paren
      `(show-paren-match-face ((t (:foreground ,cyan :background ,color-fg3))))
      `(show-paren-mismatch-face ((t (:background ,red :foreground ,color-fg3))))

      ;; widget
      `(widget-button-face ((t (:bold t :weight bold))))
      `(widget-button-pressed-face ((t (:foreground ,red))))
      `(widget-documentation-face ((t (:foreground ,green))))
      `(widget-field-face ((t (:background ,color-bg0))))
      `(widget-inactive-face ((t (:foreground ,color-fg0))))
      `(widget-single-line-field-face ((t (:background ,color-bg0))))

      ;; python
      `(py-pseudo-keyword-face ((t (:bold t :foreground ,cyan :weight bold))))

      ;; rst
      `(rst-level-1-face ((t (:background ,yellow))))
      `(rst-level-2-face ((t (:background ,orange))))
      `(rst-level-3-face ((t (:background ,red))))
      `(rst-level-4-face ((t (:background ,magenta))))
      `(rst-level-5-face ((t (:background ,violet))))
      `(rst-level-6-face ((t (:background ,blue))))

      ;; howm
      `(howm-mode-title-face ((t (:background ,yellow))))

      ;; org
      `(org-hide ((t (:foreground ,color-fg3))))
      `(org-todo ((t (:foreground ,color-fg3 :background ,red :bold t))))
      `(org-done ((t (:foreground ,green :bold t))))
      `(org-todo-kwd-face ((t (:foreground ,red :background ,color-fg3))))
      `(org-done-kwd-face ((t (:foreground ,green :background ,color-fg3))))
      `(org-project-kwd-face ((t (:foreground ,violet :background ,color-fg3))))
      `(org-waiting-kwd-face ((t (:foreground ,orange :background ,color-fg3))))
      `(org-someday-kwd-face ((t (:foreground ,blue :background ,color-fg3))))
      `(org-started-kwd-face ((t (:foreground ,yellow :background ,color-fg3))))
      `(org-cancelled-kwd-face ((t (:foreground ,green :background ,color-fg3))))
      `(org-delegated-kwd-face ((t (:foreground ,cyan :background ,color-fg3))))
      `(org-block-begin-line
        ((t (:underline ,color-fg2 :foreground ,skyblue :background ,color-bg2))))
      `(org-block
        ((t (:foreground ,color-fg2 :background ,color-bg2))))
      `(org-block-end-line
        ((t (:overline ,color-fg2 :foreground ,skyblue :background ,color-bg2))))

      ;; vline
      `(vline-visual ((t (:background ,color-bg1))))
      `(vline ((t (:background ,color-bg1))))

      ;; nxml
      `(nxml-element-local-name ((t (:foreground ,skyblue))))

      ;; anything
      ;; ファイル色がデフォルト Blue だが背景が黒系統だと見にくいので変更
      `(anything-file-name ((t (:foreground ,yellow1))))
      `(anything-candidate-number ((t (:background ,orange2 :foreground ,color-bg3))))
      `(anything-header ((t (:inherit header-line :background "LightSkyBlue4" :foreground "snow"))))

      ;; 変更点のハイライト
      `(highlight-changes ((t (:foreground nil :background ,color-bg0))))
      `(highlight-changes-delete ((t (:foreground nil :background ,color-bg1))))

      ;; flymake
      `(flymake-errline ((t (:background ,orange))))
      `(flymake-warnline ((t (:background ,violet))))
      )))))
(provide 'color-theme-dark)

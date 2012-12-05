;;; Commentary:

;; theme, highlight などの設定

;;; Code:

(require 'my-lisp-utils)

(message "init_color ...")

;;
;; color theme setting
;; usefull link: http://batsov.com/articles/2012/02/19/color-theming-in-emacs-reloaded/
;;______________________________________________________________________
;; color-theme
(setq color-theme-load-all-themes nil)
(setq color-theme-libraries nil)

;; Emacs24に対応したテーマ集の追加
(if emacs24-p (add-to-list 'custom-theme-load-path (concat user-emacs-directory "lisp/color-theme/themes-24")))

;; 利用するテーマ一覧の定義
(setq my-last-random-color-theme-identify nil)
(defvar my-random-color-theme-list
  (list
   ;; `(progn (message "select default theme"))
   ;; `(progn (apply-selected-ramdom-theme 'color-theme-tangosoft t))
   ;; `(progn (apply-selected-ramdom-theme 'color-theme-tangotango t))
   ;; `(progn (apply-selected-ramdom-theme 'color-theme-ns t))
   ;; `(progn (apply-selected-ramdom-theme 'color-theme-dark t))
   `(progn (apply-selected-ramdom-theme (quote (  misterioso ))))
   ;; `(progn (apply-selected-ramdom-theme (quote (  tango-dark ))))
   ;; `(progn (apply-selected-ramdom-theme (quote (  wheatgrass ))))
   ;; `(progn (apply-selected-ramdom-theme (quote (  wombat     ))))
   ;; `(progn (apply-selected-ramdom-theme (quote (  zenburn    ))))
   ;; ;; --- [reverse-theme] ---
   ;; ;; https://raw.github.com/syohex/emacs-reverse-theme/master/reverse-theme.el
   ;; `(progn (apply-selected-ramdom-theme (quote (  reverse    ))))
   ;; --- [theme 24 not good] ---
   ;;; `(progn (apply-selected-ramdom-theme 'color-theme-solarized t "light"))
   ;;; `(progn (apply-selected-ramdom-theme 'color-theme-solarized t "dark"))
   ;;; `(progn (apply-selected-ramdom-theme (quote (  tango      ))))
   ;;; `(progn (apply-selected-ramdom-theme (quote (  tsdh-light ))))
   ;;; `(progn (apply-selected-ramdom-theme (quote (  whiteboard ))))
   ;; --- [theme 24 useable] ---
   ;; - `(progn (apply-selected-ramdom-theme (quote (  adwaita    ))))
   ;; - `(progn (apply-selected-ramdom-theme (quote (  deeper-blue))))
   ;; - `(progn (apply-selected-ramdom-theme (quote (  dichromacy ))))
   ;; - `(progn (apply-selected-ramdom-theme (quote (  light-blue ))))
   ;; - `(progn (apply-selected-ramdom-theme (quote (  manoj-dark ))))
   ;; - `(progn (apply-selected-ramdom-theme (quote (  tsdh-dark  ))))
   ;; --- [zenburn for emacs 23] ---
   ;; `(progn
   ;;    (cond
   ;;     (emacs23-p
   ;;      (apply-selected-ramdom-theme 'color-theme-zenburn t))
   ;;     (emacs24-p
   ;;       (apply-selected-ramdom-theme (quote (zenburn))))))
   ))

(defun apply-selected-ramdom-theme (my-theme &optional old-format style-postfix)
  "emacs バージョンよりテーマ適用ロジックを自動的に調整し、テーマを適用する"
  (if old-format
      (progn
    (let ((theme-name (symbol-name my-theme))
          (style-postfix (if style-postfix (concat "-" style-postfix) ""))
          )
      (message (concat "applying new theme --> " theme-name style-postfix))
      (require 'color-theme)
      (require my-theme)
      (my-util-eval-string (concat
                "(" theme-name style-postfix ")"))))
    (progn
      (message (concat "applying new theme --> " (symbol-name (car my-theme))))
      (cond
       (emacs23-p
    (custom-set-variables '(custom-enabled-themes my-theme)))
       (emacs24-p
    (load-theme (car my-theme) t))))))

;; 臨機でテーマを適用する
(defun my-random-color-theme ()
  (interactive)
  (let ((temp-random-color-theme-identify  my-last-random-color-theme-identify))
    (message "changing color-theme")
    (random t)
    (while (eq temp-random-color-theme-identify  my-last-random-color-theme-identify)
      (message "get random number")
      (setq temp-random-color-theme-identify  (random (length my-random-color-theme-list)))
      )
    (setq my-last-random-color-theme-identify temp-random-color-theme-identify)
    (eval (nth my-last-random-color-theme-identify  my-random-color-theme-list))))

;; テーマ定期間で自動切換え
(defun running-my-random-color-theme ()
  (interactive)
  (my-random-color-theme)
  ;;(run-with-timer 0 (* 60 60) 'my-random-color-theme)
  )

;; テーマの適用
;; (if mac-p
;;     ;; Emacs 23 が Mac OS で起動中のタイミングうまく初期化できないので、起動後初期化する
;;     (add-hook 'after-init-hook (lambda() (run-with-idle-timer 0 nil 'running-my-random-color-theme)))
;;   ;; windowsの場合即時適用
;;   (running-my-random-color-theme)
;;   )
(running-my-random-color-theme)


;;
;; load-theme-buffer-local.el
;;______________________________________________________________________
;;; Set emacs color themes by buffer
;;; https://github.com/vic/color-theme-buffer-local
(add-hook 'java-mode-hook (lambda nil
                (load-theme-buffer-local 'misterioso (current-buffer) t t)))

;;
;; modeline face カスタマイズ
;;______________________________________________________________________

;; モードラインに関数名を表示するカラムのフェーズカスタマイズ
(when (eq nil (get 'which-func 'init-flag))
   ;; (set-face-foreground 'which-func (face-foreground 'font-lock-function-name-face))
   (set-face-foreground 'which-func (face-foreground 'mode-line-buffer-id))
   (set-face-background 'which-func (face-background 'mode-line))
   (set-face-bold-p 'which-func t))

;;
;; font lock settging
;;______________________________________________________________________
;; フォントロックの設定
(global-font-lock-mode t)
;;(setq font-lock-maximum-decoration t)
;; (setq font-lock-support-mode 'jit-lock-mode)

;; text-mode font lock設定
(add-hook 'text-mode-hook
      '(lambda ()
         (progn
           (font-lock-mode t)
           (font-lock-fontify-buffer))))

;;
;; rainbow-mode の有効化
;; 色文字列が記述された箇所の背景色をわかりやすくする
;;______________________________________________________________________
;; install from ELPA (package-install 'rainbow-mode)
;; (define-global-minor-mode my-rainbow-mode rainbow-mode
;;   (lambda ()
;;     (when (memq major-mode
;;                 (list 'html-mode
;;                       'css-mode
;;                       'emacs-lisp-mode))
;;       (rainbow-mode 1))))
;; (my-rainbow-mode 1)
(dolist (hook '(css-mode-hook
        html-mode-hook
        ;;emacs-lisp-mode-hook
        )) (add-hook hook 'rainbow-mode))

;;
;; whitespace mode setting
;;______________________________________________________________________
;; タブ文字、全角空白、文末の空白の色付け
;; @see http://www.emacswiki.org/emacs/WhiteSpace
;; @see http://xahlee.org/emacs/whitespace-mode.html
(require 'whitespace)
;; 常に whitespace-mode だと動作が遅くなる場合がある
(global-set-key (kbd "C-x w") 'global-whitespace-mode)
;; (global-whitespace-mode 1)

(setq whitespace-style '(face tabs tab-mark space-before-tab space-after-tab
                              spaces space-mark
                              newline newline-mark
                              trailing empty))

(setq whitespace-display-mappings
      '(
    ;; (space-mark 32 [183] [46]) ; normal space, ·
    ;; (space-mark 160 [164] [95])
    ;; (space-mark 2208 [2212] [95])
    ;; (space-mark 2336 [2340] [95])
    ;; (space-mark 3616 [3620] [95])
    ;; (space-mark 3872 [3876] [95])
    (space-mark ?\u3000 [?\u25a1])  ;全角
    (newline-mark 10 [182 10]) ; newlne, ¶
    ;;(newline-mark ?\n    [?\u21B5 ?\n] [?$ ?\n])
    ;;(newline-mark ?\n    [?\u2193 ?\n] [?$ ?\n])
    (tab-mark     ?\t    [?\xBB ?\t]   [?\\ ?\t]) ;タブ
    ))

;; newline のfaceをカスタマイズする
(defvar whitespace-default-newline-face 'whitespace-default-newline-face)
(make-face 'whitespace-default-newline-face)
(set-face-foreground 'whitespace-default-newline-face "#5f5f00")
(setq whitespace-newline 'whitespace-default-newline-face)

;;
;; show-trailing-whitespace 行末に空白を強調で表示する
;;______________________________________________________________________
;; 行末の空白を表示
(defun fc-turn-on-show-trailing-whitespace ()
  "Set `show-trailing-whitespace' to t."
  (setq show-trailing-whitespace t))
;; 有効化したいモードの指定
(mapc (lambda (hook)
    (add-hook hook 'fc-turn-on-show-trailing-whitespace))
      '(text-mode-hook
    scheme-mode-hook
    c-mode-hook
    emacs-lisp-mode-hook
    java-mode-hook))
;; フェーズのカスタマイズ
(let ((trailing-whitespace-bg (face-background 'trailing-whitespace)))
      (set-face-background 'trailing-whitespace (face-background 'default))
      (set-face-underline-p 'trailing-whitespace t)
      (set-face-underline-p 'trailing-whitespace trailing-whitespace-bg))
;;
;; zenkaku space, tab custom face setting
;;______________________________________________________________________
;; 全角スペース、タブ、行末の色の設定
(defface my-face-tab         '((t (:background "Yellow"))) nil :group 'my-faces)
(defface my-face-zenkaku-spc '((t (:background "ray60" :foreground "RosyBrown"))) nil :group 'my-faces)
(defface my-face-spc-at-eol  '((t (:foreground "Red" :underline t))) nil :group 'my-faces)
(defvar my-face-tab         'my-face-tab)
(defvar my-face-zenkaku-spc 'my-face-zenkaku-spc)
(defvar my-face-spc-at-eol  'my-face-spc-at-eol)

(defadvice font-lock-mode (before my-font-lock-mode ())
  (font-lock-add-keywords
   major-mode
   '(("　" 0 my-face-zenkaku-spc append)
     ;; ("\t" 0 my-face-tab append)
     ;; ("[ \t]+$" 0 my-face-spc-at-eol append)
     )))
(ad-enable-advice 'font-lock-mode 'before 'my-font-lock-mode)
(ad-activate 'font-lock-mode)

;;
;; highlight setting
;;______________________________________________________________________
;; 左フリンジに点線のようなものが表示させる
;; 参考ページ：http://d.hatena.ne.jp/khiker/20100114/emacs_eof
(setq-default indicate-empty-lines t)
(setq-default indicate-buffer-boundaries 'left)

;; マーク領域を色付け
(setq transient-mark-mode t)

;; 現在行に色を付ける
(global-hl-line-mode t)

;; モード制約変数をローカル化
(make-variable-buffer-local 'global-hl-line-mode)
;; 標準の hl-line だと結構邪魔なので拡張機能に変更
;; (install-elisp "http://www.emacswiki.org/emacs/download/hl-line+.el")
;; (require 'hl-line+)
;; (toggle-hl-line-when-idle 1)
;; (setq hl-line-idle-interval 3)

;; hl-line-faceのカスタマイズ
(let ((hl-line-bg (or (and (facep 'hl-line-face) (face-background 'hl-line-face))
              (and (facep 'hl-line) (face-background 'hl-line)))))
  (message "hl-line-bg --> %s" hl-line-bg)
  (when (or (eq hl-line-bg 'unspecified)
        (eq hl-line-bg nil)
        ;;(eq hl-line-bg 'inherit)
        )
    (custom-set-faces
     '(hl-line ((((class color)
          (background dark))
         (:background "NavyBlue"));; 背景色が暗い色のとき
        (((class color)
          (background light))
         (:background "LightGoldenrodYellow"));; 背景色が明るい色のとき
        (t (:bold t)))))))

(defun my-hl-line-mode-local-face (&optional new-hl-face)
  "ローカルバッファーのglobalハイライトを無効化しフェーズを変更する"
  (interactive)
  ;; (make-local-variable 'global-hl-line-mode)
  (setq global-hl-line-mode nil)
  (when new-hl-face
    (make-local-variable 'hl-line-face)
    (setq hl-line-face new-hl-face)
    (hl-line-mode t)))

;;
;; 列付ける、インデントハイライト
;;______________________________________________________________________
;; @see http://www.emacswiki.org/emacs/CrosshairHighlighting
;; @see http://www.emacswiki.org/emacs/VlineMode
;; @see http://www.emacswiki.org/cgi-bin/wiki/vline.el
;; (install-elisp "http://www.emacswiki.org/emacs/download/crosshairs.el")
;; (require 'crosshairs)

;; ;; current列のハイライト
;; ;; http://emacswiki.org/emacs/HighlightCurrentColumn
;; ;; (auto-install-batch "col-highlight")
;; (require 'col-highlight)
;; (defalias 'col-hl 'column-highlight-mode)
;; ;; 常にハイライトする
;; ;; (column-highlight-mode 1)
;; ;; idle 状態後ハイライト
;; ;; (toggle-highlight-column-when-idle 1)
;; ;; ハイライト継続時間、単位秒
;; ;; (col-highlight-set-interval 2)

;; ;;;  Highlight Indentation
;; ;; http://www.emacswiki.org/emacs/HighlightIndentation
;; ;; http://blog.iss.ms/2012/03/17/095152
;; ;; git submodule add https://github.com/antonj/Highlight-Indentation-for-Emacs lisp/highlight-indentation
;; (require 'highlight-indentation)
;; (setq highlight-indentation-offset 4)
;; (set-face-background 'highlight-indentation-face "#e3e3d3")
;; (set-face-background 'highlight-indentation-current-column-face "#e3e3d3")
;; (add-hook 'java-mode-hook 'highlight-indentation-mode)

;; (install-elisp "https://raw.github.com/ran9er/init.emacs/master/20_aux-line.el")

;;
;; カッコ表示
;;______________________________________________________________________
;; 対応するカッコを色表示する
;; 特に色をつけなくてもC-M-p、C-M-n を利用すれば対応するカッコ等に移動できる
(show-paren-mode t)
(setq blink-matching-paren t)  ;キャラクタ端末でも有効にする
;; 表示延遅
(setq show-paren-delay 0)

;; カッコ対応表示のスタイル
;; カッコその物に色が付く(デフォルト)
(setq show-paren-style 'parenthesis)
;; カッコ内に色が付く
;;(setq show-paren-style 'expression)
;; 画面内に収まる場合はカッコのみ、画面外に存在する場合はカッコ内全体に色が付く
;;(setq show-paren-style 'mixed)

;; 表示フェースのカスタマイズ
(set-face-underline 'show-paren-match "white")
(set-face-underline 'show-paren-mismatch "red")
;; (set-face-attribute 'show-paren-match-face nil
;;                     :background nil
;;                     :foreground nil
;;                     :underline "white"
;;                     :overline nil
;;                     :weight 'extra-bold)

;;
;; highlight-parentheses
;;______________________________________________________________________
;;; http://kouzuka.blogspot.jp/2011/02/highlight-parenthesesel.html
;;; http://amitp.blogspot.jp/2007/05/emacs-highlighting-parentheses.html
;;; http://lemonodor.com/archives/001207.html
;;; http://david.rysdam.org/src/emacs/emacs.xhtml#highlight-sexps
;;; (package-install "highlight-parentheses-20090406")
;;; (install-elisp "http://david.rysdam.org/src/emacs/highlight-sexps.el")
;; (require 'highlight-parentheses)
;; (setq hl-paren-colors '("red" "blue" "yellow" "green" "magenta" "peru" "cyan"))
;; (set-face-attribute 'hl-paren-face nil :weight 'bold)
;; (add-hook 'emacs-lisp-mode-hook 'highlight-parentheses-mode)
;; (require 'highlight-sexps)
;; (add-hook 'lisp-mode-hook 'highlight-sexps-mode)
;; (add-hook 'emacs-lisp-mode-hook 'highlight-sexps-mode)
;; (setq hl-sexp-background-colors '("red" "blue" "yellow" "green" "magenta" "peru" "cyan"))

;;
;; copy & peate highlight
;;______________________________________________________________________
;; ;; コピー＆ペーストのハイライト
;; (defadvice yank (after ys:highlight-string activate)
;;   (let ((ol (make-overlay (mark t) (point))))
;;     (overlay-put ol 'face 'highlight)
;;     (sit-for 1)
;;     (delete-overlay ol)
;;     ))
;; (defadvice yank-pop (after ys:highlight-string activate)
;;   (when (eq last-command 'yank)
;;     (let ((ol (make-overlay (mark t) (point))))
;;       (overlay-put ol 'face 'highlight)
;;       (sit-for 0.5)
;;       (delete-overlay ol)
;;       )))

;;
;; cunstom face function
;;______________________________________________________________________
;; face を調査するための関数
;; いろいろ知りたい場合は C-u C-x =
(defun describe-face-at-point ()
  "Return face used at point."
  (interactive)
  (message "%s" (get-char-property (point) 'face)))

;; kill-ring 中の属性を削除
;; @see http://www-tsujii.is.s.u-tokyo.ac.jp/~yoshinag/tips/junk_elisp.html
;; (defadvice kill-new (around my-kill-ring-disable-text-property activate)
;;   (let ((new (ad-get-arg 0)))
;;     (set-text-properties 0 (length new) nil new)
;;     ad-do-it))

(provide 'init_color)
;;; init_color.el ends here

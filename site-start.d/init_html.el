;;; Commentary:

;; html プログラミング環境改善

;;; Code:

(message "init_html ...")

;;
;; basic setting
;;______________________________________________________________________
;; (require 'html-helper-mode)
;; (require 'html-mode)
;; (require 'tempo)

;;
;; css-mode
;; http://www.garshol.priv.no/download/software/css-mode/doco.html
;;______________________________________________________________________
;; (install-elisp "http://www.garshol.priv.no/download/software/css-mode/css-mode.el")
(defun init-cssm-mode ()
  ;; インデントをCスタイルにする
  (setq cssm-indent-function #'cssm-c-style-indenter)
  ;; インデント幅を２にする
  (setq cssm-indent-level 2)
  ;; インデント文字を使わない
  (setq-default indent-tabs-mode nil)
  ;; 閉じる括弧の前に改行を挿入する
  (setq cssm-newline-before-closing-bracket t))

(add-hook 'css-mode-hook 'init-cssm-mode)

;; auto-complete-mode の有効
(add-to-list 'ac-modes 'css-mode)

;;
;; nxml-mode
;;______________________________________________________________________
;; htmlファイルのデフォルトモードをnXml-Modeに変える。
(add-to-list 'auto-mode-alist '("\\.[sx]?html?\\(\\.[a-zA-Z_]+\\)?\\'" . nxml-mode))

;; auto-complete-mode の有効
(add-to-list 'ac-modes 'nxml-mode)

;; nxml-mode変数設定
(add-hook 'nxml-mode-hook
          (lambda ()
            ;; 更新タイムスタンプの自動挿入
            (setq time-stamp-line-limit 10000)
            (if (not (memq 'time-stamp write-file-hooks))
                (setq write-file-hooks
                      (cons 'time-stamp write-file-hooks)))
            (setq time-stamp-format "%3a %3b %02d %02H:%02M:%02S %:y %Z")
            (setq time-stamp-start "Last modified:[ \t]")
            (setq time-stamp-end "$")
            ;;自動改行を無効化する
            (setq auto-fill-mode -1)
            ;; スラッシュの入力で終了タグを自動補完
            (setq nxml-slash-auto-complete-flag t)
            ;; Mーtabで補完
            (setq nxml-bind-meta-tab-to-complete-flag t)
            ;; C-M-kで下位を含む要素全体をkillする
            (setq nxml-sexp-element-flag t)
            ;; 子要素イデント幅
            (setq nxml-child-ident 0)
            ;; 属性値インデント幅
            (setq nxml-attribute-ident 0)))
;;
;; Edit XHTML5 documents with nxml-mode
;; https://github.com/hober/html5-el
;; git submodule add https://github.com/hober/html5-el.git lisp/html5-el
;; cd lisp/html5-el
;; make relaxng
;;______________________________________________________________________
(eval-after-load "rng-loc"
  '(add-to-list 'rng-schema-locating-files
                (concat user-emacs-directory "lisp/html5-el/schemas.xml")))
(require 'whattf-dt)

;;
;; flymake for xml and html
;;______________________________________________________________________
;;; http://d.hatena.ne.jp/CortYuming/20120330/p1
;;; http://d.hatena.ne.jp/CortYuming/20110920/p1

;;; XML用のFalymake設定
(defun flymake-xml-init ()
  ;; xmllintコマンドでFlymakeを行う
  (list "xmllint" (list "--valid" (flymake-init-create-temp-buffer-copy 'flymake-create-temp-inplace))))

;;; HTML用のFalymake設定
(defun flymake-html-init ()
  (list "tidy" (list (flymake-init-create-temp-buffer-copy 'flymake-create-temp-inplace))))

(add-to-list 'flymake-allowed-file-name-masks
             '("\\.html?\\'" flymake-html-init))

;;; tidy error pattern
(add-to-list 'flymake-err-line-patterns
             '("line \\([0-9]+\\) column \\([0-9]+\\) - \\(Warning\\|Error\\): \\(.*\\)" nil 1 2 4))

(add-hook 'html-mode-hook '(lambda () (flymake-mode t)))

;;
;; html fold setting
;;______________________________________________________________________
;; HTML・XMLの要素を隠して見やすくする
;; (install-elisp "https://github.com/ataka/html-fold/raw/master/html-fold.el")
;; M-x html-fold-buffer html-fold-clearout-buffer
(autoload 'html-fold-mode "html-fold" "Minor mode for hiding and revealing elements." t)
(eval-after-load "html-fold"
  '(progn
    ;; 隠すインライン要素
    (setq html-fold-inline-list
          '(("[a:" ("a"))
            ("[c:" ("code"))
            ("[pre:" ("pre"))
            ("[k:" ("kbd"))
            ("[v:" ("var"))
            ("[s:" ("samp"))
            ("[ab:" ("abbr" "acronym"))
            ("[lab:" ("label"))
            ("[opt:" ("option"))
            ;; RSSの設定
            ("[rss:" ("rss"))
            ("[link:" ("link"))
            ))

    ;; 隠すブロッグ要素
    (setq html-fold-block-list '("script" "style" "table"
                                 ;; RSSの設定
                                 "description" "content"))))
;; html-modeにしたらhtml-fold-modeを有効にする
;; (add-hook 'html-mode-hook 'html-fold-mode)

(provide 'init_html)
;;; init_html.el ends here

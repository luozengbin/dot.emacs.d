;;; Commentary:

;; 編集機能基本設定

;;; Code:

(message "init_edit ...")

(require 'my-lisp-utils)

;;
;; copy paste cut
;;______________________________________________________________________
;; 行削除時の改行削除
(setq kill-whole-line t)

;; リージョンを kill-ring に入れないで削除できるようにする
(delete-selection-mode t)

;; OSのクリップボードに連携できるようにする
(setq x-select-enable-clipboard t)


;;; EmacsでAOP再挑戦
;;; http://dev.ariel-networks.com/Members/inoue/aop-of-emacs-2/
;;; 現在の上下文により内容を動的に特定する
(defun my-hightlight-thing-at-point (thing)
  (cond (mark-active
         (buffer-substring (region-beginning) (region-end)))
        (t
         (if (get thing 'thing-at-point)
             (funcall (get thing 'thing-at-point))
           (let ((bounds (bounds-of-thing-at-point thing)))
             (if bounds
                 (let ((ov (make-overlay (car bounds) (cdr bounds))))
                   (overlay-put ov 'face 'region)
                   (sit-for 0.5)
                   (delete-overlay ov)
                   (buffer-substring (car bounds) (cdr bounds)))))))))

(defun my-sequential-thing-at-point (thing)
  (let ((current-thing (my-hightlight-thing-at-point thing)))
    (if current-thing
        (kill-new (my-hightlight-thing-at-point thing))
      (my-seq-next))))

;;; TODO マクロ化する
(defun my-sequential-thing-at-point-1 ()
  (interactive)
  (my-sequential-thing-at-point 'word))

(defun my-sequential-thing-at-point-2 ()
  (interactive)
  (my-sequential-thing-at-point 'symbol))

(defun my-sequential-thing-at-point-3 ()
  (interactive)
  (my-sequential-thing-at-point  'line))

(defun my-sequential-thing-at-point-4 ()
  (interactive)
  (my-sequential-thing-at-point 'sexp))

(define-sequential-command my-things-at-point
  my-sequential-thing-at-point-1
  my-sequential-thing-at-point-2
  my-sequential-thing-at-point-3
  my-sequential-thing-at-point-4)

;; Experimental multiple-cursors
(require 'multiple-cursors)

;;; mark-multiple
;;; https://github.com/magnars/mark-multiple.el
(require 'inline-string-rectangle)
(require 'mark-more-like-this)

;;; スマートにリージョン選択する
;;; https://github.com/magnars/expand-region.el
(require 'expand-region)
(require 'my-ido)

(define-prefix-command 'my/ctrl-quote-map)
(define-key global-map (kbd "C-,") 'my/ctrl-quote-map)
(smartrep-define-key
    global-map "C-," '(
                       ;; expand-region
                       (","      . 'er/expand-region)
                       ("."      . 'er/contract-region)
                       ("C-,"    . 'my-things-at-point)
                       ("w"      . 'kill-ring-save)
                       ("k"      . 'kill-region)
                       ("y"      . 'cua-paste)
                       ;; ace-jump
                       ("j"      . 'ace-jump-mode)
                       ("i"      . 'ido-imenu-push-mark)
                       ;; multiple-cursors
                       ("^"      . 'mc/edit-lines)
                       ("["      . 'mc/edit-beginnings-of-lines)
                       ("]"      . 'mc/edit-ends-of-lines)
                       ;; mark-multiple
                       ("r"      . 'inline-string-rectangle)
                       ("<"      . 'mark-previous-like-this)
                       (">"      . 'mark-next-like-this)
                       ("m"      . 'mark-more-like-this)
                       ("*"      . 'mark-all-like-this)
                       ;; work with register
                       ("1"      . 'copy-to-register-1)
                       ("2"      . 'paste-from-register-1)
                       ("+"      . 'text-scale-increase)
                       ("-"      . 'text-scale-decrease)
                       ))

;;; TODO move those code to corrent location
;; (require 'rename-sgml-tag)
;; (define-key sgml-mode-map (kbd "C-, C-r") 'rename-sgml-tag)
;; (require 'js2-rename-var)
;; (define-key js2-mode-map (kbd "C-, C-r") 'js2-rename-var)

;; 単語選択、【”】で囲んた文字列の選択、（）で囲んた文字列の選択
;; (global-set-key (kbd "C-$") 'mark-word*)
;; (global-set-key (kbd "C-\"") 'mark-string)
;; (global-set-key (kbd "C-z C-%") 'mark-up-list)

;; 矩形選択補助ツール
;;(require 'sense-region)
;;(sense-region-on)

;;
;; cua-mode
;;______________________________________________________________________
;;; C-S Space -> cua-toggle-global-mark
;;; C-Return  -> cua-set-rectangle-mark
;; Common User Accessモードを有効にする
;; 矩形編集のため有効にする
(cua-mode t)
;; C-cやC-vの乗っ取りを阻止
(setq cua-enable-cua-keys nil)

;;
;; fcopy コピーぺ支援
;;______________________________________________________________________
;;; http://at-aka.blogspot.com/2012/08/fcopyel-ver60.html
;; (install-elisp "https://raw.github.com/ataka/fcopy/master/fcopy.el")
(autoload 'fcopy-mode "fcopy" "copy lines or region without editing but modify." t)
(global-set-key (kbd "C-c k") 'fcopy-mode)

;;
;; undo & redo
;;______________________________________________________________________
;; REDO拡張機能を有効化する
;; redo+.el
;; kbd -> C-.
;; (install-elisp "http://www.emacswiki.org/emacs/download/redo+.el")
;;(require 'redo+)
;;(define-key global-map (kbd "C-.") 'redo)
;; 過去のundoがredoされないようにする
;; (setq undo-no-redo t)
;; 大量のundoを与えるようにする
;; (setq undo-limit 600000)
;; (setq undo-strong-limit 900000)

;; undohist: 閉じたバッファも Undo できる
;; (install-elisp "http://cx4a.org/pub/undohist.el")
;; (when (require 'undohist nil t)
;;   (setq undohist-directory (concat my-cache-dir "undohist"))
;;   (undohist-initialize))

;; undo-tree: Undo の分岐を視覚化する
;; (install-elisp "http://www.dr-qubit.org/undo-tree/undo-tree.el")
;; C-x u (undo-tree-visualize) undo の履歴を可視化する
;; M-x undo-tree-switch-branch
;; 参照リンク:http://www.emacswiki.org/emacs/UndoTree
(require 'undo-tree)
(setq undo-tree-auto-save-history nil)
(setq undo-tree-history-directory-alist `(("." . ,(concat my-cache-dir "undo-tree"))))
(global-undo-tree-mode t)
(defalias 'redo 'undo-tree-redo)
(global-set-key (kbd "C-/") 'undo)
(global-set-key (kbd "C-.") 'redo)
;; モードラインにundo-Treeを非表示
(require 'diminish)
(eval-after-load "undo-tree" '(diminish 'undo-tree-mode))

;;
;; auto-save-buffers
;;______________________________________________________________________
;; ---- 改良版自動保存機能
;; (install-elisp "http://homepage3.nifty.com/oatu/emacs/archives/auto-save-buffers.el")
(require 'auto-save-buffers)
;; 2秒ごとに自動保存
(run-with-idle-timer 2 t 'auto-save-buffers)
;; auto-save-buffersはファイル名に /xxx/ が含まれるファイルに限定する
(setq auto-save-buffers-regexp (rx (or "/memo/" "/junk/" "/howm/")))

;; ファイル末に不要な空白や行を削除する
;;______________________________________________________________________
;; globaly scope
;; (remove-hook 'before-save-hook (lambda () (whitespace-cleanup)))
(add-hook 'emacs-lisp-mode-hook 'no-trailing-space)
(add-hook 'java-mode-hook 'no-trailing-space)
(add-hook 'python-mode-hook 'no-trailing-space)
(add-hook 'nxml-mode-hook 'no-trailing-space)

(defun no-trailing-space ()
  "clean up space when saveing file"
  ;; this hook is buffer local, can't add it globaly
  (add-hook 'write-contents-functions 'delete-trailing-whitespace)
  ;; (add-hook 'write-contents-functions (lambda () (whitespace-cleanup)))
  )

;;; 最終行に必ず一行挿入する
(setq require-final-newline t)

;; point position change
;;______________________________________________________________________
;; 行先頭の非空白位置へ飛ぶ
(defun back-to-indentation-or-beginning ()
  (interactive)
  (if this-command-keys-shift-translated
      (unless mark-active (push-mark nil t t))
    (when (and mark-active cua--last-region-shifted)
      (deactivate-mark)))
  (if (= (point) (progn (back-to-indentation) (point)))
      (beginning-of-line)))

;;; 行を画面先頭に移動する
(defun line-to-top-of-windows ()
  (interactive)
  (recenter 0))
(define-key global-map (kbd "C-z t") 'line-to-top-of-windows)

(provide 'init_edit)
;;; init_edit.el ends here

;;; Commentary:

;; emacs lisp プログラミング環境改善

;;; Code:

(message "init_elisp ...")

;;
;; 入力改善
;; wget http://www.emacswiki.org/pics/static/PareditCheatsheet.png
;;______________________________________________________________________
;; (, "などの入力支援
;; (install-elisp "http://mumble.net/~campbell/emacs/paredit.el")
(require 'paredit)
(add-hook 'emacs-lisp-mode-hook       'enable-paredit-mode)
(add-hook 'lisp-mode-hook             'enable-paredit-mode)
(add-hook 'lisp-interaction-mode-hook 'enable-paredit-mode)
(add-hook 'ielm-mode-hook             'enable-paredit-mode)
;;(add-hook 'scheme-mode-hook           'enable-paredit-mode)

;;; pareditによるdelete-charが使用できないのが困るので、別キーに割り当てする
;;(define-key emacs-lisp-mode-map (kbd "C-c d") 'delete-char)
(smartrep-define-key
    emacs-lisp-mode-map "C-c" '(
                                ("d" .  'delete-char)
                                ))

;; edit-list.elでlispのlist変数を編集しやすいようにする
;; (install-elisp "http://mwolson.org/static/dist/elisp/edit-list.el")
(require 'edit-list)

;;
;; ドキュメントの表示
;;______________________________________________________________________
;; eldocの表示
;; (install-elisp-from-emacswiki "eldoc-extension.el")
(require 'eldoc)
(require 'eldoc-extension)
(setq eldoc-idle-delay 0.2)
(setq eldoc-minor-mode-string "")
(setq eldoc-echo-area-use-multiline-p nil)
(add-hook 'emacs-lisp-mode-hook 'turn-on-eldoc-mode)
(add-hook 'lisp-interaction-mode-hook 'turn-on-eldoc-mode)
(add-hook 'ielm-mode-hook 'turn-on-eldoc-mode)

;;
;; anythingよりemacs変数、関数、コマンド情報を探す
;;______________________________________________________________________
(defun my-anything-emacs ()
  "emacs information display with anything interface"
  (interactive)
  (anything-other-buffer
   '(anything-c-source-emacs-variables
     anything-c-source-emacs-functions
     anything-c-source-emacs-commands)
   "*my anything emacs*"))

;;
;; anythingより日本語Infoを引く
;;______________________________________________________________________
(defvar anything-c-source-info-elisp-ja            '((info-index . "elisp-ja")))
(defvar anything-c-source-info-cl-ja               '((info-index . "cl-j")))
(defvar anything-c-source-info-emacs-ja            '((info-index . "emacs-ja")))
(defvar anything-c-source-info-emacs-lisp-intro-ja '((info-index . "eintr-ja")))
(defvar anything-c-source-info-hustler-ja          '((info-index . "hustler")))
(defvar anything-c-source-info-slime-ja            '((info-index . "slime.info")))
(defvar anything-c-source-info-eieio-ja            '((info-index . "eieio-j.info")))

;; elispモード専有のanything-for-document-sources変数を作成し、
;; anythingメニューのコンテンツを変える
(add-hook 'emacs-lisp-mode-hook 'make-local-anything-for-document-sources)
(defun make-local-anything-for-document-sources ()
  (let ((origin-var anything-for-document-sources))
    (make-local-variable 'anything-for-document-sources)
    (setq anything-for-document-sources origin-var)
    (dolist (source  (reverse '(
                                ;; ;; 日本語マニュアル
                                ;; ;; anything-c-source-info-emacs-ja
                                ;; anything-c-source-info-elisp-ja
                                ;; anything-c-source-info-cl-ja
                                ;; anything-c-source-info-emacs-lisp-intro-ja
                                ;; ;; anything-c-source-info-hustler-ja
                                ;; anything-c-source-info-slime-ja
                                ;; anything-c-source-info-eieio-ja
                                ;; 英語マニュアル
                                anything-c-source-info-cl
                                anything-c-source-info-elisp
                                )))
      (add-to-list 'anything-for-document-sources source))))

;;
;; 色定義をわかりやすくする
;;______________________________________________________________________
;; 定義参照 ./init_color.el:134

;;
;; 関数名の表示
;;______________________________________________________________________
;; 現在の関数名を常に表示する
;; (which-func-mode 1)
;; (setq which-func-mode 1)
;; (delete (assoc 'which-func-mode mode-line-format) mode-line-format)
;; (setq-default header-line-format '(which-func-mode (" " which-func-format)))

;;
;; memo
;;______________________________________________________________________
;; usage-memo.elで*Help*バッファーにメモを残しておく
;; (install-elisp-from-emacswiki "usage-memo.el")
(require 'usage-memo)
(setq umemo-base-directory (concat user-emacs-directory "lispmemo"))
(umemo-initialize)

;;
;; 単体テスト支援
;;______________________________________________________________________
;;; http://d.hatena.ne.jp/kiwanami/20101004/1286196836
;; (install-elisp "https://raw.github.com/gist/608618/4754553a39761adfd1d4a4cf25b37d8372b97299/eval-last-sexp-popup.el")
;; (require 'eval-last-sexp-popup)
;; (global-set-key (kbd "C-x e") 'eval-last-sexp-popup)

;; lispxmp.el 評価値をコメントとして保存する
;; (install-elisp-from-emacswiki "lispxmp.el")
(require 'lispxmp)
(define-key emacs-lisp-mode-map (kbd "C-c C-d") 'lispxmp)

;; el-expectations.elでElispのUnitTestを支援する
;; (auto-install-batch "el-expectations")
(require 'el-expectations)

(provide 'init_elisp)
;;; init_elisp.el ends here

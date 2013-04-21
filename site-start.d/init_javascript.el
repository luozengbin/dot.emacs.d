;;; Commentary:

;; javascript プログラミング環境改善

;;; Code:

(message "init_javascript ...")

;;
;; js-mode (espresso-mode)
;;______________________________________________________________________
(require 'js)
(defun init-js-mode ()
  (setq js-indent-level 2
        js-expr-indent-offset 2
        indent-tabs-mode nil)
  ;; switch文のcaseラベルをインデントする関数を定義する
  (defun my-js-indent-line ()
    (interactive)
    (let* ((parse-status (save-excursion (syntax-ppss (point-at-bol))))
           (offset (- (current-column) (current-indentation)))
           (indentation (js--proper-indentation parse-status)))
      (back-to-indentation)
      (if (looking-at "case\\s-")
          (indent-line-to (+ indentation 2))
        (js-indent-line))
      (when (> offset 0) (forward-char offset))))
  ;; caseラベルのインデント処理をセットする
  (set (make-local-variable 'indent-line-function) 'my-js-indent-line))

;; (add-hook 'js-mode 'init-js-mode)

;;
;; js2-mode
;;______________________________________________________________________
;; (add-hook 'js2-mode 'init-js-mode)

;;
;; javascript lint setting
;;______________________________________________________________________
;; JavaScript Lintで文法チェック
;; 参照リンク:
;;      http://d.hatena.ne.jp/kazu-yamamoto/20071029/1193651325
;;      http://www.javascriptlint.com
;; flymake-mode: 動的構文チェッカ flymake-jsl.el

;; js-mode用のhookを用意
(when (executable-find "jsl")
  (defun js-mode-hooks ()
    ;; キーマップをセット
    (setq flymake-jsl-mode-map 'js-mode-map)
    ;; flymake-jslを起動するための設定
    (when (require 'flymake-jsl nil t)
      (setq flymake-check-was-interrupted t)))
  ;; js-modeの起動時にhookを追加
  (add-hook 'js-mode-hook 'js-mode-hooks))

;; ;;; compile コマンドを利用して構文チェック
;; ;; C-c C-c で構文チェック
(add-hook 'js-mode-hook
          (lambda ()
            ;; JavaScript Lint
            (set (make-local-variable 'compile-command)
                 (concat "jsl -process " buffer-file-name))
            (define-key js-mode-map "\C-c\C-c" 'compile)))

(add-hook 'js-mode-hook
          '(lambda ()
             (flymake-mode t)))

;; --------- google closure compilerで文法チェックを行う
;; (when (load "flymake" t)
;;   (defun flymake-closure-init ()
;;     (let* (
;;            (temp-file (flymake-init-create-temp-buffer-copy
;;                        'flymake-create-temp-inplace))
;;            (local-file (file-relative-name
;;                         temp-file
;;                         (file-name-directory buffer-file-name)))
;;            )
;;       (list "closure.sh" (list local-file))))
;;   (add-to-list 'flymake-allowed-file-name-masks
;;                '("\\.js\\'" flymake-closure-init)))

;;
;; format json by python
;;______________________________________________________________________
(defun json-format ()
  (interactive)
  (save-excursion
    (shell-command-on-region (mark) (point) "python -m json.tool" (buffer-name) t)))


(provide 'init_javascript)
;;; init_javascript.el ends here

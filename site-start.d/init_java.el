;;; Commentary:

;; java プログラミング環境の改善

;;; Code:

(message "init_java ...")

;; ;;
;; ;; auto-insert + yasnippet
;; ;;______________________________________________________________________
;; ;; auto-insert + yasnippet javaファイル作成時にclass codeを自動展開する
;; ;; (define-auto-insert "\\.java$" (lambda (insert "class") (yas/expand)))

;; ;;
;; ;; ajc-java-complete
;; ;;______________________________________________________________________
;; ;; http://www.emacswiki.org/emacs/AutoJavaComplete
;; ;; git clone git://github.com/jixiuf/ajc-java-complete.git
;; ;; http://www.emacswiki.org/emacs/ajc-java-complete-my-config-example.el
;; ;; auto-complete-javaの設定
;; (require 'ajc-java-complete-config)
;; (add-hook 'java-mode-hook 'ajc-java-complete-mode)
;; (add-hook 'find-file-hook 'ajc-4-jsp-find-file-hook)

;; ;;
;; ;; java anotation support
;; ;;______________________________________________________________________
;; ;; アノテーションインデント
;; ;; (install-elisp-from-emacswiki "java-mode-indent-annotations.el")
;; (require 'java-mode-indent-annotations)
;; (defun my-java-mode-hook()
;;   (java-mode-indent-annotations-setup))
;; (add-hook 'java-mode-hook 'my-java-mode-hook)

;; ;;
;; ;; JDEE
;; ;;______________________________________________________________________
;; ;; Or enable more if you wish
;; (setq semantic-default-submodes '(global-semantic-idle-scheduler-mode
;;                                   global-semanticdb-minor-mode
;;                                   global-semantic-idle-summary-mode
;;                                   global-semantic-mru-bookmark-mode))
;; (semantic-mode 1)


;;
;; groovy mode
;;______________________________________________________________________
;;; elpaのgroovy-modeに一部機能がうまく動作しないので、オーバーライドします
(eval-after-load 'groovy-mode
  '(progn
     (defun groovy-load-file (file-name)
       "Load a Groovy file into the inferior Groovy process."
       (interactive (comint-get-source "Load Groovy file: " groovy-prev-l/c-dir/file
                                       groovy-source-modes t)) ; T because LOAD
                                        ; needs an exact name
       (comint-check-source file-name) ; Check to see if buffer needs saved.
       (setq groovy-prev-l/c-dir/file (cons (file-name-directory    file-name)
                                            (file-name-nondirectory file-name)))
       (comint-send-string (groovy-proc) (concat ":l "
                                                 file-name
                                                 "\n"))))
  )

;;
;; Malabar Mode
;;______________________________________________________________________
;; ;;; *** Malabar Mode : A better Java mode
;; (when (require 'malabar-mode nil t)
;;   (setq malabar-groovy-lib-dir (expand-file-name "~/.emacs.d/toolkit/malabar-1.4.0/lib"))
;;   (add-to-list 'auto-mode-alist '("\\.java\\'" . malabar-mode))
;;   ;; 普段使わないパッケージを import 候補から除外
;;   (add-to-list 'malabar-import-excluded-classes-regexp-list
;;                "^java\\.awt\\..*$")
;;   (add-to-list 'malabar-import-excluded-classes-regexp-list
;;                "^com\\.sun\\..*$")
;;   (add-to-list 'malabar-import-excluded-classes-regexp-list
;;                "^org\\.omg\\..*$")
;;   (add-hook 'malabar-mode-hook
;;             (lambda ()
;;               (add-hook 'after-save-hook 'malabar-compile-file-silently
;;                         nil t))))

;; ;;; **** Malabar Groovy : Customization of malabar-mode's inferior Groovy.
;; (setq malabar-groovy-java-options '("-Duser.language=en")) ; 日本語だとコンパイルエラーメッセージが化けるので

;; ;; for getter/setter の生成
;; (fset 'subword-capitalize 'capitalize-word)


(provide 'init_java)
;;; init_java.el ends here

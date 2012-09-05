;;; Commentary:

;; anything 設定

;;; Code:

(message "init_anything ...")

;;
;; anythingに手を加えた部分
;;______________________________________________________________________

;;; anything-c-source-w3m-bookmarksの無効化
;; anything-c-source-w3m-bookmarksフラグ
;; anything-config.elの6655行目に次のように見直す
;;  --> (when (and toggle-anything-w3m (executable-find "w3m"))
(defvar toggle-anything-w3m nil)

;;; Linux環境で外部アプリケーションを起動するアクションの修正
(defun anything-c-open-file-with-default-tool (file)
  "Open FILE with the default tool on this platform."
  (if (eq system-type 'windows-nt)
      (anything-w32-shell-execute-open-file file)
    ;; process-connection-typeをnilにする
    (let ((process-connection-type nil))
      (start-process "anything-c-open-file-with-default-tool"
                     nil
                     (cond ((eq system-type 'gnu/linux)
                            "xdg-open")
                           ((or (eq system-type 'darwin) ;; Mac OS X
                                (eq system-type 'macos)) ;; Mac OS 9
                            "open"))
                     file))))

;;
;; anything統合インタフェースの設定
;;______________________________________________________________________
;; anything.el
;; http://www.emacswiki.org/emacs/download/anything.el
;; M-x auto-install-batch anything
;; (install-elisp-from-emacswiki "anything-yaetags.el")
(require 'anything nil t)
(require 'anything-config nil t)
(require 'anything-complete nil t)
(require 'anything-grep nil t)
(require 'anything-match-plugin nil t)
(require 'anything-show-completion nil t)
(and (executable-find "cmigemo")
     (require 'anything-migemo nil t))
;; (require 'anything-c-moccur)
;; (require 'anything-startup)

;; anythingに変数定義
(setq
 ;; debugフラグ
 ;; anything-debug t
 ;; 候補を表示するまでの時間。デフォルトは0.5
 anything-idle-delay 0.3
 ;; タイプして再描写するまでの時間。デフォルトは0.1
 anything-input-idle-delay 0.2
 ;; 候補の最大表示数。デフォルトは50
 anything-candidate-number-limit 100
 ;; 候補が多いときに体感速度を早くする
 anything-quick-update t
 ;; 候補選択ショートカットをアルファベットに
 anything-enable-shortcuts 'alphabet
 ;; root権限でアクションを実行するときのコマンド
 ;; デフォルトは"su"
 anything-su-or-sudo "sudo"
 ;; M-xによる補完をAnythingで行なう
 ;; (anything-read-string-mode 1)
 ;; lispシンボルの補完候補の再検索時間
 anything-lisp-complete-symbol-set-timer 150)

;; ------------> 目が疲れそう、コメントアウトしました。
;; バッファに対しては、カーソルを合わせただけで中身を表示する
;; (add-hook 'anything-move-selection-after-hook
;;           (lambda()
;;             (when (eq (cdr (assq 'type (anything-get-current-source))) 'buffer)
;;               (anything-execute-persistent-action))))

;;
;; anythingコマンドの定義
;;______________________________________________________________________
;; my-anything
(defun my-anything ()
  "anything command for me "
  (interactive)
  (anything-other-buffer
   '(anything-c-source-buffers+
     ;;anything-c-source-buffers
     anything-c-source-bookmarks
     anything-c-source-recentf
     anything-c-source-files-in-current-dir+
     anything-c-source-imenu
     anything-c-source-create)
   "*anything*"))

;; 以前の設定
;; anything源の設定
;; (setq anything-sources
;;       '(anything-c-source-buffers+
;;         anything-c-source-bookmarks
;;         anything-c-source-recentf
;;         ;; anything-c-source-buffer-not-found
;;         anything-c-source-files-in-current-dir+
;;         anything-c-source-imenu
;;         ;;        anything-c-source-gtags-select
;;         anything-c-source-yaetags-select
;;         anything-c-source-emacs-commands
;;         ;; anything-c-source-R-local
;;         ;; anything-c-source-R-help
;;         ;;        anything-c-source-etags-select
;;         ;;        anything-c-source-colors
;;         ;;        anything-c-source-recentf
;;         ;;        anything-c-source-man-pages
;;         ;;        anything-c-source-emacs-commands
;;         ;;        anything-c-source-emacs-functions
;;         ))

;;
;; anything-topコマンドの設定
;;______________________________________________________________________
;; 環境にあわせてanything-topコマンドの再定義
;; (setq anything-c-top-command "COLUMNS=%s top")

;;
;; anythingキーバンディングのカスタマイズ
;;______________________________________________________________________
;; anything-commandのprefix-Keyを "<f5> a" → "C-z a"に変える
(custom-set-variables '(anything-command-map-prefix-key "C-z a"))

;; anything-local-mapによるanything-mapが無効の問題を解決する
(setq anything-local-map-override-anything-map nil)

;; [C-SPC] → [C-@]
;; anythingでオブジェクト選択キーバンディングを変える
(define-key anything-map (kbd "C-@") 'anything-toggle-visible-mark)

;;
;; describe-bindingsをanythingインタフェースに変えて、絞れるように改善する
;;______________________________________________________________________
;;(global-set-key (kbd "C-h b") 'descbinds-anything)
(when (require 'descbinds-anything nil t)
  ;; describe-bindingsをAnythingに置き換える
  (descbinds-anything-install))

;;
;; anythingによる補完
;;______________________________________________________________________
;; 補足：M-c 元はseq-capitalize-backward-wordコマンドに割り当てられている
(define-key emacs-lisp-mode-map (kbd "M-c") 'anything-lisp-complete-symbol-partial-match)

;; 何でもanythingで補完
;; (anything-completion-mode -1)

;;
;; anything-projectの設定
;; 参考リンク：http://d.hatena.ne.jp/kitokitoki/20110710/p1
;;______________________________________________________________________
;;; anything-project: プロジェクトからファイルを絞り込み
;; (install-elisp "http://github.com/imakado/anything-project/raw/master/anything-project.el")
(when (require 'anything-project nil t)
  (global-set-key (kbd "C-z C-f") 'anything-project)
  (setq ap:project-files-filters
        (list
         (lambda (files)
           (remove-if 'file-directory-p files)
           (remove-if '(lambda (file) (string-match-p "~$" file)) files)))))
;; ---- for visual studio project
;; (ap:add-project
;;  :name 'visualstudio
;;  :look-for 'ap:vs-root-detector
;;  :include-regexp '("\\.cpp$" "\\.h$" "\\.hpp$" "\\.inl$" "\\.cs$")
;;  )
;; (defun ap:vs-root-detector (files)
;;   (subsetp '("\\.sln")
;;            files
;;            :test 'string-match))

;;
;; anything の表示設定
;;______________________________________________________________________
;; anythingをpopwinで表示する
;; (require 'popwin)
;; (setq anything-samewindow nil)
;; (push '("*anything*" :height 20) popwin:special-display-config)

;; anythingを左右分割で表示する
;; (defadvice anything-default-display-buffer (around my-anything-default-display-buffer activate)
;;   (delete-other-windows)
;;   (split-window (selected-window) nil t)
;;   (pop-to-buffer buf))

;; default face を反転し設定する
;; TODO anything-headerのfaceがカスタマイズされていない場合
(set-face-background 'anything-header (face-foreground 'default))
(set-face-foreground 'anything-header (face-background 'default))

;;
;; key binding
;;______________________________________________________________________
;; anythingメニュー表示する
(global-set-key (kbd "C-x t") 'my-anything)
;;; hidden bufferの絞り込み
(global-set-key (kbd "C-x y") 'my-anything-hidden-buffer-commands)

;;
;; custom anything
;;______________________________________________________________________
;; 自作関数をローディングする
(require 'my-anything-sources)

(provide 'init_anything)
;;; init_anything.el ends here

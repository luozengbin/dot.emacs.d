;;; Commentary:

;; 補完設定

;;; Code:

(message "init_completion ...")

;;
;; abbrev mode 単語補完
;;______________________________________________________________________
;; [C-x a i g] save in global
;; [C-x a i l] save in local
;; 保存先を指定する
(setq abbrev-file-name (concat my-private-emacs-path "configuration/abbrev_defs"))
;; 略語定義が変更されていたら黙って保存
(setq save-abbrevs 'silently)

;;
;; ibuffer
;;______________________________________________________________________
;; ibufferモードを有効化
(global-set-key (kbd "C-x C-b") 'ibuffer)

;;
;; icomplete-mode
;;_____________________________________________________________________
;; 補完時に大文字小文字を区別しない
;; (setq completion-ignore-case t)
(setq read-buffer-completion-ignore-case t)
(setq read-file-name-completion-ignore-case t)

;; 強力な補完機能を使う
;; p-bでprint-bufferとか
(load "complete")
(partial-completion-mode t)

;; 補完可能なものを随時表示
(icomplete-mode t)

;;
;; ido モード
;; http://www.masteringemacs.org/articles/2010/10/10/introduction-to-ido-mode/
;; http://emacswiki.org/emacs/InteractivelyDoThings
;;______________________________________________________________________
;; idoモードを有効にする
(setq ido-save-directory-list-file (my-cache-dir ".ido.last"))
(setq ido-enable-flex-matching t)
(setq ido-use-filename-at-point 'guess)
(setq ido-use-url-at-point t)
(setq ido-create-new-buffer 'always)
;; (setq ido-file-extensions-order
;;       '(".org" ".txt" ".py" ".emacs" ".xml" ".el" ".ini" ".cfg" ".cnf"))
;; (setq ido-ignore-buffers )
;; (setq ido-ignore-directories )
;; (setq ido-ignore-files )
;; (setq ido-ignore-extensions t)

;;; ido-modeを有効化
;; (ido-mode t)
;; (ido-everywhere t)                      ;'file 'buffer

;; ido ベースのM-x 拡張
;; https://github.com/nonsequitur/smex/
(unless mac-p
  (require 'smex)
  (setq smex-save-file (my-cache-dir ".smex-items"))
  (smex-initialize)

  (global-set-key (kbd "M-x") 'smex)
  (global-set-key (kbd "M-X") 'smex-major-mode-commands)
  ;; This is your old M-x.
  (global-set-key (kbd "C-c C-c M-x") 'execute-extended-command))

;; ;;
;; ;; iswitchbモード
;; ;;______________________________________________________________________
;; ;; ---- idoモードの機能と競合があるため、片方を使用する
;; ;; iswitchbで C-x C-b を改善する
;; (iswitchb-mode 1)
;; ;; バッファーを読取関数をiswitchbにする
;; (setq read-buffer-function 'iswitchb-read-buffer)
;; ;; 部分文字マッチを使う、正規表現なら t にする
;; (setq iswitchb-regexp nil)
;; ;; 新しいバッファーを作成するときにいちいち聞いてこない
;; (setq iswitchb-prompt-newbuffer nil)

;; C-x C-f でpoint現在のファイルやURLを開く
(ffap-bindings)

;;
;; thing-opt
;;______________________________________________________________________
;; カーソル位置の単語、段落をうまく操作できるようにする
;; (install-elisp "http://www.emacswiki.org/emacs/download/thing-opt.el")
(require 'thing-opt)
(define-thing-commands)

;;
;; ElectricPai Mode
;; Emacs 24 からインストール不要
;;______________________________________________________________________
;;(electric-pair-mode t)

;;
;; autopair 補完設定
;;______________________________________________________________________
;; http://code.google.com/p/autopair/
;; (install-elisp "http://autopair.googlecode.com/svn/trunk/autopair.el")
;; (require 'autopair)
;; (autopair-global-mode) ;; enable autopair in all buffers

;;
;; skeleton 補完設定
;;______________________________________________________________________
;; http://www.emacswiki.org/emacs/SkeletonMode
;; http://www.emacswiki.org/emacs/SkeletonPair
(require 'skeleton)
;; modo-hook対応
;;(setq skeleton-pair t)
(global-set-key (kbd "(") 'skeleton-pair-insert-maybe)
(global-set-key (kbd "[") 'skeleton-pair-insert-maybe)
(global-set-key (kbd "{") 'skeleton-pair-insert-maybe)
;; (global-set-key (kbd "'") 'skeleton-pair-insert-maybe)
(global-set-key (kbd "\"") 'skeleton-pair-insert-maybe)
(add-to-list 'skeleton-pair-alist '(?「 _ ?」))
(global-set-key (kbd "「") 'skeleton-pair-insert-maybe)
;; スイッチ関数の定義
(defun toggle-skeleton-mode ()
  "turn on/off for skeleton-mode"
  (interactive)
  (if skeleton-pair
      (setq skeleton-pair nil)
    (setq skeleton-pair t)))

;;
;; smartchr 補完設定
;; 使い方：http://tech.kayac.com/archive/emacs-tips-smartchr.html
;;______________________________________________________________________
;; smartchrで連続入力の挙動を変更する
;; (install-elisp "http://github.com/imakado/emacs-smartchr/raw/master/smartchr.el")
(require 'smartchr)
(defun my-smartchr-setting ()
  (local-set-key (kbd "=") (smartchr '(" = " " == " "=")))
  (local-set-key (kbd "+") (smartchr '(" + " "++" " += " "+")))
  (local-set-key (kbd "-") (smartchr '(" - " "--" " -= " "-")))
  (local-set-key (kbd "\"") (smartchr '("\"`!!'\"" "\"")))
  (local-set-key (kbd "'") (smartchr '("'`!!''" "'")))
  (local-set-key (kbd ">") (smartchr '(">" "->" ">>")))
  (local-set-key (kbd "(") (smartchr '("(`!!')" "(")))
  (local-set-key (kbd "{") (smartchr '("{ `!!' }" "{\n`!!'\n}" "{")))
  (local-set-key (kbd "[") (smartchr '("[`!!']" "[")))
  )
(add-hook 'php-mode-hook 'my-smartchr-setting)
(add-hook 'javascript-mode-hook 'my-smartchr-setting)
(add-hook 'java-mode-hook 'my-smartchr-setting)

;;
;; key-combo 補完設定
;; 使い方：
;; 	http://d.hatena.ne.jp/uk-ar/20111208/1322572618
;;______________________________________________________________________
;; (auto-install-from-url "https://raw.github.com/uk-ar/key-combo/master/key-combo.el")

(provide 'init_completion)
;;; init_completion.el ends here

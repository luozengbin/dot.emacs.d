;;; Commentary:

;; auto-complete自動補完設定

;;; Code:

(message "init_auto-complete ...")

;;
;; auto-complete
;;______________________________________________________________________
;; http://www.emacswiki.org/emacs/AutoComplete
;; git clone https://github.com/m2ym/auto-complete.git
;; auto-complete自動補完
(require 'auto-complete)

;; auto-complete キャッシュファイル
(setq ac-comphist-file (concat my-cache-dir "ac-comphist.dat"))

;; ac情報源の設定
(require 'auto-complete-config)
(ac-config-default)
;; (global-auto-complete-mode t)

;; 補完アクション開始延遅時間
;; (setq ac-delay 0.5)

;; ac-sourcesのカスタマイズ設置
;; (setq ac-sources '(.......))
;; 補完モード自動化対象モードの追加
(add-to-list 'ac-modes 'org-mode)
(add-to-list 'ac-modes 'text-mode)
(add-to-list 'ac-modes 'html-mode)
(add-to-list 'ac-modes 'ess-mode)

;;
;; カスタマイズキーバンド
;;______________________________________________________________________
;; (add-hook 'auto-complete-mode-hook
;;           (lambda ()
;;             (define-key ac-completing-map (kbd "C-n") 'ac-next)
;;             (define-key ac-completing-map (kbd "C-p") 'ac-previous)))

(define-key ac-mode-map (kbd "C-z c") 'auto-complete)

;;
;; yasnippet 最新版対応
;;______________________________________________________________________
;; (defun ac-yasnippet-candidates ()
;;                  .........
;;                  (ac-yasnippet-candidate-1 table)))))))

;;
;; pos-tip.elで ヘルプを綺麗に表示する
;;______________________________________________________________________
;;; http://www.emacswiki.org/emacs-en/PosTip
;; (install-elisp "http://www.emacswiki.org/emacs/download/pos-tip.el")
;; (install-elisp "http://www.emacswiki.org/emacs/download/popup-pos-tip.el")
(require 'pos-tip)
(require 'popup-pos-tip)
(defadvice popup-tip
  (around popup-pos-tip-wrapper (string &rest args) activate)
  (if (eq window-system 'x)
      (apply 'popup-pos-tip string args)
    ad-do-it))

;;
;; 補完情報源の追加
;;______________________________________________________________________
(require 'my-ac-source)

;;; ファイル名補完の追加
(add-hook 'auto-complete-mode-hook
          (lambda ()
            (add-to-list 'ac-sources 'ac-source-yasnippet)
            (add-to-list 'ac-sources 'ac-source-filename)))

;; 以下はこのサイトからパックしたもの
;; http://www.cnblogs.com/bamanzi/archive/2011/08/20/emacs-complete-words.html
;;
;; 英語補完
;;______________________________________________________________________
;; 英語辞書の位置
(setq my/ac-en-dict-dir (concat user-emacs-directory "share/ac-dict/en/"))
;; キーバンド
(global-set-key (kbd "C-z C-e") 'ac-expand-english-words)

;;
;; 中国語補完
;;______________________________________________________________________
;; 英語辞書の位置
(setq my/ac-cn-dict-dir (concat user-emacs-directory "share/ac-dict/cn/"))
;; キーバンド
(global-set-key (kbd "C-z C-c") 'ac-expand-chinese-words)

(provide 'init_auto-complete)
;;; init_auto-complete.el ends here

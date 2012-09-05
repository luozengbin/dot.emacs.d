;;; Commentary:

;; R プログラミング環境改善
;; R言語 統計解析向けプログラミング言語、及びその開発実行環境である。

;;; Code:

(message "init_R ...")

;;
;; ess-R
;;______________________________________________________________________
;; 参照リンク: http://sheephead.homelinux.org/2009/10/26/1673/
;; R execute module download from → http://www.r-project.org/
;; ess lisp download from → http://ess.r-project.org/
;; (require 'ess-site)
(setq auto-mode-alist
      (cons (cons "\\.r$" 'R-mode) auto-mode-alist))
(autoload 'R-mode "ess-site" "Emacs Speaks Statistics mode" t)

;;auto-completeの設定
;; git clone https://github.com/myuhe/auto-complete-acr.el.git
(eval-after-load "ess-site" 
  '(progn
     (require 'anything-R)
     (require 'auto-complete-acr)
     (require 'ess-R-object-popup)

     ;; FIXME 環境変数で対応する
     (if windows-p
         (setq-default inferior-R-program-name "C:/ProgramData/R/R-2.13.1/bin/R.exe")
       )
     ))

;;
;; inline R
;;______________________________________________________________________
;; Rソースコードへのグラフ埋め込みinlineR.el
;; 参照: http://sheephead.homelinux.org/2011/02/10/6602/
;; (install-elisp "https://raw.github.com/myuhe/inlineR.el/master/inlineR.el")
(eval-after-load "ess-site" 
  '(progn
     (require 'inlineR)
     ))

(provide 'init_R)
;;; init_R.el ends here

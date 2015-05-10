;;; Commentary:

;; タブバーの表示設定

;;; Code:

(message "init_tabbar ...")

;;; install
;; http://www.emacswiki.org/emacs/TabBarMode
;; wget http://www.emacswiki.org/emacs/download/tabbar.el
;; wget http://www.emacswiki.org/emacs/download/close-tab.xpm
;; wget http://www.emacswiki.org/emacs/download/down.xpm
;; wget http://www.emacswiki.org/emacs/download/left.xpm
;; wget http://www.emacswiki.org/emacs/download/left-disabled.xpm
;; wget http://www.emacswiki.org/emacs/download/right.xpm
;; wget http://www.emacswiki.org/emacs/download/right-disabled.xpm
;; wget http://www.emacswiki.org/emacs/download/up.xpm
;; wget http://www.emacswiki.org/emacs/download/tabbar-ruler.el

(require 'tabbar)
(setq tabbar-mode nil)


;; Ctrl-Tab, Ctrl-Shift-Tab でタブを切り替える
;; (dolist (func '(tabbar-mode tabbar-forward-tab tabbar-forward-group tabbar-backward-tab tabbar-backward-group))
;;   (autoload func "tabbar" "Tabs at the top of buffers and easy control-tab navigation"))
;; (defmacro defun-prefix-alt (name on-no-prefix on-prefix &optional do-always)
;;   `(defun ,name (arg)
;;      (interactive "P")
;;      ,do-always
;;      (if (equal nil arg)
;;          ,on-no-prefix
;;        ,on-prefix)))
;; (defun-prefix-alt shk-tabbar-next (tabbar-forward-tab) (tabbar-forward-group) (tabbar-mode 1))


;; tab切替
;; (global-set-key (kbd "<S-s-right>") 'tabbar-forward-tab)
;; (global-set-key (kbd "<S-s-left>") 'tabbar-backward-tab)

;; tab切替
(require 'smartrep)
(smartrep-define-key
    global-map "C-z" '(
                       ;;("<C-left>"  . 'tabbar-backward-group)
                       ;;("<C-right>" . 'tabbar-forward-group)
                       ("<left>"  . 'tabbar-backward)
                       ("<right>" . 'tabbar-forward)
                       ("C-k"     . '(progn
                                      (kill-buffer (buffer-name))
                                      (tabbar-forward)
                                      ))
                       ))

;; 以前の設定
;; (global-set-key (kbd "C-z <C-right>") 'tabbar-forward)
;; (global-set-key (kbd "C-z <C-left>") 'tabbar-backward)
;; (global-set-key (kbd "C-z <C-up>") 'tabbar-forward-group)
;; (global-set-key (kbd "C-z <C-down>") 'tabbar-backward-group)


;;
;; custom tabbar face
;;______________________________________________________________________
;; (set-face-background 'tabbar-default "grey20")
;; (set-face-foreground 'tabbar-default "white")
;; (set-face-foreground 'tabbar-selected "LightSkyBlue")
;;; (face-foreground 'font-lock-function-name-face)
;; (setq tabbar-background-color "grey20")
;; (set-face-foreground 'tabbar-separator "grey20")

(provide 'init_tabbar)
;;; init_tabbar.el ends here

;;; Commentary: 

;; 環境変数関連の設定

;;; Code:

(require 'my-lisp-utils)

(message "init_setenv ...")

;;
;; LANG, LC_ALL指定
;;______________________________________________________________________
(setenv "LANG" "ja_JP.UTF-8")
(setenv "LC_ALL" "ja_JP.UTF-8")

;;
;; path, manpathの設定
;;______________________________________________________________________
(defvar my-man-dirs nil)

(defvar emacs-local-bin (expand-file-name (concat user-emacs-directory "bin/")))

(defvar os-local-bin
  (cond
   (windows-p (expand-file-name (concat user-emacs-directory "bin/windows/")))
   (linux-p (expand-file-name (concat user-emacs-directory "bin/linux/")))
   (linux-p (expand-file-name (concat user-emacs-directory "bin/mac-os/")))))

;; Mac OSX のPATH設定
(when mac-p
  ;; Mac OS X の bash の PATH
  (append-dirs-to-env-path (list
                       "/usr/local/bin"
                       "/usr/X11/bin"
                       "/sw/bin"
                       "/opt/local/bin"
                       emacs-local-bin
                       (expand-file-name "~/.nvm/v0.6.0/bin")
                       (expand-file-name "~/toolkits/ImageMagick-6.7.4/bin")))
  ;; manドキュメントのパス
  (setq my-man-dirs (list
                     (expand-file-name (concat user-emacs-directory "share/man/ja_JP.UTF-8"))
                     "/usr/share/man/"
                     "/usr/local/share/man"
                     "/usr/local/share/man/ja"
                     "/Developer/usr/share/man"
                     "/usr/X11/man"))
  (append-varlist-to-env my-man-dirs "MANPATH"))

;; windows のPATH設定
(when windows-p
  ;; Windows の shell の PATH
  (append-dirs-to-env-path (list
                            emacs-local-bin
                            os-local-bin
                            ;; R言語
                            ;; Perl言語
                            ;; Ruby言語
                            ;; Python言語
                            ;; privateに置かれたツール
                            ;; (expand-file-name (concat my-private-emacs-path "toolkit/twittering-mode/win-curl"))
                            (expand-file-name (concat os-local-bin "cmigemo-default-win32"))
                            (expand-file-name (concat my-private-emacs-path "toolkit/WinShot-1.53a")) ;画面キャプチャツール
                            (expand-file-name (concat my-private-emacs-path "toolkit/boxes-1.1"))
                            (expand-file-name (concat my-private-emacs-path "toolkit/darkroom-mode"))
                            (expand-file-name (concat my-private-emacs-path "toolkit/jsl-0.3.0"))
                            (expand-file-name (concat my-private-emacs-path "toolkit/googlecl-win32-0.9.13"))))
  (setq my-man-dirs (list
                     (expand-file-name (concat user-emacs-directory "share/man/ja_JP.UTF-8"))))
  (append-varlist-to-env my-man-dirs "MANPATH"))

(when linux-p
  ;; shellのPATH変数を取り込み
  (set-exec-path-from-shell-PATH)
  ;; linux の bash の PATH
  (append-dirs-to-env-path (list
                            emacs-local-bin
                            os-local-bin))
  ;; ;; manドキュメントのパス
  ;; (setq my-man-dirs (list
  ;;                    (expand-file-name (concat user-emacs-directory "share/man/ja_JP.UTF-8"))
  ;;                    "/usr/share/man/"
  ;;                    "/usr/local/share/man"
  ;;                    "/usr/local/share/man/ja"
  ;;                    "/Developer/usr/share/man"
  ;;                    "/usr/X11/man"
  ;;                    ))
  ;; (append-varlist-to-env my-man-dirs "MANPATH")
  )

;;
;; java環境変数の設定
;;______________________________________________________________________
;; java options設定
(setenv "JAVA_OPTS" "-Dfile.encoding=UTF-8")

;;
;; ssh接続環境変数
;;______________________________________________________________________
;; (setenv "CVS_RSH" "ssh")
;; (setenv "DISPLAY" "localhost")
(setenv "SSH_AUTH_SOCK" (getenv "SSH_AUTH_SOCK"))

;;
;; private環境変数の読み込む
;;______________________________________________________________________
;; privateからprivate環境変数を読み込む
(require 'init_privateenv)

;;
;; ウェブブラウザの選択
;;______________________________________________________________________
(when linux-p
    (setq browse-url-browser-function 'browse-url-generic
          browse-url-generic-program "chromium"))

(provide 'init_setenv)
;;; init_setenv.el ends here

;;
;; emacs-lisp compile debug
;;______________________________________________________________________
;; デバッグ状態
(setq debug-on-error nil)

;; clを使うelispが多いようなので
(require 'cl)

;; バイトコンパイル時のワーニングを抑制する
(setq byte-compile-warnings '(free-vars unresolved callargs redefine obsolete noruntime cl-functions interactive-only make-local))

;; モジュールローディング時間の記録
(defvar my-module-loading-log-flag nil)
(if my-module-loading-log-flag
    (defadvice require (around require-cost-time activate)
      (let* ((start-time (current-time))
             (result ad-do-it)
             (end-time (current-time))
             (cost-time (float-time (time-subtract end-time start-time))))
        ;;(when (> cost-time 1)
        (save-excursion
          (set-buffer (get-buffer-create "*module loading time log*"))
          (goto-char (point-max))
          (insert (format "%s --> %.3f sec\n" (symbol-name (ad-get-arg 0)) cost-time)))
        ;;)
        )))

;;
;; load path
;;______________________________________________________________________
;; 引数を load-path へ追加
;; normal-top-level-add-subdirs-to-load-path はディレクトリ中の中で
;; [A-Za-z] で開始する物だけ追加するので、追加したくない物は . や _ を先頭に付与しておけばロードしない
;; load-pathの追加関数
(defun add-to-load-path (base-path &rest paths)
  (let (path)
    (dolist (path paths paths)
      (let ((default-directory (expand-file-name (concat base-path path))))
        (add-to-list 'load-path default-directory)
        (if (fboundp 'normal-top-level-add-subdirs-to-load-path)
            (normal-top-level-add-subdirs-to-load-path))))))

;; Emacs Lisp のPathを通す
(add-to-load-path user-emacs-directory
                  "lisp"
                  ;; 変更したり、自作の Emacs Lisp
                  "local-lisp"
                  ;; 初期設定ファイル
                  "site-start.d")

;; 公開しない部分
(defvar my-private-emacs-path (concat user-emacs-directory "private/"))
(add-to-load-path my-private-emacs-path "lisp")

;;
;; emacsの起動と終了
;;______________________________________________________________________
;; 終了時バイトコンパイル
(add-hook 'kill-emacs-query-functions
          (lambda ()
            (if (file-newer-than-file-p (concat user-emacs-directory "init.el") (concat user-emacs-directory "init.elc"))
                (byte-compile-file (concat user-emacs-directory "init.el")))
            ;; (byte-recompile-directory (concat user-emacs-directory "lisp") 0)
            ;; (byte-recompile-directory (concat user-emacs-directory "elpa") 0)
            (byte-recompile-directory (concat user-emacs-directory "local-lisp") 0)
            (byte-recompile-directory (concat user-emacs-directory "private/lisp") 0)
            (byte-recompile-directory (concat user-emacs-directory "private/mew-config") 0)
            (byte-recompile-directory (concat user-emacs-directory "site-start.d") 0)))

;; 起動時間計測 目標は常に 3000ms 圏内(dump-emacs すれば可能だがしてない)
(defun message-startup-time ()
  (message "Emacs loaded in %dms"
           (/ (- (+ (third after-init-time) (* 1000000 (second after-init-time)))
                 (+ (third before-init-time) (* 1000000 (second before-init-time))))
              1000)))
(add-hook 'after-init-hook 'message-startup-time)

;; 終了時に聞く
(setq confirm-kill-emacs 'y-or-n-p)

;;
;; emacs version variable
;;______________________________________________________________________
;; Emacs の種類バージョンを判別するための変数を定義
;; @see http://github.com/elim/dotemacs/blob/master/init.el
(defun x->bool (elt) (not (not elt)))
(defvar emacs23-p (equal emacs-major-version 23))
(defvar emacs24-p (equal emacs-major-version 24))
(defvar darwin-p (eq system-type 'darwin))
(defvar ns-p (featurep 'ns))
(defvar mac-p (and (eq window-system 'ns) (or emacs23-p emacs24-p)))
(defvar linux-p (eq system-type 'gnu/linux))
(defvar colinux-p (when linux-p
            (let ((file "/proc/modules"))
              (and
               (file-readable-p file)
               (x->bool
            (with-temp-buffer
              (insert-file-contents file)
              (goto-char (point-min))
              (re-search-forward "^cofuse\.+" nil t)))))))
(defvar cygwin-p (eq system-type 'cygwin))
(defvar nt-p (eq system-type 'windows-nt))
(defvar meadow-p (featurep 'meadow))
(defvar windows-p (or cygwin-p nt-p meadow-p))

;;
;; global variable defination
;;______________________________________________________________________
;;; cacheディレクトリ
(defvar my-cache-dir (concat user-emacs-directory "cache/"))
(defun my-cache-dir (cache-file) (concat my-cache-dir cache-file))
(if (not (file-exists-p my-cache-dir)) (mkdir my-cache-dir t))

;;; workディレクトリ
(defvar my-work-dir (concat user-emacs-directory "work/"))
(defun my-work-dir (work-file) (concat my-work-dir work-file))
(if (not (file-exists-p my-work-dir)) (mkdir my-work-dir t))

;;; privateディレクトリ
(defvar my-private-dir (concat user-emacs-directory "private/"))
(defun my-private-file (append-path) (expand-file-name (concat my-private-dir append-path)))
(if (not (file-exists-p my-private-dir)) (mkdir my-private-dir t))

;;
;; load init setting
;;______________________________________________________________________
;; パッケージ初期化
(require 'init_package)

;; Global 設定
(require 'init_global)

;; 各モジュールの初期設定
(require 'init_main)

;; init_globalから分離したもの、emacsの起動速度に影響ある
;; init_mainの前に置かないこと
(require 'init_global_ext)

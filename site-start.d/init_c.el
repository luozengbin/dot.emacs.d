;;; init_c.el --- init for c mode

;; Copyright (C) 2012  Zouhin.Ro

;; Author: LuoZengbin <jalen.cn@gmail.com>
;; Keywords: 

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; C 言語programing環境の設定

;;; Code:

;;
;; 文法チェック
;; ------------------------------------------------------------------------
(require 'flymake)
;;; flymakeモードを有効にする
(add-hook 'c-mode-hook '(lambda () (flymake-mode t)))

;;; Makefileの種類定義
(defvar flymake-makefle-filenames '("Makefile" "makefile" "GUNmakefile") "File names for make.")

;;; Makefileがなければコマンドを直接利用するコマンドラインの生成
(defun flymake-get-make-gcc-cmdline (source base-dir)
  (let ((found (catch 'found
                 (dolist (makefile flymake-makefle-filenames)
                   (if (file-readable-p (concat base-dir "/" makefile))
                       (throw 'found t))))))
    (if found
        (flymake-get-make-cmdline source base-dir)
      (list (if (string= (file-name-extension source) "c") "gcc" "g++")
            (list "-o" "/dev/null" "-fsyntax-only" "-Wall" source)))))

;;; Flymake初期化関数の生成
(defun flymake-simple-make-gcc-init-impl (create-temp-f use-relative-base-dir
                                                        use-relative-source
                                                        build-file-name
                                                        get-cmdline-f)
  "Create syntax check command line for a directory checked source file.
Use CREATE-TEMP-F for creating temp copy."
  (let* ((args nil)
         (source-file-name buffer-file-name)
         (buildfile-dir (file-name-directory source-file-name)))
    (if buildfile-dir
        (let* ((temp-source-file-name (flymake-init-create-temp-buffer-copy create-temp-f)))
          (setq args
                (flymake-get-syntax-check-program-args
                 temp-source-file-name
                 buildfile-dir
                 use-relative-base-dir
                 use-relative-source
                 get-cmdline-f))))
    args))

;;; 初期化関数を定義
(defun flymake-simple-make-gcc-init ()
  (interactive)
  (let ((flymake-cmd-line (flymake-simple-make-gcc-init-impl
                           'flymake-create-temp-inplace t t "Makefile"
                           'flymake-get-make-gcc-cmdline)))
    flymake-cmd-line))

;;; 拡張子 .c, .cpp, c++などの時上記の関数を利用する
(add-to-list 'flymake-allowed-file-name-masks
             '("\\.\\(?:c\\(?:pp\\|xx\\|\\+\\+\\)?\\|CC\\)\\'" flymake-simple-make-gcc-init))

;;
;; @ c-eldoc.el
;; 記事：http://d.hatena.ne.jp/mooz/20100421/p1
;; ------------------------------------------------------------------------
;; (install-elisp "http://www.emacswiki.org/emacs/download/c-eldoc.el")
;;カーソル付近にあるC言語の関数や変数のヘルプをエコーエリアに表示
;; TODO プリプロセッサの導入
(when (require 'c-eldoc nil t)
  (add-hook 'c-mode-hook
            (lambda ()
              (set (make-local-variable 'eldoc-idle-delay) 0.2)
              (set (make-local-variable 'eldoc-minor-mode-string) "")
              (c-turn-on-eldoc-mode))))

(provide 'init_c)
;;; init_c.el ends here

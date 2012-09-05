;;; init_picture.el --- configuration for picture mode

;; Copyright (C) 2011  Zouhin.Ro

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

;; 画像表示、操作の改善

;;; Code:

;;
;; picture-modeでアスキー絵を描く
;;______________________________________________________________________
(add-hook 'picture-mode-hook 'picture-mode-init)
(autoload 'picture-mode-init "picture-init")

;;
;; imcap-capture
;;______________________________________________________________________
;; ImageCapture imcapで画面キャプチャする
;; howm本家からソースを入手する 
;; http://howm.sourceforge.jp/cgi-bin/hiki/hiki.cgi?ImageCapture
;; windows環境ではImageMagick の import は使えないので代替ソフトとして WinShot を使います。
;; download from http://www.woodybells.com/winshot.html
(require 'imcap)
(setq imcap-file-name-format "%Y-%m-%d-%H%M%S.png")
(setq imcap-directory "./.imcap/")
(setq imcap-capture-delay 5)
;; キャプチャを取るコマンドを指定する
(if windows-p
    (setq imcap-capture-command "WinShot.exe -Jpeg -Rectangle -Close -File %s")
  (setq imcap-capture-command "import %s"))

(defun imcap-capture-command-format ()
  (concat "sleep "
          (format "%s" imcap-capture-delay)
          "\; "
          imcap-capture-command
          ))

;; マイナーモードによって出力するテキストを変える
(defun imcap-paste-format ()
  (cond
   ((string= major-mode "org-mode") "file:%s")
   ((and (boundp 'howm-mode)
         howm-mode)
    ">>> %s")
   (t "[img:%s]") ; cacoo
   ))

;; 延遅時間指定できるコマンドの定義
(defun my-imcap-capture (delay)
  (interactive
   (list (read-string "Delay seconds: " (format "%s" imcap-capture-delay))))
  (setq imcap-capture-delay delay)
  (imcap-capture))

(global-set-key (kbd "<C-apps>") 'my-imcap-capture)
(global-set-key (kbd "<C-menu>") 'my-imcap-capture)

;;
;; screenshot.el
;;______________________________________________________________________
;; screenshot.el でスクリーンショットを撮る
;; (install-elisp "http://www.emacswiki.org/cgi-bin/wiki/download/screenshot.el")
;; (install-elisp "http://www.emacswiki.org/cgi-bin/wiki/download/yaoddmuse.el")
;; 参照リンク: http://d.hatena.ne.jp/rubikitch/20090401/screenshot_emacs
(require 'screenshot)
(setq screenshot-schemes              ; edit as you like
      '(
        ;; To local image directory
        ("local"
         :dir "~/picture") ; Image repository directory
        ;; To current directory
        ("current-directory"          ; No need to modify
         :dir default-directory)
        ;; ;; To remote ssh host
        ;; ("remote-ssh"
        ;;  :dir "/tmp/"                 ; Temporary saved directory
        ;;  :ssh-dir "www.example.org:public_html/archive/" ; SSH path
        ;;  :url "http://www.example.org/archive/")  ; Host URL prefix
        ;; ;; To EmacsWiki (need yaoddmuse.el)
        ;; ("EmacsWiki"                 ; Emacs users' most familiar Oddmuse wiki
        ;;  :dir "~/.yaoddmuse/EmacsWiki/"  ; same as yaoddmuse-directory
        ;;  :yaoddmuse "EmacsWiki")         ; You can specify another Oddmuse Wiki
        ;; ;; To local web server
        ;; ("local-server"
        ;;  :dir "~/public_html/"           ; local server directory
        ;;  :url "http://127.0.0.1/")
        )
      )     ; local server URL prefix
(setq screenshot-default-scheme "local") ; default scheme is "local"

;;
;; keisen.el 罫線引きプログラム (Emacs Lisp)
;;______________________________________________________________________
;; (install-elisp "http://www.pitecan.com/Keisen/keisen.el")

;; 文字端末の矢印キーで罫線を引く場合
;; (global-set-key "\eOA" 'keisen-up-move)
;; (global-set-key "\eOB" 'keisen-down-move)
;; (global-set-key "\eOD" 'keisen-left-move)
;; (global-set-key "\eOC" 'keisen-right-move)
;;
;; 文字端末のMeta-Pなどで罫線を引く場合
;; (global-set-key "\M-p" 'keisen-up-move)
;; (global-set-key "\M-n" 'keisen-down-move)
;; (global-set-key "\M-b" 'keisen-left-move)
;; (global-set-key "\M-f" 'keisen-right-move)
;;
;; Control+矢印キーで罫線を引く場合
;; (global-set-key [C-right] 'keisen-right-move)
;; (global-set-key [C-left]  'keisen-left-move)
;; (global-set-key [C-up]    'keisen-up-move)
;; (global-set-key [C-down]  'keisen-down-move)
;;
;; (autoload 'keisen-up-move "keisen" nil t)
;; (autoload 'keisen-down-move "keisen" nil t)
;; (autoload 'keisen-left-move "keisen" nil t)
;; (autoload 'keisen-right-move "keisen" nil t)

;; カスタマイズpicture-mode
(require 'my-picture-mode)

(provide 'init_picture)
;;; init_picture.el ends here

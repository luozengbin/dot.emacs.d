;;; init_Cacoo.el --- configuration for Cacoo service

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

;; Cacooサービスで図形編集と作成

;;; Code:

;;
;; information
;;______________________________________________________________________
;; 参照: 
;;      https://github.com/kiwanami/emacs-cacoo
;;      http://d.hatena.ne.jp/kiwanami/20110303/1299174459
;;      http://d.hatena.ne.jp/kiwanami/20100507/1273205079
;;      http://www.imagemagick.org/script/index.php
;; emacs-deferred 非同期処理の支援
;;   (auto-install-from-url "https://github.com/kiwanami/emacs-deferred/raw/master/deferred.el")
;;   (auto-install-from-url "https://github.com/kiwanami/emacs-deferred/raw/master/concurrent.el")
;; Cacoo 
;;   (auto-install-from-url "http://github.com/kiwanami/emacs-cacoo/raw/master/cacoo.el")
;;   (auto-install-from-url "http://github.com/kiwanami/emacs-cacoo/raw/master/cacoo-plugins.el")

;;
;; setting
;;______________________________________________________________________
(require 'cacoo) ; cacooを読み込み
(require 'cacoo-plugins)      ; 追加機能
;; (setq cacoo:debug t)          ; *cacoo:debug*ログバッファーの有効化
(global-set-key (kbd "M--") 'toggle-cacoo-minor-mode) ; Alt+「-」で切り替え
;; 追加設定
;; (setq cacoo:img-dir ".cimg")    ;キャッシュ用のディレクトリ名
(setq cacoo:api-diagrams-cache-dir (my-cache-dir "cacoo"))
(setq cacoo:img-dir-ok t) ; 画像フォルダは確認無しで作る
(setq cacoo:png-background "white")
(setq cacoo:max-size 450)
(setq cacoo:external-viewer nil)        ;emacsのimage-modeで開く

;; cacoo.elで表示するタグの定義
;; http://sheephead.homelinux.org/2011/02/09/6582/
(setq cacoo:img-regexp
      '("\\[img:\\([^]]*\\)\\]"            ; default
        "^file:\\(.+\.\\(jpg\\|png\\)\\)" ; org
        "^>>> \\(.+\.\\(jpg\\|png\\)\\)"  ; howm
        ))

(provide 'init_Cacoo)
;;; init_Cacoo.el ends here

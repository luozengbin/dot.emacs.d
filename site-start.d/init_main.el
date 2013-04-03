;;; Commentary:

;; すべての拡張を初期化する init_* ファイルを実行環境によって自動的ローディングする

;;; Code:

;; 環境変数
(require 'init_setenv)

;; help機能の設定
(require 'init_help)

;; キーボードとマウスの設定
(require 'init_keyboard)

;; 入力メッソドの設定
;; (if linux-p (require 'init_input))

;; キーバンディング
(require 'init_keybinding)

;; フォントの設定
(require 'init_font)

;; 色の、themeの設定
(require 'init_color)

;; window表示の初期設定
(require 'init_window)

;; emacs windows manager の設定
(require 'init_e2wm)

;; タブバーの表示
(require 'init_tabbar)

;; linum設定
(require 'init_linum)

;; バッファー初期設定
(require 'init_buffer)

;; プリンタの設定
(require 'init_print)

;; カーソル動きの制御
(require 'init_point)

;; 編集機能基本設定
(require 'init_edit)

;; ediff ツールの初期設定
(require 'init_ediff)

;; format 設定
(require 'init_format)

;; 自動補完設定
(require 'init_completion)
(require 'init_yasnippet)
(require 'init_auto-complete)
(require 'init_auto-insert)

;; anything 設定
(require 'init_anything)

;; helm 設定
(require 'init_helm)

;; dired 設定
(require 'init_dired)

;; tramp 設定
(require 'init_tramp)

;; 検索設定
(require 'init_search)

;; shell 設定
(require 'init_shell)

;; マクロ設定
(require 'init_kmacro)

;; スベルチェック
(require 'init_flyspell)

;; lisp プログラミング
(require 'init_elisp)

;; common lisp 開発環境
;; (require 'init_slime)

;; sql環境
(require 'init_sql)

;; DB操作ツール
(require 'init_edbi)

;; C言語環境の設定
(require 'init_c)

;; php-mode 初期設定
(require 'init_php-mode)

;; perl プログラミング
(require 'init_perl)

;; ruby プログラミング
(require 'init_ruby)

;; python プログラミング
(require 'init_python)

;; ;; java プログラミング
;; (require 'init_java)

;; javascript プログラミング
(require 'init_javascript)

;; html プログラミング
(require 'init_html)

;; ;; R プログラミング
;; (require 'init_R)

;; プログラミング支援ツール
(require 'init_pgsupport)

;; ;; ソースコースの折り畳む対応
;; (require 'init_hideshow)

;; ログ監視、ビューアツール
(require 'init_logview)

;; バージョン管理
(require 'init_versions)

;; gitバージョン管理
(require 'init_git)

;; view mode 設定
(require 'init_view-mode)

;; org-modeの初期設定
(require 'init_org)

;; makedown 文書作成支援
(require 'init_markdown)

;; howm 初期設定
(require 'init_howm)

;; clmemo 設定
(require 'init_clmemo)

;; picture mode, screenshoot 設定
(require 'init_picture)

;; Cacoo 初期設定
(require 'init_Cacoo)

;; カレンダー 初期設定
(require 'init_calendar)

;; calfw 初期設定
(require 'init_calfw)

;; growl 初期設定 for mac os
(require 'init_notification)

;; social 初期設定
(require 'init_social)

;; google-services 初期設定
(require 'init_google-services)

;; 翻訳ツール初期設定
(require 'init_translator)

;; w3m 初期設定
(require 'init_w3m)

;;mew 初期設定
(require 'init_mew)

;; skype 初期化
(require 'init_skype)

;; navi2ch 初期設定
(require 'init_navi2ch)

;; 面白いものです
(require 'init_funnythings)

;; ブログ執筆環境
(require 'init_blogger)

;; 音楽環境
(require 'init_music)

;; 自前関数のローディング
(require 'my-funs)

;; ロード完了メッセージをGrowlで通知する
(my-notification nil (format "Hello %s, welcome to Emacs!!!" user-login-name))

;;
;; end
;;______________________________________________________________
(provide 'init_main)
;;end init_main.el

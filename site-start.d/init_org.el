;;; init_org.el --- configuration for org-mode

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

;; org-modeで文書作成支援

;;; Code:

(message "init_org ...")

(require 'org-install)

;;
;; change window buffer popup in popwin way
;;______________________________________________________________________
;; (push '("*Org Links*" :height 20 :position top) popwin:special-display-config)

;;
;; auto-fill
;;______________________________________________________________________
;; org-modeのauto-fillの有効とsc-sources指定
(add-hook 'org-mode-hook
          (lambda ()
            (setq fill-column 85)
            (auto-fill-mode 1)
            (add-to-list 'ac-sources 'ac-source-yasnippet)))

;;
;; yasnippetとの統合
;;______________________________________________________________________
;; org-modeでyasnippetのためのキバインディング
;; (defun yas/org-very-safe-expand ()
;;   (let ((yas/fallback-behavior 'return-nil)) (yas/expand)))
;; (add-hook 'org-mode-hook
;;           (lambda ()
;;             ;;yasnippet (using the new org-cycle hooks)
;;             (setq ac-use-overriding-local-map t)
;;             (make-variable-frame-local 'yas/trigger-key)
;;             (setq  yas/trigger-key [tab])
;;             (add-to-list 'org-tab-first-hook 'yas/org-very-safe-expand)
;;             (define-key yas/keymap [tab] 'yas/next-field)))

;;
;; link function
;;______________________________________________________________________
;; ハイパーリンク関連
(global-set-key (kbd "C-c l") 'org-store-link)

;;
;; agenda mode
;;______________________________________________________________________
;; TODO状態
(setq org-todo-keywords
      '((sequence "TODO(t)" "STARTED(s)" "WAITTING(w)" "SOMEDAY(d)" "|" "DONE(x)" "CANCEL(c)")
        (sequence "APPT(a)" "|" "DONE(x)" "CANCEL(c)")
        ))

;; DONEの時刻を記録
(setq org-log-done 'time)

;; 習慣(habits)の記録
;; http://d.hatena.ne.jp/tamura70/20100227/org
(require 'org-habit)

;; TODO項目をエクスポートするための設定
(setq org-icalendar-include-todo t)

;; org-remeberで瞬時メモを取る
(org-remember-insinuate)                ;org-remberの初期化
;; orgメモ格納先の指定
(setq org-directory (concat my-private-emacs-path "myfiles/"))

;; テンプレートの設定
(setq org-remember-templates
      '(
        ;;形式: ("名称" ?選択キー "テンプレート定義" "保存先" "タイトル")
        ("Note"         ?n "** []%?\n   %i\n   %a\n   %U"                "default-notes.org"  "Inbox")
        ("Event"        ?e "** APPT []%?\n   :PROPERTIES:\n   :LOCATION: \n   :Attachments: %a\n   :END:\n\n*** 内容\n %i\n*** 出席チェックリスト [/]\n - [ ] 参加者A\n - [ ] 参加者B\n\n   %U\n" "default-events.org" "Events")
        ("PJ Event"     ?p "** APPT []%?\n   :PROPERTIES:\n   :LOCATION: \n   :Attachments: %a\n   :END:\n\n*** 内容\n %i\n*** 出席チェックリスト [/]\n - [ ] 参加者A\n - [ ] 参加者B\n\n   %U\n" "default-events.org" "ANA Project Events")
        ("SomeDay"      ?s "** SOMEDAY []%?\n   %i\n   %a\n   %U"           "default-tasks.org"  "Tasks")
        ("Todo"         ?t "** TODO []%?\n   %i\n   %a\n   %U"           "default-tasks.org"  "Tasks")
        ("Work"         ?w "** TODO []%?   :work:\n   %i\n   %a\n   %U"  "default-tasks.org"  "Tasks")
        ("Home"         ?h "** TODO []%?   :home:\n   %i\n   %a\n   %U"  "default-tasks.org"  "Tasks")
        ("Bug"          ?b "** TODO []%?   :bug:\n   %i\n   %a\n   %U"   "default-tasks.org" "Bugs")
        ("Idea"         ?i "** %?\n   %i\n   %a\n   %U"                "default-notes.org" "New Ideas")
        ("GoodThing"    ?g "** %?\n   %i\n   %U"                       "default-notes.org" "Good Things")
        ("Want"         ?a "** %?\n   %i\n   %U"                       "default-notes.org" "Wants")
        ))

;; キーバンド
(global-set-key (kbd "<C-f9>") 'org-remember)

;; アジェンダに使うorgファイルのリストアップ
(setq org-agenda-files (list
                        (concat org-directory "default-events.org")
                        (concat org-directory "default-tasks.org")
                        (concat org-directory "emacs_todo.org")))
(global-set-key (kbd "C-c a") 'org-agenda)

;; TAGの定義
(setq org-tag-alist
      '(("@OFFICE" . ?o) ("@HOME" . ?h)
        ("SHOPPING" . ?s) ("MAIL" . ?m) ("PROJECT" . ?p)
        ("Emacs" . ?e) ("Java" . ?j) ("SOA" . ?a) (".NET" . ?d)
        ("QNES" . ?q)))

;; アジェンダビューのカスタマイズ
;; (setq org-agenda-custom-commands
;;       '(("x" "My agenda view"
;;          ((agenda)
;;           (todo "WAITTING")
;;           (tags-todo "project")))
;;         ))

;; 予定日未設定のTODOリスト
(setq org-agenda-custom-commands
      '(("x" "Unscheduled TODO" tags-todo "-SCHEDULED>=\"<now>\"" nil)))

;;
;; 作図支援
;;______________________________________________________________________
;; ditaa
(setq org-ditaa-jar-path
     (concat user-emacs-directory "extra/org-7.7/contrib/scripts/jditaa.jar"))

;; gnuplot-mode設定
;; http://xafs.org/BruceRavel/GnuplotMode
;; git clone https://github.com/bruceravel/gnuplot-mode.git
;; http://www.gnuplot.info/
(require 'gnuplot)

;;
;; code reading
;;______________________________________________________________________
;; org-rememberをコードリーディングのメモ
(defvar org-code-reading-software-name nil)
;; ~/memo/code-reading.org に記録する
(defvar org-code-reading-file "code-reading.org")
(defun org-code-reading-read-software-name ()
  (set (make-local-variable 'org-code-reading-software-name)
       (read-string "Code Reading Software: "
                    (or org-code-reading-software-name
                        (file-name-nondirectory
                         (buffer-file-name))))))

(defun org-code-reading-get-prefix (lang)
  (concat "[" lang "]"
          "[" (org-code-reading-read-software-name) "]"))
(defun org-remember-code-reading ()
  (interactive)
  (let* ((prefix (org-code-reading-get-prefix (substring (symbol-name major-mode) 0 -5)))
         (org-remember-templates
          `(("CodeReading" ?r "** %(identity prefix)%?\n   \n   %a\n   %t"
             ,org-code-reading-file "Memo"))))
    (org-remember)))

;;
;; org-babel
;;______________________________________________________________________
;; org-babel-R機能を有効化する
(require 'ob-R)
(org-babel-do-load-languages
 'org-babel-load-languages
 '((R . t)
   (ditaa . t)
   (dot . t)
   (emacs-lisp . t)
   (gnuplot . t)
   (haskell . nil)
   (ocaml . nil)
   (python . t)
   (ruby . t)
   (java . t)
   (screen . nil)
   (sh . t)
   (sql . nil)
   (sqlite . t)))

;;
;; RSS Reader
;;______________________________________________________________________
;; RSSフィードを取り込む
;; refs: http://d.hatena.ne.jp/tamura70/20100225/org
(defun org-feed-parse-rdf-feed (buffer)
  "Parse BUFFER for RDF feed entries.
Returns a list of entries, with each entry a property list,
containing the properties `:guid' and `:item-full-text'."
  (let (entries beg end item guid entry)
    (with-current-buffer buffer
      (widen)
      (goto-char (point-min))
      (while (re-search-forward "<item[> ]" nil t)
        (setq beg (point)
              end (and (re-search-forward "</item>" nil t)
                       (match-beginning 0)))
        (setq item (buffer-substring beg end)
              guid (if (string-match "<link\\>.*?>\\(.*?\\)</link>" item)
                       (org-match-string-no-properties 1 item)))
        (setq entry (list :guid guid :item-full-text item))
        (push entry entries)
        (widen)
        (goto-char end))
      (nreverse entries))))

;; (setq org-feed-retrieve-method 'wget)
(setq org-feed-retrieve-method 'curl)

(setq org-feed-default-template "\n* %h\n  - %U\n  - %a  - %description")

;; (setq org-feed-alist nil)
;; (add-to-list 'org-feed-alist
;;              '("hatena" "http://feeds.feedburner.com/hatena/b/hotentry"
;;                (concat my-private-emacs-path "myfiles/rss.org") "はてな"
;;                :parse-feed org-feed-parse-rdf-feed))
;; (add-to-list 'org-feed-alist
;;              '("tamura70" "http://d.hatena.ne.jp/tamura70/rss"
;;                (concat my-private-emacs-path "myfiles/rss.org") "屯遁"
;;                :parse-feed org-feed-parse-rdf-feed))


;;
;; org-tree-slide.el
;; org-modeのツリーでスライドショー
;;______________________________________________________________________
;; install
;; 作成者サイト：http://pastelwill.jp/wiki/doku.php?id=emacs:org-tree-slide
;; Github: https://github.com/takaxp/org-tree-slide
;; (auto-install-from-url "https://raw.github.com/takaxp/org-tree-slide/master/org-tree-slide.el")
;; (require 'org-tree-slide)
;; ;; シンプルに使う
;; ;; (org-tree-slide-simple-profile)
;; ;; プレゼンテーションに使う
;; (org-tree-slide-presentation-profile)
;; ;; (setq org-tree-slide-header nil)
;; ;; 起動時にヘッダを表示しないようにする
;; (setq org-tree-slide-slide-in-effect nil)
;; ;; スライドインのスピードを調節する（数値を変えてください）
;; (setq org-tree-slide-slide-in-waiting 0.02)
;; ;; スライドインの開始位置を調節する（行数を指定）
;; (setq org-tree-slide-slide-in-brank-lines 10)
;; ;; 起動時に見出しを強調する
;; (setq org-tree-slide-heading-emphasis t)


;; アジェンダをHTML (htmlizeを使用)へエクスポート時使用されるhtmlize
;; (install-elisp "http://fly.srk.fer.hr/~hniksic/emacs/htmlize.el.cgi")
(require 'htmlize)

;; ;; Postscriptエクスポート用
;; (setq ps-multibyte-buffer 'non-latin-printer)
;; (setq ps-right-header
;;       '("/pagenumberstring load" ps-time-stamp-yyyy-mm-dd ps-time-stamp-hh:mm:ss))

(provide 'init_org)
;;; init_org.el ends here

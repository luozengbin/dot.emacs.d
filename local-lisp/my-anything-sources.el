;;; Commentary:

;; 自作anything関数

;;; Code:

(require 'cl)  ; loop, delete-duplicates

;;
;; フォント表示
;;______________________________________________________________________
;; フォントの表示確認
;; M-x anything-font-familiesで一覧を開く
(defun anything-font-families ()
  "Preconfigured `anything' for font family."
  (interactive)
  (flet ((anything-mp-highlight-match () nil))
    (anything-other-buffer
     '(anything-c-source-font-families)
     "*anything font families*")))

(defun anything-font-families-create-buffer ()
  (with-current-buffer
      (get-buffer-create "*Fonts*")
    (loop for family in (sort (delete-duplicates (font-family-list)) 'string<)
          do (insert
              (propertize (concat family "\n")
                          'font-lock-face
                          (list :family family :height 2.0 :weight 'bold))))
    (font-lock-mode 1)))

(defvar anything-c-source-font-families
  '((name . "Fonts")
    (init lambda ()
          (unless (anything-candidate-buffer)
            (save-window-excursion
              (anything-font-families-create-buffer))
            (anything-candidate-buffer
             (get-buffer "*Fonts*"))))
    (candidates-in-buffer)
    (get-line . buffer-substring)
    (action
     ("Copy Name" lambda
      (candidate)
      (kill-new candidate))
     ("Insert Name" lambda
      (candidate)
      (with-current-buffer anything-current-buffer
        (insert candidate))))))

;;
;; [2012-12-10 無効しました] m-y でkill-ring一覧を表示する
;;______________________________________________________________________
;; すべてのkillを表示
(setq anything-kill-ring-threshold 0)
;; anythingインタフェースでkill-ringの内容を表示する
(defun anything-kill-ring ()
  (interactive)
  (anything 'anything-c-source-kill-ring nil nil nil nil "*anything kill ring*"))

;; M-y でanything-kill-ringを呼び出すする
;; (defadvice yank-pop (around anything-kill-ring-maybe activate)
;;   (if (not (eq last-command 'yank))
;;       (anything-kill-ring)
;;       ;;(anything-show-kill-ring)
;;     ad-do-it))

;;
;; 削除コマンドのanythingインタフェース定義
;;______________________________________________________________________
;; TODO 拡張：段落を削除する、関数を削除する
(defvar anything-delete-command-list
  '(("ポイントより上を kill" . "(kill-region (point) (point-min))")
    ("ポイントより下を kill" . "(kill-region (point) (point-max))")
    ("バッファ全体を kill" . "(kill-region (point-min) (point-max))")
    ("ポイントより上を delete" . "(delete-region (point) (point-min))")
    ("ポイントより下を delete" . "(delete-region (point) (point-max))")
    ("バッファ全体を delete" . "(delete-region (point-min) (point-max))")))

(defvar anything-l-source-delete-commands
  '((name . "削除コマンド集")
    (candidates . anything-delete-command-list)
    (type . sexp)))

(defun anything-delete-commands ()
  (interactive)
  (let* ((anything-enable-digit-shortcuts t)
         (anything-enable-shortcuts 'alphabet))
    (anything (list anything-l-source-delete-commands) nil nil nil)))


;;
;; 見えないbuffer一覧のanythingインタフェース
;;______________________________________________________________________
;;; アクション定義
(define-anything-type-attribute 'hidden-buffer
  `((action
     ("Switch to buffer" . anything-c-switch-to-buffer)
     ,(and (locate-library "popwin") '("Switch to buffer in popup window" . popwin:popup-buffer))
     ("Switch to buffer other window" . switch-to-buffer-other-window)
     ("Switch to buffer other frame" . switch-to-buffer-other-frame)
     ,(and (locate-library "elscreen") '("Display buffer in Elscreen" . anything-find-buffer-on-elscreen))
     ("Query replace regexp" . anything-c-buffer-query-replace-regexp)
     ("Query replace" . anything-c-buffer-query-replace)
     ("View buffer" . view-buffer)
     ("Display buffer"   . display-buffer)
     ("Grep buffers (C-u grep all buffers)" . anything-c-zgrep-buffers)
     ("Revert buffer(s)" . anything-revert-marked-buffers)
     ("Insert buffer" . insert-buffer)
     ("Kill buffer(s)" . anything-kill-marked-buffers)
     ("Diff with file" . diff-buffer-with-file)
     ("Ediff Marked buffers" . anything-ediff-marked-buffers)
     ("Ediff Merge marked buffers" . (lambda (candidate)
                                       (anything-ediff-marked-buffers candidate t))))
    (persistent-help . "Show this buffer"))
  "Buffer or buffer name.")

(defun my-anything-hidden-buffer-commands ()
  (interactive)
  (let* ((anything-enable-digit-shortcuts t)
         (anything-enable-shortcuts 'alphabet))
    (anything (list
               (list (cons 'name "Hidden Buffer List")
                     (cons 'candidates (my-hidden-buffer-list))
                     (cons 'type 'hidden-buffer))) nil nil nil)))

;;
;; キャラクターセット検査一覧
;;______________________________________________________________________
(defvar my-anything-show-charset-list
  (mapcar (lambda (x)
            (cons (symbol-name x) (concat "(insert \""  (symbol-name x) "\")" )))
          (charset-list)))

(defvar my-anything-l-source-charset-commands
  '((name . "フォントセット一覧")
    (candidates . my-anything-show-charset-list)
    (type . sexp)))

(defun my-anything-charset-commands ()
  (interactive)
  (let* ((anything-enable-digit-shortcuts t)
         (anything-enable-shortcuts 'alphabet))
    (anything (list my-anything-l-source-charset-commands) nil nil nil)))

;;
;; anythingとauto-install統合したインタフェースの定義
;;______________________________________________________________________
(defun my-anything-auto-install ()
  "anything command for me "
  (interactive)
  (anything-other-buffer
   '(
     anything-c-source-auto-install-from-emacswiki
     anything-c-source-auto-install-from-library)
   "*my anything-auto-install*"))

(provide 'my-anything-sources)

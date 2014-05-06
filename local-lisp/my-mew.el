;;; my-mew.el --- mew support functions

;; Copyright (C) 2012  Zouhin.Ro

;; Author: Zouhin.Ro <jalen.cn@gmail.com>
;; Keywords: mew

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

;;

;;; Code:

(require 'my-lisp-utils)
(require 'my-notification)
(require 'mew)

;; 返信ラベルを求める関数の再定義
;; ~/.emacs.d/lisp/mew/mew-draft.elの524行のmew-cite-strings関数を元に作成した
(defun my-mew-cite-strings ()
  "A function to create cite labels according to
'mew-cite-format' and 'mew-cite-fields'."
  (if (null mew-cite-fields)
      ""
    (let* (
           ;; ----- ★再定義の部分start★
           (vals (mapcar 'my-mew-cite-get-value mew-cite-fields))
           ;; ----- ★再定義の部分end★
           (label (apply 'format mew-cite-format vals))
           (ellipses (if (stringp mew-draft-cite-ellipses)
                         mew-draft-cite-ellipses ""))
           beg eol)
      (if (not (or (eq mew-draft-cite-fill-mode 'truncate)
                   (eq mew-draft-cite-fill-mode 'wrap)))
          label
        (with-temp-buffer
          (let ((fill-column
                 (or mew-draft-cite-label-fill-column fill-column)))
            (insert label)
            (goto-char (point-min))
            (while (not (eobp))
              (cond
               ((eq mew-draft-cite-fill-mode 'truncate)
                (end-of-line)
                (if (>= fill-column (current-column))
                    ()
                  (setq eol (point))
                  (insert ellipses)
                  (goto-char eol)
                  (while (< fill-column (current-column))
                    (delete-char -1))))
               ((eq mew-draft-cite-fill-mode 'wrap)
                (setq beg (point))
                (end-of-line)
                (if (= (current-column) 0)
                    ()
                  (fill-region beg (point)))))
              (forward-line)))
          (buffer-string))))))
;; メールヘッダーから日付項目値取得時のフォーマット変換
(defun my-mew-cite-get-value (field)
  (let ((value (mew-cite-get-value field)) time date )
    (when (string= mew-date: field)
      (setq time (parse-time-string value))
      (setq date (apply 'encode-time time))
      (setq value (format-time-string "%Y/%m/%d %T %z" date)))
    value
    ))

;; 返信時のwindowレイアウトの調整
(defun my-mew-resize-draft-windows ()
  (let ((msgbuf (get-buffer (mew-buffer-message))))
    (when msgbuf
      (delete-windows-on msgbuf)
      (with-current-buffer msgbuf
        (if (= 1 (line-number-at-pos (point-max)))
            (progn
              (kill-buffer msgbuf)
              (setq msgbuf nil))
          (delete-other-windows)
          (split-window-horizontally)
          (set-window-buffer (selected-window) msgbuf)
          (other-window 1)
          )))))

;; Draftモードでメールの先頭に定型分の挿入とメール文末にシグニチャの挿入
(defun my-mew-insert-header-signature ()
  (mew-header-goto-body)
  ;; ケース毎に定型文の挿入
  (mew-insert-file-contents
   (cdr (assoc
         (if (mew-tinfo-get-case)
             (mew-tinfo-get-case)
           "default")
         my-mew-header-signature)))
  (my-mew-insert-signature))

;; 引用返信の場合、シグニチャの特別扱い
(defun my-mew-insert-signature ()
  (let (start end sign-point)
    (save-excursion
      (goto-char (point-min))
      (setq start (next-single-property-change (point) 'signature-start))
      (setq end (next-single-property-change (point) 'signature-end))
      ;; シグニチャを行う前に既存のシグニチャを削除する
      (when (and start end)
        (goto-char end)
        (end-of-line)
        (delete-region start (point)))
      ;; シグニチャの挿入
      (goto-char (point-max))
      (setq sign-point (point))
      (mew-draft-insert-signature)
      (goto-char (point-max))
      (forward-line -1)
      (end-of-line)
      (put-text-property sign-point (1+ sign-point) 'signature-start t)
      (put-text-property (1- (point-max)) (point-max) 'signature-end t)
      )))

(defvar my-mew-sig-dashes "-- ")
(defun my-mew-remove-sig-dashes ()
  (mew-cite-original arg)
  (save-excursion
    (goto-char (point-max))
    (when (re-search-backward
           (format "^%s%s$"
                   mew-cite-default-prefix
                   my-mew-sig-dashes) nil t)
      (forward-line -1)
      (when (string= (buffer-substring (point-at-bol) (point-at-eol))
                     mew-cite-default-prefix)
        (message "remove sig dashes from origin mail contents.")
        (let ((signature-start-pos
               (next-single-property-change (point) 'signature-start)))
          (delete-region (point)
                         (if signature-start-pos
                             signature-start-pos
                           (point-max))))))))

;;
;; 送信時DCCヘッダーの削除処理
;;______________________________________________________________________
(defvar my-mew-jointed-mail-list nil)
(defun my-mew-check-header ()
  ;; Delete {Resent-,}Dcc: anyway.
  (when (> (string-width (mew-cite-get-value 'Dcc:)) 0)
    (catch 'loop
      (dolist (exclude-item (cdr (assoc (mew-cite-get-value 'From:)
                                        my-mew-jointed-mail-list)))
        (when (or
               (string-match exclude-item  (mew-cite-get-value 'To:))
               (string-match exclude-item  (mew-cite-get-value 'Cc:)))
          (mew-header-delete-lines (list mew-dcc: mew-resent-dcc:))
          (throw 'loop nil))))))

;;
;; アドレス帳登録処理のカスタマイズ
;;______________________________________________________________________
(defadvice mew-addrbook-prepare-template (around mew-addrbook-preset activate)
  ;; NickNameを予め入力する
  (if name (setq nickname name))
  ad-do-it)

;;
;; mew-summary-form-カスタマイズ関数の定義
;;______________________________________________________________________
;; 曜日計算関数
;; mew-summary-formで利用される想定
(defun mew-summary-form-youbi ()
  (let ((s (format-time-string "%u" (date-to-time (MEW-DATE)))))
    (cond
     ((string= s "1") "(月)")
     ((string= s "2") "(火)")
     ((string= s "3") "(水)")
     ((string= s "4") "(木)")
     ((string= s "5") "(金)")
     ((string= s "6") "(土)")
     ((string= s "7") "(日)")
     (t "??"))))

(defun mew-summary-form-xtime ()
  (format-time-string "%H:%M" (date-to-time (MEW-DATE))))

;; メール日付表示の調整を行うための関数
(defvar my-mew-message-date-overlay nil)
(defun my-mew-message-date-overlay ()
  (or
   my-mew-message-date-overlay
   (setq my-mew-message-date-overlay
         (make-overlay (point-min) (point-min)))))

(defun my-mew-message-display-local-date ()
  (condition-case err
      (save-excursion
        (goto-char (point-min))
        (when (re-search-forward (concat "^" mew-date: " *\\(.*\\)") nil t)
          (let* ((original (match-string 1))
                 (start (match-beginning 1))
                 (end (match-end 1))
                 (ov (my-mew-message-date-overlay))
                 (time (parse-time-string original))
                 (date (apply 'encode-time time))
                 (orig-tz (nth 8 time))
                 (tz (nth 8 (decode-time (current-time))))
                 (local-time (parse-time-string (mew-time-ctz-to-rfc date)))
                 (local-date (apply 'encode-time local-time))
                 (local (format-time-string "%Y/%m/%d %T %z" local-date))
                 (new (format-time-string "%Y/%m/%d %T %z" date))
                 )
            (move-overlay ov start end (current-buffer))
            (unless (equal orig-tz tz)
              (setq new (format "%s == %s" original local)))
            (overlay-put ov 'display new))))
    (error
     (message "%s" err))))

;;; メール本文一部の抽出処理
;; summaryビューに、base64メール本部も表示できるように変える
;; Label: overwrite for windows
(defun mew-scan-body (mew-vec &optional draftp)
  (forward-line)
  (let* ((i 0) (I mew-scan-max-body-length)
         (j 0) (J mew-scan-body-length)
         (ctr (MEW-CT))
         (cte (MEW-CTE))
         (body "")
         (case-fold-search t)
         textp charset cs beg skip boundary found regex)
    (catch 'break
      (cond
       (draftp
        (setq textp t)
        (setq cs mew-cs-m17n))
       ((string= ctr "")
        (if (mew-case-equal cte mew-b64) (throw 'break nil))
        (setq textp t)
        (setq cs mew-cs-autoconv))
       (t
        ;; The following code is generic but too slow.
        ;; (setq ctl (mew-param-decode ctr))
        ;; (setq ct (mew-syntax-get-value ctl 'cap))
        ;; So, this hard coding is used.
        (when (and (string-match "^Multipart/" ctr)
                   (string-match "boundary=\"?\\([^\"\n\t;]+\\)\"?" ctr))
          (setq boundary (mew-match-string 1 ctr))
          (setq boundary (concat "^--" (regexp-quote boundary)))
          (catch 'loop
            (while (< i I)
              (if (looking-at boundary) (throw 'loop (setq found t)))
              (forward-line)
              (setq i (1+ i))))
          (if (not found)
              (throw 'break nil)
            (forward-line)
            (save-restriction
              (narrow-to-region (point) (point-max))
              (setq ctr (mew-header-get-value mew-ct:))
              (setq cte (mew-addrstr-parse-value
                         (mew-header-get-value mew-cte:)))
              (mew-header-goto-end)) ;; should be in the narrowed region
            (unless ctr ;; not ""
              (setq textp t)
              (setq cs mew-cs-autoconv)
              (throw 'break nil))))
        ;; ---> hack start do comment
        ;; (if (and cte (mew-case-equal cte mew-b64)) (throw 'break nil))
        ;; ---> hack end
        (when (string-match "^Text/Plain" ctr)
          (when (string-match "charset=\"?\\([^\"\n\t;]+\\)\"?" ctr)
            (setq charset (mew-match-string 1 ctr)))
          ;; xxx quoted-printable. not enough DB in mew-mule3.el.
          (setq textp t)
          (setq cs (mew-charset-to-cs charset))
          (if (null cs) (setq cs mew-cs-autoconv)))))) ;; end of 'break
    (set-buffer-multibyte nil)
    (when (and textp (mew-coding-system-p cs))
      (setq i 0)
      (while (and (not (eobp)) (< i I) (< j J))
        (setq regex mew-regex-ignore-scan-body-list)
        (setq skip nil)
        (catch 'matched
          (dolist (re regex)
            (if (looking-at re)
                (throw 'matched (setq skip t)))))
        (if skip
            (forward-line)
          (when (looking-at "^[ \t]+")
            (goto-char (match-end 0)))
          (setq beg (point))
          (forward-line)
          (setq body (concat body (mew-buffer-substring beg (1- (point))) " "))
          (setq j (1+ j)))
        (setq i (1+ i)))
      (set-buffer-multibyte t)
      ;; ---> hack start
      (when cte
        ;; base64 decode
        (when (mew-case-equal cte mew-b64)
          (setq body (mew-base64-decode-string body)))
        ;; quoted-printable decode
        (when (mew-case-equal cte mew-qp)
          ;; crazy hacking
          (require 'my-lisp-utils)
          (setq body (string-replace "=[ ]*$" "" body t))
          (setq body (mew-q-decode-string (string-replace-2 "= =" "=" body)))))

      ;; ---> hack end
      (if body (setq body (mew-replace-white-space body)))
      (setq body (condition-case nil
                     (mew-cs-decode-string body cs)
                   (error body)))
      (aset mew-vec (1- (length mew-vec)) body))))

;;
;; gpg拡張関連処理
;;______________________________________________________________________
;; gpg-agentの起動
(defvar my-mew-default-smime-signer nil
  "defaultアカウントで使用する署名ID、gpgsm --dump-secret-keysで確認できる")
(defvar my-mew-smime-default-keygrip nil)
(defvar my-mew-gpg-agent-program nil "the location of gpg agent program")
(defvar my-mew-gpg-preset-passphrase-program nil "the location of gpg passphrase preset program")
(defvar my-mew-gpg-preset-passphrase-flag nil "thr flag of  gpg passphrase preset")
(defvar my-mew-gpg-agent-buffer " *mew-gpg-agent*")

;; メール署名のためにgpg-agentを起動する
;; now for windows + cygwin only
(defun my-mew-start-gpg-agent ()
  "Start GunPG 2.0 agent for s/mime module"
  (interactive)
  (let ((gpg-agent-process
         (start-process "mew-gpg-agent" my-mew-gpg-agent-buffer
                        my-mew-gpg-agent-program "--daemon" "--allow-preset-passphrase")))
    ;; for debug
    ;;(message (format "gpg-agent --> %s" (process-command gpg-agent-process)))

    ;; gpg-agentプロセス終了時、いちいち確認するのをやめる
    (set-process-query-on-exit-flag gpg-agent-process nil)

    (set-process-filter gpg-agent-process 'my-mew-gpg-agent-process-filter)

    (message "starting gpg-agent ...")

    ;; 予めパスプレースを入力させる
    (when my-mew-gpg-preset-passphrase-flag

      (put 'my-mew-gpg-agent-process-filter 'matched nil)

      ;; gpg-agentが立ち上がるまで待ち
      (while (get 'my-mew-gpg-agent-process-filter 'matched)
        (sit-for 0.5))

      ;; sime signer idを元にgpgsmでkeygripを抽出する
      (setq my-mew-smime-default-keygrip
            (my-shell-command-to-single-line
             (format "%s --dump-secret-keys \"%s\" | grep keygrip | sed -e \"s/.* keygrip: //g\""
                     mew-prog-smime my-mew-default-smime-signer)))
      ;; gpg-preset-passphraseを起動して、パスプレースを入力させて、gpg-agentに登録する
      (let ((gpg-preset-passphrase-process
             (start-process-shell-command "mew-gpg-preset-passphrase" nil
                                          (format "sh.exe -c \"%s -P %s -c %s\""
                                                  (my-shell-command-to-single-line
                                                   (concat "cygpath " my-mew-gpg-preset-passphrase-program))
                                                  (read-passwd "S/MIME Sign Key Passphrase: ")
                                                  my-mew-smime-default-keygrip))))
        ;; for debug
        ;;(message (format "gpg-agent --> %s" (process-command gpg-preset-passphrase-process)))
        ;; プロセス終了時、いちいち確認するのをやめる
        (set-process-query-on-exit-flag gpg-preset-passphrase-process nil)))))

(defun my-mew-gpg-agent-process-filter (proc string)
  (with-current-buffer (process-buffer proc)
    (cond
     ((string-match "gpg-agent.*started$" string) ;gpg-agentプロセス起動成功イベントをキャッチする
      (put 'my-mew-gpg-agent-process-filter 'matched t)
      (set-process-filter gpg-agent-process nil)
      ))))

;; 標準のマスタパスワード機能が旨く動作しない環境があるため。
;; `epa' と `alpaca' ライブラリを利用したカスタマイズ実装を使う
(defvar my-mew-passwd-policy nil "カスタマイズマスターパスワードポリシー使用フラグ")
(when my-mew-passwd-policy

  (require 'my-decrypt-utils)

  ;; 暗号ファイルから読み取った元のパスワード情報、mew終了時に
  (defvar my-orgin-mew-passwd-alist nil)

  ;; パスワードクリア
  (defun my-mew-clear-passwd ()
    "clear mew-use-master-passwd and mew-passwd-alist"
    (interactive)
    (setq mew-passwd-master nil)
    (setq mew-passwd-alist nil))

  ;; before mew-passwd-clean-up
  ;; パスワード比較、差異がなければ保存を行わない
  (defadvice mew-passwd-clean-up (before mew-passwd-clean-up-hackin activate)
    (when (and mew-use-master-passwd mew-passwd-master)
      (if (equal mew-passwd-alist my-orgin-mew-passwd-alist)
          (setq mew-passwd-master nil))))

  ;;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  ;; mew-passwd.el中身のいくつ関数を上書きする

  ;; gpgファイルに暗号化されたパスワード情報を取り出す
  ;; Label: overwrite for windows
  (defun mew-passwd-load ()
    (let ((file (expand-file-name mew-passwd-file mew-conf-path))
          (N mew-passwd-repeat)
          encrypted-text pwds)
      (catch 'loop
        (dotimes (i N)
          (setq encrypted-text (my-read-from-encrypted-file file))
          (if encrypted-text
              (setq mew-passwd-master t)
            (mew-warn "Master password is wrong!"))
          (when mew-passwd-master
            (condition-case nil
                (progn
                  (setq pwds (read encrypted-text))
                  (setq my-orgin-mew-passwd-alist pwds))
              (error ()))
            (throw 'loop nil)))
        (message "Master password is wrong!")
        (mew-let-user-read))
      pwds))

  ;; パスワード情報を暗号化してgpgファイルに保存する
  ;; Label: overwrite for windows
  (defun mew-passwd-save ()
    (let ((file (expand-file-name mew-passwd-file mew-conf-path))
          (N mew-passwd-repeat))
      (if (file-exists-p file)
          (rename-file file (concat file mew-backup-suffix) 'override))
      (catch 'loop
        (dotimes (i N)
          (setq mew-passwd-master (my-write-and-encrypt file (pp-to-string mew-passwd-alist)))
          (when (and mew-passwd-master (file-exists-p file))
            (setq my-orgin-mew-passwd-alist mew-passwd-alist)
            (throw 'loop nil)))
        (message "Master password is wrong! Passwords not saved")
        (mew-let-user-read))
      (unless (file-exists-p file)
        (rename-file (concat file mew-backup-suffix) file)))))

;;
;; メール自動受信および通知
;;______________________________________________________________________
(defvar my-mew-fetch-mail-timer nil "自動受信タイマー")
(defvar my-mew-fetch-mail-interval-time (* 5 60) "自動受信間隔、単位秒")
(defvar my-mew-fetch-mail-deley-time (* 1 60) "初回自動受信延遅実行秒数")

;; ;; 自動受信トグルのON/OFF
;; (add-hook 'mew-init-hook 'my-mew-fetch-mail-timer-toggle)
;; (add-hook 'mew-quit-hook 'my-mew-fetch-mail-timer-toggle)
;; ;; 受信処理後の通知を駆動する
;; (add-hook 'mew-pop-sentinel-hook 'my-mew-mail-notification)
;; (add-hook 'mew-imap-sentinel-hook 'my-mew-mail-notification)

(defun my-mew-fetch-mail-timer-toggle ()
  "メール自動受信トグル"
  (interactive)
  (cond
   ((not my-mew-fetch-mail-timer)
    (my-mew-fetch-mail-timer-on)
    (message "Trun On mew-fetch-mail-timer"))
   (t
    (my-mew-fetch-mail-timer-off)
    (message "Trun Off mew-fetch-mail-timer"))))

(defun my-mew-fetch-mail-timer-on ()
  (my-cancel-timer-by-funcname 'my-mew-fetch-mail)
  (setq my-mew-fetch-mail-timer
        (run-with-timer my-mew-fetch-mail-deley-time
                        my-mew-fetch-mail-interval-time 'my-mew-fetch-mail)))

(defun my-mew-fetch-mail-timer-off ()
  (cancel-timer my-mew-fetch-mail-timer)
  (setq my-mew-fetch-mail-timer nil))

(defun anything-c-timer-real-to-display (timer)
  (destructuring-bind (triggered t1 t2 t3 repeat-delay func args idle-delay)
      (append timer nil)                ;use `append' to convert vector->list
    (format "%s repeat=%5S %s(%s)"
            (let ((time (list t1 t2 t3)))
              (if idle-delay
                  (format-time-string "idle-for=%5s" time)
                (format-time-string "%m/%d %T" time)))
            repeat-delay
            func
            (mapconcat 'prin1-to-string args " "))))


(defun my-mew-fetch-mail ()
  "受信処理を駆動する"
  (interactive)
  (if mew-passwd-alist                  ;認証済み、精密な確認ではない
      (save-excursion
        (save-window-excursion
          ;; 新しいフレームを作成し、受信処理を行い
          (let ((temp-current-frame (selected-frame))
                (temp-frame (make-frame '((visibility . nil)
                                          (minibuffer . t)))))
            (select-frame temp-frame)
            (put 'my-mew-fetch-mail 'running t)
            ;; (put 'my-mew-fetch-mail 'current-work-frame temp-frame)
            (with-current-buffer (my-mew-get-summary-buffer-name)
              (my-mew-fetch-mail-log "------ fetch new mail ------")
              (put 'my-mew-fetch-mail 'old-inbox-line-count (count-lines (point-min) (point-max)))
              ;; (put 'my-mew-temp-work-frame temp-frame)
              (my-mew-fetch-mail-log "[before fetch] count line in mail box: " (get 'my-mew-fetch-mail 'old-inbox-line-count))
              ;; メール受信処理
              (my-mew-fetch-mail-log "running mew-summary-retrieve...")
              (if (mew-folder-remotep (mew-proto mew-case))
                  ;; imapの場合は "s"
                  (my-mew-fetch-mail-log (pp-to-string (mew-summary-ls nil 'goend 'update)))
                ;; popの場合は "i"
                (my-mew-fetch-mail-log (pp-to-string (mew-summary-retrieve)))))
            (select-frame temp-current-frame)
            ;; フレームを削除する
            (if (frame-live-p temp-frame)
                (delete-frame temp-frame)))))))

(defun my-mew-get-summary-buffer-name ()
  "現在選択されたメールアカウントのsummaryバッファー名を求める関数"
  (let* ((proto (mew-proto mew-case))
         (inbox (mew-proto-inbox-folder proto mew-case))
         case:inbox)
    (cond
     ((mew-folder-remotep proto)
      (setq case:inbox (mew-case-folder mew-case inbox)))
     (t ;; local
      (setq case:inbox inbox)))))

(defun my-summary-matched-regp ()
 "サマリーバッファーから受信したメッセージの情報を抽出するための正規表現式を求める関数"
  (let (matched-regp last-form)
    (setq matched-regp "^")
    (dolist (current-form mew-summary-form)
      (when (stringp current-form)
        (setq matched-regp
              (concat matched-regp
                      (if (and (consp last-form)
                               (or (equal (cdr last-form) '(from))
                                   (equal (cdr last-form) '(subj))))
                          "\\(.*?\\)"
                        ".*?") current-form)))
      (setq last-form current-form))
    (setq matched-regp (concat matched-regp "\\(.*?$\\)"))))

(defvar my-mew-notification-max 10)

(defun my-mew-mail-notification ()
"受信ボックスの件数差を見て、新たなメッセージ情報を通知する"
(let* ((is-fetch-status (get 'my-mew-fetch-mail 'running))
       (old-inbox-line-count (get 'my-mew-fetch-mail 'old-inbox-line-count))
       (my-summary-matched-regp (my-summary-matched-regp))
       my-summary-from-str my-summary-title-str my-summary-content-str
       count-line-inbox new-message-count)
  ;; 実行フラグをOFFにする
  (if is-fetch-status
      (put 'my-mew-fetch-mail 'running nil))
  ;; 受信件数確認
  (when old-inbox-line-count
    (my-mew-fetch-mail-log "running my-mew-mail-notification...")
    (put 'my-mew-fetch-mail 'old-inbox-line-count nil)
    (save-excursion
      (save-window-excursion
        (with-current-buffer (my-mew-get-summary-buffer-name)
          (setq count-line-inbox (count-lines (point-min) (point-max)))
          (setq new-message-count (- count-line-inbox old-inbox-line-count))
          (my-mew-fetch-mail-log "[after fetch] count line in mail box: " count-line-inbox)
          (my-mew-fetch-mail-log (format "you got %s new email. " new-message-count))
          (when (> count-line-inbox old-inbox-line-count)
            (goto-line (1+ old-inbox-line-count))
            (if (> new-message-count my-mew-notification-max)
                (my-notification (format "着信%s件あり" new-message-count)
                                 "Mew Notification"
                                 (my-notification-icon "email.png") nil t))
            (let ((notification-counter 0))
              (while (and (< notification-counter my-mew-notification-max)
                          (search-forward-regexp my-summary-matched-regp nil t))
                (setq notification-counter (1+ notification-counter))
                (setq my-summary-from-str (buffer-substring (match-beginning 1) (match-end 1)))
                (setq my-summary-title-str (buffer-substring (match-beginning 2) (match-end 2)))
                (setq my-summary-content-str (buffer-substring (match-beginning 3) (match-end 3)))
                (my-mew-fetch-mail-log "receive new mail from" my-summary-from-str)
                (my-notification my-summary-from-str my-summary-title-str
                                 (my-notification-icon "email.png") nil t))))))))))

;;; 自動受信時message出力しないようにするため
;;; 一部の内部関数にアドバイザを適用し、messageの出力を制御する
(defadvice mew-pop-message (before mew-pop-message-before activate)
  (if (and (get 'my-mew-fetch-mail 'running) (not (mew-pop-get-no-msg pnm)))
      (mew-pop-set-no-msg pnm t)))

(defadvice mew-pop-open (before mew-pop-open-before activate)
  (if (get 'my-mew-fetch-mail 'running)
      (ad-set-arg 3 t)))

(defadvice mew-imap-message (before mew-imap-message-before activate)
  (if (and (get 'my-mew-fetch-mail 'running) (not (mew-imap-get-no-msg pnm)))
      (mew-imap-set-no-msg pnm t)))

(defadvice mew-imap-open (before mew-imap-open-before activate)
  (if (get 'my-mew-fetch-mail 'running)
      (ad-set-arg 3 t)))

;; "ログ出力関数"
(defvar my-mew-fetch-mail-log-buffer " *my-mew-fetch-mail*")

(defun my-mew-fetch-mail-log (&rest msgs)
  (apply 'my-log my-mew-fetch-mail-log-buffer msgs))

(defun my-mew-show-fetch-mail-log ()
  (interactive)
  (pop-to-buffer my-mew-fetch-mail-log-buffer))

;;
;; Hyper Estraier検索エンジン for windows
;;______________________________________________________________________
(when windows-p
  ;; Label: overwrite for windows
  (defun mew-est-index-all ()
    "Make Hyper Estraier index for all folders."
    (interactive) ;
    (if (not (mew-which-exec mew-prog-est-update))
        (message "'%s' does not exist" mew-prog-est-update)
      (message "Hyper Estraier indexing...")
      (let ((pro (start-process "*Mew EST*" nil mew-prog-est-update "-s" mew-suffix "-b"
                                ;; fix for windows
                                (if windows-p
                                    (my-dos-path (mew-expand-folder mew-mail-path))
                                  (mew-expand-folder mew-mail-path))
                                )))
        (set-process-filter pro 'mew-est-index-filter)
        (set-process-sentinel pro 'mew-est-index-sentinel))))

  ;; Label: overwrite for windows

  (defun mew-est-index-folder (folder)
    "Make Hyper Estraier index for this folder."
    (interactive)
    (if (not (mew-which-exec mew-prog-est-update))
        (message "\"%s\" does not exist" mew-prog-est-update)
      (message "Hyper Estraier indexing for %s..." folder)
      (let* ((path (file-truename (mew-expand-folder folder)))
             (pro (start-process "*Mew EST*" nil mew-prog-est-update "-s" mew-suffix "-b"
                                 ;; fix for windows
                                 (if windows-p
                                     (my-dos-path (mew-expand-folder mew-mail-path))
                                   (mew-expand-folder mew-mail-path))
                                 (if windows-p
                                     (my-dos-path path)
                                   path))))
        (set-process-filter pro 'mew-est-index-filter)
        (set-process-sentinel pro 'mew-est-index-sentinel)))))

;;; インディクスの定期更新処理
(defun my-mew-update-est-index-all ()
  (interactive)
  (my-mew-update-index-log "------ update id index ------")
  (my-mew-check-update-est-lock)
  (my-mew-summary-make-id-index-all)
  (my-mew-update-index-log "------ update search index ------")
  (let ((pro (start-process "*Mew EST*" nil mew-prog-est-update "-v" "-s" mew-suffix "-b"
                            ;; for windows
                            (if windows-p
                                (my-dos-path (mew-expand-folder mew-mail-path))
                              (mew-expand-folder mew-mail-path)))))
    (set-process-filter pro 'my-mew-update-est-index-filter)))

(defun my-mew-check-update-est-lock ()
  "check lock file when update index, if lock file exists ask delete it"
  (interactive)
  (let ((lock-file (expand-file-name (concat mew-mail-path "/.mewest.lock"))))
    (when (file-exists-p lock-file)
      (my-notification nil "updating mew index blocked by .mewest.lock file")
      (if (y-or-n-p "[.mewest.lock] exists! delete it?")
          (delete-file lock-file))
      (message ".mewest.lock check done!"))))

(defun my-mew-summary-make-id-index-all (&optional full-update)
  (interactive "P")
  (if (not (mew-which-exec mew-prog-cmew))
      (my-mew-update-index-log "%s not found" mew-prog-cmew)
    (let* ((dbfile (expand-file-name mew-id-db-file mew-mail-path))
           (path (expand-file-name mew-mail-path))
           (options (list dbfile path mew-id-db-ignore-regex))
           (buf (generate-new-buffer (concat mew-buffer-prefix "cmew")))
           pro)
      (if full-update (setq options (cons "-f" options)))
      (my-mew-update-index-log "Updating ID database...")
      (setq pro (apply 'start-process "cmew" buf mew-prog-cmew options))
      (set-process-filter pro 'mew-summary-make-id-index-filter)
      (set-process-sentinel pro 'my-mew-summary-make-id-index-sentinel))))

(defun my-mew-summary-make-id-index-sentinel (process event)
  (let ((buf (process-buffer process)))
    (with-current-buffer buf
      (goto-char (point-max))
      (forward-line -1)
      (let ((str (mew-buffer-substring (line-beginning-position)
                                       (line-end-position))))
        (my-mew-update-index-log "Updating ID database...done (%s)" str)))
    (mew-remove-buffer buf)))

(defun my-mew-update-est-index-filter (process string)
  (my-mew-update-index-log string)
  (cond
   ((string-match "exists" string)
    (my-mew-update-index-log "Another Hyper Estraier indexer is running"))
   ((string-match "\.\.\.failed" string)
    (my-mew-update-index-log "Hyper Estraier indexing ...failed"))
   ((string-match "old messages\.\.\.done" string)
    (my-mew-update-index-log "Hyper Estraier purging ...done"))
   ((string-match "new messages\.\.\.done" string)
    (my-mew-update-index-log "Hyper Estraier indexing ...done"))))

(defvar my-mew-update-index-log-buffer " *my-mew-update-index*")

(defun my-mew-update-index-log (&rest msgs)
  (apply 'my-log my-mew-update-index-log-buffer msgs))

(defun my-mew-show-update-index-log ()
  (interactive)
  (pop-to-buffer my-mew-update-index-log-buffer))

(defvar my-mew-update-index-timer nil "インデックス更新タイマー")
(defvar my-mew-update-index-interval-time (* 60 60) "インデックス更新間隔、単位秒")
(defvar my-mew-update-index-deley-time (* 30 60) "初回延遅実行秒数")

(defun my-mew-update-index-timer-toggle ()
  "インデックス自動更新トグル"
  (interactive)
  (cond
   ((not my-mew-update-index-timer)
    (my-mew-update-index-timer-on)
    (message "Trun On my-mew-update-index-timer"))
   (t
    (my-mew-update-index-timer-off)
    (message "Trun Off my-mew-update-index-timer"))))

(defun my-mew-update-index-timer-on ()
  (my-cancel-timer-by-funcname 'my-mew-update-est-index-all)
  (setq my-mew-update-index-timer
        (run-with-timer my-mew-update-index-deley-time
                        my-mew-update-index-interval-time 'my-mew-update-est-index-all)))

(defun my-mew-update-index-timer-off ()
  (cancel-timer my-mew-update-index-timer)
  (setq my-mew-update-index-timer nil))

;;
;; キーバンド拡張機能
;;______________________________________________________________________
;;; summary mode for scroll message buffer
(define-key mew-summary-mode-map (kbd "[") 'my-mew-summary-scroll-down)
(define-key mew-summary-mode-map (kbd "]") 'my-mew-summary-scroll-up)

(define-key mew-message-mode-map (kbd "[") 'inertias-down)
(define-key mew-message-mode-map (kbd "]") 'inertias-up)

(defun my-mew-summary-scroll-up ()
  (interactive)
  (my-mew-summary-scroll t))

(defun my-mew-summary-scroll-down ()
  (interactive)
  (my-mew-summary-scroll nil))

(defun my-mew-summary-scroll (scroll-up)
  (let ((next-msgp nil))
    (save-window-excursion
      (other-window 1)
      (if (eq major-mode 'mew-message-mode)
          (if scroll-up ;; scroll-up action
              (if (eobp)
                  (setq next-msgp t)
                (inertias-up))
            ;; scroll-down action
            (if (equal (window-start) (point-min))
                (setq next-msgp t)
              (inertias-down)))))
    (if next-msgp
        (if scroll-up
            (mew-summary-display-down)
          (mew-summary-display-up)))))

;;; start dired from summary mode
(require 'direx)
(define-key mew-summary-mode-map (kbd "C-z E") 'my-mew-exec-explorer)
(defun my-mew-exec-explorer (inline)
  (interactive "P")
  (let ((target-dir (mew-expand-folder (buffer-name))))
    (if inline
        (dired target-dir)
      (direx:find-directory-other-window target-dir))))

(define-key mew-summary-mode-map (kbd "C-z T") 'my-mew-show-save-dir)
(defun my-mew-show-save-dir (inline)
  (interactive "P")
  (if inline
      (dired mew-save-dir) ;;(explorer mew-save-dir)
    (direx:find-directory-other-window mew-save-dir)))

;;; ファイルディレクトリ開く操作
(when (or linux-p mac-p)
  (define-key mew-message-mode-map (kbd "C-x C-f") 'my-mew-find-file-at-point)
  (defun my-mew-find-file-at-point ()
    "open file in mew message mode"
    (interactive)
    (smb-file-backslash-to-slash (ffap-string-at-point))
    ;; posix環境ではwindowsファイルパス識別しない問題の対応
    (let* ((smb-file-path (smb-file-backslash-to-slash (ffap-string-at-point))))
      (if (file-exists-p smb-file-path)
          (with-temp-buffer
            (insert smb-file-path)
            (call-interactively 'ffap-other-window))
        (call-interactively 'ffap-other-window)))))

(define-key mew-summary-mode-map (kbd "C-z z") 'my-mew-summary-anything)
(define-key mew-message-mode-map (kbd "C-z z") 'my-mew-message-anything)

(defun my-mew-summary-anything ()
  "anything command for mew summary mode"
  (interactive)
  (anything-other-buffer
   '(anything-c-source-mew-summary-command)
   "*mew summary anything*"))

(defvar anything-c-source-mew-summary-command
      '((name . "summary commands")
        (candidates . mew-summary-command-candidates)
        (type . sexp)))

(defvar mew-summary-command-candidates
  '(("新規作成(w)"         . "(mew-summary-write)")
    ("引用返信(A)"         . "(mew-summary-reply-with-citation)")
    ("返信(a)"             . "(mew-summary-reply)")
    ("引用個別返信(C-u A)" . "(mew-summary-reply-with-citation t)")
    ("個別返信(C-u a)"     . "(mew-summary-reply t)")
    ("再送(r)"             . "(mew-summary-resend)")
    ("転送(f)"             . "(mew-summary-forward)")
    ("一括転送(F)"         . "(mew-summary-multi-forward)")
    ("削除(d)"             . "(mew-summary-delete)")
    ("ゴミ箱を空にする(D)" . "(mew-summary-clean-trash)")
    ("整理整頓(o)"         . "(mew-summary-refile)")
    ("未読にする(U)"       . "(mew-summary-unread)")
    ("アドレス帳に追加(C-c C-a). " "(mew-summary-addrbook-add)")))

(defun my-mew-message-anything ()
  "anything command for mew message mode"
  (interactive)
  (anything-other-buffer
   '(anything-c-source-mew-file-at-point
     anything-c-source-mew-message-command)
   "*mew message anything*"))

(defvar anything-c-source-mew-message-command
  '((name . "message commands")
    (candidates . mew-message-command-candidates)
    (type . sexp)))

(defvar mew-message-command-candidates
  '(("次のへ(n)"     . "(mew-message-next-msg)")
    ("前のへ(p)"     . "(mew-message-prev-msg)")
    ("Summaryへ(h)"  . "(mew-message-goto-summary)")
    ("新規作成(w)"   . "(mew-summary-write)")
    ("引用返信(A)"   . "(mew-message-reply-with-citation)")
    ("返信(a)"       . "(mew-message-reply)")
    ("引用個別返信"  . "(progn (mew-message-goto-summary) (mew-summary-reply-with-citation t))")
    ("個別返信"      . "(progn (mew-message-goto-summary) (mew-summary-reply t))")
    ("再送(r)"       . "(mew-message-resend)")
    ("転送(f)"       . "(mew-message-forward)")
    ("削除(d)"       . "(progn (mew-message-goto-summary) (mew-summary-delete))")
    ("整理整頓(o)"   . "(progn (mew-message-goto-summary) (mew-summary-refile))")
    ("未読にする(U)" . "(save-window-excursion (mew-message-goto-summary) (mew-summary-unread))")))

(defvar anything-c-source-mew-file-at-point
  '((name . "mew-file-at-point")
    (candidates . my-mew-file-at-point)
    (action
     ("Open file with default tool" . anything-c-open-file-with-default-tool)
     ("Find file in popup window" . popwin:find-file)
     ("Find file other window" . find-file-other-window)
     ("Find file other frame" . find-file-other-frame)
     ("Find file" . anything-find-many-files)
     ("Find file as root" . anything-find-file-as-root)
     ("View file" . view-file)
     ("Insert file" . insert-file)
     ("Delete file(s)" . anything-delete-marked-files)
     ("Open file externally (C-u to choose)" . anything-c-open-file-externally)
     ("Find file in hex dump" . hexl-find-file))))

(defun my-mew-file-at-point ()
  "get file path at mew message mode"
  (with-current-buffer anything-current-buffer
    (let* ((file-name
            (if (use-region-p)
                (buffer-substring-no-properties (region-beginning) (region-end))))
           (file-name
            (if (or linux-p mac-p)
                (smb-file-backslash-to-slash (ffap-string-at-point))
              (ffap-string-at-point))))
      (message file-name)
      (if (and (> (string-width file-name) 0) (file-exists-p file-name))
          ;;(open-file-dwim (read-file-name "X on File: " file-name))
          (if (file-directory-p file-name)
              (mapcar (lambda (x) (cons x (concat file-name "/" x)))
               (directory-files file-name))
            (list file-name))))))

;;
;; 返信時メールアドレスの訂正処理 for MS Exchange
;;______________________________________________________________________

(defadvice mew-to-cc-newsgroups (after mew-to-cc-newsgroups-fix activate)
  ;; (message "+++++++++ %s" (pp-to-string ad-return-value))
  (setq ad-return-value
        (let ((new-list nil))
          (loop for x in ad-return-value do
                (setq new-list
                      (if x
                          (loop for addr in x
                                when (string-match thing-at-point-email-regexp addr)
                                collect addr)
                        x))
                collect new-list)))
  ;; (message "-------- %s" (pp-to-string ad-return-value))
  ad-return-value)

(provide 'my-mew)
;;; my-mew.el ends here

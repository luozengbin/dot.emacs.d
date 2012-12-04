;;; Commentary:

;; dired 関連機能関数

;;; Code:

;;---------------------------------------------------------
;; ワンキーで dired のソートタイプを切り替える
;; 拡張子順、バージョン順の追加
;; | s | 色々なソートタイプを順に切り替え      |
;; | c | anything を利用してソートタイプを選択 |
;; 参考サイト：http://d.hatena.ne.jp/mooz/20091207/p1
;;---------------------------------------------------------
(defvar dired-various-sort-type
  '(("S" . "size")
    ("X" . "extension")
    ("v" . "version")
    ("t" . "date")
    (""  . "name")))

(defun dired-various-sort-change (sort-type-alist &optional prior-pair)
  (when (eq major-mode 'dired-mode)
    (let* (case-fold-search
           get-next
           (options
            (mapconcat 'car sort-type-alist ""))
           (opt-desc-pair
            (or prior-pair
                (catch 'found
                  (dolist (pair sort-type-alist)
                    (when get-next
                      (throw 'found pair))
                    (setq get-next (string-match (car pair) dired-actual-switches)))
                  (car sort-type-alist)))))
      (setq dired-actual-switches
            (concat "-l" (dired-replace-in-string (concat "[l" options "-]")
                                                  ""
                                                  dired-actual-switches)
                    (car opt-desc-pair)))
      (setq mode-name
            (concat "Dired by " (cdr opt-desc-pair)))
      (force-mode-line-update)
      (revert-buffer))))

(defun dired-various-sort-change-or-edit (&optional arg)
  "Hehe"
  (interactive "P")
  (when dired-sort-inhibit
    (error "Cannot sort this dired buffer"))
  (if arg
      (dired-sort-other
       (read-string "ls switches (must contain -l): " dired-actual-switches))
    (dired-various-sort-change dired-various-sort-type)))

(defvar anything-c-source-dired-various-sort
  '((name . "Dired various sort type")
    (candidates . (lambda ()
                    (mapcar (lambda (x)
                              (cons (concat (cdr x) " (" (car x) ")") x))
                            dired-various-sort-type)))
    (action . (("Set sort type" . (lambda (candidate)
                                    (dired-various-sort-change dired-various-sort-type candidate)))))
    ))

(add-hook 'dired-mode-hook
          '(lambda ()
             (define-key dired-mode-map "s" 'dired-various-sort-change-or-edit)
             (define-key dired-mode-map "c"
               '(lambda ()
                  (interactive)
                  (anything '(anything-c-source-dired-various-sort))))
             ))

;;---------------------------------------------------------
;; dired で見たときに今日編集したファイルが目立っているとうれしいですよね。
;; 参考サイト：http://d.hatena.ne.jp/higepon/20061230/1167447340
;;---------------------------------------------------------
(defface my-face-f-2 '((t (:foreground "DeepPink"))) nil)
(defvar my-face-f-2 'my-face-f-2)
(defun my-dired-today-search (arg)
  "Fontlock search function for dired."
  (search-forward-regexp
   (concat (format-time-string "%Y-%m-%d" (current-time)) " [0-9]....") arg t))

(add-hook 'dired-mode-hook
          '(lambda ()
             (font-lock-add-keywords
              major-mode
              (list
               '(my-dired-today-search . my-face-f-2)
               ))))

;;---------------------------------------------------------
;; dired を使って、一気にファイルの coding system (漢字) を変換する
;; 参考サイト：http://www.bookshelf.jp/soft/meadow_25.html#SEC278
;;---------------------------------------------------------
(require 'dired-aux)
;; (add-hook 'dired-mode-hook
;;            (lambda ()
;;              (define-key (current-local-map) "R"
;;                'dired-do-convert-coding-system)))

(defun dired-convert-coding-system ()
  (let ((file (dired-get-filename))
        ;;(coding-system-for-read 'euc-japan)
        (coding-system-for-write dired-file-coding-system)
        failure)
    (condition-case err
        (with-temp-buffer
          (insert-file file)
          (write-region (point-min) (point-max) file))
      (error (setq failure err)))
    (if (not failure)
        nil
      (dired-log "convert coding system error for %s:\n%s\n" file failure)
      (dired-make-relative file))))

(defun dired-do-convert-coding-system (coding-system &optional arg)
  "Convert file (s) in specified coding system."
  (interactive
   (list (let ((default (or dired-default-file-coding-system
                            buffer-file-coding-system)))
           (read-coding-system
            (format "Coding system for converting file (s) (default, %s): "
                    default)
            default))
         current-prefix-arg))
  (check-coding-system coding-system)
  (setq dired-file-coding-system coding-system)
  (dired-map-over-marks-check
   (function dired-convert-coding-system) arg 'convert-coding-system t))

;; デフォルトの文字コードの指定
(setq dired-default-file-coding-system 'utf-8)

;;---------------------------------------------------------
;; dired モードで[z]を押す
;; diredでWindowsに関連付けられたアプリを起動する
;; 参考サイト：http://d.hatena.ne.jp/mooz/20100915/p1
;;             http://www.bookshelf.jp/soft/meadow_25.html
;;---------------------------------------------------------
(defun open-file-dwim (fname)
  "Open file dwim"
  (let ((process-connection-type nil))
    (message "started %s" fname)
    (cond (windows-p
           (w32-shell-execute "open" (substitute ?\\ ?/ fname)))
          (mac-p
           (apply 'start-process "finder" nil "open" (list (concat "" fname))))
          (linux-p
           (apply 'start-process "xdg-open" nil "xdg-open" (list (concat "" fname)))))))

;; カーソル下のファイルやディレクトリを関連付けられたプログラムで開く
(defun dired-open-dwim ()
  "Open file under the cursor"
  (interactive)
  (open-file-dwim (dired-get-filename)))

;; 現在のディレクトリを関連付けられたプログラムで開く
(defun dired-open-here ()
  "Open current directory"
  (interactive)
  (open-file-dwim (expand-file-name dired-directory)))

;;---------------------------------------------------------
;; ショートカットをw32-symlinksで扱えるようにする
;; 参考サイト：http://d.hatena.ne.jp/holidays-l/20110610/p1
;;---------------------------------------------------------
(when (eq system-type 'windows-nt)
  (custom-set-variables '(w32-symlinks-handle-shortcuts t))
  (require 'w32-symlinks)

  (defadvice insert-file-contents-literally (before insert-file-contents-literally-before activate)
    (set-buffer-multibyte nil))

  (defadvice minibuffer-complete (before expand-symlinks activate)
    (let ((file (expand-file-name
                 (buffer-substring-no-properties
                  (line-beginning-position) (line-end-position)))))
      (when (file-symlink-p file)
        (delete-region (line-beginning-position) (line-end-position))
        (insert (w32-symlinks-parse-symlink file))))))

;;
;; ファイルエクスプローラーとの連携 (explorer.exe | finder)
;;______________________________________________________________________
(defun my-exec-explorer-atpoint ()
  "In current buffer, execute Explorer."
  (interactive)
  (let* ((current-file-name (buffer-file-name))
         (current-dir-name (if current-file-name
                               (file-name-directory current-file-name)
                             user-emacs-directory)))
    (explorer current-dir-name)))

(defun dired-exec-explorer ()
  "In dired, execute Explorer."
  (interactive)
  (explorer (dired-current-directory)))

(defun unix-to-dos-filename (file)
  ;; 最後の"/"を削除する
  (setq file (replace-regexp-in-string "/$" "" file))
  (with-temp-buffer
    (insert file)
    (goto-char (point-min))
    (while (search-forward "/" nil t)
      (replace-match "\\" nil t))
    (buffer-string)))

(defun explorer (&optional dir)
  (interactive)
  (let ((dir (expand-file-name (or dir default-directory)))
        (process-connection-type nil))
    (if (or (not (file-exists-p dir))
            (and (file-exists-p dir)
                 (not (file-directory-p dir))))
        (message "%s can't open." dir)
      (cond (mac-p (apply 'start-process
                          "finder" nil "open" (list (concat "" dir))))
            (linux-p (apply 'start-process
                            "xdg-open" nil "xdg-open" (list (concat "" dir))))
            (windows-p
             (setq dir (unix-to-dos-filename dir))
             (let ((w32-start-process-show-window t))
               (apply 'start-process
                      "explorer" nil "explorer.exe" (list (concat "" dir)))))))))

;;
;; 圧縮、解凍用のカスタマイズ関数
;;______________________________________________________________________
(defcustom default-archive-format ".zip"
  "default file archive format."
  :type 'string
  :group 'dired)

(defcustom archive-format-list
  (list ".7z" ".Z" ".a" ".ace" ".alz" ".arc" ".arj" ".bz" ".bz2" ".cab" ".cpio"
        ".deb" ".gz" ".jar" ".lha" ".lrz" ".lz" ".lzh" ".lzma" ".lzo" ".rar"
        ".rpm" ".rz" ".t7z" ".tZ" ".tar" ".tbz" ".tbz2" ".tgz" ".tlz" ".txz"
        ".tzo" ".war" ".xz" ".zip" ".tar.gz")
  "usable file archive format list"
  :type 'list
  :group 'dired)

(defvar archive-unarchive-flashing-timers nil "timer queue")
(defvar archive-unarchive-highlight-time 10 "highlight target archive unarchive file name for seconds")
(defvar archive-unarchive-flashing-ferquence 0.6 "flashing ferquence")

(defun my-dired-flashing-on-keyword (buffer-or-name regp &optional cleanup)
  (with-current-buffer buffer-or-name
    (goto-char (point-min))
    (re-search-forward regp nil t)
    (let ((buffer-read-only nil))
      (if (not cleanup)
          (let* ((pos (next-single-property-change (point-min) 'flashing-flag))
                 (flashing-flag (if pos
                                    (get-text-property pos 'flashing-flag)
                                  "1")))
            (put-text-property (point) (1+ (point))
                               'flashing-flag
                               (if (string= flashing-flag "1")
                                   "0"
                                 "1"))
            (if (string= flashing-flag "1")
                (highlight-regexp regp)
              (unhighlight-regexp regp)))
        ;; do clean up work
        (unhighlight-regexp regp)
        (put-text-property (point) (1+ (point)) 'flashing-flag nil)))))

(defun my-dired-flashing (buf-name regp)
  ;; ハイライトタイマーを起動する
  (push-to-timer-queue 'archive-unarchive-flashing-timers
                       0 archive-unarchive-flashing-ferquence
                       `(lambda () (my-dired-flashing-on-keyword
                                    ,buf-name ,regp)))
  ;; ハイライトの停止タイマーを起動する
  (run-with-timer archive-unarchive-highlight-time nil
                  `(lambda ()
                     (pop-from-timer-queue 'archive-unarchive-flashing-timers
                                           '(my-dired-flashing-on-keyword
                                             ,buf-name ,regp t)))))


(defun my-dired-do-compress (&optional arg)
  "ファイル圧縮と解凍を自動的に識別し、処理を行う関数"
  (interactive "P")
  (let ((selected-files (dired-get-marked-files t current-prefix-arg))
        (extension-regexp (regexp-quote default-archive-format)))
    (dolist (extension-name archive-format-list)
      (setq extension-regexp (concat extension-regexp "\\|" (regexp-quote extension-name))))
    (setq extension-regexp (concat ".+\\(" extension-regexp "\\)$"))
    ;; 選択されたファイル数１つしかない、かつ拡張子が圧縮ファイルならば解凍を行う
    (if (and (eq 1 (length selected-files))
             (string-match extension-regexp (car selected-files)))
        (my-dired-do-unarchive)
      (my-dired-do-archive))
    ))

(defun my-dired-do-archive (&optional arg)
  "archive selected files with apack command."
  (interactive "P")
  (let (archive-file-name
        archive-format
        archive-file-full-name
        (selected-files (dired-get-marked-files t current-prefix-arg))
        (completion-ignore-case t)
        proc buf)
    ;; 圧縮ファイル名の入力
    (setq archive-file-name (read-string "Archive File Name: " (car selected-files)))
    ;; 圧縮ファイルの拡張子を選ぶ
    (setq archive-format (completing-read "Archive Format: " archive-format-list nil t default-archive-format))
    (setq archive-file-full-name (concat archive-file-name archive-format))
    ;; (dired-do-shell-command (concat "apack " archive-file-name archive-format " * &") nil selected-files)
    ;; 圧縮処理の出力用のバッファーを用意する
    (setq buf (generate-new-buffer (concat "*apack " archive-file-full-name "<" (buffer-name (current-buffer)) ">*")))
    ;; 圧縮プロセスを起動する
    (setq proc (start-process-shell-command "apack" buf
                                            (dired-shell-stuff-it (concat "apack " archive-file-full-name) selected-files nil)))
    (set-process-sentinel proc 'my-dired-do-archive-sentinel)
    (set-process-filter proc 'my-dired-do-command-output-filter)
    (message (concat archive-file-full-name " 圧縮中..."))
    ;; 選択されたファイルのマークをクリアする
    (dired-unmark-all-files ?\r)
    ))

(defun my-dired-do-archive-sentinel (proc state)
  "圧縮処理プロセス完了後のリスナー定義"
  (let* ((ps (process-status proc))
         (result-buffer (process-buffer proc))
         (result-buffer-name (buffer-name result-buffer))
         begin-pos-1 end-pos-1 archive-file-name
         begin-pos-2 end-pos-2 dest-buffer-name)
    (cond
     ((eq ps 'exit)
      ;; 出力バッファー名から、諸々情報を取り出す
      (string-match "[\*]apack \\([^<]+\\)<\\([^>]+\\)>[\*].*" result-buffer-name)
      (setq begin-pos-1 (match-beginning 1))
      (setq end-pos-1 (match-end 1))
      (setq begin-pos-2 (match-beginning 2))
      (setq end-pos-2 (match-end 2))
      (when (and begin-pos-1 end-pos-1 begin-pos-2 end-pos-2)
        ;; 圧縮ファイル名
        (setq archive-file-name (substring result-buffer-name begin-pos-1 end-pos-1))
        ;; 作業ディレクトリバッファー名
        (setq dest-buffer-name (substring result-buffer-name begin-pos-2 end-pos-2))
        (message (concat "result buffer name: " result-buffer-name))
        (message (concat "archive file name: " archive-file-name))
        (message (concat "dest buffer name: " dest-buffer-name))
        (when (get-buffer dest-buffer-name)
          (goto-char (point-max))
          (insert (concat "\nArchive To --> " archive-file-name "\n"))
          (with-current-buffer dest-buffer-name
            (revert-buffer)             ;diredバッファーの更新
            ;; ハイライト制御
            (my-dired-flashing dest-buffer-name (concat archive-file-name "$"))))
        ;; show buffer with popwin style
        (unless (eq popwin:popup-buffer result-buffer)
          (popwin:popup-buffer result-buffer))
        (message (concat archive-file-name " 圧縮完了しました！"))))
     (t nil))))

(defun my-dired-do-unarchive (&optional arg)
  "unarchive selected files with aunpack command."
  (interactive "P")
  (let (archive-dest-folder buf proc
        (selected-files (dired-get-marked-files t current-prefix-arg)))
    (dolist (archive-file selected-files)
      ;; (dired-do-shell-command "aunpack * &" nil (list archive-file))
      ;; 解凍プロセス処理で使う出力バッファーの作成
      (setq buf (generate-new-buffer (concat "*aunpack " archive-file "<" (buffer-name (current-buffer)) ">*")))
      ;; 解凍プロセスの起動
      (setq proc (start-process "aunpack" buf "aunpack" archive-file))
      (set-process-sentinel proc 'my-dired-do-unarchive-sentinel)
      (set-process-filter proc 'my-dired-do-command-output-filter)
      (message (concat archive-file " 解凍中...")))))

(defun my-dired-do-command-output-filter (proc string)
  "プロセス出力テキストをバッファーに随時に反映するリスナー"
  (let* ((result-buffer (process-buffer proc))
         (popwin:special-display-config (if result-buffer `((,(buffer-name result-buffer))))))
    (when result-buffer
      (with-current-buffer result-buffer
        (insert string)
        (goto-char (point-max)))
      ;; show buffer with popwin style
      (unless (eq popwin:popup-buffer result-buffer)
        (popwin:popup-buffer result-buffer)))))

(defun my-dired-do-unarchive-sentinel (proc state)
  "解凍処理プロセス完了後のリスナー定義"
  (let* ((ps (process-status proc))
         (result-buffer (process-buffer proc))
         (result-buffer-name (buffer-name result-buffer))
         begin-pos-1 end-pos-1 archive-file-name
         begin-pos-2 end-pos-2 dest-buffer-name
         dest-folder-name)
    (cond
     ((eq ps 'exit)
      ;; 出力バッファー名からファイル情報をゲットする
      (toggle-read-only)              ; 出力バッファーをreadonlyにする
      (string-match "[\*]aunpack \\([^<]+\\)<\\([^>]+\\)>[\*].*" result-buffer-name)
      (setq begin-pos-1 (match-beginning 1))
      (setq end-pos-1 (match-end 1))
      (setq begin-pos-2 (match-beginning 2))
      (setq end-pos-2 (match-end 2))
      (when (and begin-pos-1 end-pos-1 begin-pos-2 end-pos-2)
        ;; 解凍された圧縮ファイル名
        (setq archive-file-name (substring result-buffer-name begin-pos-1 end-pos-1))
        ;; 作業ディレクトリ
        (setq dest-buffer-name (substring result-buffer-name begin-pos-2 end-pos-2))
        (message (concat "result buffer name: " result-buffer-name))
        (message (concat "archive file name: " archive-file-name))
        (message (concat "dest buffer name: " dest-buffer-name))
        (when (get-buffer dest-buffer-name)
          ;; 出力バッファーから解凍先のディレクトリ名を探す
          (save-excursion
            (goto-char (point-min))
            (re-search-forward "^.+extracted to [\`]\\(.+\\)'" nil t)
            (setq dest-folder-name (match-string 1))
            (message (concat "dest folder name: " dest-folder-name)))
          (with-current-buffer (get-buffer dest-buffer-name)
            (revert-buffer)             ; diredバッファー更新
            (when dest-folder-name
              ;; ハイライト制御
              (my-dired-flashing dest-buffer-name (concat dest-folder-name "$"))
              (goto-char (point-min))
              (re-search-forward (concat dest-folder-name "$") nil t)
              (dired-find-file-other-window))))
        ;; show buffer with popwin style
        (unless (eq popwin:popup-buffer result-buffer)
          (popwin:popup-buffer result-buffer))
        (message (concat archive-file-name " 解凍完了しました！"))))
     (t nil))))

(defun dired-find-file-as-root ()
  "In Dired, visit the file or directory named on this line."
  (interactive)
  (let ((find-file-run-dired t))
    (find-file (concat "/" anything-su-or-sudo "::" (dired-get-file-for-visit)))))

(defun dired-find-file-other-window-as-root ()
  "In Dired, visit this file or directory in another window."
  (interactive)
  (find-file-other-window (concat "/" anything-su-or-sudo "::" (dired-get-file-for-visit))))

;;
;; マークをトグル式にする
;;______________________________________________________________________
;;; http://www.bookshelf.jp/soft/meadow_25.html#SEC276
(defun my-dired-toggle-mark (arg)
  "Toggle the current (or next ARG) files."
  ;; S.Namba Sat Aug 10 12:20:36 1996
  (interactive "P")
  (let ((dired-marker-char
         (if (save-excursion (beginning-of-line)
                             (looking-at " "))
             dired-marker-char ?\040)))
    (dired-mark arg)
    (dired-previous-line 1)))


;;
;; diredからファイルをちら見する
;;______________________________________________________________________
(defun dired-view-file-other-window ()
  (interactive)
  (let ((file (dired-get-file-for-visit)))
    (if (file-directory-p file)
        (or (and (cdr dired-subdir-alist)
                 (dired-goto-subdir file))
            (dired file))
      (view-file-other-window file)
      )))

(defun dired-view-file-next (&optional reverse)
  (interactive)
  (lexical-let ((dir-buffer  (assoc-default default-directory dired-buffers))
                (win         (selected-window))
                (dir-win     nil)
                (disp-buffer nil))
    (when dir-buffer
      (View-quit)
      (walk-windows '(lambda (xw)
                       (when (eq (window-buffer xw) dir-buffer)
                         (setq dir-win xw))))
      (when dir-win
        (select-window dir-win)
        (if reverse (previous-line)
          (next-line))
        (save-window-excursion
          (dired-view-file-other-window)
          (setq disp-buffer (current-buffer)))
        (when disp-buffer
          (set-window-buffer win disp-buffer)
          (select-window win))))))

(defun dired-view-file-previous ()
  (interactive)
  (dired-view-file-next 1))

(provide 'my-dired)
;;; my-dired.el ends here

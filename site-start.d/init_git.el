;;; init_git.el --- configuration for git version control functions

;; Copyright (C) 2011  LuoZengbin

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

;; git バージョン管理支援

;;; Code:

(message "init_git ...")

;;
;; git-program
;;______________________________________________________________________
(when windows-p
  (setq vc-git-program "C:/Program Files/Git/bin/git.exe")
  (modify-coding-system-alist 'process "git" '(utf-8-dos . utf-8-unix)))

;;
;; magit for git
;;______________________________________________________________________
;; git clone https://github.com/magit/magit.git
;; Magit で Gitを扱う
(when (require 'magit nil t)
  ;; windowsの場合文字化けるため、プロセス通信文字コードを調整
  (when windows-p
    (setq magit-git-executable vc-git-program)
    (modify-coding-system-alist 'process "git" '(utf-8-dos . utf-8-unix)))
  ;; ;; integrates with git-svn. Hit 'N' to see your options.
  ;; (require 'magit-svn)
  ;; ;; integrates with topgit.
  ;; (require 'magit-topgit)
  ;; ;; integrates with StGit
  ;; (require 'magit-stgit)

  ;; (require 'vc)
  ;; (require 'cl)
  ;; (defun vc-status-dwim ()
  ;;   (interactive)
  ;;   (call-interactively
  ;;    (case (vc-backend buffer-file-name)
  ;;      (CVS 'cvs-status)
  ;;      (SVN 'svn-status)
  ;;      (t 'magit-status))))
  ;; (global-set-key (kbd "C-x v d") 'vc-status-dwim)

  ;; global-hl-line-modeを無効化する
  (add-hook 'magit-mode-hook (lambda () (my-hl-line-mode-local-face nil)))
  (defun magit-private-repo ()
    (interactive)
    (magit-status my-private-dir))
  (defun magit-emacs-repo ()
    (interactive)
    (magit-status user-emacs-directory))
  )

;;
;; Egg: Git フロントエンド
;;______________________________________________________________________
;;; install from elpa
(when (executable-find "git")
  (autoload 'egg-status "egg" "load egg when using egg-status" t nil)
  (autoload 'egg-log    "egg" "load egg when using egg-log" t nil)
  ;;egg-minor-mode-map
  )

;;
;; gist for github support
;; install from elpa
;;______________________________________________________________________
(require 'gist)
(setq gist-view-gist t)

(defun gh-api-set-response (status retry-data)
  ;; マルチバイト対応
  (set-buffer-multibyte t)
  (destructuring-bind (api req transform resp num) retry-data
    (condition-case err
        (gh-api-response-init resp (current-buffer) transform)
      (error
       (if (or (null num) (zerop num))
           (signal (car err) (cdr err))
         (logito:info api "Retrying request %s %s"
                      (oref req :method) (oref req :url))
         (let ((num (1- num)))
           (gh-api-run-request api req transform resp num)))))))

;;; windows環境プロキシ対応
(when (and my-office-mode windows-p)
  (defadvice gh-api-run-request (around gh-api-run-request-around activate)
    (let (
          ;; GnuTLSでプロキシを超えるのが困難であり、SSHポートフォワードで対応する
          ;; 手順：hostsファイルに 127.0.0.1 -> api.github.com マッピングする
          ;;       .ssh/configに LocalForward 443 --> api.github.com:443
          (url-proxy-services nil))
      ad-do-it)))

;;
;; helmでgitプロジェクトファイルを扱う
;;______________________________________________________________________
(defun helm-c-sources-git-project-for (pwd)
  (loop for elt in
        '(("Modified files" . "--modified")
          ("Untracked files" . "--others --exclude-standard")
          ("All controlled files in this project" . nil))
        for title  = (format "%s (%s)" (car elt) pwd)
        for option = (cdr elt)
        for cmd    = (format "\"%s\" ls-files %s" vc-git-program (or option ""))
        collect
        `((name . ,title)
          (init . (lambda ()
                    (unless (and (not ,option) (helm-candidate-buffer))
                      (with-current-buffer (helm-candidate-buffer 'global)
                        (call-process-shell-command ,cmd nil t nil)))))
          (candidates-in-buffer)
          (type . file))))

(defun helm-git-project-topdir ()
  (file-name-as-directory
   (replace-regexp-in-string
    "\n" ""
    (shell-command-to-string (format "\"%s\" rev-parse --show-toplevel" vc-git-program)))))

(defun helm-git-project ()
  (interactive)
  (let ((topdir (helm-git-project-topdir)))
    (unless (file-directory-p topdir)
      (error "I'm not in Git Repository!!"))
    (let* ((default-directory topdir)
           (sources (helm-c-sources-git-project-for default-directory)))
      (helm-other-buffer sources "*helm git project*"))))

(define-key global-map (kbd "C-;") 'helm-git-project)

(provide 'init_git)
;;; init_git.el ends here

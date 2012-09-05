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
;; magit for git
;;______________________________________________________________________
;; git clone https://github.com/magit/magit.git
;; Magit で Gitを扱う
(when (require 'magit nil t)
  ;; windowsの場合文字化けるため、プロセス通信文字コードを調整
  (when windows-p
    (setq magit-git-executable "C:/Program Files/Git/bin/git.exe")
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
;; anythingでgitプロジェクトファイルを扱う
;;______________________________________________________________________
(defun anything-c-sources-git-project-for (pwd)
  (loop for elt in
        '(("Modified files (%s)" . "--modified")
          ("Untracked files (%s)" . "--others --exclude-standard")
          ("All controlled files in this project (%s)" . ""))
        collect
        `((name . ,(format (car elt) pwd))
          (init . (lambda ()
                    (unless (and ,(string= (cdr elt) "") ;update candidate buffer every time except for that of all project files
                                 (anything-candidate-buffer))
                      (with-current-buffer
                          (anything-candidate-buffer 'global)
                        (insert
                         (shell-command-to-string
                          ,(format "git ls-files $(git rev-parse --show-cdup) %s"
                                   (cdr elt))))))))
          (candidates-in-buffer)
          (type . file))))

(defun anything-git-project ()
  (interactive)
  (let* ((pwd default-directory)
         (sources (anything-c-sources-git-project-for pwd)))
    (anything-other-buffer sources
                           (format "*Anything git project in %s*" pwd))))

(define-key global-map (kbd "C-;") 'anything-git-project)

(provide 'init_git)
;;; init_git.el ends here

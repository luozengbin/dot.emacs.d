;;; init_blogger.el --- configuration for writting blog content

;; Copyright (C) 2012  LuoZengbin

;; Author: LuoZengbin <jalen.cn@gmail.com>
;; Keywords: blog

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

;;

;;
;; org2blog
;;_____________________________________________________________________
;; source https://github.com/punchagan/org2blog
;; deps
;;     (install-elisp "https://launchpad.net/xml-rpc-el/trunk/1.6.8/+download/xml-rpc.el")

;; (require 'org2blog-autoloads)

;; ;; wordpress
;; (setq org2blog/wp-blog-alist
;;       '(("default"
;;          :url "http://luozengbin.wordpress.com/xmlrpc.php"
;;          :username "luozengbin"
;;          ;; :password "xxx"
;;          :tags-as-categories nil)
;;         ))

;; ;; Syntax Highlightとの連携
;; (setq org2blog/wp-use-sourcecode-shortcode t)
;; ;; (setq org2blog/wp-sourcecode-default-params nil)

;;
;; org-googlecl
;;_____________________________________________________________________
;; org-googleclでブログをgoogle bloggerに投稿する
;; git clone http://github.com/rileyrg/org-googlecl.git
;; The command line google utility found here http://code.google.com/p/googlecl/
;; M-x org-googlecl-blog
;; M-x org-googlecl-list-blogs
;; M-x googlecl-prompt-blog
;; 参照リンク:http://gihyo.jp/admin/serial/01/ubuntu-recipe/0130
;; install http://kikukawatei.blogspot.com/2011/01/org-googleclel-blogger_4570.html
;; (require 'org-googlecl)
;; (setq googlecl-blogname "懶人日記")
;; (setq googlecl-username "jalen.cn@gmail.com")


;;
;; o-blog
;;_____________________________________________________________________
;;; http://renard.github.com/o-blog/
;; (autoload 'org-publish-blog "o-blog" nil t)

;;
;; org-jekyll
;;_____________________________________________________________________
;; http://juanreyero.com/open/org-jekyll/
;; (install-elisp "https://raw.github.com/juanre/org-jekyll/67dd3ff2d6ad54727a1f916c89aaef456f6930f7/org-jekyll.el")
;; (require 'org-publish)
;; (require 'org-jekyll)
;; (setq org-publish-blog (concat my-private-emacs-path "luozengbin.github.com/source"))
;; (setq blog-base-directory (concat my-private-emacs-path "luozengbin.github.com/source"))
;; (add-to-list 'org-publish-project-alist
;;              `("github-blog"
;;                :base-directory ,blog-base-directory
;;                :recursive t
;;                :base-extension "org"
;;                :publishing-directory ,org-publish-blog
;;                :blog-publishing-directory ,org-publish-blog
;;                :site-root "http://luozengbin.github.com/"
;;                :jekyll-sanitize-permalinks t
;;                :publishing-function org-publish-org-to-html
;;                :section-numbers nil
;;                :headline-levels 4
;;                :table-of-contents t
;;                :auto-index nil
;;                :auto-preamble nil
;;                :body-only t
;;                :auto-postamble nil))

;;
;; org-octopress
;;_____________________________________________________________________
(require 'org-octopress)
(setq org-octopress-directory-top       (concat user-emacs-directory "blogs/octopress/source"))
(setq org-octopress-directory-posts     (concat user-emacs-directory "blogs/octopress/source/_posts"))
(setq org-octopress-directory-org-top   (concat user-emacs-directory "blogs/octopress/source"))
(setq org-octopress-directory-org-posts (concat user-emacs-directory "blogs/octopress/source/blog"))
(setq org-octopress-setup-file          (concat user-emacs-directory "blogs/octopress/setupfile.org"))

(defvar org-octopress-top
  (concat user-emacs-directory "blogs/octopress/")
  "octopressブログテンプレートディレクトリ")

(defun org-octopress-deploy ()
  "deploy octopress content to github page service."
  (interactive)
  (message "deploy octopress content ....")
  (lexical-let* ((default-directory org-octopress-top))
    (deferred:$
      (deferred:process-shell "blog_deploy.sh" org-octopress-top)
      (deferred:nextc it
        (lambda (x)
          (message "*** deploy blog ***")
          (message x))))))

(defun org-octopress-preview ()
  "preview octopress content by call external shell script."
  (interactive)
  (message "preview octopress content ....")
  (lexical-let* ((default-directory org-octopress-top)
                 (preview-url "http://localhost:4000"))
    (deferred:$
      (deferred:process-shell "blog_preview.sh" org-octopress-top)
      (deferred:nextc it
        (lambda (x)
          (message "*** preview blog ***")
          (message x)
          (message "launch preview url %s" preview-url)
          (browse-url preview-url))))))

(provide 'init_blogger)
;;; init_blogger.el ends here

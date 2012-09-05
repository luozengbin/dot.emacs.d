;;; init_skype.el --- configuration for skype

;; Copyright (C) 2012  LuoZengbin

;; Author: LuoZengbin <jalen.cn@gmail.com>
;; Keywords: chat, skype

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

;;; install
;; (install-elisp "https://raw.github.com/kiwanami/emacs-skype/master/skype.el")

(defun my-skype ()
  (interactive)
  (require 'skype)
  (setq skype--my-user-handle "jalen_cn")
  (skype--init)
  (skype--open-all-users-buffer-command))

(provide 'init_skype)
;;; init_skype.el ends here

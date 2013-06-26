;;; init_tools.el --- configuration for emacs tools

;; Copyright (C) 2013  LuoZengbin

;; Author: LuoZengbin <jalen.cn@gmail.com>
;; Keywords: tools

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


;;; 国名とトップレベルドメインの相互参照ができるツール
;; (install-elisp "http://www.davep.org/emacs/tld.el")
(autoload 'tld "tld" "Perform a TLD lookup" t)

(provide 'init_tools)
;;; init_tools.el ends here

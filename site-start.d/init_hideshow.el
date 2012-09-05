;;; init_hideshow.el --- configuration for hide show behavior

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

;; ソースコースの折り畳む

;;; Code:

;;
;; fold-dwim
;;______________________________________________________________________
;; fold-dwim 3つ覚えるだけで伸縮自在に
(autoload 'fold-dwim-toggle
  "fold-dwim"
  "try to show any hidden text at the cursor" t)
(autoload 'fold-dwim-hide-all
  "fold-dwim" "hide all folds in the buffer" t)
(autoload 'fold-dwim-show-all
  "fold-dwim" "show all folds in the buffer" t)
(define-key global-map "\C-c\C-o" 'fold-dwim-toggle)
(define-key global-map "\C-c\C-m" 'fold-dwim-hide-all)
(define-key global-map "\C-c\C-k" 'fold-dwim-show-all)

;;
;; hideshow
;;______________________________________________________________________
;; hideshow.elでソースコードを折り畳む
;; (install-elisp "http://www.dur.ac.uk/p.j.heslin/Software/Emacs/Download/fold-dwim.el")
(require 'hideshow)

(provide 'init_hideshow)
;;; init_hideshow.el ends here

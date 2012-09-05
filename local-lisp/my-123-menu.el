;;; my-123-menu.el --- my 123 menu configuration

;; Copyright (C) 2012  LuoZengbin

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

(123-menu-defmenu marc-menu-root
                  ("a" "[A]bbrev"    '123-menu-display-menu-marc-menu-abbrev)
                  ("b" "[B]uffer"    '123-menu-display-menu-marc-menu-buffer)
                  ("c" "[C]ode"      '123-menu-display-menu-marc-menu-code)
                  ("e" "[E]val"      '123-menu-display-menu-marc-menu-eval)
                  ("f" "[F]ile"      '123-menu-display-menu-marc-menu-file)
                  ("m" "[M]arks"     '123-menu-display-menu-marc-menu-marks)
                  ("r" "[R]ect"      '123-menu-display-menu-marc-menu-rect)
                  ("s" "[S]earch"    '123-menu-display-menu-marc-menu-search)
                  ("v" "[V]ersion"   '123-menu-display-menu-marc-menu-version)
                  ("w" "[W]indow"    '123-menu-display-menu-marc-menu-window))

(123-menu-defmenu marc-menu-abbrev
                  ("g" "[G]lobal"              'add-global-abbrev)
                  ("m" "[M]ode-specific"       'add-mode-abbrev)
                  ("i" "[I]nverse"             '123-menu-display-menu-marc-menu-abbrev-inverse))

(123-menu-defmenu marc-menu-abbrev-inverse
                  ("g" "[G]lobal"              'inverse-add-global-abbrev)
                  ("m" "[M]ode-specific"       'inverse-add-mode-abbrev))

(123-menu-defmenu marc-menu-buffer
                  ("k" "[K]ill"                'kill-buffer)
                  ("l" "[L]ist"                'list-buffers)
                  ("r" "[R]ename"              'rename-buffer))

(123-menu-defmenu marc-menu-code
                  ("c" "[C]omment region"      'comment-region)
                  ("u" "[U]ncomment region"    'uncomment-region))

(123-menu-defmenu marc-menu-eval
                  ("b" "[B]uffer"              'eval-buffer)
                  ("l" "[L]ast sexp"           'eval-last-sexp)
                  ("r" "[R]egion"              'eval-region))

(123-menu-defmenu marc-menu-file
                  ("d" "[D]ired"               'dired)
                  ("f" "[F]ind"                'find-file)
                  ("i" "[I]nsert"              'insert-file)
                  ("s" "[S]ave"                'save-buffer))

(123-menu-defmenu marc-menu-marks
                  ("j" "[J]ump"                'bookmark-jump)
                  ("s" "[S]et"                 'bookmark-set))

(123-menu-defmenu marc-menu-rect
                  ("k" "[K]ill"                'kill-rectangle)
                  ("y" "[Y]ank"                'yank-rectangle)
                  ("o" "[O]pen"                'open-rectangle))

(123-menu-defmenu marc-menu-search
                  ("i" "[I]ncremental"         'isearch-forward)
                  ("o" "[O]ccur"               'occur))

(123-menu-defmenu marc-menu-version
                  ("a" "[A]nnotate"            'vc-annotate)
                  ("d" "[D]iff"                'vc-diff)
                  ("l" "[L]og"                 'vc-print-log))

(123-menu-defmenu marc-menu-window
                  ("1" "[1]window"             'delete-other-windows)
                  ("o" "[O]ther"               'other-window)
                  ("v" "[V]ert split"          'split-window-vertically)
                  ("h" "[H]oriz split"         'split-window-horizontally))

(define-key global-map (kbd "<apps>") '123-menu-display-menu-marc-menu-root)

(provide 'my-123-menu)
;;; my-123-menu.el ends here

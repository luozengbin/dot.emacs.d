;;; init_python.el --- configuration python mode

;; Copyright (C) 2012  LuoZengbin

;; Author: LuoZengbin <jalen.cn@gmail.com>
;; Keywords: languages, ruby

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

;; (require 'python-mode)

;;; 構文チェッカー
;; sudo pacman -S pychecker

;;
;; flymake for pyhton
;;______________________________________________________________________
;; flake8を利用する
(setq flymake-python-syntax-checker "flake8")
;; pep8を利用する
;; (setq flymake-python-syntax-checker "pep8")

(defconst flymake-allowed-python-file-name-masks '(("\\.py\\'" flymake-python-init)))

;; syntax checker for Python - examples include `pep8', `pyflakes', `flake8' (combination of pep8, pyflakes, and McCabe), `pychecker', or a custom shell script
(defcustom flymake-python-syntax-checker "pyflakes"
  "Syntax checker for Flymake Python."
  :type 'string)

(defun flymake-python-create-temp-in-system-tempdir (filename prefix)
  (make-temp-file (or prefix "flymake-python")))

(defun flymake-python-init ()
  (list flymake-python-syntax-checker (list (flymake-init-create-temp-buffer-copy
                                             'flymake-python-create-temp-in-system-tempdir))))

(defun flymake-python-load ()
  (interactive)
  (require 'flymake)
  (defadvice flymake-post-syntax-check (before flymake-force-check-was-interrupted)
    (setq flymake-check-was-interrupted t))
  (ad-activate 'flymake-post-syntax-check)
  (set (make-local-variable 'flymake-allowed-file-name-masks) flymake-allowed-python-file-name-masks)
  (if (executable-find flymake-python-syntax-checker)
      (flymake-mode t)
    (message (concat "Not enabling flymake: " flymake-python-syntax-checker " command not found"))))

(add-hook 'python-mode-hook 'flymake-python-load)

(provide 'init_python)
;;; init_python.el ends here

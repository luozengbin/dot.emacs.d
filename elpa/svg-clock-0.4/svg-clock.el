;;; svg-clock.el --- Analog clock using Scalable Vector Graphics

;; Copyright (C) 2011  Free Software Foundation, Inc.

;; Author:      Ulf Jasper <ulf.jasper@web.de>
;; Created:     22. Sep. 2011
;; Keywords:    demo, svg, clock
;; Version:     0.4

;; This file is part of GNU Emacs.

;; GNU Emacs is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; GNU Emacs is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; svg-clock provides a scalable analog clock.  Rendering is done by
;; means of svg (Scalable Vector Graphics).  Works only with Emacsen
;; which were built with svg support -- (image-type-available-p 'svg)
;; must return t.  Call `svg-clock' to start/stop the clock.
;; Set `svg-clock-size' to change its size.

;; Installation
;; ------------

;; Add the following lines to your Emacs startup file (`~/.emacs').
;; (add-to-list 'load-path "/path/to/svg-clock.el")
;; (autoload 'svg-clock "svg-clock" "Start/stop svg-clock" t)

;; ======================================================================

;;; Code:
(defconst svg-clock-version "0.4" "Version number of `svg-clock'.")

(require 'image-mode)

(defgroup svg-clock nil
  "svg-clock"
  :group 'applications)

(defcustom svg-clock-size t
  "Size (width and height) of the clock.
Either an integer which gives the clock size in pixels, or t
which makes the clock fit to its window automatically."
  :type '(choice (integer :tag "Fixed Size" :value 250)
                 (const :tag "Fit to window" t))
  :group 'svg-clock)

(defvar svg-clock-timer nil)

(defconst svg-clock-template
  "<?xml version=\"1.0\"?>
<!DOCTYPE svg PUBLIC \"-//W3C//DTD SVG 1.1//EN\"
\"http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd\">
<svg xmlns=\"http://www.w3.org/2000/svg\"
     width=\"%SIZE%\" height=\"%SIZE%\" >
    <defs>
        <symbol id=\"tick\">
            <line x1=\"50\" y1=\"2\" x2=\"50\" y2=\"4\"
                  style=\"stroke:%FG%;stroke-width:1\"/>
        </symbol>
        <symbol id=\"ticklong\">
            <line x1=\"50\" y1=\"2\" x2=\"50\" y2=\"9\"
                  style=\"stroke:%FG%;stroke-width:2\"/>
        </symbol>
        <symbol id=\"hand-hour\">
            <line x1=\"50\" y1=\"22\" x2=\"50\" y2=\"54\"
                  style=\"stroke:%FG%;stroke-width:3\"/>
        </symbol>
        <symbol id=\"hand-minute\">
            <line x1=\"50\" y1=\"12\" x2=\"50\" y2=\"55\"
                  style=\"stroke:%FG%;stroke-width:3\"/>
        </symbol>
        <symbol id=\"hand-second\">
            <line x1=\"50\" y1=\"10\" x2=\"50\" y2=\"59\"
                  style=\"stroke:%FG%;stroke-width:0.5\"/>
        </symbol>
        <g id=\"minute-ticks-a\">
           <use xlink:href=\"#tick\"
                transform=\"rotate(6, 50, 50)\" />
           <use xlink:href=\"#tick\"
                transform=\"rotate(12, 50, 50)\" />
           <use xlink:href=\"#tick\"
                transform=\"rotate(18, 50, 50)\" />
           <use xlink:href=\"#tick\"
                transform=\"rotate(24, 50, 50)\" />
        </g>
        <g id=\"minute-ticks-b\">
            <use xlink:href=\"#minute-ticks-a\"
                 transform=\"rotate(0, 50, 50)\" />
            <use xlink:href=\"#minute-ticks-a\"
                 transform=\"rotate(30, 50, 50)\" />
            <use xlink:href=\"#minute-ticks-a\"
                 transform=\"rotate(60, 50, 50)\" />
            <use xlink:href=\"#minute-ticks-a\"
                 transform=\"rotate(90, 50, 50)\" />
            <use xlink:href=\"#minute-ticks-a\"
                 transform=\"rotate(120, 50, 50)\" />
            <use xlink:href=\"#minute-ticks-a\"
                 transform=\"rotate(150, 50, 50)\" />
        </g>

        <g id=\"5-minute-ticks\">
           <use xlink:href=\"#ticklong\" />
           <use xlink:href=\"#ticklong\" transform=\"rotate(30, 50, 50)\" />
           <use xlink:href=\"#ticklong\" transform=\"rotate(60, 50, 50)\" />
        </g>

        <g id=\"clock\">
          <use xlink:href=\"#5-minute-ticks\"
               transform=\"rotate(0, 50, 50)\" />
          <use xlink:href=\"#5-minute-ticks\"
               transform=\"rotate(90, 50, 50)\" />
          <use xlink:href=\"#5-minute-ticks\"
               transform=\"rotate(180, 50, 50)\" />
          <use xlink:href=\"#5-minute-ticks\"
               transform=\"rotate(270, 50, 50)\" />

          <use xlink:href=\"#minute-ticks-b\"
               transform=\"rotate(0, 50, 50)\" />
          <use xlink:href=\"#minute-ticks-b\"
               transform=\"rotate(180, 50, 50)\" />

          <use xlink:href=\"#hand-second\"
               transform=\"rotate(%SECOND%, 50, 50)\">
          </use>
          <use xlink:href=\"#hand-minute\"
               transform=\"rotate(%MINUTE%, 50, 50)\">
          </use>
          <use xlink:href=\"#hand-hour\"
               transform=\"rotate(%HOUR%, 50, 50)\">
          </use>

          <circle cx=\"50\" cy=\"50\" r=\"3\" fill=\"%FG%\"/>
        </g>
    </defs>
    <use xlink:href=\"#clock\"
         transform=\"scale(%SCALE%, %SCALE%)\"/>
</svg>"
  "The template for drawing the `svg-clock'.")

(defvar svg-clock--actual-size 100
  "Actual size of the svg clock.")

(defun svg-clock-color-to-hex (colour)
  "Return hex representation of COLOUR."
  (let ((values (color-values colour)))
    (format "#%02x%02x%02x" (nth 0 values) (nth 1 values) (nth 2 values))))

(defun svg-clock-replace (from to)
  "Replace all occurrences of FROM with TO."
  (goto-char (point-min))
  (while (re-search-forward from nil t)
    (replace-match to)))

(defun svg-clock-do-update (time)
  "Make the clock display TIME.
TIME must have the form (SECOND MINUTE HOUR ...), as returned by `decode-time'."
  (with-current-buffer (get-buffer-create "*clock*")
    (let* ((inhibit-read-only t)
           (seconds (nth 0 time))
           (minutes (nth 1 time))
           (hours (nth 2 time))
           (bg-colour (svg-clock-color-to-hex (face-background 'default)))
           (fg-colour (svg-clock-color-to-hex (face-foreground 'default))))
      (erase-buffer)
      (insert svg-clock-template)

      (svg-clock-replace "%BG%" bg-colour)
      (svg-clock-replace "%FG%" fg-colour)
      (svg-clock-replace "%HOUR%"
                         (format "%f" (+ (* hours 30) (/ minutes 2.0))))
      (svg-clock-replace "%MINUTE%"
                         (format "%f" (+ (* minutes 6) (/ seconds 10.0))))
      (svg-clock-replace "%SECOND%" (format "%f" (* seconds 6)))
      (svg-clock-replace "%SIZE%" (format "%d" svg-clock--actual-size))
      (svg-clock-replace "%SCALE%"
                         (format "%f" (/ svg-clock--actual-size 100.0)))

      (image-toggle-display-image))))

(defun svg-clock-update ()
  "Update the clock."
  (if (integerp svg-clock-size)
      (setq svg-clock--actual-size svg-clock-size)
    (svg-clock-fit-window))
  (svg-clock-do-update (decode-time (current-time))))

(defun svg-clock-set-size (size &optional perform-update)
  "Set the SIZE of the clock and optionally PERFORM-UPDATE."
  (setq svg-clock--actual-size size)
  (if perform-update
      (svg-clock-update)))

(defun svg-clock-grow ()
  "Enlarge the size of the svg clock by 10 pixesl.
If `svg-clock-size' is t this command has no effect."
  (interactive)
  (svg-clock-set-size (+ 10 svg-clock--actual-size) t))

(defun svg-clock-shrink ()
  "Reduce the size of the svg clock by 10 pixesl.
If `svg-clock-size' is t this command has no effect."
  (interactive)
  (svg-clock-set-size (max 10 (- svg-clock--actual-size 10)) t))

(defun svg-clock-fit-window (&optional perform-update)
  "Make the svg clock fill the whole window it is displayed in.
Optionally PERFORM-UPDATE immediately."
  (interactive)
  (let  ((clock-win (get-buffer-window "*clock*")))
    (if clock-win
        (let* ((coords (window-inside-pixel-edges clock-win))
               (width (- (nth 2 coords) (nth 0 coords)))
               (height (- (nth 3 coords) (nth 1 coords))))
          (svg-clock-set-size (min width height) perform-update)))))

(defun svg-clock-stop ()
  "Stop the svg clock and hide it."
  (interactive)
  (if (not svg-clock-timer)
      (message "svg-clock is not running.")
    (cancel-timer svg-clock-timer)
    (setq svg-clock-timer nil)
    (replace-buffer-in-windows "*clock*")
    (message "Clock stopped")))

(defun svg-clock-start ()
  "Start the svg clock."
  (if svg-clock-timer
      (message "svg-clock is running already")
    (switch-to-buffer (get-buffer-create "*clock*"))
    (unless (integerp svg-clock-size)
      (svg-clock-fit-window))
    (setq svg-clock-timer
          (run-with-timer 0 1 'svg-clock-update))
    (svg-clock-mode)
    (message "Clock started")))

(defvar svg-clock-mode-map
  (let ((map (make-sparse-keymap)))
    (define-key map [?+] 'svg-clock-grow)
    (define-key map [?-] 'svg-clock-shrink)
    (define-key map [?q] 'svg-clock-stop)
    (define-key map [?f] 'svg-clock-fit-window)
    map))

(define-derived-mode svg-clock-mode fundamental-mode "svg clock"
  "Major mode for the svg-clock buffer.
\\{svg-clock-mode-map}"
  (buffer-disable-undo))

;;;###autoload
(defun svg-clock ()
  "Start/stop the svg clock."
  (interactive)
  (if svg-clock-timer
      (svg-clock-stop)
    (svg-clock-start)))

(provide 'svg-clock)

;;; svg-clock.el ends here

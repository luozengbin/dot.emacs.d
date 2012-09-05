svg-clock provides a scalable analog clock.  Rendering is done by
means of svg (Scalable Vector Graphics).  Works only with Emacsen
which were built with svg support -- (image-type-available-p 'svg)
must return t.  Call `svg-clock' to start/stop the clock.
Set `svg-clock-size' to change its size.

Installation
------------

Add the following lines to your Emacs startup file (`~/.emacs').
(add-to-list 'load-path "/path/to/svg-clock.el")
(autoload 'svg-clock "svg-clock" "Start/stop svg-clock" t)

======================================================================

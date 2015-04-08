;;; init_google-services.el --- configuration for google tools

;; Copyright (C) 2011  Zouhin.Ro

;; Author: Zouhin.Ro <jalen.cn@gmail.com>
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

;; googleサービス初期設定

;;; Code:

;;
;; google-contacts
;; docs: http://julien.danjou.info/software/google-contacts.el
;;______________________________________________________________________
;; install
;; git submodule add http://git.naquadah.org/git/google-contacts.el.git lisp/google-contacts
(autoload 'google-contacts "google-contacts" nil t)
;; (require 'google-contacts-gnus)
;; (require 'google-contacts-message)

;;
;; google-maps
;; docs: http://julien.danjou.info/software/google-maps.el
;;______________________________________________________________________
;; install
;; git submodule add http://git.naquadah.org/git/google-maps.git lisp/google-maps

;; M-x google-maps
;; + or - to zoom in or out;
;; left, right, up, down to move;
;; z to set a zoom level via prefix;
;; q to quit;
;; m to add or remove markers;
;; c to center the map on a place;
;; C to remove centering;
;; t to change the maptype;
;; w to copy the URL of the map to the kill-ring;
;; h to show your home.
;; You can integrate directly Google Maps into Org-mode:
;; 参照リンク: http://julien.danjou.info/google-maps-el.html
(autoload 'google-maps "google-maps" "Run Google Maps on LOCATION.
If NO-GEOCODING is t, then does not try to geocode the address
and do not ask the user for a more precise location." t)

(autoload 'org-location-google-maps "org-location-google-maps"
"Show Google Map for location of an Org entry in an org buffer.
If WITH-CURRENT-LOCATION prefix is set, add a marker with current
location." t)

;;
;; google-weather
;; docs: http://julien.danjou.info/software/google-weather.el
;;______________________________________________________________________
;; install
;; git submodule add http://git.naquadah.org/git/google-weather.git lisp/google-weather
;; (require 'google-weather)
;; (require 'org-google-weather)


(provide 'init_google-services)
;;; init_google-services.el ends here

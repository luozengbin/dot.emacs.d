;;; init_music.el --- play music on emacs

;; Copyright (C) 2012  LuoZengbin

;; Author: LuoZengbin <jalen.cn@gmail.com>
;; Keywords: music

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

;;; 豆瓣在线音乐
;;; (install-elisp "https://raw.github.com/wxjeacen/douban-music/master/douban-music.el")
(require 'douban-music)

;; (global-set-key (kbd "C-c p")     'douban-music-play-next-song)
;; (global-set-key (kbd "C-c P")     'douban-music-stop-play)

(provide 'init_music)
;;; init_music.el ends here

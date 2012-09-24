;;; Commentary:

;; カスタマイズ windows 関数

;;; Code:

;; windowsの縦2分割 <-> 横2分割
(defun window-toggle-division ()
  (interactive)
  (unless (= (count-windows 1) 2)
    (error "Window isn't divide"))
  (let (before-height (other-buf (window-buffer (next-window))))
    (setq before-height (window-height))
    (delete-other-windows)
    (if (= (window-height) before-height)
        (split-window-vertically)
      (split-window-horizontally)
      )
    (switch-to-buffer-other-window other-buf)
    (other-window -1)))

;;分割したWindowの中身を交換する
(defun swap-screen()
  "Swap two screen,leaving cursor at current window."
  (interactive)
  (let ((thiswin (selected-window))
        (nextbuf (window-buffer (next-window))))
    (set-window-buffer (next-window) (window-buffer))
    (set-window-buffer thiswin nextbuf)
    (other-window 1)))

(defun swap-screen-with-cursor()
  "Swap two screen,with cursor in same buffer."
  (interactive)
  (let ((thiswin (selected-window))
        (thisbuf (window-buffer)))
    (other-window 1)
    (set-window-buffer thiswin (window-buffer))
    (set-window-buffer (selected-window) thisbuf)))

;;終了時のフレームサイズを記憶する
(defun my-window-size-save ()
  (let* ((rlist (frame-parameters (selected-frame)))
         (ilist initial-frame-alist)
         (nCHeight (frame-height))
         (nCWidth (frame-width))
         (tMargin (if (integerp (cdr (assoc 'top rlist)))
                      (cdr (assoc 'top rlist)) 0))
         (lMargin (if (integerp (cdr (assoc 'left rlist)))
                      (cdr (assoc 'left rlist)) 0))
         buf
         (file "~/.framesize.el"))
    (if (get-file-buffer (expand-file-name file))
        (setq buf (get-file-buffer (expand-file-name file)))
      (setq buf (find-file-noselect file)))
    (set-buffer buf)
    (erase-buffer)
    (insert (concat
             ;; 初期値をいじるよりも modify-frame-parameters
             ;; で変えるだけの方がいい?
             "(delete 'width initial-frame-alist)\n"
             "(delete 'height initial-frame-alist)\n"
             "(delete 'top initial-frame-alist)\n"
             "(delete 'left initial-frame-alist)\n"
             "(setq initial-frame-alist (append (list\n"
             "'(width . " (int-to-string nCWidth) ")\n"
             "'(height . " (int-to-string nCHeight) ")\n"
             "'(top . " (int-to-string tMargin) ")\n"
             "'(left . " (int-to-string lMargin) "))\n"
             "initial-frame-alist))\n"
             ;;"(setq default-frame-alist initial-frame-alist)"
             ))
    (save-buffer)
    (kill-buffer)
    ))

;; emacs起動と終了時にframeのサイズを調整する
;; (defun my-window-size-load ()
;;   (let* ((file "~/.framesize.el"))
;;     (if (file-exists-p file)
;;         (load file))))
;; (my-window-size-load)
;; ;; Call the function above at C-x C-c.
;; (defadvice save-buffers-kill-emacs
;;   (before save-frame-size activate)
;;   (my-window-size-save))


;; windowsを４割に分割する
;; +----------+-----------+
;; |          |           |
;; |          |           |
;; +----------+-----------+
;; |          |           |
;; |          |           |
;; +----------+-----------+
(defun split-window-4() 
  "Splite window into 4 sub-window"
  (interactive) 
  (if (= 1 (length (window-list))) 
      (progn (split-window-vertically) 
             (split-window-horizontally) 
             (other-window 2) 
             (split-window-horizontally) 
             ) 
    ) 
  )

(defun split-window-3() 
  "Splite window into 3 sub-window"
  (interactive) 
  (if (= 1 (length (window-list))) 
      (progn (split-window-vertically) 
             (split-window-horizontally) 
             ;; (other-window 2) 
             ;; (split-window-horizontally) 
             ) 
    ) 
  )

;; +----------------------+                 +------------+-----------+
;; |                      |           \     |            |           |
;; |                      |   +-------+\    |            |           |
;; +----------+-----------+   +-------+/    |            +-----------+
;; |          |           |           /     |            |           |
;; |          |           |                 |            |           |
;; +----------+-----------+                 +------------+-----------+
(defun split-v-3 () 
  "Change 3 window style from horizontal to vertical"
  (interactive) 

  (select-window (get-largest-window)) 
  (if (= 3 (length (window-list))) 
      (let ((winList (window-list))) 
	    (let ((1stBuf (window-buffer (car winList))) 
              (2ndBuf (window-buffer (car (cdr winList)))) 
              (3rdBuf (window-buffer (car (cdr (cdr winList)))))) 
	      (message "%s %s %s" 1stBuf 2ndBuf 3rdBuf) 

	      (delete-other-windows) 
	      (split-window-horizontally) 
	      (set-window-buffer nil 1stBuf) 
	      (other-window 1) 
	      (set-window-buffer nil 2ndBuf) 
	      (split-window-vertically) 
	      (set-window-buffer (next-window) 3rdBuf) 
	      (select-window (get-largest-window)) 
          )))) 


 ;; +------------+-----------+                  +----------------------+
 ;; |            |           |            \     |                      |
 ;; |            |           |    +-------+\    |                      |
 ;; |            +-----------+    +-------+/    +----------+-----------+
 ;; |            |           |            /     |          |           |
 ;; |            |           |                  |          |           |
 ;; +------------+-----------+                  +----------+-----------+
(defun split-h-3 () 
  "Change 3 window style from vertical to horizontal"
  (interactive) 

  (select-window (get-largest-window)) 
  (if (= 3 (length (window-list))) 
      (let ((winList (window-list))) 
	    (let ((1stBuf (window-buffer (car winList))) 
              (2ndBuf (window-buffer (car (cdr winList)))) 
              (3rdBuf (window-buffer (car (cdr (cdr winList)))))) 
          (message "%s %s %s" 1stBuf 2ndBuf 3rdBuf) 

          (delete-other-windows) 
          (split-window-vertically) 
          (set-window-buffer nil 1stBuf) 
          (other-window 1) 
          (set-window-buffer nil 2ndBuf) 
          (split-window-horizontally) 
          (set-window-buffer (next-window) 3rdBuf) 
          (select-window (get-largest-window)) 
	      ))))

 
;; +------------+-----------+                 +------------+-----------+
;; |            |           |            \    |            |           |
;; |            |           |    +-------+\   |            |           |
;; +------------+-----------+    +-------+/   +------------+           |
;; |                        |            /    |            |           |
;; |                        |                 |            |           |
;; +------------+-----------+                 +------------+-----------+
;; +------------+-----------+                 +------------+-----------+
;; |            |           |            \    |            |           |
;; |            |           |    +-------+\   |            |           |
;; |            +-----------+    +-------+/   +------------+-----------+
;; |            |           |            /    |                        |
;; |            |           |                 |                        |
;; +------------+-----------+                 +------------+-----------+
(defun change-split-type-3 () 
  "Change 3 window style from horizontal to vertical and vice-versa"
  (interactive) 

  (select-window (get-largest-window)) 
  (if (= 3 (length (window-list))) 
      (let ((winList (window-list))) 
        (let ((1stBuf (window-buffer (car winList)))
              (2ndBuf (window-buffer (car (cdr winList))))
              (3rdBuf (window-buffer (car (cdr (cdr winList)))))

              (split-3 
               (lambda(1stBuf 2ndBuf 3rdBuf split-1 split-2) 
                 "change 3 window from horizontal to vertical and vice-versa"
                 (message "%s %s %s" 1stBuf 2ndBuf 3rdBuf) 

                 (delete-other-windows) 
                 (funcall split-1) 
                 (set-window-buffer nil 2ndBuf) 
                 (funcall split-2) 
                 (set-window-buffer (next-window) 3rdBuf) 
                 (other-window 2) 
                 (set-window-buffer nil 1stBuf)))

              (split-type-1 nil)
              (split-type-2 nil)
              )
          (if (= (window-width) (frame-width)) 
              (setq split-type-1 'split-window-horizontally 
                    split-type-2 'split-window-vertically)
            (setq split-type-1 'split-window-vertically  
                  split-type-2 'split-window-horizontally))
          (funcall split-3 1stBuf 2ndBuf 3rdBuf split-type-1 split-type-2) 

          ))))

;; +------------+-----------+                   +------------+-----------+
;; |            |     C     |            \      |            |     A     |
;; |            |           |    +-------+\     |            |           |
;; |     A      |-----------|    +-------+/     |     B      |-----------|
;; |            |     B     |            /      |            |     C     |
;; |            |           |                   |            |           |
;; +------------+-----------+                   +------------+-----------+

;; +------------------------+                   +------------------------+
;; |           A            |           \       |           B            |
;; |                        |   +-------+\      |                        |
;; +------------+-----------+   +-------+/      +------------+-----------+
;; |     B      |     C     |           /       |     C      |     A     |
;; |            |           |                   |            |           |
;; +------------+-----------+                   +------------+-----------+
(defun roll-v-3 (&optional arg) 
  "Rolling 3 window buffers (anti-)clockwise"
  (interactive "P") 
  (select-window (get-largest-window)) 
  (if (= 3 (length (window-list))) 
      (let ((winList (window-list))) 
        (let ((1stWin (car winList)) 
              (2ndWin (car (cdr winList))) 
              (3rdWin (car (last winList)))) 
          (let ((1stBuf (window-buffer 1stWin)) 
                (2ndBuf (window-buffer 2ndWin)) 
                (3rdBuf (window-buffer 3rdWin))) 
            (if arg (progn                                ; anti-clockwise
                      (set-window-buffer 1stWin 3rdBuf) 
                      (set-window-buffer 2ndWin 1stBuf) 
                      (set-window-buffer 3rdWin 2ndBuf)) 
              (progn                                      ; clockwise
                (set-window-buffer 1stWin 2ndBuf) 
                (set-window-buffer 2ndWin 3rdBuf) 
                (set-window-buffer 3rdWin 1stBuf)) 
              ))))))

;; すべてのバッファーリージョン選択状態を解除する
(defun clear-active-region-all-buffers ()
  "clear active region mark for all buffers."
  (interactive)
  (let ((current-buffer-name (buffer-name (current-buffer)))
        (clear-selected-region (lambda(local-buffer-name) 
                                 (switch-to-buffer local-buffer-name t)
                                       (setq mark-active nil) 
                                       ;; (message (concat "clear selected region of " local-buffer-name))
                                       )))
    (save-excursion
      (loop for buffer being the buffers
            do (progn 
                 (funcall clear-selected-region (buffer-name buffer))
                 )))
    (switch-to-buffer current-buffer-name t)
    (funcall clear-selected-region current-buffer-name)
    ))

(defun my-scroll-other-window (&optional ARG)
  "scroll other windows in inertias way when inertias mode is on"
  (interactive)
  (let ((ow (other-window-for-scrolling)))
    (if ow
        (if inertias-global-minor-mode
            (save-window-excursion
              (select-window ow)
              (if (eq 1 ARG)
                  (inertias-up)
                (inertias-down)))
          (scroll-other-window ARG))
      (message "There is no other window"))))

(provide 'my-window)
;;; my-window.el ends here

;;
;; kill-all-buffers
;;______________________________________________________________________

(defun kill-all-buffers ()
  (interactive)
  (loop for buffer being the buffers
        do (kill-buffer buffer)))

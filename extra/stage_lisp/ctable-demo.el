(defun ctbl:demo ()
  "Sample code for implementation for the table model."
  (interactive)
  (let ((param (copy-ctbl:param ctbl:default-rendering-param)))
    ;; rendering parameters
    (setf (ctbl:param-fixed-header param) t)
    (setf (ctbl:param-hline-colors param)
          '((0 . "#00000") (1 . "#909090") (-1 . "#ff0000") (t . "#00ff00")))
    (setf (ctbl:param-draw-hlines param)
          (lambda (model row-index)
            (cond ((memq row-index '(0 1 -1)) t)
                  (t (= 0 (% (1- row-index) 5))))))
    (setf (ctbl:param-bg-colors param)
          (lambda (model row-id col-id str)
            (cond ((string-match "CoCo" str) "LightPink")
                  ((= 0 (% (1- row-index) 2)) "Darkseagreen1")
                  (t nil))))
    (let ((cp
           (ctbl:create-table-component-buffer
            :width nil :height nil
            :model
            (make-ctbl:model
             :column-model
             (list (make-ctbl:cmodel
                    :title "A" :sorter 'ctbl:sort-number-lessp
                    :min-width 5 :align 'right)
                   (make-ctbl:cmodel
                    :title "Title" :align 'center
                    :sorter (lambda (a b) (ctbl:sort-number-lessp (length a) (length b))))
                   (make-ctbl:cmodel
                    :title "Comment" :align 'left))
             :data
             '((1  "Bon Tanaka" "8 Year Curry." 'a)
               (2  "Bon Tanaka" "Nan-ban Curry." 'b)
               (3  "Bon Tanaka" "Half Curry." 'c)
               (4  "Bon Tanaka" "Katsu Curry." 'd)
               (5  "Bon Tanaka" "Gyu-don." 'e)
               (6  "CoCo Ichi"  "Beaf Curry." 'f)
               (7  "CoCo Ichi"  "Poke Curry." 'g)
               (8  "CoCo Ichi"  "Yasai Curry." 'h)
               (9  "Berkley"    "Hamburger Curry." 'i)
               (10 "Berkley"    "Lunch set." 'j)
               (11 "Berkley"    "Coffee." k))
             :sort-state
             '(2 1)
             )
            :param param)))
      (ctbl:cp-add-click-hook 
       cp (lambda () (message "CTable : Click Hook [%S]" 
                              (ctbl:cp-get-selected-data-row cp))))
      (ctbl:cp-add-selection-change-hook cp (lambda () (message "CTable : Select Hook")))
      (ctbl:cp-add-update-hook cp (lambda () (message "CTable : Update Hook")))
      (switch-to-buffer (ctbl:cp-get-buffer cp)))))

(list (list (list '^o^)))

(let 
  ((anything-enable-shortcuts 'alphabet))
  (anything '(((name . "test")
               (candidates "foo" "bar" "baz")
               (action . message)))))

;; -------------------------- smartchr learning
(defun my-smartchr-setting ()
  (global-set-key (kbd "=") (smartchr '("=" " = " " == " "=")))
  ;;(global-set-key (kbd "{") (smartchr '("{ `!!' }" "{")))
  (global-set-key (kbd ">") (smartchr '(">" " => " " => '`!!''" " => \"`!!'\"")))
  (global-set-key (kbd "F") (smartchr '("F" "$" "$_" "$_->" "@$")))  
  (global-set-key (kbd "M") (smartchr '("M" "my $`!!' = " "my ($self, $`!!') = @_;" "my @`!!' = ")))
  (global-set-key (kbd "S") (smartchr '("S" perl-smartchr:sub "sub { `!!' }")))
  (global-set-key (kbd "j") (smartchr '("j" ik:insert-semicolon-eol)))
  )

(defun perl-smartchr:sub ()
 ""
 "sub `!!' {
    my ($self) = @_;

}")

(defun ik:insert-eol (s)
 (interactive)
 (lexical-let ((s s))
    (smartchr-make-struct
     :insert-fn (lambda ()
                 (save-excursion
                    (goto-char (point-at-eol))
                    (when (not (string= (char-to-string (preceding-char)) s))
                     (insert s))))
     :cleanup-fn (lambda ()
                 (save-excursion
                     (goto-char (point-at-eol))
                     (delete-backward-char (length s)))))))

(defun ik:insert-semicolon-eol ()
 (ik:insert-eol ";"))

(my-smartchr-setting)

(customize-set-value 'solarized-degrade t)
(customize-set-value 'solarized-bold nil)
(customize-set-value 'solarized-underline t)

;; --------------------------------- key-combo learning
(require 'key-combo)
(key-combo-define-global (kbd "=") '(" = " " == " " === " ))
(key-combo-define-global (kbd "=>") " => ")
(key-combo-define-global (kbd "=") '(self-insert-command . delete-backward-char))
(key-combo-define-global (kbd "==") '((lambda() (insert " = ")) .
                                      (lambda() (delete-backward-char 3))))
(key-combo-define-global (kbd "===") " == ")
(key-combo-define-global
 (kbd "=")
 '((self-insert-command . delete-backward-char)
   ((lambda() (insert " = ")) . (lambda() (delete-backward-char 3)))
   " == " ))

(key-combo-define-global (kbd "C-a")
'((back-to-indentation) (beginning-of-line) (beginning-of-buffer) (key-combo-return)))

(key-combo-define-global (kbd "C-e")
'((lambda () (end-of-line)) (lambda () (goto-char (point-max))) (lambda () (key-combo-return))))

;; -------------------------------------------popup.el learning
(defun popup-menu-ac-like (&rest arguments)
  (interactive)
  (push (car (rassoc 'popup-isearch popup-menu-keymap)) unread-command-events)
  (apply 'popup-menu* arguments))


(defun my-switch-to-buffer-popup ()
  (interactive)
  (switch-to-buffer
   (popup-menu-ac-like (mapcar 'buffer-name (buffer-list))
                       :scroll-bar t :margin t)))


(my-switch-to-buffer-popup)



(setq my-world (lookup-words "comm*" ispell-alternate-dictionary))


;; ----------------------------------------------------- isepll-complete-word

(defun my-ispell-complete-word (&optional interior-frag)
  "Try to complete the word before or under point (see `lookup-words').
If optional INTERIOR-FRAG is non-nil then the word may be a character
sequence inside of a word.
Standard ispell choices are then available."
  (interactive "P")
  (let ((cursor-location (point))
        (case-fold-search-val case-fold-search)
        (word (ispell-get-word nil "\\*")) ; force "previous-word" processing.
        start end possibilities replacement)
    (setq start (car (cdr word))
          end (car (cdr (cdr word)))
          word (car word)
          possibilities
          (or (string= word "")		; Will give you every word
              (lookup-words (concat (and interior-frag "*") word
                                    (if (or interior-frag (null ispell-look-p))
                                        "*"))
                            (or ispell-complete-word-dict
                                ispell-alternate-dictionary))))

    (cond ((eq possibilities t)
           (message "No word to complete"))
          ((null possibilities)
           (message "No match for \"%s\"" word))
          (t				; There is a modification...
           (setq case-fold-search nil)	; Try and respect case of word.
           (cond
            ((string-equal (upcase word) word)
             (setq possibilities (mapcar 'upcase possibilities)))
            ((eq (upcase (aref word 0)) (aref word 0))
             (setq possibilities (mapcar (function
                                          (lambda (pos)
                                            (if (eq (aref word 0) (aref pos 0))
                                                pos
                                              (capitalize pos))))
                                         possibilities))))
           (setq case-fold-search case-fold-search-val)

           (setq replacement (popup-menu-ac-like possibilities :scroll-bar t :margin t))
           (if replacement		; REPLACEMENT WORD
               (progn
                 (delete-region start end)
                 (ispell-insert-word replacement)
                 ))))

    (ispell-pdict-save ispell-silently-savep)
    )
  )


(my-ispell-complete-word "commu*")

(define-key direx:direx-mode-map (kbd "z") 'direx:persistent-display-item)

(defun direx:persistent-display-item (&optional item)
  (interactive)
  (setq item (or item (direx:item-at-point!)))
  ;;(direx:generic-find-item item t)

  (let ((filename (direx:file-full-name (direx:item-tree item))))
    (message filename)
    (save-selected-window
      ;;(open-file )
       (switch-to-buffer-other-window "init_anything.el")
       )
       ;;(find-file filename)
     )
    )

(defmethod direx:generic-find-item ((item direx:regular-file-item) not-this-window)
  (let ((filename (direx:file-full-name (direx:item-tree item))))
    (save-selected-window
      ;;(switch-to-buffer-other-window "filename"))
      (find-file filename)
    ;; (if not-this-window
    ;;     (find-file-other-window filename)
    ;;   (find-file filename))
    )))

(setq-default mode-line-format
              '("%e"
               (:eval
                (if
                    (display-graphic-p)
                    #(" " 0 1
                      (help-echo "mouse-1: Select (drag to resize)\nmouse-2: Make current window occupy the whole frame\nmouse-3: Remove current window from display"))
                  #("-" 0 1
                    (help-echo "mouse-1: Select (drag to resize)\nmouse-2: Make current window occupy the whole frame\nmouse-3: Remove current window from display"))))
               mode-line-mule-info mode-line-client mode-line-modified mode-line-remote mode-line-frame-identification mode-line-buffer-identification
               #("   " 0 3
                 (help-echo "mouse-1: Select (drag to resize)\nmouse-2: Make current window occupy the whole frame\nmouse-3: Remove current window from display"))
               mode-line-position
               (:eval smartrep-mode-line-string)
               (vc-mode vc-mode)
               #("  " 0 2
                 (help-echo "mouse-1: Select (drag to resize)\nmouse-2: Make current window occupy the whole frame\nmouse-3: Remove current window from display"))
               mode-line-modes
               (which-func-mode
                ("" which-func-format
                 #(" " 0 1
                   (help-echo "mouse-1: Select (drag to resize)\nmouse-2: Make current window occupy the whole frame\nmouse-3: Remove current window from display"))))
               (global-mode-string
                ("" global-mode-string
                 #(" " 0 1
                   (help-echo "mouse-1: Select (drag to resize)\nmouse-2: Make current window occupy the whole frame\nmouse-3: Remove current window from display"))))
               (:eval
                (unless
                    (display-graphic-p)
                  #("-%-" 0 3
                    (help-echo "mouse-1: Select (drag to resize)\nmouse-2: Make current window occupy the whole frame\nmouse-3: Remove current window from display"))))))


(make-local-variable 'mode-line-format)
(setq mode-line-format
              '("%e"
                (:eval
                 (let* ((active (powerline-selected-window-active))
                        (face1 (if active 'powerline-active1
                                 'powerline-inactive1))
                        (face2 (if active 'powerline-active2
                                 'powerline-inactive2))
                        (lhs (list
                              (powerline-raw win:mode-string nil 'l)
                              (powerline-arrow-right nil face1)

                              (powerline-raw "%*" face1 'l)
                              (powerline-raw "%z" face1 'l)
                              (powerline-buffer-size face1 'l)
                              ;; (powerline-buffer-id face1 'l)

                              (powerline-arrow-right face1 nil)

                              (when (boundp 'erc-modified-channels-object)
                                (powerline-raw erc-modified-channels-object
                                               face1 'l))

                              (powerline-major-mode nil 'l)
                              (powerline-process nil)
                              (powerline-minor-modes nil 'l)
                              (powerline-narrow nil 'l)

                              (powerline-raw " " nil)
                              (powerline-arrow-right nil face2)

                              (powerline-vc face2)))
                        (rhs (list
                              (powerline-raw global-mode-string face2 'r)

                              (powerline-arrow-left face2 face1)

                              (powerline-raw "%4l" face1 'r)
                              (powerline-raw ":" face1)
                              (powerline-raw "%3c" face1 'r)

                              (powerline-arrow-left face1 nil)
                              (powerline-raw " ")

                              (powerline-raw "%6p" nil 'r)

                              (powerline-hud face2 face1))))
                   (concat
                    (powerline-render lhs)
                    (powerline-fill face2 (powerline-width rhs))
                    (powerline-render rhs))))))

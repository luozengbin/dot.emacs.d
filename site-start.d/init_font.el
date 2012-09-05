;;; Commentary:

;; 作業環境よりフォントの切り替えを自動化する

;;; Code:

(message "init_font ...")

(require 'my-windows-os)

;;
;; font-setting
;;______________________________________________________________________
(let ((my-font-style (cond (mac-p "monacokakumaru")
                           (windows-p "consolastakao")
                           (linux-p ;;"monacokakumaru"
                                    "ricty"))))

;;; -------------- for mac
  ;; ヒラギノ丸ゴ ProN + Monaco
  (when (equal my-font-style "monacokakumaru")
    ;; 英数字フォント
    (set-face-attribute 'default nil :family "Monaco" :height 140)
    ;; 中国語繁体フォント
    (set-fontset-font nil 'chinese-big5-1 (font-spec    :family "儷黑 Pro"))
    (set-fontset-font nil 'chinese-big5-2 (font-spec    :family "儷黑 Pro"))
    ;; 中国語簡体フォント
    (set-fontset-font nil 'chinese-gb2312 (font-spec    :family "Hiragino Sans GB"))
    ;; 日本語漢字 → Hiragino MaruGothic Pro
    (set-fontset-font nil 'japanese-jisx0208 (font-spec :family "ヒラギノ丸ゴ Pro"))
    ;; 幅調調整
    (setq face-font-rescale-alist '(
                                    (".*Monaco.*"   . 1.0)
                                    (".*Hiragino.*" . 1.2)
                                    (".*LiHei.*"    . 1.2)
                                    ("-cdac$"       . 1.3)
                                    ))
    )

;;; -------------- for windows
  ;; Consolas + Takaoゴシック フォントスタイル
  ;; Takaoフォント：https://code.launchpad.net/takao-fonts/+download
  ;; Consolasフォント：http://www.microsoft.com/download/en/details.aspx?displaylang=en&id=17879
  (when (equal my-font-style "consolastakao")
    ;; 英数字フォント → Consolas
    (if (is-windows-xp)
        (set-face-attribute 'default nil :family "Consolas" :height 110)
      (set-face-attribute 'default nil :family "Consolas"))

    ;; 中国語繁体フォント
    (set-fontset-font nil 'chinese-big5-1 (font-spec    :family "Microsoft JhengHei"))
    (set-fontset-font nil 'chinese-big5-2 (font-spec    :family "Microsoft JhengHei"))
    ;; 中国語簡体フォント
    (set-fontset-font nil 'chinese-gb2312 (font-spec    :family "Microsoft Yahei"))

    ;; 日本語漢字 → Takaoゴシック
    (set-fontset-font nil 'japanese-jisx0208 (font-spec :family "Takaoゴシック"))
    ;;(set-fontset-font nil 'japanese-jisx0208 (font-spec :family "メイリオ"))

    ;; ;; 幅調調整
    ;; (setq face-font-rescale-alist '(
    ;;                                 (".*Consolas.*"           . 1.0)
    ;;                                 (".*メイリオ.*" . 1.1)
    ;;                                 ;;(".*MeiryoKe.*"           . 1.2)
    ;;                                 (".*Microsoft JhengHei.*" . 1.1)
    ;;                                 (".*Microsoft Yahei.*"    . 1.1)
    ;;                                 ("-cdac$"                 . 1.3)
    ;;                                 ))
    )

;;; -------------- for linux
  (when (equal my-font-style "ricty")
    (add-to-list 'default-frame-alist '(font . "ricty-13.5")))

  ;; ヒラギノ丸ゴ ProN + Menlo
  (when (equal my-font-style "menlokakumaru")
    (create-fontset-from-ascii-font "Menlo-14:weight=normal:slant=normal" nil "menlokakumaru")
    (set-fontset-font "fontset-menlokakumaru" 'unicode (font-spec :family "Hiragino Kaku Gothic ProN" ) nil 'append)
    (add-to-list 'default-frame-alist '(font . "fontset-menlokakumaru"))
    (setq face-font-rescale-alist '((".*Hiragino.*" . 1.2) (".*Menlo.*" . 1.0)))
    )


  ;; セプテンバー + Monaco
  (when (equal my-font-style "monacosept")
    (create-fontset-from-ascii-font "Monaco-15:weight=normal:slant=normal" nil "monacosept")
    (set-fontset-font "fontset-monacosept" 'unicode (font-spec :family "September" ) nil 'append)
    (add-to-list 'default-frame-alist '(font . "fontset-monacosept"))
    (setq face-font-rescale-alist '((".*September.*" . 1.2) (".*Monaco.*" . 1.0)))
    )


  ;; M+2VM+IPAG circle フォントスタイル
  (when (equal my-font-style "M+2VM+IPAG_Circle")
    (set-face-attribute 'default nil
                        :family "M+2VM+IPAG circle"
                        :height 160)
    (set-fontset-font (frame-parameter nil 'font) 'japanese-jisx0208 '("M+2VM+IPAG circle" . "iso10646-1"))
    (set-fontset-font (frame-parameter nil 'font) 'japanese-jisx0212 '("M+2VM+IPAG circle" . "iso10646-1"))
    (set-fontset-font (frame-parameter nil 'font) 'mule-unicode-0100-24ff '("M+2VM+IPAG circle" . "iso10646-1"))
    (setq face-font-rescale-alist
          '(("^-apple-hiragino.*"               . 1.3)
            (".*osaka-bold.*"                   . 1.2)
            (".*osaka-medium.*"                 . 1.2)
            (".*courier-bold-.*-mac-roman"      . 1.0)
            (".*monaco cy-bold-.*-mac-cyrillic" . 0.9)
            (".*monaco-bold-.*-mac-roman"       . 0.9)
            ("-cdac$"                           . 1.3)))

    )

  ;; Consolas + MeiryoKe Gothic
  ;; download from: http://okrchicagob.blog4.fc2.com/blog-entry-169.html
  (when (equal my-font-style "consolasMeiryo")
    (if (is-windows-xp)
        (set-face-attribute 'default nil :family "Consolas" :height 110)
      (set-face-attribute 'default nil :family "Consolas"))

  (dolist (target '(japanese-jisx0212
                      japanese-jisx0213-2
                      japanese-jisx0213.2004-1
                      katakana-jisx0201
                      ))
      (set-fontset-font (frame-parameter nil 'font)
                        target
                        (font-spec :family "MeiryoKe_Gothic" :registry "unicode-bmp" :lang 'ja)))
    ))

;; 古代ギリシア文字、コプト文字を表示したい場合は以下のフォントをインストールする
;; http://apagreekkeys.org/NAUdownload.html
(set-fontset-font nil 'greek-iso8859-7 (font-spec :family "New Athena Unicode") nil 'prepend)

(provide 'init_font)
;;; init_font.el ends here

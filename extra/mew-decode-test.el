
;; (require 'un-define)
;; (require 'jisx0213)

;; (add-hook 'mew-init-hook
;;           '(lambda ()
;;              (nconc mew-cs-database
;;                     '(("utf-8"
;;                        (ascii
;;                         latin-iso8859-1 latin-iso8859-2
;;                         latin-iso8859-3 latin-iso8859-4
;;                         cyrillic-iso8859-5
;;                         greek-iso8859-7
;;                         hebrew-iso8859-8
;;                         latin-iso8859-9
;;                         japanese-jisx0208 japanese-jisx0212
;;                         chinese-cns11643-1 chinese-cns11643-2
;;                         chinese-cns11643-3 chinese-gb2312
;;                         korean-ksc5601 katakana-jisx0201
;;                         latin-jisx0201)
;;                        utf-8 "quoted-printable"
;;                        utf-8 "Q")))))

;; (defvar mew-cs-database-for-encoding
;;   `(((ascii)                    nil         "7bit"             "7bit" nil)
;;     ;; West European (Latin 1)
;;     ((ascii latin-iso8859-1)    iso-8859-1  "quoted-printable" "Q" nil)
;;     ;; East European (Latin 2)
;;     ((ascii latin-iso8859-2)    iso-8859-2  "quoted-printable" "Q" nil)
;;     ;; South European (Latin 3)
;;     ((ascii latin-iso8859-3)    iso-8859-3  "quoted-printable" "Q" nil)
;;     ;; North European (Latin 4)
;;     ((ascii latin-iso8859-4)    iso-8859-4  "quoted-printable" "Q" nil)
;;     ;; Cyrillic
;;     ((ascii cyrillic-iso8859-5) koi8-r      "quoted-printable" "Q" nil)
;;     ;; Arabic
;;     ((ascii arabic-iso8859-6)   iso-8859-6  "base64"           "B" t)
;;     ;; Greek
;;     ((ascii greek-iso8859-7)    iso-8859-7  "base64"           "B" t)
;;     ;; Hebrew
;;     ((ascii hebrew-iso8859-8)   iso-8859-8  "base64"           "B" t)
;;     ;; Turkish (Latin 5)
;;     ((ascii latin-iso8859-9)    iso-8859-9  "quoted-printable" "Q" nil)
;;     ;; Celtic (Latin 8)
;;     ((ascii latin-iso8859-14)   iso-8859-14 "quoted-printable" "Q" nil) ;; xxx
;;     ;; New West European (Latin 9 or Latin 0)
;;     ((ascii latin-iso8859-15)   iso-8859-15 "quoted-printable" "Q" nil)
;;     ((ascii thai-tis620)        tis-620     "base64"           "B" t)
;;     ((ascii latin-jisx0201 japanese-jisx0208 japanese-jisx0208-1978)
;;      iso-2022-jp "7bit"             "B" t)
;;     ((ascii korean-ksc5601)     euc-kr     "8bit"             "B" t)
;;     ((ascii chinese-gbk)        gbk        "base64"           "B" t)
;;     ((ascii chinese-gb2312)     cn-gb-2312 "base64"           "B" t)
;;     ((ascii chinese-big5-1 chinese-big5-2)
;;      chinese-big5 "base64"           "B" t)
;;     ((ascii japanese-jisx0208 japanese-jisx0213-1 japanese-jisx0213-2)
;;      iso-2022-jp-3 "7bit"             "B" t)
;;     (nil utf-7 "7bit" "Q" t) ;; xxx
;;     (nil utf-8 ,mew-charset-utf-8-encoding ,mew-charset-utf-8-header-encoding t)
;;     (nil iso-2022-jp-2 "7bit" "B" t)))

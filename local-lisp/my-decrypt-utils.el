;;; my-decrypt-utils.el --- decrypt utils

;; Copyright (C) 2012  Zouhin.Ro

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

;; 

;;; Code:

(eval-when-compile
  (require 'epa nil t)
  (require 'alpaca nil t))

;; 復号化処理、暗号化されたファイルから複合化し、内容を戻る
(defun my-read-from-encrypted-file (file)
  "Decrypt contents from FILE and return them.
Read encrypted contents from FILE and return the decrypted contents.
This function requires `epa' or `alpaca' library."
  (cond
   ((not (file-readable-p file))
    (error "Failed to read %s" file)
    nil)
   ((require 'epa nil t)
    (let ((context (epg-make-context epa-protocol))
          ;; Bind `default-directory' to the temporary directory
          ;; because it is possible that the directory pointed by
          ;; `default-directory' has been already removed.
          (default-directory temporary-file-directory))
      (epg-context-set-passphrase-callback
       context #'epa-passphrase-callback-function)
      (epg-context-set-progress-callback
       context
       (cons #'epa-progress-callback-function
             (format "Decrypting %s..." (file-name-nondirectory file))))
      (message "Decrypting %s..." (file-name-nondirectory file))
      (condition-case err
          (let ((full-path (expand-file-name file)))
            ;; `epg-decrypt-file' included in EasyPG 1.0.0, which is
            ;; distributed with Emacs 23.2, requires the expanded full path
            ;; as the argument CIPHER. This is because CIPHER is directly
            ;; used as an argument of the command `gpg'.
            (epg-decrypt-file context full-path nil))
        (error
         (message "%s" (cdr err))
         nil))))
   ((require 'alpaca nil t)
    (with-temp-buffer
      (let ((buffer-file-name (expand-file-name file))
            (alpaca-regex-suffix ".*")
            (coding-system-for-read 'binary)
            (coding-system-for-write 'binary)
            (temp-buffer (current-buffer))
            ;; Bind `default-directory' to the temporary directory
            ;; because it is possible that the directory pointed by
            ;; `default-directory' has been already removed.
            (default-directory temporary-file-directory))
        (insert-file-contents-literally file)
        (set-buffer-modified-p nil)
        (condition-case nil
            (progn
              (alpaca-after-find-file)
              (if (eq temp-buffer (current-buffer))
                  (buffer-string)
                ;; `alpaca-after-find-file' kills the current buffer
                ;; if the decryption is failed.
                nil))
          (error
           (when (eq temp-buffer (current-buffer))
             (delete-region (point-min) (point-max)))
           nil)))))
   (t
    nil)))

;; 暗号化処理
;;  file: 暗号化ファイル保存先
;;  str:暗号化内容
(defun my-write-and-encrypt (file str)
  (cond
   ((require 'epg nil t)
    (let ((context (epg-make-context epa-protocol))
          ;; Bind `default-directory' to the temporary directory
          ;; because it is possible that the directory pointed by
          ;; `default-directory' has been already removed.
          (default-directory temporary-file-directory))
      (epg-context-set-passphrase-callback
       context #'epa-passphrase-callback-function)
      (epg-context-set-progress-callback
       context (cons #'epa-progress-callback-function "Encrypting..."))
      (message "Encrypting...")
      (condition-case err
          (unwind-protect
              ;; In order to prevent `epa-file' to encrypt the file double,
              ;; `epa-file-name-regexp' is temorarily changed into the null
              ;; regexp that never matches any string.
              (let ((epa-file-name-regexp "\\`\\'")
                    (coding-system-for-read 'binary)
                    (coding-system-for-write 'binary))
                (when (fboundp 'epa-file-name-regexp-update)
                  (epa-file-name-regexp-update))
                (with-temp-file file
                  (set-buffer-multibyte nil)
                  (delete-region (point-min) (point-max))
                  (insert (epg-encrypt-string context str nil))
                  (message "Encrypting...wrote %s" file)
                  t))
            (when (fboundp 'epa-file-name-regexp-update)
              (epa-file-name-regexp-update)))
        (error
         (message "%s" (cdr err))
         nil))))
   ((require 'alpaca nil t)
    ;; Create the file.
    ;; This is required because `alpaca-save-buffer' checks its timestamp.
    (with-temp-file file)
    (with-temp-buffer
      (let ((buffer-file-name file)
            (coding-system-for-read 'binary)
            (coding-system-for-write 'binary)
            ;; Bind `default-directory' to the temporary directory
            ;; because it is possible that the directory pointed by
            ;; `default-directory' has been already removed.
            (default-directory temporary-file-directory))
        (insert str)
        (condition-case nil
            (if (alpaca-save-buffer)
                t
              (delete-file file)
              nil)
          (error
           (when (file-exists-p file)
             (delete-file file))
           nil)))))
   (t
    nil)))

;;; ---------------- test code
;; (my-write-and-encrypt (expand-file-name "~/.emacs.d/work/encrypt-test.gpg") "hello world!!!")
;; (message (my-read-from-encrypted-file (expand-file-name "~/.emacs.d/work/encrypt-test.gpg")))

(provide 'my-decrypt-utils)
;;; my-decrypt-utils.el ends here

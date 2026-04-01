;;; early-init.el --- A home-manager Emacs configuration -*- lexical-binding: t; -*-
;;
;;; Commentary:
;;
;; The early init component of home-manager Emacs configuration.
;;
;;; Code:

;; Set high GC limits on startup.
;; The init.el file will set a dynamic GC strategy.
(setq gc-cons-threshold (* 256 1024 1024)
      gc-cons-percentage 0.8)

;; Avoid unnecessary regexp matching while loading .el files.
(defvar dmd/file-name-handler-alist file-name-handler-alist)
(setq file-name-handler-alist nil)

(defun dmd/restore-file-name-handler-alist ()
  "Restore `file-name-handler-alist` variable."
  (setq file-name-handler-alist dmd/file-name-handler-alist)
  (makunbound 'dmd/file-name-handler-alist))

(add-hook 'emacs-startup-hook #'dmd/restore-file-name-handler-alist)

;; Avoid frame resizing, which can be expensive.
(setq frame-inhibit-implied-resize t)

;; Unnecessary.
(setq-default inhibit-startup-screen t
              ihhibit-startup-echo-area-message (user-login-name)
              inhibit-scratch-message nil)

;; Disable any GUI distraction.
(push '(menu-bar-lines . 0) default-frame-alist)
(push '(tool-bar-lines . nil) default-frame-alist)
(push '(vertical-scroll-bars . nil) default-frame-alist)

(provide 'early-init)
;;; early-init.el ends here

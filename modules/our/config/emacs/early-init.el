;;; early-init.el --- -*- lexical-binding: t; -*-
;;; Commentary:
;;; Code:

(defvar inhibit-scratch-message)
(setq frame-inhibit-implied-resize t
      inhibit-startup-screen t
      inhibit-startup-buffer-menu t
      inhibit-splash-screen t
      inhibit-x-resources t
      inhibit-startup-echo-area-message user-login-name
      inhibit-scratch-message nil)

;; Make `lsp-mode' be compiled in `plist' mode.  This provides better
;; performance than the alternative `hash-table' compilation mode.
;; (setenv "LSP_USE_PLISTS" "true")

;; Disable GUI elements.
(menu-bar-mode -1)
(mouse-wheel-mode -1)
(scroll-bar-mode -1)
(tool-bar-mode -1)

;; Seen it before.
(defalias 'view-emacs-news 'ignore)
(defalias 'describe-gnu-project 'ignore)

;; Temporarily increase the garbage collection threshold. It is belligerent to
;; set the threshold to `most-positive-fixnum' but you only YOLO once.  It's
;; set to something safe in the `after-init-hook' at the bottom, or on loading
;; the gcmh package (used to set a dynamic GC strategy).
(setq gc-cons-threshold most-positive-fixnum
      gc-cons-percentage 0.5)

;; Similar--disable things that are unnecessary during startup and replace them
;; in a hook.
;; For instance when loading files, if `file-name-handler-alist' were not
;; disabled, the filename would be checked against each regex-filehandler in the
;; alist to see if it can use a special handler, which is not applicable in this
;; case.
(defvar dmd/file-name-handler-alist file-name-handler-alist)
(defvar dmd/vc-handled-backends vc-handled-backends)

(setq file-name-handler-alist nil
      vc-handled-backends nil)

(add-hook 'after-init-hook
          (lambda ()
            (setq gc-cons-threshold (* 1024 1024 20)
                  gc-cons-percentage 0.2
                  file-name-handler-alist dmd/file-name-handler-alist
                  vc-handled-backends dmd/vc-handled-backends)))

(provide 'early-init)
;;; early-init.el ends here

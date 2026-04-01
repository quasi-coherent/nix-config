;;; default.el --- Emacs configuration for VISUAL  -*- lexical-binding: t; -*-
;;
;;; Commentary:
;;
;; Minimal configuration for Emacs.
;;
;;; Code:
(eval-when-compile
  (require 'use-package)
  (setq use-package-verbose nil))

(use-package move-text :ensure t)

(use-package multiple-cursors
  :ensure t
  :bind
  (("M-n" . mc/mark-next-like-this)
   ("M-p" . mc/mark-previous-like-this)
   ("M-s m n" . mc/skip-to-next-like-this)
   ("M-s m p" . mc/skip-to-previous-like-this)
   ("M-s m N" . mc/unmark-next-like-this)
   ("M-s m P" . mc/unmark-previous-like-this)
   ("M-s m a" . mc/mark-all-like-this)
   ("M-s m r" . mc/mark-all-in-region))
  :config
  (setq mc/always-run-for-all t
        mc/cmds-to-run-once nil))

(provide 'default)
;;; default.el ends here

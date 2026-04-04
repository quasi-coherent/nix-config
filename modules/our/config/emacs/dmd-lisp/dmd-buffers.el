;;; dmd-buffers.el --- -*- lexical-binding: t; -*-
;;; Commentary:
;;; Code:

(declare-function global-undo-tree-mode "undo-tree")
(declare-function smartparens-global-mode "smartparens")
(declare-function show-smartparens-global-mode "smartparens")
(declare-function move-text-default-bindings "move-text")

(require 'use-package)

(use-package undo-tree
  :init (global-undo-tree-mode 1)
  :bind ("C-c _" . undo-tree-visualize)
  :config
  (unbind-key "M-_" undo-tree-map)
  (setq undo-tree-auto-save-history nil
        undo-tree-history-directory-alist `((".*" . ,temporary-file-directory))))

;; For balancing pairs of characters automatically.
(use-package smartparens
  :diminish
  :config
  (require 'smartparens-config)
  (smartparens-global-mode 1)
  (show-smartparens-global-mode 1))

;; Jump to other visible buffer.
(use-package ace-window
  :bind ("C-x o" . ace-window)
  :config
  (setq aw-keys '(?a ?s ?d ?f ?g ?h ?j ?k ?l)))

(use-package avy
  :bind ("C-c j" . avy-goto-word-or-subword-2)
  :config
  (setq avy-all-windows t))

;; Expand a selection intelligently according to syntax.
(use-package expand-region)

;; Move a line or region up or down n lines with "M-<up>/<down>".
(use-package move-text :config (move-text-default-bindings))

;; MVP
(use-package multiple-cursors
  :bind (("M-n" . mc/mark-next-like-this)
         ("M-p" . mc/mark-previous-like-this)
         ("M-s n" . mc/skip-to-next-like-this)
         ("M-s p" . mc/skip-to-previous-like-this)
         ("M-s N" . mc/unmark-next-like-this)
         ("M-s P" . mc/unmark-previous-like-this)
         ("M-s a" . mc/mark-all-like-this)
         ("M-s r" . mc/mark-all-in-region))
  :config
  (setq mc/always-run-for-all t
        mc/cmds-to-run-once nil))

(provide 'dmd-buffers)
;;; dmd-buffers.el ends here

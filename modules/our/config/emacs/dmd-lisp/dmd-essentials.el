;;; dmd-essentials.el --- -*- lexical-binding: t; -*-
;;; Commentary:
;;; Code:

(declare-function global-undo-tree-mode "undo-tree")
(declare-function smartparens-global-mode "smartparens")
(declare-function show-smartparens-global-mode "smartparens")
(declare-function move-text-default-bindings "move-text")
(declare-function no-littering-theme-backups "no-littering")

(require 'use-package)

;; Kitty keyboard protocol to work within tmux.  Responds to extended key
;; sequences.  TODO: It doesn't do a good job sometimes...  Figure out which
;; thing or things in alacritty -> tmux -> emacs is still missing something.
(use-package kkp
  :hook
  (tty-setup . global-kkp-mode)
  :config
  (require 'kkp-debug))

(use-package no-littering
  :init (no-littering-theme-backups))

;; Persist history over restarts.
(use-package savehist
  :init
  (savehist-mode)
  :config
  (setq savehist-file (locate-user-emacs-file "savehist")
	history-length 1000
	savehist-save-minibuffer-history t
	savehist-additional-variables '(register-alist kill-ring)))

(use-package undo-tree
  :init
  (global-undo-tree-mode 1)
  (setq undo-tree-auto-save-history nil)
  :bind
  ("C-c _" . undo-tree-visualize)
  :config
  (unbind-key "M-_" undo-tree-map))

;; A helpful package.
(use-package helpful
  :diminish
  :bind
  (("C-h f" . helpful-callable)
   ("C-h v" . helpful-variable)
   ("C-h k" . helpful-key)
   ("C-h L" . helpful-at-point)
   ("C-h F" . helpful-function)
   ("C-h C" . helpful-command)))

;; Shows keys that can complete the current sequence.
(use-package which-key
  :diminish
  :functions
  (which-key-mode which-key-add-major-mode-key-based-replacements)
  :config
  (which-key-mode))

;; Jump to other visible buffer.
(use-package ace-window
  :bind ("C-x o" . ace-window)
  :config
  (setq aw-keys '(?a ?s ?d ?f ?g ?h ?j ?k ?l)))

;; For balancing pairs of characters automatically.
(use-package smartparens
  :diminish
  :config
  (require 'smartparens-config)
  (smartparens-global-mode 1)
  (show-smartparens-global-mode 1))

(use-package avy
  :init
  (global-set-key (kbd "C-c j") 'avy-goto-char-1)
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
         ("M-s A" . mc/mark-all-like-this)
         ("M-s R" . mc/mark-all-in-region))
  :config
  (setq mc/always-run-for-all t
        mc/cmds-to-run-once nil))

(provide 'dmd-essentials)
;;; dmd-essentials.el ends here

;;; init.el --- A home-manager Emacs configuration  -*- lexical-binding: t; -*-
;;
;;; Commentary:
;;
;; Main configuration for Emacs via home-manager/emacs-overlays.
;;
;;; Code:

;;;; * Variable init.

;; Set together with `alwaysEnsure = true' in ./default.nix.
;; Otherwise emacs-overlays will not correctly download packages.
;; Alternatively, remove both and write `:ensure t' on every use-package
;; invocation.
(setq-default use-package-always-ensure t)

(setq-default make-backup-files nil
              create-lockfiles nil
              auto-save-default nil
              backup-directory-alist `((".*" . ,temporary-file-directory))
              auto-save-file-name-transforms `((".*" ,temporary-file-directory t))
              cursor-in-non-selected-windows nil
              display-time-default-load-average 5
              mouse-wheel-mode -1
              history-length 1000
              kill-ring-max 64
              mark-ring-max 64
              confirm-nonexistent-file-or-buffer t
              confirm-kill-processes nil
              load-prefer-newer t
              view-read-only t
              scroll-conservatively most-positive-fixnum
              compilation-scroll-output 'first-error
              ad-redefinition-action 'accept
              read-extended-command-predicate #'command-completion-default-include-p
              fill-column 80
              show-trailing-whitespace t
              indent-tabs-mode nil)

;; I’ve accidentally activated these more times than I’ve thought about
;; intentionally doing that, which is 0 times.
(defalias 'view-emacs-news 'ignore)
(defalias 'describe-gnu-project 'ignore)

;; Global settings/modes.
(global-display-line-numbers-mode 1)
(global-hl-line-mode t)
(global-auto-revert-mode t)
(delete-selection-mode 1)
(column-number-mode 1)
(show-paren-mode 1)
(winner-mode 1)

;; Global hooks.
(add-hook 'before-save-hook #'delete-trailing-whitespace)
(add-hook 'minibuffer-setup-hook
          (lambda ()
            (make-local-variable 'kill-ring)))

;; Global keybindings.
(global-set-key (kbd "C-x C-b") #'ibuffer)
(global-set-key (kbd "C-<return>") #'toggle-frame-fullscreen)
(global-set-key (kbd "C-<backspace>")
                (lambda ()
                  (interactive)
                  (kill-line 0)
                  (indent-according-to-mode)))

;; Functions

(defun yes-or-no-p (prompt)
  "Accept y/n instead of yes/no with PROMPT."
  (y-or-n-p prompt))

(declare-function darkroom-mode "ext:darkroom")

(defun dmd/darkroom-mode ()
  "Toggle `darkroom-mode` on or off in the current buffer."
  (interactive)
  (cond ((bound-and-true-p darkroom-mode)
         (darkroom-mode -1)
         (display-line-numbers-mode 1))
        (t (darkroom-mode 1)
           (display-line-numbers-mode -1))))

(defun dmd/kill-other-buffers (&optional arg)
  "Kill buffers other than ARG if provided, `current-buffer' if not."
  (interactive "P")
  (when (yes-or-no-p (format "Kill all buffers except \"%s\"? " (buffer-name)))
    (mapc 'kill-buffer (delq (current-buffer) (buffer-list)))
    (when (equal '(4) arg) (delete-other-windows))))

(eval-when-compile
  (require 'use-package)
  (setq use-package-verbose nil))

;; For :diminish and :bind in (use-package).
(require 'diminish)
(require 'bind-key)

(autoload #'use-package-autoload-keymap "use-package-bind-key")

;;;; * General

(use-package ace-window
  :bind ("C-x o" . ace-window)
  :config
  (setq aw-keys '(?a ?s ?d ?f ?g ?h ?j ?k ?l)))

(use-package autorevert
  :bind ("C-x R" . revert-buffer)
  :diminish
  :config
  (setq auto-revert-verbose nil))

(use-package avy
  :bind ("C-c j" . avy-goto-word-or-subword-1)
  :config
  (setq avy-all-windows t))

;; Remove borders, gutter, modeline, etc.
(use-package darkroom :config (setq darkroom-margins 0.99))
(use-package direnv :config (direnv-mode t))

(use-package doom-modeline
  :config
  (doom-modeline-mode 1)
  (setq doom-modeline-buffer-file-name-style 'relative-from-project
        doom-modeline-icon nil
        doom-modeline-major-mode-icon nil))


(use-package envrc
  :defer 1
  :hook (after-init . envrc-global-mode)
  :config (envrc-global-mode))

(use-package expand-region :bind ("C-@" . er/expand-region))

;; Set a GC strategy that will garbage collect more eagerly when idle.
(use-package gcmh
  :config
  (setopt gcmh-high-cons-threshold (* 256 1024 1024))
  (setopt gcmh-low-cons-threshold (* 16 1024 1024))
  (setopt gcmh-idle-delay 3)
  (setopt gc-cons-percentage 0.2)
  (add-hook 'after-init-hook '#gcmh-mode))

(use-package git-gutter
  :config (global-git-gutter-mode 1))

(use-package hemisu-theme
  :config
  (load-theme 'hemisu-dark 1))

;; `M-<down>' and `M-<up>' for moving a line or region up/down a line.
(use-package move-text)

(use-package multiple-cursors
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

;; Save buffer history; vertico sorts by this.
(use-package savehist :init (savehist-mode))

(use-package smartparens
  :diminish
  :config
  (smartparens-global-mode 1)
  (show-smartparens-global-mode 1))

(require 'smartparens-config)

(use-package time
  :init (setq display-time-format "%F %T [%s]")
  :config (display-time))

(use-package undo-tree
  :config
  (global-undo-tree-mode 1)
  (setq undo-tree-auto-save-history)
  (setq undo-tree-history-directory-alist
        '(("." . "~/.local/state/emacs/undo"))))

;; Used by orderless or consult or vertico or something.
(use-package wgrep)

(use-package which-key
  :diminish
  :functions
  (which-key-mode which-key-add-major-mode-key-based-replacements)
  :config
  (which-key-mode))

;;; * Vertico ecosystem

;; Company global completion backend.
(use-package company :config (global-company-mode 1))

(use-package consult
  :bind
  (("C-s" . consult-line)
   ("C-t" . consult-goto-line)
   ("C-x b" . consult-buffer)
   ("M-g f" . consult-flycheck)
   ("M-g i" . consult-imenu)
   ("M-s L" . consult-line-multi)
   ("M-s f" . consult-fd)
   ("M-s g" . consult-git-grep)
   ("M-s r" . consult-ripgrep)
   (:map minibuffer-local-map
         ("M-r" . consult-history)
         ("M-s" . consult-history)))
  :config
  (setq consult-narrow-key "<"))

(use-package consult-yasnippet)

;; I don't remember what this was for.
;; (defvar dmd/consult-line-map
;;   (let ((map (make-sparse-keymap)))
;;     (define-key map "\C-s" #'vertico-next)
;;     map))

(use-package embark
  :bind
  (("C-." embark-act)
   ("M-." embark-dwim)))

(use-package embark-consult)

(use-package marginalia
  :bind (:map minibuffer-local-map
              ("M-A" . marginalia-cycle))
  :init
  (marginalia-mode))

(use-package orderless
  :init
  (setq completion-styles '(orderless basic)
        completion-category-defaults nil
        completion-category-overrides '((file (styles partial-completion)))))

(use-package vertico
  :config (vertico-mode)
  :custom
  (vertico-count 20)
  (vertico-resize t)
  (vertico-cycle t)
  (enable-recursive-minibuffers t))

(use-package vertico-directory
  :after (vertico)
  :bind
  (:map vertico-map
        ("RET" . vertico-directory-enter)
        ("DEL" . vertico-directory-delete-char)
        ("M-DEL" . vertico-directory-delete-word)))

;;;; * Language servers

;; Wraps eglot with `emacs-lsp-booster'.
(use-package eglot-booster
  :after eglot
  :config (eglot-booster-mode))

;; Use whatever-ts-mode instead of whatever-mode with less pain.
(use-package treesit-auto
  :config
  (treesit-auto-add-to-auto-mode-alist 'all)
  (global-treesit-auto-mode))

(use-package bash-ts-mode :hook (bash-ts-mode . eglot-ensure))
(use-package c++-ts-mode :hook (c++-ts-mode . eglot-ensure))
(use-package dhall-ts-mode)
(use-package dockerfile-ts-mode :hook (dockerfile-ts-mode . eglot-ensure))
(use-package nael :init (add-hook 'lean4-mode-hook 'eglot-ensure))
(use-package go-ts-mode :hook (go-ts-mode . eglot-ensure))
(use-package haskell-ts-mode :hook (haskell-ts-mode . eglot-ensure))
(use-package java-ts-mode :hook (java-ts-mode . eglot-ensure))
(use-package justl-mode)
(use-package just-ts-mode :hook (just-ts-mode . eglot-ensure))
(use-package lean4-mode :hook (lean4-mode . eglot-ensure))
(use-package markdown-ts-mode :hook (markdown-ts-mode . eglot-ensure))
(use-package nix-ts-mode :hook (nix-ts-mode . eglot-ensure))
(use-package ocaml-ts-mode :hook (ocaml-ts-mode . eglot-ensure))
(use-package python-ts-mode :hook (python-ts-mode . eglot-ensure))
(use-package rust-ts-mode :hook (rust-ts-mode . eglot-ensure))
(use-package scala-ts-mode :hook (scala-ts-mode . eglot-ensure))
(use-package terraform-ts-mode)
(use-package typescript-ts-mode :hook (typescript-ts-mode . eglot-ensure))
(use-package yaml-ts-mode :hook (yaml-ts-mode . eglot-ensure))

(provide 'init)
;;; init.el ends here

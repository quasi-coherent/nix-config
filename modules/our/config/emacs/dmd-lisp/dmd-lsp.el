;;; dmd-lsp.el --- -*- lexical-binding: t; -*-
;;; Commentary:
;;; Code:

(require 'dmd-lib)
(require 'flycheck)
(require 'use-package)

(declare-function lsp-enable-which-key-integration "lsp")
(declare-function treesit-auto-add-to-auto-mode-alist "treesit-auto")
(declare-function global-treesit-auto-mode "treesit-auto")

(defvar lsp-modeline-diagnostics-scope)
(defvar lsp-headerline-breadcrumb-segments)
(defvar lsp-modeline-code-actions-mode)
(defvar lsp-nix-nixd-formatting-command)

(use-package lsp-mode
  :commands lsp lsp-deferred
  :init
  (setq lsp-keymap-prefix "C-c C-l")
  :custom
  (lsp-diagnostics-provider :flycheck)
  (lsp-completion-provider :none)       ; Using corfu
  :config
  (define-key lsp-mode-map (kbd "C-c C-l") lsp-command-map)
  (setq lsp-headerline-breadcrumb-enable t
        lsp-headerline-breadcrumb-segments '(file symbols)
        flycheck-checker-error-threshold 1000
        lsp-idle-delay 0.5)
  :hook
  (lsp-mode . lsp-enable-which-key-integration))

(use-package lsp-ui
  :hook (lsp-mode . lsp-ui-mode)
  :config
  (setq lsp-ui-doc-enable t
        lsp-ui-doc-use-webkit t
        lsp-ui-sideline-show-hover t
        lsp-ui-sideline-enable nil
        lsp-modeline-code-actions-mode nil))

(use-package treesit-auto
  :config
  (setq treesit-font-lock-level 4)
  (treesit-auto-add-to-auto-mode-alist 'all)
  (global-treesit-auto-mode))

(use-package bash-ts-mode :hook (bash-ts-mode . lsp-deferred))
(use-package haskell-ts-mode :hook (haskell-ts-mode . lsp-deferred))
(use-package json-ts-mode :hook (json-ts-mode . lsp-deferred))
(use-package markdown-mode :hook (markdown-mode . lsp-deferred))

(use-package nix-ts-mode
  :hook
  (nix-ts-mode . lsp-deferred)
  :config
  (setq lsp-nix-nixd-formatting-command [ "nixfmt" ]))

(use-package rust-ts-mode
  :hook
  (rust-ts-mode . lsp-deferred))

(use-package toml-ts-mode :hook (toml-ts-mode . lsp-deferred))
(use-package yaml-ts-mode :hook (yaml-ts-mode . lsp-deferred))

(define-derived-mode helm-mode yaml-ts-mode "helm"
  "Major mode for editing kubernetes helm templates.")

(provide 'dmd-lsp)
;;; dmd-lsp.el ends here

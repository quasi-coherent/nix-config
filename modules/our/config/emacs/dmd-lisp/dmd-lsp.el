;;; dmd-lsp.el --- -*- lexical-binding: t; -*-
;;; Commentary:
;;; Code:

(require 'dmd-lib)
(require 'flycheck)
(require 'use-package)

(declare-function lsp-enable-which-key-integration "lsp")
(declare-function treesit-auto-add-to-auto-mode-alist "treesit-auto")
(declare-function global-treesit-auto-mode "treesit-auto")
(declare-function consult-lsp-symbols "consult-lsp")

(defvar lsp-modeline-diagnostics-scope)
(defvar lsp-headerline-breadcrumb-segments)
(defvar lsp-modeline-code-actions-mode)
(defvar lsp-nix-nixd-formatting-command)

(use-package flycheck
  :init
  (global-flycheck-mode)
  :config
  (setq flycheck-emacs-lisp-load-path 'inherit
        flycheck-check-syntax-automatically '(mode-enabled save)))

(use-package lsp-mode
  :commands lsp lsp-deferred
  :init
  (setq lsp-keymap-prefix "C-c l")
  :custom
  (lsp-diagnostics-provider :flycheck)
  (lsp-completion-provider :none)       ; Using corfu
  :config
  (define-key lsp-mode-map (kbd "C-c l") lsp-command-map)
  (setq lsp-headerline-breadcrumb-enable t
        lsp-headerline-breadcrumb-segments '(file symbols)
        lsp-modeline-diagnostics-scope :workspace
        flycheck-checker-error-threshold 1000
        lsp-idle-delay 0.5)
  :hook
  (lsp-mode . lsp-enable-which-key-integration))

(use-package lsp-ui
  :commands lsp-ui-mode
  :hook (lsp-mode . lsp-ui-mode)
  :config
  (setq lsp-ui-doc-enable t
        lsp-ui-doc-use-webkit t
        lsp-ui-peek-always-show t
        lsp-ui-sideline-show-hover t
        lsp-ui-sideline-enable nil
        lsp-modeline-code-actions-mode nil))

(use-package consult-flycheck)

(use-package consult-lsp
  :after lsp-mode
  :config
  (define-key lsp-mode-map [remap xref-find-apropos] #'consult-lsp-symbols)
  (setq completion-category-overrides
        '((consult-lsp-symbols (orderless))
          (consult-lsp-file-symbols (orderless)))))

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
  (rust-ts-mode . lsp-deferred)
  :custom
  (lsp-rust-analyzer-cargo-watch-command "check")
  (lsp-rust-analyzer-display-lifetime-elision-hints-enable "skip_trivial")
  (lsp-rust-analyzer-display-chaining-hints t)
  (lsp-rust-analyzer-display-lifetime-elision-hints-use-parameter-names nil)
  (lsp-rust-analyzer-display-closure-return-type-hints t)
  (lsp-rust-analyzer-display-parameter-hints nil))

(use-package toml-ts-mode :hook (toml-ts-mode . lsp-deferred))
(use-package yaml-ts-mode :hook (yaml-ts-mode . lsp-deferred))

(define-derived-mode helm-mode yaml-ts-mode "helm"
  "Major mode for editing kubernetes helm templates.")

(provide 'dmd-lsp)
;;; dmd-lsp.el ends here

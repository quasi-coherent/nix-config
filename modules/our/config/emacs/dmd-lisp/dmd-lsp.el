;;; dmd-lsp.el --- -*- lexical-binding: t; -*-
;;; Commentary:
;;; Code:

(require 'use-package)

(declare-function global-flycheck-mode "flycheck")
(declare-function flycheck-list-errors "flycheck")
(declare-function flycheck-next-error "flycheck")
(declare-function flycheck-previous-error "flycheck")
(declare-function lsp-enable-which-key-integration "lsp")
(declare-function treesit-auto-add-to-auto-mode-alist "treesit-auto")
(declare-function global-treesit-auto-mode "treesit-auto")
(defvar lsp-modeline-diagnostics-scope)

(use-package flycheck
  :diminish
  :init (global-flycheck-mode)
  :config
  (setq flycheck-check-syntax-automatically '(mode-enabled save)))

(use-package lsp-mode
  :commands (lsp lsp-deferred)
  :hook (lsp-mode . (lambda ()
                      (let ((lsp-keymap-prefix "C-c l"))
                        (lsp-enable-which-key-integration))))
  :init
  (setq lsp-keep-workspace-alive t
        lsp-signature-doc-lines 5
        lsp-idle-delay 0.5)
  :bind-keymap
  ("C-c l" . lsp-command-map)
  :bind
  (:map lsp-mode-map
               ("<tab>" . company-indent-or-complete-common))
  (:map lsp-command-map
        ("C-c l e l" . #'flycheck-list-errors)
        ("C-c l e n" . #'flycheck-next-error)
        ("C-c l e p" . #'flycheck-previous-error))
  :config
  (setq lsp-modeline-diagnostics-enable t
        lsp-modeline-diagnostics-scope :workspace))

(use-package lsp-ivy)

(use-package lsp-ui
  :config (setq lsp-ui-sideline-show-diagnostics t
                lsp-ui-sideline-show-code-actions nil
                lsp-ui-sideline-update-mode "line"
                lsp-ui-sideline-delay 0.5))

(use-package treesit-auto
  :config
  (setq treesit-font-lock-level 4)
  (treesit-auto-add-to-auto-mode-alist 'all)
  (global-treesit-auto-mode))

(use-package haskell-ts-mode
  :hook
  (haskell-ts-mode . lsp-deferred)
  (haskell-ts-mode . subword-mode))

(use-package lua-ts-mode :hook (lua-ts-mode . lsp-deferred))

(use-package markdown-mode :hook (markdown-mode . lsp-deferred))

(defvar lsp-nix-nixd-formatting-command)
(use-package nix-ts-mode
  :hook
  (nix-ts-mode . lsp-deferred)
  (nix-ts-mode . subword-mode)
  :config
  (setq lsp-nix-nixd-formatting-command [ "nixfmt" ]))

(use-package rust-ts-mode
  :hook
  (rust-ts-mode . lsp-deferred)
  (rust-ts-mode . subword-mode))

(use-package toml-ts-mode :hook (toml-ts-mode . lsp-deferred))
(use-package yaml-ts-mode :hook (yaml-ts-mode . lsp-deferred))

(define-derived-mode helm-mode yaml-ts-mode "helm"
  "Major mode for editing kubernetes helm templates.")

(require 'lsp-nix)

(provide 'dmd-lsp)
;;; dmd-lsp.el ends here

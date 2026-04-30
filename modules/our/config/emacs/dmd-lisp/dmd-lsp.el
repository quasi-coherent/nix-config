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
        flycheck-checker-error-threshold 1000
        flycheck-check-syntax-automatically '(mode-enabled save)))

(use-package cape
  :config
  ;; NB: First one returning wins, so order matters.
  ;;
  ;; Use ~add-hook~ because it sets the global (default) value of capf.
  ;; Using ~setq~ would be a mistake since that's buffer-local and capf is
  ;; already buffer-local.
  (add-hook 'completion-at-point-functions #'cape-history)
  (add-hook 'completion-at-point-functions #'cape-file)
  (add-hook 'completion-at-point-functions #'cape-keyword)
  (add-hook 'completion-at-point-functions #'cape-dabbrev))

(use-package lsp-mode
  :commands (lsp lsp-deferred)
  :custom
  (define-key lsp-mode-map (kbd "C-c l") lsp-command-map)
  (lsp-diagnostics-provider :flycheck)
  (lsp-modeline-diagnostics-scope :workspace)
  (lsp-completion-provider :none) ; Using corfu
  (lsp-enable-xref t)
  (lsp-headerline-breadcrumb-enable t)
  (lsp-headerline-breadcrumb-segments '(file symbols))
  (lsp-idle-delay 0.5)
  (lsp-before-save-edits nil)
  (lsp-log-io nil)
  (lsp-enable-links nil)
  (lsp-server-trace nil)
  (lsp-print-performance nil)
  (lsp-report-if-no-buffer nil)
  (lsp-keep-workspace-alive nil)
  (lsp-eldoc-render-all nil)
  :init
  (defun dmd/lsp-mode-completion-setup ()
    (setf (alist-get 'styles (alist-get 'lsp-capf completion-category-defaults)) '(orderless))
    (setq-local orderless-style-dispatchers (list #'dmd/orderless-flex-first-dispatch))
    (setq-local completion-at-point-functions (list (cape-capf-buster #'lsp-completion-at-point))))
  :bind-keymap ("C-c C-l" . lsp-command-map)
  :bind
  (:map lsp-command-map
        ("f f" . lsp-format-buffer))
  :hook
  (lsp-mode . (lambda ()
                (let ((lsp-keymap-prefix "C-c C-l"))
                  (lsp-enable-which-key-integration))))
  (lsp-completion-mode . dmd/lsp-mode-completion-setup))

(use-package lsp-ui
  :commands (lsp-ui-mode)
  :hook (lsp-mode . lsp-ui-mode)
  :custom
  (lsp-ui-doc-enable t)
  (lsp-ui-doc-use-webkit t)
  (lsp-ui-peek-enable t)
  (lsp-ui-peek-show-directory nil)
  (lsp-ui-doc-enable t)
  (lsp-ui-doc-position 'at-point)
  (lsp-ui-doc-delay 0.2))

(use-package consult-flycheck)

(use-package consult-lsp
  :after lsp-mode
  :config
  (define-key lsp-mode-map [remap xref-find-apropos] #'consult-lsp-symbols)
  :bind
  (:map lsp-command-map
        ("g e" . consult-lsp-diagnostics)
        ("g a" . consult-lsp-symbols)))

(use-package treesit-auto
  :config
  (setq treesit-font-lock-level 4)
  (treesit-auto-add-to-auto-mode-alist 'all)
  (global-treesit-auto-mode))

(use-package bash-ts-mode :hook (bash-ts-mode . lsp-deferred))
(use-package haskell-ts-mode :hook (haskell-ts-mode . lsp-deferred))
(use-package json-ts-mode :hook (json-ts-mode . lsp-deferred))

(use-package markdown-mode
  :hook (markdown-mode . lsp-deferred)
  :bind
  (:map markdown-mode-map
        ("M-h" . nil) ; Pretty bold of markdown-mode to set these
        ("M-n" . nil)
        ("M-p" . nil)))

(use-package nix-ts-mode
  :hook (nix-ts-mode . lsp-deferred)
  :config
  (setq lsp-nix-nixd-formatting-command ["nixfmt"]))

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

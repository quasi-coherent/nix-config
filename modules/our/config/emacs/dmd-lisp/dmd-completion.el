;;; dmd-completion.el --- -*- lexical-binding: t; -*-
;;; Commentary:
;;; Code:

(require 'dmd-lib)
(require 'use-package)

(declare-function vertico-next "vertico")
(declare-function vertico-mode "vertico")
(declare-function marginalia-mode "marginalia")

(setq completion-styles '(basic substring initials flex orderless)
      completion-category-defaults nil)

(setq completion-category-overrides
      '((file (styles . (basic partial-completion orderless)))
	(embark-keybinding (styles . (basic substring)))
	(imenu (styles . (basic substring orderless)))
	(consult-location (styles . (basic substring orderless)))
	(kill-ring (styles . (emacs22 orderless)))
	(lsp (styles . (emacs22 substring orderless)))))

(setq completion-ignore-case t
      read-buffer-completion-ignore-case t
      read-file-name-completion-ignore-case t
      read-extended-command-predicate #'command-completion-default-include-p)

(setq-default tab-always-indent 'complete)
(setq minibuffer-prompt-properties
      '(read-only t cursor-intangible t face minibuffer-prompt))

(setq enable-recursive-minibuffers t)
(setq-default case-fold-search t)

(add-hook 'minibuffer-setup-hook #'cursor-intangible-mode)

(use-package vertico
  :init (vertico-mode)
  :bind (:map vertico-map
              ("C-x C-d" . consult-dir)
              ("C-x C-j" . consult-dir-jump-file))
  :config
  (setq vertico-scroll-margin 0
	vertico-count 20
	vertico-resize t
	vertico-cycle t
	read-buffer-completion-ignore-case t
	read-file-name-completion-ignore-case t
	text-mode-ispell-word-completion nil
	completion-styles '(basic substring partial-completion flex)))

(use-package vertico-directory
  :after vertico
  :bind (:map vertico-map
              ("RET" . vertico-directory-enter)
              ("DEL" . vertico-directory-delete-char)
              ("M-DEL" . vertico-directory-delete-word))
  :hook (rfn-eshadow-update-overlay . vertico-directory-tidy))

(use-package embark
  :bind
  (("C-." . dmd/embark-act-quit)
   ("C-," . dmd/embark-act-no-quit))
  :config
  (setq embark-confirm-act-all nil
	embark-mixed-indicator-both nil
	embark-mixed-indicator-delay 1.0
	embark-indicators '(embark-mixed-indicator embark-highlight-indicator)
	embark-verbose-indicator-nested nil
	embark-verbose-indicator-buffer-sections '(bindings)
	embark-verbose-indicator-excluded-actions
	'(embark-cycle embark-act-all embark-collect embark-export embark-insert)))

(use-package embark-consult)

(use-package marginalia
  :init
  (marginalia-mode)
  :bind
  (:map minibuffer-local-map
	("M-A" . marginalia-cycle))
  :config
  (setq marginalia-max-relative-age 0
	marginalia-annotator-registry
	'((buffer dmd/marginalia-buffer)
	  (package dmd/marginalia-package)
	  (function dmd/marginalia-symbol)
	  (symbol dmd/marginalia-symbol)
	  (variable dmd/marginalia-symbol))))

(use-package consult
  :bind (("C-s" . consult-line)
         ("C-t" . consult-goto-line)
         ("C-x b" . consult-buffer)
         ("C-x p b" . consult-project-buffer)
         ("M-g f" . consult-flycheck)
         ("M-g i" . consult-imenu)
         ("M-g I" . consult-imenu-multi)
         ("M-g k" . consult-global-mark)
         ("M-g r" . consult-grep-match)
         ("M-s c" . consult-locate)
         ("M-s d" . consult-fd)
         ("M-s e" . consult-isearch-history)
         ("M-s g" . consult-git-grep)
         ("M-s l" . consult-complex-command)
         ("M-s L" . consult-line-multi)
         ("M-s r" . consult-ripgrep)
         ("M-y" . consult-yank-pop)
         (:map isearch-mode-map
               ("M-e" . consult-isearch-history)
               ("M-s e" . consult-isearch-history)
               ("M-s l" . consult-line)
               ("M-s L" . consult-line-multi))
         (:map minibuffer-local-map
               ("M-r" . consult-history)
               ("M-s" . consult-history)))
  :config
  (setq consult-line-numbers-widen t
	consult-async-min-input 3
	consult-async-input-debounce 0.5
	consult-async-input-throttle 0.8
	consult-narrow-key "<")
  (defvar dmd/consult-line-map
    (let ((map (make-sparse-keymap)))
      (define-key map "\C-s" #'vertico-next)
      map)))

(use-package consult-flycheck)
(use-package consult-lsp)
(use-package consult-yasnippet)

;; (use-package company
;;   :diminish
;;   :init
;;   (setq company-minimum-prefix-length 2
;;         company-idle-delay 0.0
;;         company-require-match 'never
;;         company-dabbrev-ignore-case nil
;;         company-dabbrev-downcase nil)
;;   :bind ((:map company-active-map
;;                ("<tab>" . company-complete-selection)))
;;   :config
;;   (global-company-mode +1))

(use-package orderless
  :bind
  (:map minibuffer-local-completion-map
	("SPC" . nil)
	("?" . nil))
  :config
  (setq orderless-matching-styles
        '(orderless-prefixes orderless-regexp))
  (setq orderless-style-dispatchers
        '(dmd/orderless-literal-dispatch
          dmd/orderless-file-ext-dispatch
          dmd/orderless-beg-or-end-dispatch)))

(use-package corfu
  :init (global-corfu-mode))

(provide 'dmd-completion)
;;; dmd-completion.el ends here

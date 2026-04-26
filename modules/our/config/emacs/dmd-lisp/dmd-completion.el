;;; dmd-completion.el --- -*- lexical-binding: t; -*-
;;; Commentary:
;;; Code:

(require 'dmd-lib)
(require 'use-package)

(declare-function vertico-next "vertico")
(declare-function vertico-mode "vertico")
(declare-function marginalia-mode "marginalia")
(declare-function global-corfu-mode "corfu")
(declare-function corfu-terminal-mode "corfu-terminal")

(use-package consult
  :init
  (setq consult-preview-key 'any)
  :bind
  (("C-s" . consult-line)
   ("C-t" . consult-goto-line)
   ("C-c h" . consult-history)
   ("C-c b" . consult-bookmark)
   ("C-x C-b" . consult-buffer)
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
   :map isearch-mode-map
   ("C-o" . consult-line-literal)
   ("M-e" . consult-isearch-history)
   ("M-s e" . consult-isearch-history)
   ("M-s l" . consult-line-literal)
   ("M-s L" . consult-line-multi))
  :config
  (setq consult-narrow-key "<")
  (consult-customize consult-theme :preview-key '(:debounce 0.4 any)))

(use-package consult-dir
  :bind
  (("C-x C-d" . consult-dir)
   :map minibuffer-local-completion-map
   ("C-x C-d" . consult-dir)
   ("C-x C-j" . consult-dir-jump-file)))

(use-package vertico
  :after consult
  :config
  (vertico-mode)
  (setq vertico-scroll-margin 0
        vertico-count 20
        vertico-resize t
        vertico-cycle t
        read-buffer-completion-ignore-case t
        read-file-name-completion-ignore-case t))

(use-package vertico-directory
  :after vertico
  :bind
  (:map vertico-map
        ("RET" . vertico-directory-enter)
        ("DEL" . vertico-directory-delete-char)
        ("M-DEL" . vertico-directory-delete-word))
  :hook (rfn-eshadow-update-overlay . vertico-directory-tidy))

(use-package vertico-quick
  :after vertico
  ;; :init
  ;; ;; https://kristofferbalintona.me/posts/202202211546/
  ;; (defun dmd/vertico-quick-embark (&optional arg)
  ;;   "Embark on candidate using quick keys."
  ;;   (interactive)
  ;;   (when (vertico-quick-jump)
  ;;     (embark-act arg)))
  :config
  (keymap-set vertico-map "M-g j" #'vertico-quick-insert)
  (keymap-set vertico-map "M-g J" #'vertico-quick-exit))

(use-package orderless
  :after consult
  :custom
  (completion-styles '(orderless partial-completion basic))
  (completion-category-overrides '((file (styles partial-completion orderless))))
  (orderless-matching-styles '(orderless-literal orderless-prefixes orderless-initialism orderless-regexp))
  (orderless-style-dispatchers '(dmd/orderless-literal-dispatch dmd/orderless-file-ext-dispatch dmd/orderless-beg-or-end-dispatch))
  (orderless-component-separator 'orderless-escapable-split-on-space))

(use-package marginalia
  :init
  (marginalia-mode)
  :bind
  (:map minibuffer-local-map
        ("M-A" . #'marginalia-cycle))
  :custom
  (marginalia-max-relative-age 0))

(use-package corfu-history)

(use-package corfu
  :init
  (global-corfu-mode)
  :bind
  (:map corfu-map
        ("C-n" . #'corfu-next)
        ("C-p" . #'corfu-previous)
        ("C-g" . #'corfu-quit)
        ("M-SPC" . #'corfu-insert-separator)
        ("M-d" . #'corfu-info-documentation)
        ("M-l" . #'corfu-show-location)
        ("C-v" . #'corfu-scroll-down)   ; Corfu has these two backwards
        ("M-v" . #'corfu-scroll-up)
        ("RET" . nil)                   ; This gets in the way
        ("M-h" . nil)                   ; Unset things we remapped
        ("M-g" . nil))
  :custom
  (tab-always-indent 'complete)
  (corfu-auto t)
  (corfu-cycle t)
  (corfu-auto-delay 0.67)
  (corfu-auto-prefix 2)
  (corfu-preselect 'directory)
  (corfu-history-mode)
  (add-to-list 'savehist-additional-variables 'corfu-history)
  (corfu-popupinfo-mode)
  :config
  (keymap-unset corfu-map "RET"))

(use-package corfu-terminal :init (corfu-terminal-mode +1))

(use-package embark
  :bind
  (("C-." . dmd/embark-act-quit)
   ("M-." . dmd/embark-act-no-quit)
   ("C-h B" . embark-bindings))
  :config
  (setq prefix-help-command #'embark-prefix-help-command)
  ;; Hide the mode line of the Embark live/completions buffers.
  (add-to-list 'display-buffer-alist
               '("\\`\\*Embark Collect \\(Live\\|Completions\\)\\*"
                 nil
                 (window-parameters (mode-line-format . none)))))

(use-package embark-consult
  :after (embark consult)
  :demand t
  :hook
  (embark-collect-mode . consult-preview-at-point-mode))

(use-package yasnippet-snippets)

(use-package yasnippet
  :diminish yas-minor-mode
  :config
  (yas-global-mode t)
  (define-key yas-minor-mode-map (kbd "<tab>") nil)
  (define-key yas-minor-mode-map (kbd "TAB") nil)
  (define-key yas-minor-mode-map (kbd "C-c y") #'yas-expand)
  (yas-reload-all))

(provide 'dmd-completion)
;;; dmd-completion.el ends here

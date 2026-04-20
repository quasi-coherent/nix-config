;;; dmd-completion.el --- -*- lexical-binding: t; -*-
;;; Commentary:
;;; Code:

(require 'dmd-lib)
(require 'use-package)

(declare-function vertico-next "vertico")
(declare-function vertico-mode "vertico")
(declare-function marginalia-mode "marginalia")

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
   (setq xref-show-xrefs-function #'consult-xref
         xref-show-definitions-function #'consult-xref)
   (setq consult-narrow-key "<")
   (consult-customize consult-theme :preview-key '(:debounce 0.4 any)))

(use-package consult-dir
  :bind
  (("C-x C-d" . consult-dir)
   :map minibuffer-local-completion-map
   ("C-x C-d" . consult-dir)
   ("C-x C-j" . consult-dir-jump-file)))

(use-package consult-flycheck)

(use-package consult-lsp
  :config
  (define-key lsp-mode-map [remap xref-find-apropos] #'consult-lsp-symbols))

(use-package consult-yasnippet)

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
  (completion-category-defaults nil)
  (completion-category-overrides '((file (styles partial-completion)))))

(use-package marginalia
  :config
  (marginalia-mode)
  (setq marginalia-max-relative-age 0))

(use-package corfu
  :hook (lsp-completion-mode . dmd/corfu-setup-lsp)
  :init
  (global-corfu-mode)
  (setq tab-always-indent 'complete
        corfu-auto t
        corfu-auto-prefix 2
        corfu-auto-delay 0.25
        corfu-cycle nil
        corfu-preview-current t
        corfu-preselect-first t)
  :bind
  (:map corfu-map
        ("M-n" . #'corfu-next)
        ("M-p" . #'corfu-previous)
        ("M-TAB" . #'corfu-expand)
        ("RET" . #'corfu-insert)
        ("M-SPC" . #'corfu-insert-separator)
        ("M-d" . #'corfu-info-documentation)
        ("M-l" . #'corfu-show-location)
        ("C-g" . #'corfu-quit))
  :config
  (defun corfu-enable-always-in-minibuffer ()
    "Enable Corfu in the minibuffer if Vertico/Mct are not active."
    (unless (or (bound-and-true-p mct--active) ; Useful if I ever use MCT
                (bound-and-true-p vertico--input))
      (setq-local corfu-auto nil)
      (corfu-mode 1)))
  (add-hook 'minibuffer-setup-hook #'corfu-enable-always-in-minibuffer 1)

  (defun dmd/corfu-setup-lsp ()
    "Use orderless completion style with lsp-capf instead of the
default lsp-passthrough."
    (setf (alist-get 'styles (alist-get 'lsp-capf completion-category-defaults))
          '(orderless))))

(use-package corfu-history
  :after corfu
  :config
  (corfu-history-mode)
  (savehist-mode 1)
  (add-to-list 'savehist-additional-variables 'corfu-history))

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

(use-package embark
  :bind
  (("M-o" . dmd/embark-act-quit)
   ("M-u" . dmd/embark-act-no-quit)
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

(provide 'dmd-completion)
;;; dmd-completion.el ends here

;;; dmd-general.el --- -*- lexical-binding: t; -*-
;;; Commentary:
;;; Code:

(require 'use-package)

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

;; Kitty keyboard protocol to work within tmux.  Responds to extended key
;; sequences.  TODO: It doesn't do a good job sometimes...  Figure out which
;; thing or things in alacritty -> tmux -> emacs is still missing something.
(use-package kkp
  :hook
  (tty-setup . global-kkp-mode)
  :config
  (require 'kkp-debug))

;; Set a GC strategy that will garbage collect more eagerly when idle.
(declare-function gcmh-mode "gcmh")
(use-package gcmh
  :diminish
  :config
  (setopt gcmh-high-cons-threshold (* 256 1024 1024))
  (setopt gcmh-low-cons-threshold (* 16 1024 1024))
  (setopt gcmh-idle-delay 3)
  (setopt gc-cons-percentage 0.2)
  (add-hook 'after-init-hook #'gcmh-mode))

;; Persist history over restarts.
(use-package savehist
  :init
  (savehist-mode)
  :config
  (setq savehist-file (locate-user-emacs-file "savehist")
	history-length 1000
	savehist-save-minibuffer-history t
	savehist-additional-variables '(register-alist kill-ring)))

;; Shows keys that can complete the current sequence.
(use-package which-key
  :diminish
  :functions
  (which-key-mode which-key-add-major-mode-key-based-replacements)
  :config
  (which-key-mode))

;; Late binding with after-init-hook since other global minor modes _prepend_ to
;; hooks and direnv may need something they put on the path to load envrc.
(use-package envrc :hook (after-init . envrc-global-mode))

(provide 'dmd-general)
;;; dmd-general.el ends here

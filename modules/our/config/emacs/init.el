;;; init.el --- -*- lexical-binding: t; -*-
;;; Commentary:
;;; Code:

(defvar emacs-d
  (file-name-directory
   (file-chase-links load-file-name))
  "we should build a great bonfire
we should congratulate ourselves on our
endurance")

(add-to-list 'load-path emacs-d)
(add-to-list 'load-path (expand-file-name "dmd-lisp/" emacs-d))

(setq byte-compile-warnings '(cl-functions))
(setq enable-local-variables :all)

(require 'use-package)
(require 'bind-key)
(require 'delight)
(require 'diminish)
(require 'dmd-lib)

(setq use-package-verbose nil)
(autoload #'use-package-autoload-keymap "use-package-bind-key")

(defmacro csetq (variable value)
  `(funcall (or (get ',variable 'custom-set) 'set-default) ',variable ,value))

(defun dmd/advice-add (&rest args)
  (when (fboundp 'advice-add)
    (apply #'advice-add args)))

;;;; Global defaults:

(use-package emacs
  :init
  (csetq vc-follow-symlinks t)
  (csetq vc-find-revisions-no-save t)
  (csetq enable-recursive-minibuffers t)
  (csetq show-trailing-whitespace t)
  (csetq indent-tabs-mode nil)
  ;; Don't need to (defalias 'yes-or-no-p 'y-or-n-p) anymore.
  (csetq use-short-answers t)
  (csetq make-backup-files nil)
  (csetq backup-inhibited nil)
  (csetq create-lockfiles nil)
  (csetq auto-save-default nil)
  (csetq load-prefer-newer t)
  (csetq view-read-only t)
  ;; Default is to write to init.el, but ours is in the nix store so that is
  ;; not possible.
  (csetq custom-file (expand-file-name "custom.el" user-emacs-directory))
  (csetq frame-title-format '(%b))
  (csetq ring-bell-function 'ignore)
  (csetq use-file-dialog nil)
  (when (string= system-type "darwin")
    (setq dired-use-ls-dired t
          insert-directory-program "gls" ; Needs coreutils on the path
          dired-listing-switches "-aBhl --group-directories-first")))
  ;; (csetq lsp-use-plists t))

;;;; Global modes:
(require 'git-gutter)
(require 'simpleclip)

(column-number-mode 1)
(delete-selection-mode 1) ; Yank replaces the region
(global-auto-revert-mode t)
(global-display-line-numbers-mode 1)
(global-git-gutter-mode 1)
(global-hl-line-mode 1)
(global-subword-mode 1) ; camelCase word boundaries
(show-paren-mode 1)
(simpleclip-mode 1) ; Bindings to OS-defined clipboard keys
(winner-mode 1)
(menu-bar-mode -1)
(mouse-wheel-mode -1)
(scroll-bar-mode -1)
(tool-bar-mode -1)


;;;; Global keys:

;; `keyboard-quit' that actually works.
(global-set-key (kbd "C-g") #'dmd/keyboard-quit-dwim)
(global-set-key (kbd "C-x b") #'ibuffer)

;; Hate whitespace.
(add-hook 'before-save-hook #'delete-trailing-whitespace)

;; Don't let moving up directories in the minibuffer add to the kill ring.
(define-key minibuffer-local-map [M-backspace] #'dmd/backward-delete-word)

(defmacro dmd-emacs-map (keymap &rest definitions)
  "Expand key binding DEFINITIONS for the given KEYMAP."
  (declare (indent 1))
  (unless (zerop (% (length definitions) 2))
    (error "Uneven number of key+command pairs"))
  (let ((keys (seq-filter #'stringp definitions))
        (commands (seq-remove #'stringp definitions)))
    `(when-let (((keymapp ,keymap))
                (map ,keymap))
       ,@(mapcar
          (lambda (pair)
            (let* ((key (car pair))
                   (command (cdr pair)))
              (unless (and (null key) (null command))
                `(define-key map (kbd ,key) ,command))))
          (cl-mapcar #'cons keys commands)))))

(require 'dmd-appearance)
(require 'dmd-completion)
(require 'dmd-essentials)
(require 'dmd-lsp)

;; Set a GC strategy that will garbage collect more eagerly when idle.
(require 'gcmh)
(setopt gcmh-high-cons-threshold (* 256 1024 1024))
(setopt gcmh-low-cons-threshold (* 16 1024 1024))
(setopt gcmh-idle-delay 3)
(setopt gc-cons-percentage 0.2)
(add-hook 'after-init-hook #'gcmh-mode)

;; Late binding with after-init-hook since other global minor modes _prepend_ to
;; hooks and direnv may need something they put on the path to load envrc.
(require 'envrc)
(add-hook 'after-init-hook #'envrc-global-mode)

(provide 'init)
;;; init.el ends here

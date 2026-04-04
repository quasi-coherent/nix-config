;;; init.el --- -*- lexical-binding: t; -*-
;;; Commentary:
;;; Code:

;;; Personal defaults:

(setq-default make-backup-files nil
	      backup-inhibited nil
	      create-lockfiles nil
	      auto-save-default nil
	      ad-redefinition-action 'accept
	      view-read-only t
	      load-prefer-newer 1

	      scroll-conservatively most-positive-fixnum
	      cursor-in-non-selected-windows nil

	      history-length 1000
	      kill-ring-max 64
	      mark-ring-max 64

	      fill-column 80
	      indent-tabs-mode nil
	      mode-line-end-spaces nil
	      show-trailing-whitespace t)

(setq-default backup-directory-alist `((".*" . ,temporary-file-directory)))
(setq-default auto-save-file-name-transforms `((".*" ,temporary-file-directory t)))
(setq-default auto-save-default nil)

;; Enable these.
(mapc
 (lambda (command)
   (put command 'disabled nil))
 '(narrow-to-region narrow-to-page upcase-region downcase-region))

;; Disable these.
(mapc
 (lambda (command)
   (put command 'disabled t))
 '(eshell project-eshell overwrite-mode iconify-frame diary))

;; Global modes.
(delete-selection-mode 1) ; Yank replaces the region
(global-auto-revert-mode t)
(column-number-mode 1)
(global-display-line-numbers-mode 1)
(global-subword-mode 1) ; camelCase word boundaries
(show-paren-mode 1)
(global-hl-line-mode 1)
(winner-mode 1)

;; Hate whitespace.
(add-hook 'before-save-hook #'delete-trailing-whitespace)

(defun backward-delete-word (arg)
  "Delete characters backward until encountering the beginning of a word.
With argument ARG, do this that many times."
  (interactive "p")
  (delete-region (point) (progn (backward-word arg) (point))))

;; To not have moving up directories contribute to the kill ring.
(define-key minibuffer-local-map [M-backspace] #'backward-delete-word)

(eval-when-compile
  (require 'use-package)
  (setq use-package-verbose nil))

(require 'bind-key)
(require 'delight)
(require 'diminish)

(declare-function cl-mapcar "cl-lib")

(autoload #'use-package-autoload-keymap "use-package-bind-key")

(defmacro dmd-emacs-map (keymap &rest definitions)
  "Expand key binding DEFINITIONS for the given KEYMAP."
  (declare (indent 1))
  (unless (zerop (% (length definitions) 2))
    (error "Uneven number of key+command pairs"))
  (let ((keys (seq-filter #'stringp definitions))
        ;; We do accept nil as a definition: it unsets the given key.
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

(dmd/add-to-list 'load-path (locate-user-emacs-file "dmd-lisp"))

(require 'dmd-appearance)
(require 'dmd-buffers)
(require 'dmd-completion)
(require 'dmd-general)
(require 'dmd-lib)
(require 'dmd-lsp)

(provide 'init)
;;; init.el ends here

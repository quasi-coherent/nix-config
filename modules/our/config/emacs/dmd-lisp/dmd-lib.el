;;; dmd-lib.el --- -*- lexical-binding: t; -*-
;;; Commentary:
;;; Code:

(defun dmd/add-to-list (listvar elements)
  "Add multiple ELEMENTS to LISTVAR."
  (dolist (elt elements)
    (add-to-list listvar elt)))

;;;###autoload
(defun dmd/backward-delete-word (arg)
  "Delete characters backward until encountering the beginning of a word.
With argument ARG, do this that many times."
  (interactive "p")
  (delete-region (point) (progn (backward-word arg) (point))))

;;;###autoload
(defun dmd/minor-modes-active ()
  "Return list of active minor modes for the current buffer."
  (let ((active-modes))
    (mapc (lambda (m)
            (when (and (boundp m) (symbol-value m))
              (push m active-modes)))
          minor-mode-list)
    active-modes))

;;;###autoload
(defun dmd/disable-hl-line ()
  "Disable `hl-line-mode' (for hooks)."
  (hl-line-mode -1))

;;;###autoload
(defun dmd/keyboard-quit-dwim ()
  "Does the right thing when `keyboard-quit' is invoked:

- When the region is active, disable it.
- When a minibuffer is open, but not focused, close the minibuffer.
- When the Completions buffer is selected, close it.
- Otherwise, `keyboard-quit'."
  (interactive)
  (cond
   ((region-active-p)
    (keyboard-quit))
   ((derived-mode-p 'completion-list-mode)
    (delete-completion-window))
   ((> (minibuffer-depth) 0)
    (abort-recursive-edit))
   (t
    (keyboard-quit))))

(defun dmd/mark--between (bounds)
  "Mark between BOUNDS as a cons cell of beginning and end positions."
  (push-mark (car bounds))
  (goto-char (cdr bounds))
  (activate-mark))

;;;###autoload
(defun dmd/mark-sexp ()
  "Mark symbolic expression at or near point.
Repeat to extend the region forward to the next symbolic
expression."
  (interactive)
  (if (eq last-command this-command)
      (ignore-errors (forward-sexp 1))
    (let ((thing (cond
                  ((thing-at-point 'sexp) 'sexp)
                  ((thing-at-point 'string) 'string)
                  (t 'word))))
      (dmd/mark--between (bounds-of-thing-at-point thing)))))

;;;###autoload
(defun dmd/kill-buffer (buffer)
  "Kill current BUFFER without confirmation.
When called interactively, prompt for BUFFER."
  (interactive (list (read-buffer "Select buffer: ")))
  (let ((kill-buffer-query-functions nil))
    (kill-buffer (or buffer (current-buffer)))))

;;;###autoload
(defun dmd/rename-file-and-buffer (name)
  "Apply NAME to current file and rename its buffer.
Do not try to make a new directory or anything fancy."
  (interactive
   (list (read-string "Rename current file: " (buffer-file-name))))
  (let ((file (buffer-file-name)))
    (if (vc-registered file)
        (vc-rename-file file name)
      (rename-file file name))
    (set-visited-file-name name t t)))

(defun dmd/embark-act-no-quit ()
  "Call `embark-act' but do not quit after the action."
  (interactive)
  (let ((embark-quit-after-action nil))
    (call-interactively #'embark-act)))

(defun dmd/embark-act-quit ()
  "Call `embark-act' and quit after the action."
  (interactive)
  (let ((embark-quit-after-action 1))
    (call-interactively #'embark-act)))

(defun dmd/marginalia-truncate (string)
  "Truncate STRING to `fill-column', if necessary."
  (if (> (length string) fill-column)
      (concat (substring string 0 fill-column) "...")
    string))

(defun dmd/marginalia-display (string)
  "Propertize the display of STRING for completion annotation purposes."
  (when (stringp string)
    (format "%s%s"
            (propertize " " 'display `(space :align-to 40))
            (propertize (dmd/marginalia-truncate string)
                        'face 'completions-annotations))))

(defun dmd/marginalia-buffer (buffer)
  "Annotate BUFFER with the return value of function `buffer-file-name'."
  (if-let ((name (buffer-file-name (get-buffer buffer))))
      (dmd/marginalia-display (abbreviate-file-name name))
    (dmd/marginalia-display (format "%s" (buffer-local-value 'major-mode (get-buffer buffer))))))

(defun dmd/marginalia-package (package)
  "Annotate PACKAGE with its summary."
  (when-let* ((pkg-alist (bound-and-true-p package-alist))
              (pkg (intern-soft package))
              (desc (or (when (package-desc-p pkg) pkg)
                        (car (alist-get pkg pkg-alist))
                        (if-let (built-in (assq pkg package--builtins))
                            (package--from-builtin built-in)
                          (car (alist-get pkg package-archive-contents))))))
    (dmd/marginalia-display (package-desc-summary desc))))

(defun dmd/marginalia--get-symbol-doc (symbol)
  "Return documentation string according to SYMBOL type."
  (cond
   ((or (functionp symbol) (macrop symbol))
    (documentation symbol))
   (t
    (get symbol 'variable-documentation))))

(defun dmd/marginalia--first-line-documentation (symbol)
  "Return first line of SYMBOL documentation string."
  (when-let ((doc-string (dmd/marginalia--get-symbol-doc symbol))
             ((stringp doc-string))
             ((not (string-empty-p doc-string))))
    (car (split-string doc-string "[?!.\n]"))))

(defun dmd/marginalia-symbol (symbol)
  "Annotate SYMBOL with its documentation string."
  (when-let ((sym (intern-soft symbol))
             (doc-string (dmd/marginalia--first-line-documentation sym)))
    (dmd/marginalia-display doc-string)))

(defun dmd/orderless-fast-dispatch (word index total)
  (and (= index 0) (= total 1) (length< word 4)
       (cons 'orderless-literal-prefix word)))

(defun dmd/orderless-flex-first-dispatch (_pattern index _basic)
  (and (eq index 0) 'orderless-flex))

(defun dmd/orderless-literal-dispatch (word _index _total)
  "Read WORD= as a literal string."
  (when (string-suffix-p "=" word)
    ;; The `orderless-literal' is how this should be treated by
    ;; orderless.  The `substring' form omits the `=' from the
    ;; pattern.
    `(orderless-literal . ,(substring word 0 -1))))

(defun dmd/orderless-file-ext-dispatch (word _index _total)
  "Expand WORD.  to a file suffix when completing file names."
  (when (and minibuffer-completing-file-name
             (string-suffix-p "." word))
    `(orderless-regexp . ,(format "\\.%s\\'" (substring word 0 -1)))))

(defun dmd/orderless-beg-or-end-dispatch (word _index _total)
  "Expand WORD~ to \\(^WORD\\|WORD$\\)."
  (when-let (((string-suffix-p "~" word))
             (word (substring word 0 -1)))
    `(orderless-regexp . ,(format "\\(^%s\\|%s$\\)" word word))))

(provide 'dmd-lib)
;;; dmd-lib.el ends here

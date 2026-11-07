;;; package -- Summary
;;;
;;; Commentary:
;;; elisp has the most particular linting rules, and I couldn't have written
;;; this on the previous line after "Commentary:" because of that.
;;;
;;; Code:
;;; Here is some code.  It does things, like be the configuration for $EDITOR.
;;; It's supposed to be fast.
(require 'move-text)
(require 'multiple-cursors)

(autoload #'mc/mark-next-like-this "multiple-cursors")
(autoload #'mc/mark-previous-like-this "multiple-cursors")

(global-set-key "M-n" mc/mark-next-like-this)
(global-set-key "M-p" mc/mark-previous-like-this)
(provide 'editor)
;;; editor.el ends here

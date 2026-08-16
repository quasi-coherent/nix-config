;;; Code:
(require 'move-text)
(require 'multiple-cursors)

(autoload #'mc/mark-next-like-this "multiple-cursors")
(autoload #'mc/mark-previous-like-this "multiple-cursors")

(global-set-key "M-n" mc/mark-next-like-this)
(global-set-key "M-p" mc/mark-previous-like-this)

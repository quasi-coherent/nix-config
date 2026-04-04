
(eval-when-compile
  (require 'use-package)
  (setq use-package-verbose nil))

(autoload #'use-package-autoload-keymap "use-package-bind-key")

(use-package move-text :config (move-text-default-bindings))

(use-package multiple-cursors
  :bind (("M-n" . mc/mark-next-like-this)
         ("M-p" . mc/mark-previous-like-this)))

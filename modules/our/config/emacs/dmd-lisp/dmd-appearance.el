;;; dmd-appearance.el --- -*- lexical-binding: t; -*-
;;; Commentary:
;;; Code:

(require 'use-package)

(declare-function doom-modeline-mode "doom-modeline")

;; TODO: figure out what is configuring faces...  We can turn stylix off with
;; stylix.targets.emacs.enable set to false and not load themes, but things will
;; still deliberately be picked for face/font lock attributes.
;;
;; So this is some kind of default, but it clearly is picking from the base16
;; palette that is used to configure other programs by having the setting
;; stylix.autoEnable = true.  I cannot for the life of me figure out how.  It's
;; picking way better than the `base16-theme' package though...
;;
;; NB: If we turn this back on, there is an obscure convention:
;; For `load-theme' to work, a file `my-cool-theme.el' must exist and contain a
;; theme `my-cool'.  Or `my-cool-theme-theme.el' could have `my-cool-theme' and
;; that would work too.  So this needs to be in a different file with the name
;; `our-base16-theme.el'.
;;
;; (require 'base16-theme)
;;
;; (deftheme our-base16)
;;
;; (defvar our-base16-colors
;;   '(:base00 "#131213"
;;     :base01 "#2f1823"
;;     :base02 "#472234"
;;     :base03 "#ffbee3"
;;     :base04 "#74af68"
;;     :base05 "#f15c99"
;;     :base06 "#81506a"
;;     :base07 "#632227"
;;     :base08 "#ff3242"
;;     :base09 "#ff9153"
;;     :base0A "#87d75f"
;;     :base0B "#9ddf69"
;;     :base0C "#5fafd7"
;;     :base0D "#ffd75"
;;     :base0E "#9413e5"
;;     :base0F "#7f2121")
;;   "Colors for the base16 scheme defined here.")
;;
;; (setq base16-theme-256-color-source 'colors)
;; (base16-theme-define 'our-base16 our-base16-colors)
;;
;; (provide-theme 'our-base16)

;; The default has one bad thing, however, which is that the modeline is very
;; light orange on white a.k.a. not readable. Somehow that's being chosen over
;; the mode-line face provided by doom-modeline even though that's certainly
;; available, not to mention the only thing it exists for.
(use-package doom-modeline
  :hook
  ;; (doom-modeline-mode . size-indicator-mode)
  (doom-modeline-mode . display-time-mode)
  :init
  (doom-modeline-mode 1)
  (setq doom-modeline-time t
	doom-modeline-check 'auto
	doom-modeline-buffer-file-name-style 'relative-from-project
        doom-modeline-icon nil
        doom-modeline-github nil
	doom-modeline-mu4e nil
	doom-modeline-persp-name nil
	doom-modeline-major-mode-icon nil
	doom-modeline-minor-modes nil
        doom-modeline-window-width-limit nil
        display-time-day-and-date t))

;; ;; Use the fontset we have elsewhere.
;; (set-face-attribute 'default nil
;;                     :font (font-spec
;;                            :family "Hasklug Nerd Font"
;;                            :size 12.0))

(set-face-attribute 'mode-line nil
                    :background "#6e1641"
                    :foreground "#0aa3ec"
                    :inherit 'mode-line)
(set-face-attribute 'mode-line-inactive nil
                    :background "#664d59"
                    :foreground "#dbe4e9"
                    :inherit 'mode-line)

(provide 'dmd-appearance)
;;; dmd-appearance.el ends here

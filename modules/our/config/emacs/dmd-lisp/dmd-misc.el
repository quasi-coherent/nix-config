;;; dmd-misc.el --- -*- lexical-binding: t; -*-
;;; Commentary:
;;; Code:

(require 'cl-lib)
(defvar lichess-token)
(declare-function lichess-http-request "lichess-http")

(defun dmd/load-lichess-oauth-token ()
  "Hook for loading an lichess authorization token."
  (unless (executable-find "sops-get")
    (message "sops-get not found on PATH")
    (cl-return-from dmd/load-lichess-oauth-token nil))
  (with-temp-buffer
    (let ((exit-code (call-process "sops-get" nil t nil "-a" "lichess_oauth_token")))
      (if (= exit-code 0)
          (setq lichess-token (string-trim (buffer-string)))
        (message "sops-get failed with exit code %d: %s"
                 exit-code (string-trim (buffer-string)))))))

(defun dmd/unload-lichess-oauth-token ()
  "Hook for unloading an lichess authorization token."
  (setq lichess-token nil))

(use-package lichess
  :commands (lichess lichess-tv lichess-game-watch)
  :config
  (advice-add 'lichess-http-request :before (lambda (&rest _) (dmd/load-lichess-oauth-token)))
  (advice-add 'lichess-http-request :after (lambda (&rest _) (dmd/unload-lichess-oauth-token))))

(use-package chess)

(provide 'dmd-misc)
;;; dmd-misc.el ends here

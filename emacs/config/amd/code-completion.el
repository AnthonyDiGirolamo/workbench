;;; -*- lexical-binding: t; -*-

;;; code-completion.el --- Summary
;;; Commentary:
;;; Code:

(use-package completion-preview
  :if (>= emacs-major-version 30)
  :ensure nil
  ;; :bind
  ;; ( :map completion-preview-active-mode-map
  ;;   ("M-n" . completion-preview-next-candidate)
  ;;   ("M-p" . completion-preview-prev-candidate))
  :hook (prog-mode . completion-preview-mode))

(use-package yasnippet
  :disabled ;; TODO
  :diminish yas-minor-mode
  :config
  ;; seems to be needed for yankpad
  (yas-global-mode))

(use-package yankpad
  ;; :disabled ;; TODO
  :commands (yankpad-edit yankpad-set-category yankpad-expand yankpad-insert)
  ;; :after yasnippet
  :custom
  (yankpad-file (concat user-emacs-directory "/yankpad.org")))

(provide 'amd/code-completion)
;;; code-completion.el ends here

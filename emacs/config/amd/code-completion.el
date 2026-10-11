;;; -*- lexical-binding: t; -*-

;;; code-completion.el --- Summary
;;; Commentary:
;;; Code:

;;; Snippets

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


;;; language-servers

(use-package eglot
  :config
  (add-to-list 'eglot-server-programs
               '((c-mode c-ts-mode c++-mode c++-ts-mode) . ("clangd" "--header-insertion=never")))
  ;; (add-to-list 'eglot-server-programs
  ;;              '((fish-mode) . ("fish-lsp" "start")))
  ;; (add-to-list 'eglot-server-programs
  ;;              '((js-mode typescript-ts-mode) . ("rass" "typescript-language-server" "--stdio" "--" "vscode-eslint-language-server" "--stdio")))
  ;; (add-to-list 'eglot-server-programs
  ;;              '((go-mode go-ts-mode) . ("rass" "gopls" "--" "golangci-lint-langserver")))
  ;; (add-to-list 'eglot-server-programs
  ;;              '(nix-mode . ("nil")))
  :hook
  ((c-mode
    c-ts-mode
    c++-mode
    c++-ts-mode
    ;; fish-mode
    ;; js-mode
    ;; typescript-ts-mode
    ;; go-mode
    ;; go-ts-mode
    ;; nix-mode
    ) . eglot-ensure))

(use-package lsp-mode
  :disabled
  :commands lsp
  :custom
  ;; (lsp-restart 'auto-restart)
  (lsp-restart 'interactive)
  (lsp-headerline-breadcrumb-enable nil)
  (lsp-enable-file-watchers nil)
  :general
  (:keymaps '(lsp-signature-mode-map)
   ;; was lsp-signature-next
   "M-n" 'tmux-window-navigation/move-down)
  :init
  (setq lsp-keymap-prefix "s-l")
  (setq lsp-prefer-flymake nil)

  ;; example .dir-locals.el file for clangd:
  ;; ((nil
  ;;   (lsp-clients-clangd-args "--background-index=true" "--compile-commands-dir=~/project-root")
  ;;   (lsp-clients-clangd-executable . "clangd")))

  ;; Run my-local-variables-hook after processing .dir-locals.el
  (defun my-local-variables-hook ()
    (cond
     ((derived-mode-p 'c++-mode) (lsp))
     ((derived-mode-p 'rust-mode) (lsp))
     ))
  (add-hook 'hack-local-variables-hook #'my-local-variables-hook)

  ;; Standard use-package hook setup
  ;; :hook ((python-mode . lsp)
  ;;         ;; (lsp-mode . lsp-enable-which-key-integration)
  ;;         ;; (c++-mode . lsp)
  ;;       )

  :config
  ;; Likely broken with last lsp update. Error on emacs startup:
  ;;
  ;; Error (use-package): lsp-mode/:config: Wrong type argument: (or
  ;; string function (and list (satisfies (lambda (l) (seq-every-p
  ;; (lambda (el) (stringp el)) l))))), lsp-clients--clangd-command,
  ;; command
  ;;
  ;; (lsp-register-client
  ;;  (make-lsp-client
  ;;   :new-connection
  ;;   (lsp-tramp-connection
  ;;    'lsp-clients--clangd-command)
  ;;   :major-modes '(c-mode c++-mode objc-mode)
  ;;   :priority -1
  ;;   :remote? t
  ;;   :server-id 'clangd-remote))
  )

;;; Completion packages

(use-package completion-preview
  :if (>= emacs-major-version 30)
  :ensure nil
  :diminish
  ;; :bind
  ;; ( :map completion-preview-active-mode-map
  ;;   ("M-n" . completion-preview-next-candidate)
  ;;   ("M-p" . completion-preview-prev-candidate))
  :hook (prog-mode . completion-preview-mode))

(use-package corfu
  :custom
  (corfu-auto t)
  (corfu-quit-no-match 'separator)
  ;; (corfu-cycle t)                ;; Enable cycling for `corfu-next/previous'
  ;; (corfu-quit-at-boundary nil)   ;; Never quit at completion boundary
  ;; (corfu-preview-current nil)    ;; Disable current candidate preview
  ;; (corfu-preselect 'prompt)      ;; Preselect the prompt
  ;; (corfu-on-exact-match 'insert) ;; Configure handling of exact matches

  ;; Enable Corfu only for certain modes. See also `global-corfu-modes'.
  ;; :hook ((prog-mode . corfu-mode)
  ;;        (shell-mode . corfu-mode)
  ;;        (eshell-mode . corfu-mode))

  :init
  ;; Recommended: Enable Corfu globally.  Recommended since many modes provide
  ;; Capfs and Dabbrev can be used globally (M-/).  See also the customization
  ;; variable `global-corfu-modes' to exclude certain modes.
  (global-corfu-mode)

  ;; Enable optional extension modes:
  ;; (corfu-history-mode)
  ;; (corfu-mouse-mode)
  ;; (corfu-popupinfo-mode)
  )

(provide 'amd/code-completion)
;;; code-completion.el ends here

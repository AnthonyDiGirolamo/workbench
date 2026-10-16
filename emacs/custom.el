(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes t)
 '(package-selected-packages
   '(ace-link ace-window amx avy bazel catppuccin-theme cmake-mode
              color-identifiers-mode consult consult-eglot corfu
              counsel diminish dired-hacks-utils dired-subtree
              doom-modeline doom-themes embark embark-consult evil
              evil-commentary evil-matchit evil-surround expand-region
              fish-mode general gn-mode helpful
              highlight-indent-guides hydra ibuffer-vc ivy magit
              marginalia orderless outli posframe powerline projectile
              rainbow-delimiters rust-mode shackle solaire-mode swiper
              toc-org vertico vundo wgrep yankpad))
 '(safe-local-variable-values
   '((lsp-clients-clangd-args "--background-index=true")
     (eval add-to-list 'exec-path (expand-file-name "~/.cargo/bin")))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(doom-modeline-evil-emacs-state ((t (:inherit (doom-modeline font-lock-builtin-face) :inverse-video t))))
 '(doom-modeline-evil-insert-state ((t (:inherit (doom-modeline font-lock-keyword-face) :inverse-video t))))
 '(doom-modeline-evil-motion-state ((t (:inherit (doom-modeline font-lock-doc-face) :inverse-video t :slant normal))))
 '(doom-modeline-evil-normal-state ((t (:inherit doom-modeline-info :inverse-video t))))
 '(doom-modeline-evil-operator-state ((t (:inherit (doom-modeline mode-line) :inverse-video t))))
 '(doom-modeline-evil-replace-state ((t (:inherit doom-modeline-urgent :inverse-video t))))
 '(doom-modeline-evil-visual-state ((t (:inherit doom-modeline-warning :inverse-video t)))))

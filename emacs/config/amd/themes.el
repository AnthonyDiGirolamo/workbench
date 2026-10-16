;;; -*- lexical-binding: t; -*-

;;; themes.el --- Summary
;;; Commentary:
;;; Code:

(use-package solaire-mode
  :demand
  :hook
  ((change-major-mode after-revert ediff-prepare-buffer) . turn-on-solaire-mode)
  (minibufer-setup . solaire-mode-in-minibuffer)
  :init
  :config
  ;; (solaire-mode-swap-faces-maybe)
  (solaire-global-mode +1))

;;; modeline

;;;; doom-modeline

(use-package doom-modeline
  :custom
  (doom-modeline-bar-width 8) ;; fringe width/2
  ;; TODO: force height to be (frame-char-height)
  ;;   This seems to always multiply
  ;;   (if doom-modeline-icon 1.68 1.25) by the (frame-char-height)
  (doom-modeline-height 1)
  :init
  :hook
  (after-init . doom-modeline-mode)
  :config
  ;; (when (display-graphic-p)
  ;;     ;; use nerd-icons in gui mode
  ;;     (setq doom-modeline-icon t))

  (setq
   doom-modeline-icon nil
   ;; use unicode / emoji as fallback
   doom-modeline-unicode-fallback nil)

  (unless doom-modeline-icon
    ;; use reverse video for evil state for higher contrast
    (custom-set-faces
     '(doom-modeline-evil-emacs-state
       ((t (:inherit (doom-modeline font-lock-builtin-face) :inverse-video t))) t)
     '(doom-modeline-evil-insert-state
       ((t (:inherit (doom-modeline font-lock-keyword-face) :inverse-video t))) t)
     '(doom-modeline-evil-motion-state
       ((t (:inherit (doom-modeline font-lock-doc-face) :inverse-video t :slant normal))) t)
     '(doom-modeline-evil-normal-state
       ((t (:inherit doom-modeline-info :inverse-video t))) t)
     '(doom-modeline-evil-operator-state
       ((t (:inherit (doom-modeline mode-line) :inverse-video t))) t)
     '(doom-modeline-evil-visual-state
       ((t (:inherit doom-modeline-warning :inverse-video t))) t)
     '(doom-modeline-evil-replace-state
       ((t (:inherit doom-modeline-urgent :inverse-video t))) t))))

;;;; airline-themes

(use-package airline-themes
  :disabled
  :init
  (setq powerline-default-separator 'utf-8)
  ;; (setq powerline-utf-8-separator-left  #x2572
  ;;       powerline-utf-8-separator-right #x2572)
  (setq powerline-utf-8-separator-left  #x20
        powerline-utf-8-separator-right #x20)
  ;; (setq powerline-utf-8-separator-left  #xe0b0
  ;;       powerline-utf-8-separator-right #xe0b2)

  ;; (setq powerline-default-separator nil)
  (setq airline-hide-state-on-inactive-buffers t)
  (setq airline-hide-vc-branch-on-inactive-buffers t)
  (setq airline-hide-eyebrowse-on-inactive-buffers t)
  ;; (setq airline-display-directory 'airline-directory-full)
  (setq airline-display-directory 'airline-directory-shortened)
  ;; (setq airline-display-directory nil)
  (setq airline-eshell-colors t)
  ;; (setq airline-utf-glyph-separator-left      #x20)
  ;; (setq airline-utf-glyph-separator-right     #x20)
  ;; (setq airline-utf-glyph-subseparator-left   #x20)
  ;; (setq airline-utf-glyph-subseparator-right  #x20)
  ;; (setq airline-utf-glyph-branch              #xe0a0)
  ;; (setq airline-utf-glyph-readonly            #xe0a2)
  ;; (setq airline-utf-glyph-linenumber          #xe0a1)
  (setq airline-shortened-directory-length 16))

;;; leuven

;; (use-package leuven-theme
;;   :custom
;;   (leuven-scale-org-agenda-structure nil)
;;   (leuven-scale-outline-headlines t))

(defun amd/leuven-light-theme ()
  "Light background theme"
  (interactive)
  (setq leuven-scale-org-agenda-structure nil
        leuven-scale-outline-headlines t)
  (amd/disable-loaded-themes)
  (load-theme 'leuven t)
  (when (featurep 'airline-themes)
   ;; (load-theme 'airline-qwq t)
   (load-theme 'airline-base16_atelier_cave_light t))
  (custom-theme-set-faces
   'leuven
   ;; '(org-level-1 ((t (:height 1.3 :weight bold :slant normal :foreground "#875fff" :underline nil))) t)
   ;; '(org-level-2 ((t (:height 1.1 :weight bold :slant normal :foreground "#005fff" :underline nil))) t)
   ;; '(org-level-3 ((t (:height 1.0 :weight bold :slant normal :foreground "#00875f" :underline nil))) t)

   ;; '(magit-section-heading ((t (:foreground "#483d8b"))) t)
   ;; '(magit-section-heading-selection ((t (:foreground "#6a5acd"))) t)

   '(rainbow-delimiters-depth-1-face ((t (:foreground "#aa88ff" :weight bold))) t)
   '(rainbow-delimiters-depth-2-face ((t (:foreground "#88aaff" :weight bold))) t)
   '(rainbow-delimiters-depth-3-face ((t (:foreground "#88ffff" :weight bold))) t)
   '(rainbow-delimiters-depth-4-face ((t (:foreground "#66ffaa" :weight bold))) t)
   '(rainbow-delimiters-depth-5-face ((t (:foreground "#ffff66" :weight bold))) t)
   '(rainbow-delimiters-depth-6-face ((t (:foreground "#ffaa00" :weight bold))) t)
   '(rainbow-delimiters-depth-7-face ((t (:foreground "#ff6666" :weight bold))) t)
   '(rainbow-delimiters-depth-8-face ((t (:foreground "#ff66aa" :weight bold))) t)

   ;; lavender experiment
   ;; ;; '(default ((t (:foreground "#333333" :background "#F5F5F5"))) t)
   ;; '(default ((t (:foreground "#E0CEED" :background "#29222E"))) t)
   ;; '(org-block ((t (:foreground "#776385" :background "#160e1b"))) t)
   ;; '(org-block-begin-line ((t (:foreground "#E0CEED" :background "#3A2F42"))) t)
   ;; '(org-block-end-line   ((t (:foreground "#E0CEED" :background "#3A2F42"))) t)
   ;; '(font-lock-keyword-face ((t (:foreground "#A29DFA"))) t)
   ;; '(font-lock-comment-face           ((t (:foreground "#776385" :background "#160e1b"))) t)
   ;; '(fringe ((t (:foreground "#776385" :background "#160e1b"))) t)

   ;; 100% blue faces
   ;; '(comint-highlight-input ((t (:foreground "#ff4500"))) t)
   ;; '(comint-highlight-prompt ((t (:foreground "#ff4500"))) t)
   ;; '(company-tooltip-annotation ((t (:foreground "#ff4500"))) t)
   ;; '(dired-directory ((t (:foreground "#ff4500" :background "#ffffd2" :weight bold))) t)
   ;; '(dired-header ((t (:foreground "#ff4500" :background "#ffffd2" :weight bold))) t)
   ;; '(font-lock-keyword-face ((t (:foreground "#ff4500"))) t)
   ;; '(hydra-face-blue ((t (:foreground "#ff4500" :weight bold))) t)
   ;; '(info-node ((t (:foreground "#ff4500" :underline t))) t)
   ;; '(ivy-subdir ((t (:foreground "#ff4500" :background "#ffffd2" :weight bold))) t)
   ;; '(makey-key-mode-header-face ((t (:foreground "#ff4500"))) t)
   ;; '(org-priority ((t (:foreground "#ff4500"))) t)
   ;; '(wgrep-done-face ((t (:foreground "#ff4500"))) t)
   ;; '(web-mode-keyword-face ((t (:foreground "#ff4500"))) t)
   ;; '(web-mode-css-selector-face ((t (:foreground "#ff4500"))) t)
   ;; '(which-key-group-description-face ((t (:foreground "#ff4500"))) t)

   '(avy-lead-face ((t (:foreground "#ffaf00"))) t)
   '(avy-lead-face-0 ((t (:foreground "#5fd7ff"))) t)
   '(avy-background-face ((t (:background "#eeeeee" :foreground "#a2a2a2"))) t)))

;;; doom-themes

(use-package doom-themes
  :custom
  (doom-themes-enable-bold t)
  (doom-themes-enable-italic t)
  :config
  (defun amd/doom-snazzy-theme ()
    "load snazzy"
    (interactive)
    (amd/disable-loaded-themes)
    (load-theme 'doom-snazzy t)
    (when (featurep 'airline-themes)
      (load-theme 'airline-base16_snazzy t))
    (custom-theme-set-faces
     'doom-snazzy
     '(markdown-code-face ((t (:extend t :background "#242631"))) t t)
     '(magit-diff-removed ((t (:foreground "#cc4945" :background "#433b3d"))) t t)
     '(magit-diff-removed-highlight ((t (:foreground "#ff5c57" :background "#433b3d"))) t t)))

  (defun amd/doom-one-theme ()
    "load doom-one-theme and override some colors"
    (interactive)
    (amd/disable-loaded-themes)
    (load-theme 'doom-one t)
    ;; (load-theme 'doom-moonlight t)
    (when (featurep 'airline-themes)
      (load-theme 'airline-onedark t))
    (custom-theme-set-faces
     'doom-one
     '(flyspell-duplicate ((t (:underline "yellow" :weight bold))) t)
     '(flyspell-incorrect ((t (:underline "yellow" :weight bold))) t)
     '(rainbow-delimiters-depth-1-face ((t (:foreground "#aa88ff" :weight bold))) t)
     '(rainbow-delimiters-depth-2-face ((t (:foreground "#88aaff" :weight bold))) t)
     '(rainbow-delimiters-depth-3-face ((t (:foreground "#88ffff" :weight bold))) t)
     '(rainbow-delimiters-depth-4-face ((t (:foreground "#66ffaa" :weight bold))) t)
     '(rainbow-delimiters-depth-5-face ((t (:foreground "#ffff66" :weight bold))) t)
     '(rainbow-delimiters-depth-6-face ((t (:foreground "#ffaa00" :weight bold))) t)
     '(rainbow-delimiters-depth-7-face ((t (:foreground "#ff6666" :weight bold))) t)
     '(rainbow-delimiters-depth-8-face ((t (:foreground "#ff66aa" :weight bold))) t)
     '(tab-bar-tab ((t (:foreground "#1B2229" :background "#51AFEF" :weight bold))) t)
     '(tab-bar-tab-inactive ((t (:foreground "#ABB2BF" :background "#3E4452"))) t)

     ;; '(org-level-1 ((t (:height 1.3 :weight normal :slant normal :foreground "#00B3EF" :background "#21272d" :underline nil :box (:line-width 4 :color "#21272d" :style nil)))) t)
     ;; '(org-level-2 ((t (:height 1.1 :weight normal :slant normal :foreground "#40D3FF" :background "#21272d" :underline nil :box (:line-width 4 :color "#21272d" :style nil)))) t)
     ;; doom-one specific backgrounds
     '(org-level-1 ((t (:height 1.0 :weight normal :slant normal :underline nil :box nil :foreground "#aa88ff" :background "#21272d" :underline nil :box (:line-width 4 :color "#21272d" :style nil)))) t)
     '(org-level-2 ((t (:height 1.0 :weight normal :slant normal :underline nil :box nil :foreground "#88aaff" :background "#21272d" :underline nil :box (:line-width 4 :color "#21272d" :style nil)))) t)
     '(org-level-3 ((t (:height 1.0 :weight normal :slant normal :underline nil :box nil :foreground "#88ffff" :underline nil))) t) ;; cyan
     '(org-level-4 ((t (:height 1.0 :weight normal :slant normal :underline nil :box nil :foreground "#66ffaa" :underline nil))) t) ;; sea-green
     '(org-level-5 ((t (:height 1.0 :weight normal :slant normal :underline nil :box nil :foreground "#ffff66" :underline nil))) t) ;; yellow
     '(org-level-6 ((t (:height 1.0 :weight normal :slant normal :underline nil :box nil :foreground "#ffaa00" :underline nil))) t) ;; orange
     '(org-level-7 ((t (:height 1.0 :weight normal :slant normal :underline nil :box nil :foreground "#ff6666" :underline nil))) t) ;; red
     '(org-level-8 ((t (:height 1.0 :weight normal :slant normal :underline nil :box nil :foreground "#ff66aa" :underline nil))) t) ;; pink
     ;; '(org-block ((t (:foreground nil :background nil :inherit 'org-block-begin-line))) t)
     '(dired-subtree-depth-1-face ((t (:background "#23272e"))) t)
     '(dired-subtree-depth-2-face ((t (:background "#363d47"))) t)
     '(dired-subtree-depth-3-face ((t (:background "#4a5261"))) t)
     '(dired-subtree-depth-4-face ((t (:background "#5d687a"))) t)
     '(dired-subtree-depth-5-face ((t (:background "#717d94"))) t)
     '(dired-subtree-depth-6-face ((t (:background "#8493ad"))) t)
     '(ace-jump-face-foreground ((t (:background "color-18" :foreground "#ff8700" :weight bold))) t)
     '(avy-lead-face ((t (:foreground "#ffaf00"))) t)
     '(avy-lead-face-0 ((t (:foreground "#5fd7ff"))) t)
     '(avy-lead-face-1 ((t (:foreground "#66ffaa"))) t)
     '(avy-lead-face-2 ((t (:foreground "#ff6666"))) t)
     '(eyebrowse-mode-line-active ((t (:foreground "#ECBE7B" :weight bold))) t)
     '(flyspell-duplicate ((t (:underline "yellow" :weight bold))) t)
     '(flyspell-incorrect ((t (:underline "yellow" :weight bold))) t)
     ;; '(secondary-selection ((t (:foreground "#51afef" :background "#181e26"))) t)
     '(lsp-ui-doc-background ((t (:background "#42444a"))) t)
     '(term-color-black   ((t (:background "#303030" :foreground "#2d2d2d"))) t)
     '(term-color-blue    ((t (:background "#303030" :foreground "#6699cc"))) t)
     '(term-color-cyan    ((t (:background "#303030" :foreground "#66cccc"))) t)
     '(term-color-green   ((t (:background "#303030" :foreground "#99cc99"))) t)
     '(term-color-magenta ((t (:background "#303030" :foreground "#cc99cc"))) t)
     '(term-color-red     ((t (:background "#303030" :foreground "#f2777a"))) t)
     '(term-color-white   ((t (:background "#303030" :foreground "#f2f0ec"))) t)
     '(term-color-yellow  ((t (:background "#303030" :foreground "#ffcc66"))) t)

     '(line-number ((t (:weight normal :slant normal :inherit default))) t)
     '(line-number-current-line ((t (:inherit (hl-line default) :slant normal :weight normal))) t))
    (solaire-mode-swap-faces-maybe))

  (defun amd/doom-palenight-theme ()
    "load doom-palenight-theme"
    (interactive)
    (amd/disable-loaded-themes)
    (when (featurep 'airline-themes)
      (load-theme 'airline-base16_material_palenight t)
      ;; (custom-theme-set-faces
      ;;  'airline-base16_material_palenight
      ;;  '(tab-bar-tab-inactive ((t (:foreground "#32374D":background "#444267" :inherit))) t))
      )
    (load-theme 'doom-palenight)
    (custom-theme-set-faces
     'doom-palenight
     '(org-level-1 ((t (:inherit nil :height 1.0 :weight normal :slant normal :underline nil :box nil :foreground "#aa88ff" :background "#21272d" :underline nil :box (:line-width 4 :color "#21272d" :style nil)))) t)
     '(org-level-2 ((t (:inherit nil :height 1.0 :weight normal :slant normal :underline nil :box nil :foreground "#88aaff" :background "#21272d" :underline nil :box (:line-width 4 :color "#21272d" :style nil)))) t)
     '(org-level-3 ((t (:inherit nil :height 1.0 :weight normal :slant normal :underline nil :box nil :foreground "#88ffff" :underline nil))) t) ;; cyan
     '(org-level-4 ((t (:inherit nil :height 1.0 :weight normal :slant normal :underline nil :box nil :foreground "#66ffaa" :underline nil))) t) ;; sea-green
     '(org-level-5 ((t (:inherit nil :height 1.0 :weight normal :slant normal :underline nil :box nil :foreground "#ffff66" :underline nil))) t) ;; yellow
     '(org-level-6 ((t (:inherit nil :height 1.0 :weight normal :slant normal :underline nil :box nil :foreground "#ffaa00" :underline nil))) t) ;; orange
     '(org-level-7 ((t (:inherit nil :height 1.0 :weight normal :slant normal :underline nil :box nil :foreground "#ff6666" :underline nil))) t) ;; red
     '(org-level-8 ((t (:inherit nil :height 1.0 :weight normal :slant normal :underline nil :box nil :foreground "#ff66aa" :underline nil))) t) ;; pink
     ))
  )

;;; catppuccin-theme

(use-package catppuccin-theme
  :custom
  ;; Dark
  (catppuccin-flavor 'mocha)        ;; High contrast
  ;; (catppuccin-flavor 'macchiato) ;; Low contrast
  ;; Light
  ;; (catppuccin-flavor 'frappe)    ;; High contrast
  ;; (catppuccin-flavor 'latte)     ;; Low contrast

  :config
  (defun amd/catppuccin-theme ()
    "load catppuccin"
    (interactive)
    (amd/disable-loaded-themes)
    (load-theme 'catppuccin t)
    (custom-theme-set-faces
     'catppuccin
     '(ace-jump-face-foreground ((t (:background "color-18" :foreground "#ff8700" :weight bold))) t)
     '(avy-lead-face ((t (:foreground "#ffaf00"))) t)
     '(avy-lead-face-0 ((t (:foreground "#5fd7ff"))) t)
     '(avy-lead-face-1 ((t (:foreground "#66ffaa"))) t)
     '(avy-lead-face-2 ((t (:foreground "#ff6666"))) t))
    (when (featurep 'airline-themes)
      (load-theme 'airline-catppuccin_frappe t))))

(defun amd/tokyo-night-theme ()
  "load tokyo-night-theme"
  (interactive)
  (amd/disable-loaded-themes)
  (load-theme 'tokyo-night-moon t)
  (when (featurep 'airline-themes)
    (load-theme 'airline-catppuccin_frappe t)))

;;; modus themes

(defun amd/modus-light-theme ()
  "load modus-operandi and override some colors"
  (interactive)
  (amd/disable-loaded-themes)
  (load-theme 'modus-operandi t)
  (when (featurep 'airline-themes)
    (load-theme 'airline-qwq t)))

(defun amd/modus-dark-theme ()
  "load modus-vivendi and override some colors"
  (interactive)
  (amd/disable-loaded-themes)
  (load-theme 'modus-vivendi-tinted t)
  (custom-theme-set-faces
   'modus-vivendi
   '(font-lock-comment-face
     ((t (:weight normal :slant normal :inverse-video nil :foreground "#707070" :background "#000000" :inherit default))) t)
   '(line-number
     ((t (:weight normal :slant normal :inherit default))) t)
   '(line-number-current-line
     ((t (:weight normal :slant normal :inherit (hl-line default)))) t))
  (when (featurep 'airline-themes)
    (load-theme 'airline-ouo t)))

;;; Load Theme

(amd/disable-loaded-themes)
;; (load-theme 'doom-tokyo-night)
(amd/catppuccin-theme)

(provide 'amd/themes)
;;; themes.el ends here

;;; -*- lexical-binding: t; -*-

;;; appearance.el --- Summary
;;; Commentary:
;;; Code:

(use-package page-break-lines
  :disabled
  :diminish)

(use-package dashboard
  :disabled
  :diminish dashboard-mode
  :demand
  :custom-face
  (dashboard-heading ((t (:inherit (font-lock-string-face bold)))))
  (dashboard-items-face ((t (:weight normal))))
  (dashboard-no-items-face ((t (:weight normal))))
  :custom
  (dashboard-startup-banner 'ascii)
  ;;   (dashboard-banner-ascii "
  ;;  ╭──╮
  ;;   ¯╲ ╲
  ;;     ╲ ╲ Λ──Λ
  ;;      ╲ ( ˇωˇ)
  ;;      ╱   ──.
  ;;     ╱    ⋀ ╲
  ;;    ╱    ╱  ╲ ╲_
  ;;    │   ╱    ╰──╯
  ;;   ╱  ╱ ╲ per
  ;;  (  ( ╲ ╲ my
  ;;  │  │  ╲ ╲ last
  ;;  │  )   ╲ ╲  email
  ;;  | |     ) /
  ;; ╭╯_│     ╰/")
  (dashboard-page-separator "\n\f\n")
  (dashboard-projects-backend 'projectile)
  (dashboard-center-content t)
  (dashboard-vertically-center-content t)
  :init
  (setq dashboard-items
        '((projects . 5)
          (recents . 5)
          ;; (agenda . 5)
          (bookmarks . 5)))
  :general
  (:states '(emacs) :keymaps 'dashboard-mode-map
           "C-p" 'amd/counsel-git-or-file-jump
           "n" 'dashboard-next-line
           "e" 'dashboard-previous-line
           "N" 'dashboard-next-section
           "E" 'dashboard-previous-section)
  :config
  (add-hook 'dashboard-mode-hook 'page-break-lines-mode)
  (dashboard-setup-startup-hook))

;;; ** appearance minor-modes
;; Setup a list of major-modes to load appearance minor-modes. ~eval-and-compile~
;; is used so the list is accessible inside use-package definitions.

(eval-and-compile
  (setq amd/appearance-modes nil)
  (setq amd/appearance-mode-hooks
        '(awk-mode-hook
          c++-mode-hook
          c-mode-common-hook
          emacs-lisp-mode-hook
          js2-mode-hook
          latex-mode-hook
          lua-mode-hook
          makefile-mode
          python-mode-hook
          ruby-mode-hook
          rust-mode-hook
          sh-mode-hook)))

(defun amd/add-appearance-mode (mode-to-add)
  "Add MODE-TO-ADD to all hooks defined in amd/appearance-mode-hooks."
  (add-to-list 'amd/appearance-modes mode-to-add)
  (cl-loop for this-mode in amd/appearance-mode-hooks
           collect (add-hook this-mode mode-to-add)))

;; manually run appearance modes
(defun amd/set-appearance-modes ()
  "Manually run preffered appearance modes."
  (interactive)
  (cl-loop for this-mode in amd/appearance-modes
           do (funcall this-mode 1)))

;;; hl-line
;; Highlight the current line using the built-in ~hl-line-mode~.
(use-package hl-line
  :config
  (amd/add-appearance-mode 'hl-line-mode))

(use-package fill-column-indicator
  ;; :init
  ;; (unless (or amd/using-pocketchip amd/using-android)
  ;;   (amd/add-appearance-mode 'fci-mode))
  :commands (fci-mode))

(use-package highlight-indent-guides
  :custom
  (highlight-indent-guides-method 'character)
  (highlight-indent-guides-responsive 'top)
  ;; (highlight-indent-guides-delay 3)
  (highlight-indent-guides-character ?\│))

(use-package display-line-numbers
  :custom
  (display-line-numbers-type t) ;; t=absolute 'relative 'visual
  (display-line-numbers-current-absolute t))

(use-package color-identifiers-mode ;; the package is actually called "color-identifiers-mode" with -mode at the end
  :commands (color-identifiers-mode)
  :diminish color-identifiers-mode
  :init
  (amd/add-appearance-mode 'color-identifiers-mode)
  :config
  (add-to-list
   'color-identifiers:modes-alist
   `(lua-mode . (""
                 "\\_<\\([a-zA-Z_$]\\(?:\\s_\\|\\sw\\)*\\)"
                 (nil font-lock-variable-name-face tree-sitter-hl-face:variable))))
  (setq color-identifiers:num-colors 16))

(use-package rainbow-delimiters
  :commands (rainbow-delimiters-mode)
  :init
  (amd/add-appearance-mode 'rainbow-delimiters-mode))

(provide 'amd/appearance)
;;; appearance.el ends here

;;; -*- lexical-binding: t; -*-

;;; emacs.el --- Summary
;;; Commentary:
;;; Code:

;;; emacs settings:
(use-package emacs
  :init
  ;; Startup buffer
  (setq initial-buffer-choice nil
        ;; nil      = emacs startup screen
        ;; t        = Open *scratch* buffer
        ;; function = call and display returned buffer
        ;; string   = open file or directory
        inhibit-startup-message t
        inhibit-startup-screen t)

  ;; Start Maximized
  ;; (add-to-list 'default-frame-alist '(fullscreen . maximized))

  ;; leader key
  (setq amd/leader-key ",")
  (setq amd/leader-key-insert "C-,")

  ;; Echo unfinished keystrokes after 0.2 seconds.
  (setq echo-keystrokes 0.2)

  (setq ring-bell-function (lambda ()))
  (setq recenter-redisplay nil) ;; don't redraw the whole display when recentering

  ;; NOTE: Setting the default here seems to override settings like git-commit-fill-column 70
  ;; (setq-default fill-column 80)

  ;; Get auto line breaks at fill-column - auto-fill-mode
  ;; (add-hook 'text-mode-hook 'turn-on-auto-fill)
  ;; NOTE: toggle-truncate-lines will toggle line wrapping

  ;; Hide the \ at the end of each wrapped line. Don't need it with relative-line-numbers
  (set-display-table-slot standard-display-table 'wrap ?\ )

  ;; Save Tempfiles in ~/.config/emacs/tmp
  (setq backup-directory-alist `(("." . ,(expand-file-name "tmp/" user-emacs-directory)))
        auto-save-file-name-transforms `((".*" ,(expand-file-name "tmp/" user-emacs-directory) t)))

  ;; Stop making backup files
  (setq make-backup-files nil)

  (defalias 'yes-or-no-p 'y-or-n-p) ;; no more typing out y.e.s.

  ;; (set-default 'show-trailing-whitespace t)
  (setq delete-trailing-lines nil)

  ;; Indentation
  (setq-default c-basic-indent 2)
  (setq-default tab-width 2)          ;; set tw=4
  (setq-default indent-tabs-mode nil) ;; set expandtab

  ;; Mouse scrolling
  ;; Scroll just one line when hitting bottom of window
  (setq scroll-step 1)
  (setq scroll-conservatively 101)

  (setq mouse-wheel-scroll-amount '(5 ((shift) . 1)) ;; 5 lines at a time
        mouse-wheel-progressive-speed nil ;; don't accelerate scrolling
        mouse-wheel-follow-mouse 't)      ;; scroll window under mouse

  ;; (setq mouse-wheel-flip-direction nil) ;; Swap left/right scroll direction

  ;; Swap up/down scroll direction
  ;; (setq mouse-wheel-down-event 'wheel-up)
  ;; (setq mouse-wheel-up-event 'wheel-down)

  ;; cursor movement lag reduction?
  (setq auto-window-vscroll nil)

  ;; Mac OSX Emacs Settings
  (setq ns-alternate-modifier 'meta
        ns-command-modifier 'meta)

  ;; UTF8 Setup
  (set-language-environment 'utf-8)
  (setq locale-coding-system 'utf-8)

  ;; set the default encoding system
  (prefer-coding-system 'utf-8)
  (setq default-file-name-coding-system 'utf-8)
  (set-default-coding-systems 'utf-8)
  (set-terminal-coding-system 'utf-8)
  (set-keyboard-coding-system 'utf-8)

  (setq buffer-file-coding-system 'utf-8)

  ;; Treat clipboard input as UTF-8 string first; compound text next, etc.
  (setq x-select-request-type '(UTF8_STRING COMPOUND_TEXT TEXT STRING))

  ;; Enable narrowing and erasing buffers
  (put 'narrow-to-region 'disabled nil)
  (put 'erase-buffer 'disabled nil)

  ;; Prevent ffap from Pinging Hostnames
  (setq ffap-machine-p-known 'reject)

  ;; Save the existing clipboard content into the kill ring before overwriting it
  (setq save-interprogram-paste-before-kill t)

  ;; No Duplicates in the Kill Ring
  (setq kill-do-not-save-duplicates t)

  ;; Don’t Render Cursors in Non-Focused Windows
  (setq-default cursor-in-non-selected-windows nil)
  (setq highlight-nonselected-windows nil)

  (defun amd/tangle-init ()
    "Manually copy code from README.org into README.el."
    (interactive)
    (require 'ob-tangle)
    (org-babel-tangle-file "~/.emacs.d/README.org" "~/.emacs.d/README.el" "emacs-lisp"))

  (defun amd/take-svg-screenshot ()
    "Take a screenshot and save as an svg (requires cairo support)."
    (interactive)
    (let ((screenshot-filename (format-time-string
                                "%Y-%m-%d-%H%M%S-emacs.svg"
                                (current-time))))
      (with-temp-buffer
        (insert (x-export-frames nil 'svg))
        (write-region (point-min) (point-max)
                      (concat
                       (expand-file-name "~/Pictures/") screenshot-filename)))))

  ;; Default font size and name
  (setq amd/font-size (cond
                       ((eq system-type 'gnu/linux) 15.0)
                       ((eq system-type 'darwin) 22.0)
                       (t 18.0))
        amd/font-name "PragmataPro"
        amd/font-antialias t)

  (defun amd/set-font (&optional fsize fname antialias)
    "Set preferred GUI font."
    (interactive)
    (when (display-graphic-p)
      ;; Update amd/font-* variables
      (when fsize
        (setq amd/font-size fsize))
      (when fname
        (setq amd/font-name fname))
      (when antialias
        (setq amd/font-antialias
              (if (eq 'yes antialias)
                  t
                nil)))

      ;; (format amd/font-name amd/font-size)
      (let ((fspec (font-spec :family amd/font-name :size (float amd/font-size) :antialias amd/font-antialias)))
        (set-frame-font fspec)
        ;; This doesn't work when launching emacs for some reason.
        ;; (add-to-list 'default-frame-alist `(font . ,fspec))
        )

      ;; Determine a good powerline height
      (setq amd/font-dpi 96) ;; default dpi assumption
      ;; query xrdb for existing xft dpi
      (when (eq system-type 'gnu/linux)
        (let ((xrdb-dpi
               (string-to-number
                (shell-command-to-string "xrdb -query | grep -i Xft.dpi | cut -f 2"))))
          (if (> xrdb-dpi 0)
              (setq amd/font-dpi xrdb-dpi))))
      ;; Formula: points = pixels * 72 / dpi
      (setq powerline-height
            (floor (* 2.0
                      ;; pixel height from dpi and pt size
                      (* (/ amd/font-dpi 72.0) amd/font-size))))))

  ;; Emacs 28: Hide commands in M-x which do not work in the current mode.
  ;; Vertico commands are hidden in normal buffers.
  ;; (setq read-extended-command-predicate
  ;;       #'command-completion-default-include-p)

  ;; Default modeline with repeated dashes removed in terminal mode.
  (setq
   mode-line-format
   '("%e"
     " " ;; mode-line-front-space
     mode-line-mule-info
     mode-line-client
     mode-line-modified
     mode-line-remote
     mode-line-window-dedicated
     mode-line-frame-identification
     mode-line-buffer-identification
     "   "
     mode-line-position
     evil-mode-line-tag
     (project-mode-line project-mode-line-format)
     (vc-mode vc-mode)
     "  "
     mode-line-modes
     mode-line-misc-info
     ;; mode-line-end-spaces
     ))

  :custom
  ;; START vertico recommended config
  ;; Enable context menu. `vertico-multiform-mode' adds a menu in the minibuffer
  ;; to switch display modes.
  (context-menu-mode t)
  ;; Support opening new minibuffers from inside existing minibuffers.
  (enable-recursive-minibuffers t)
  ;; Hide commands in M-x which do not work in the current mode.  Vertico
  ;; commands are hidden in normal buffers. This setting is useful beyond
  ;; Vertico.
  (read-extended-command-predicate #'command-completion-default-include-p)
  ;; Do not allow the cursor in the minibuffer prompt
  (minibuffer-prompt-properties
   '(read-only t cursor-intangible t face minibuffer-prompt))
  ;; END vertico recommended config

  :config
  ;; Erase trailing whitespace before save
  (add-hook 'before-save-hook 'delete-trailing-whitespace)

  ;; chmod +x scripts that start with #!
  (add-hook 'after-save-hook
            #'executable-make-buffer-file-executable-if-script-p)

  (when (memq window-system '(mac ns))
    (exec-path-from-shell-initialize))

  ;; Mouse scrolling
  (if (display-graphic-p)
      ;; Use smooth scrolling in gui mode
      (progn
        (pixel-scroll-precision-mode))
    ;; Enable mouse events in terminal mode
    (progn
      (require 'mouse)
      (xterm-mouse-mode t)))

  ;; Hide tool, scroll and menu bar
  (when (fboundp 'tool-bar-mode) (tool-bar-mode -1))
  (when (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))
  (menu-bar-mode -1)

  ;; Examples of setting a font with antialias on or off:
  ;; set-frame-font :size <int>pixel size <float>point size
  ;;
  ;; (set-frame-font (font-spec :name "PragmataPro" :antialias nil :size amd/font-size :weight 'regular))
  ;; (set-frame-font (font-spec :name "Iosevka Term SS17 Light" :antialias t :size 16.0))
  ;; (set-frame-font (font-spec :name "CozetteVector" :antialias nil :size 26.0))

  ;; Set gui font
  (when (display-graphic-p)
    (cond
     ((member "PragmataPro" (font-family-list))
      (amd/set-font amd/font-size "PragmataPro"))
     ((member "Iosevka SS08" (font-family-list))
      (amd/set-font amd/font-size "Iosevka SS08 Light"))
     ((member "Iosevka SS17" (font-family-list))
      (amd/set-font amd/font-size "Iosevka SS17 Light"))
     (t
      (amd/set-font))))
  )

;;; Built in packages

;;; autorevert
(use-package autorevert
  :diminish auto-revert-mode)

;;; recentf
(use-package recentf
  :custom
  ;; (recentf-auto-cleanup 300)
  (recentf-max-menu-items 30)
  :config
  (recentf-mode 1))

;;; re-builder
;; [[info:emacs#Regexps][info:emacs#Regexps]]
(use-package re-builder
  :init
  (setq reb-re-syntax 'string))

;;; saveplace
(use-package saveplace
  :config
  (save-place-mode)
  ;; Recenter when opening a file.
  ;; TODO: make this work when in an org-src buffer
  ;; (defadvice find-file (after advice-for-find-file activate) (recenter))
  (defun amd/find-file--recenter-around (orig-fun &rest args)
    (apply orig-fun args)
    (recenter))
  (advice-add 'find-file :around #'amd/find-file--recenter-around)
  )

;;; savehist: save minibuffer history
(use-package savehist
  :custom
  (savehist-autosave-interval 150)
  :config
  (savehist-mode))

;;; desktop-save: - save buffers, windows, and tabs between sessions
(use-package desktop
  :custom
  (desktop-auto-save-timeout 30)
  ;; :config
  ;; (desktop-save-mode 1)
  )

(provide 'amd/emacs)
;;; emacs.el ends here

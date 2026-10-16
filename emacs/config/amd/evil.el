;;; -*- lexical-binding: t; -*-

;;; evil.el --- Summary
;;; Commentary:
;;; Code:

(use-package general
  ;; :config
  ;; (general-auto-unbind-keys t)
  :demand)

(use-package vundo
  :init
  (setq vundo-window-side 'bottom)
  (setq vundo-window-max-height 3)
  (setq vundo-glyph-alist
        vundo-ascii-symbols
        ;; vundo-unicode-symbols
        ;; '((selected-node . ?♦)
        ;;   (node . ?♢)
        ;;   (horizontal-stem . ?─)
        ;;   (vertical-stem . ?│)
        ;;   (branch . ?├)
        ;;   (last-branch . ?└))
        )
  :bind ("C-x u" . vundo)
  :config
  (add-to-list 'evil-emacs-state-modes 'vundo-mode)
  (add-to-list 'evil-emacs-state-modes 'vundo-diff-mode))

(use-package evil
  :demand
  ;; :after undo-tree
  :custom
  ;; (evil-undo-system 'undo-tree)
  (evil-undo-system 'undo-redo) ;; for vundo
  (x-select-enable-clipboard t)
  (x-select-enable-clipboard-manager nil)
  (evil-regexp-search t)  ;; Whether to use regular expressions for searching.
  (evil-echo-state nil)  ;; Whether to signal the current state in the echo area.
  (evil-auto-balance-windows nil)  ;; If non-nil window creation and deletion trigger rebalancing.
  (evil-flash-delay .5) ;; Time in seconds to flash search matches after M-x evil-search-next and M-x evil-search-previous.
  (evil-want-fine-undo 'no) ;; All changes made during insert state, including a possible delete after a change operation, are collected in a single undo step.
  (evil-want-C-i-jump 'yes)
  (evil-want-C-u-scroll 'yes)

  ;; Make sure C-w is not a prefix key
  (evil-want-C-w-delete nil)
  (evil-want-C-w-in-emacs-state 'yes)
  (evil-move-cursor-back nil)         ;; Don't move back one charachter when exiting insert
  (evil-search-module 'evil-search)   ;; Need to set this before loading evil and evil-visualstar
  :init

  ;; Make mouse wheel use evil mode C-d and C-u
  (setq mwheel-scroll-down-function 'evil-scroll-down
        mwheel-scroll-up-function 'evil-scroll-up)

  (when amd/using-android ;; don't use the system clipboard
    (setq x-select-enable-clipboard nil))

  (setq-default evil-symbol-word-search t) ;; make * and # search for symbols (instead of words)

  ;; join inner paragraph macro
  (fset 'macro-join-inner-paragraph "vipJ^")
  (fset 'macro-join-inner-paragraph-reflow "vipJVgq^")
  (fset 'key-colon-to-as
        (lambda (&optional arg)
          "Keyboard macro."
          (interactive "p")
          (kmacro-exec-ring-item (quote ([94 100 102 58 36 65 32 97 115 32 escape 112 65 127 44 escape] 0 "%d")) arg)))

  :general
  (:states '(motion)
   ;; hlne movement
   "n" 'evil-next-line
   "e" 'evil-previous-line
   ;; swiper
   ;; "/" 'swiper
   "C-/" 'swiper
   "C-_" 'swiper  ;; C-/ registers as C-_ in the terminal
   ;; search using isearch
   ;; "/" 'evil-search-forward
   ;; "k" 'evil-search-next
   ;; "K" 'evil-search-previous
   ;; search using evil's search module
   "/" 'evil-ex-search-forward
   "g /" 'evil-ex-search-forward
   "k" 'evil-ex-search-next
   "K" 'evil-ex-search-previous
   ;; swap * and # to backward and forward respectively
   "*" (lambda () (interactive) (swiper (format "%s" (thing-at-point 'symbol t))))
   ;; "#" (lambda () (interactive) (swiper (format "%s" (thing-at-point 'symbol t))))
   ;; "*" (lambda () (interactive) (swiper (format "\\<%s\\>" (thing-at-point 'symbol t))))
   "#" (lambda () (interactive) (swiper (format "\\<%s\\>" (thing-at-point 'symbol t))))
   ;; "*"   'evil-ex-search-word-backward
   ;; "#"   'evil-ex-search-word-forward
   "g *" 'evil-ex-search-unbounded-word-backward
   "g #" 'evil-ex-search-unbounded-word-forward)

  (:states '(normal)
   ;; "-" 'amd/dired-at-buffer-location
   "C-s" 'save-buffer
   "C-p" 'amd/counsel-git-or-file-jump
   "C-M-c" 'amd/split-compilation
   "g j" 'amd/join-to-end-of-next-line
   "g s" 'count-words
   "g W" 'macro-join-inner-paragraph
   "g r" 'macro-join-inner-paragraph-reflow
   "C-l" (lambda() (interactive) (evil-ex-nohighlight) (redraw-display))
   "C-e" 'move-line-up
   "C-n" 'move-line-down)

  (:states '(visual)
   "C-e" 'evil-move-lines-up
   "C-n" 'evil-move-lines-down)
  ;; (:states '(insert motion visual emacs)
  ;;  :prefix "C-w"
  ;;  "" nil)

  (:states '(insert)
   "C-s" (lambda() (interactive) (save-buffer) (evil-normal-state))
   ;; "C-y" 'counsel-yank-pop
   "C-y" 'consult-yank-pop
   "M-t" 'consult-buffer
   "M-b" 'ibuffer
   "C-x C-l" 'evil-complete-previous-line
   ;; The C-w insert bindings require 'evil-want-C-w-delete nil
   "C-w c" 'evil-window-delete
   "C-w o" 'delete-other-windows
   "C-b" 'yankpad-insert ;; Was evil-scroll-page-up
   amd/leader-key-insert 'amd/transient-leader-menu)

  (:states '(motion visual)
   "RET" 'evil-ex ;; Enter opens : prompt
   ";" 'evil-ex)  ;; semicolon also enters : prompt

  (:states '(motion visual emacs)
   "C-w m" 'evil-window-set-height
   "M-t" 'consult-buffer
   "M-T" 'counsel-ibuffer
   "M-b" 'ibuffer
   "M-d" (lambda() (interactive) (dired-other-window (projectile-project-root)))
   "M-D" (lambda() (interactive) (dired-jump t))
   amd/leader-key 'amd/transient-leader-menu)

  (:states '(motion emacs)
   "C-M-c" 'amd/split-compilation
   "C-w N" 'evil-window-move-very-bottom
   "C-w E" 'evil-window-move-very-top
   "C-w H" 'evil-window-move-far-left
   "C-w L" 'evil-window-move-far-right
   "C-w u" 'winner-undo
   "C-w d" 'winner-redo)

  :config
  ;; (add-hook 'evil-local-mode-hook 'turn-on-undo-tree-mode)
  (evil-mode 1)

  (setopt
   evil-emacs-state-tag " EMACS "
   evil-normal-state-tag " NORMAL "
   evil-motion-state-tag " MOTION "
   evil-insert-state-tag " INSERT "
   evil-visual-state-tag " VISUAL "
   evil-replace-state-tag " REPLACE "
   evil-operator-state-tag " OPERATOR ")

  ;; (defun amd/get-inner-symbol ()
  ;;   (interactive)
  ;;   ;; (message "%s" (evil-inner-symbol 1)
  ;;   (message "%s" (thing-at-point 'symbol))
  ;; ))

  ;; put the current line at the end of the next line
  (defun amd/join-to-end-of-next-line ()
    (interactive)
    (move-line-down) (join-line))

  ;; ESC changes

  ;; NOTE: ESC is Meta inside a terminal

  (global-unset-key (kbd "ESC ESC ESC"))
  (global-unset-key (kbd "ESC ESC"))

  (defun amd/minibuffer-keyboard-quit ()
    "Abort recursive edit. In Delete Selection mode, if the mark is active, just deactivate it; then it takes a second \\[keyboard-quit] to abort the minibuffer."
    (interactive)
    (if (and delete-selection-mode transient-mark-mode mark-active)
        (setq deactivate-mark  t)
      (when (get-buffer "*Completions*") (delete-windows-on "*Completions*"))
      (abort-recursive-edit)))

  (define-key evil-normal-state-map           [escape] 'keyboard-quit)
  (define-key evil-visual-state-map           [escape] 'keyboard-quit)
  (define-key evil-emacs-state-map            [escape] 'keyboard-quit)
  (define-key minibuffer-local-map            [escape] 'amd/minibuffer-keyboard-quit)
  (define-key minibuffer-local-ns-map         [escape] 'amd/minibuffer-keyboard-quit)
  (define-key minibuffer-local-completion-map [escape] 'amd/minibuffer-keyboard-quit)
  (define-key minibuffer-local-must-match-map [escape] 'amd/minibuffer-keyboard-quit)
  (define-key minibuffer-local-isearch-map    [escape] 'amd/minibuffer-keyboard-quit)

  ;; TODO: this is failing with wrong number of arguments
  ;; Center Screen on search hit
  ;; (advice-add 'evil-ex-search-word-forward            :after #'recenter)
  ;; (advice-add 'evil-ex-search-word-backward           :after #'recenter)
  ;; (advice-add 'evil-ex-search-unbounded-word-forward  :after #'recenter)
  ;; (advice-add 'evil-ex-search-unbounded-word-backward :after #'recenter)
  ;; (advice-add 'evil-ex-search-next                    :after #'recenter)
  ;; (advice-add 'evil-ex-search-previous                :after #'recenter)

  ;; TODO: this is failing with wrong number of arguments
  ;; (advice-add 'evil-jump-forward  :after #'recenter)
  ;; (advice-add 'evil-jump-backward :after #'recenter)

  (add-to-list 'evil-emacs-state-modes 'dashboard-mode)
  (add-to-list 'evil-emacs-state-modes 'dired-mode)
  (add-to-list 'evil-emacs-state-modes 'magit-popup-mode)
  (add-to-list 'evil-emacs-state-modes 'makey-key-mode)

  (add-to-list 'evil-normal-state-modes 'git-commit-mode)

  (add-to-list 'evil-motion-state-modes 'package-menu-mode)
  (add-to-list 'evil-motion-state-modes 'paradox-menu-mode)
  (add-to-list 'evil-motion-state-modes 'flycheck-error-list-mode)

  (add-to-list 'evil-motion-state-modes 'help-mode)
  (add-to-list 'evil-motion-state-modes 'compilation-mode)
  (add-to-list 'evil-motion-state-modes 'woman-mode)
  (add-to-list 'evil-motion-state-modes 'Info-mode)

  (add-to-list 'evil-normal-state-modes 'eww-mode)
  (add-to-list 'evil-normal-state-modes 'Custom-mode)

  ;; Recenter after using history back or forward in Info mode (C-o or TAB).
  ;; (defadvice Info-history-back (after advice-for-Info-history-back activate) (recenter))
  ;; (defadvice Info-history-forward (after advice-for-Info-history-forward activate) (recenter))
  (advice-add 'Info-history-back :after #'recenter)
  (advice-add 'Info-history-forward :after #'recenter)

  (defun paste-other-window (beg end other-buffer-window-name)
    (let ((current-file-window (selected-window))
          (current-file-path   (buffer-file-name (current-buffer)))
          (text                (buffer-substring-no-properties beg end))
          (other-window        (get-buffer-window other-buffer-window-name)))
      (when sql-buffer
        (select-window other-window)
        (goto-char (point-max))
        (insert text)
        (comint-send-input)
        (select-window current-file-window))))

  (evil-define-operator paste-to-sql (beg end type)
    "Evil operator for pasting text to another buffer."
    :move-point nil
    (interactive "<R>")
    (paste-other-window beg end "*SQL*"))

  (evil-define-key 'motion (current-global-map)
    (kbd "g p s") 'paste-to-sql)

  (evil-declare-not-repeat 'outline-next-heading)
  (evil-declare-not-repeat 'outline-previous-heading)
  )

;; (use-package evil-visualstar
;;   :config
;;   (global-evil-visualstar-mode 1))

(use-package evil-surround
  :after evil
  :config
  (global-evil-surround-mode 1)
  (add-hook
   'web-mode-hook
   (lambda ()
     (add-to-list 'evil-surround-pairs-alist '(?h . ("{{ " . " }}"))  )
     (add-to-list 'evil-surround-pairs-alist '(?= . ("<%= " . " %>")) )
     (add-to-list 'evil-surround-pairs-alist '(?- . ("<% "  . " %>")) ))))

(use-package evil-matchit
  :after evil
  :config
  (global-evil-matchit-mode 1))

(use-package evil-commentary
  :after evil
  :diminish
  :config
  (evil-commentary-mode))

;; (use-package pico8
;;   :after evil
;;   :load-path "pico8")

(use-package evil-case-operators
  :after evil
  :config
  (global-evil-case-operators-mode 1))

;; useful find-replaces
;; s/\([^ \n]\)  */\1 /g

(use-package expand-region
  :after evil
  :general
  (:states '(normal)
    "ge" 'er/expand-region))

(provide 'amd/evil)
;;; evil.el ends here

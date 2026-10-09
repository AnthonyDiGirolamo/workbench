;;; -*- lexical-binding: t; -*-

;;; help.el --- Summary
;;; Commentary:
;;; Code:

(use-package which-key
  :demand
  :diminish
  :custom
  (which-key-separator " → ") ;; »
  (which-key-ellipsis "") ;; "…"
  (which-key-idle-delay 0.5)
  (which-key-popup-type 'side-window)
  (which-key-side-window-location 'bottom)
  (which-key-echo-keystrokes 0.2)
  (which-key-show-prefix 'echo)
  :config
  (which-key-mode 1))

(use-package info-mode
  :general
  (:states '(motion) :keymaps '(Info-mode-map)
    amd/leader-key 'amd/transient-leader-menu
    "M-n" 'tmux-window-navigation/move-down ;; was clone-buffer
    "f"   'ace-link-info
    "gg"  'evil-goto-first-line
    "TAB" 'Info-history-forward
    "C-o" 'Info-history-back
    "RET" 'Info-follow-nearest-node
    ;; Not sure why these need redefining here and are not inherited
    ;; from evil default motion map.
    "C-l" (lambda() (interactive) (evil-ex-nohighlight) (redraw-display))
    "w"   'evil-forward-word-begin
    "b"   'evil-backword-word-begin
    "n"   'evil-next-line
    "e"   'evil-previous-line
    "k" 'evil-ex-search-next
    "K" 'evil-ex-search-previous
    "q"   'Info-exit)
  :init
  :config)

(use-package helpful
  :bind (("C-h v"   . helpful-variable)
         ("C-h C-v" . helpful-variable)
         ("C-h f"   . helpful-function)
         ("C-h C-f" . helpful-function)
         ("C-h s"   . helpful-symbol))
  :init
  :config
  ;; (ivy-set-actions
  ;;  'counsel-M-x
  ;;  '(("d" counsel--find-symbol "definition")
  ;;    ("h" (lambda (x) (helpful-function (intern x))) "helpful")))
  (add-to-list 'evil-motion-state-modes 'helpful-mode)
  (add-to-list 'evil-motion-state-modes 'elisp-refs-mode))

(provide 'amd/help)
;;; help.el ends here

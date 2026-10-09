;;; -*- lexical-binding: t; -*-

;;; searching.el --- Summary
;;; Commentary:
;;; Code:

(use-package swiper
  ;; :disabled
  :diminish ivy-mode
  :general
  (:keymaps '(ivy-minibuffer-map)
    "<escape>" 'minibuffer-keyboard-quit
    "C-e" 'previous-line
    "C-u" 'ivy-scroll-down-command
    "C-d" 'ivy-scroll-up-command
    ;; "C-n" 'next-line  ;; this is the default
    "<C-return>" 'ivy-alt-done
    "<C-M-return>" 'ivy-immediate-done)
  (:states '(motion)
   :keymaps '(ivy-occur-grep-mode-map)
    "M-n" 'tmux-window-navigation/move-down ;; was compilation-next-error
    "C-d" 'evil-scroll-down
    "C-u" 'evil-scroll-up
    "gg" 'evil-goto-first-line
    "G" 'evil-goto-line
    "k" 'evil-ex-search-next
    "n" 'ivy-occur-next-line
    "e" 'ivy-occur-previous-line
    "RET" 'ivy-occur-press-and-switch
    "N" 'next-error-no-select
    "E" 'previous-error-no-select)
  (:states '(motion)
   :keymaps '(grep-mode-map)
    "M-n" 'tmux-window-navigation/move-down ;; was compilation-next-error
    "C-d" 'evil-scroll-down
    "C-u" 'evil-scroll-up
    "gg" 'evil-goto-first-line
    "G" 'evil-goto-line
    "k" 'evil-ex-search-next
    "n" 'evil-next-line
    "e" 'evil-previous-line
    "N" 'next-error-no-select
    "E" 'previous-error-no-select)

  :config
  (add-to-list 'evil-normal-state-modes 'ivy-occur-grep-mode)
  (add-to-list 'evil-normal-state-modes 'grep-mode)
  ;; Enable ivy for all completions
  ;; (ivy-mode 1)

  (defun amd/update-evil-search (&optional arg1 &rest args)
    "Update evil search pattern history with the last swiper regex."
    ;; recenter after hitting RET from swiper is jarring.
    ;; (recenter)
    (let ((count 1)
          (direction 'forward)
          (regex (ivy--regex ivy-text)))
      ;; This bit is mostly taken from evil-ex-start-word-search
      (setq evil-ex-search-count count
            evil-ex-search-direction direction
            evil-ex-search-pattern (evil-ex-make-search-pattern regex)
            evil-ex-search-offset nil
            evil-ex-last-was-search t)
      ;; update search history unless this pattern equals the previous pattern
      (unless (equal (car-safe evil-ex-search-history) regex)
        (push regex evil-ex-search-history))
      (evil-push-search-history regex (eq direction 'forward))
      ;; set the highlight
      (evil-ex-search-activate-highlight evil-ex-search-pattern)))

  ;; TODO: update swiper history after evil-ex-search
  (advice-add 'swiper                 :after #'amd/update-evil-search)
  (advice-add 'counsel-git-grep       :after #'amd/update-evil-search)
  (advice-add 'counsel-grep           :after #'amd/update-evil-search)
  (advice-add 'counsel-grep-or-swiper :after #'amd/update-evil-search))

(use-package wgrep)

(provide 'amd/searching)
;;; searching.el ends here

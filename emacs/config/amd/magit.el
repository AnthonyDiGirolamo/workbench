;;; -*- lexical-binding: t; -*-

;;; magit.el --- Summary
;;; Commentary:
;;; Code:

(use-package ediff
  :init
  (setq ediff-split-window-function 'split-window-horizontally))

(use-package magit
  :defer t
  :custom
  (magit-section-initial-visibility-alist
   '((stashes . hide) (untracked . hide) (unpushed . show)))
  (magit-diff-expansion-threshold 10.0)
  (magit-commit-show-diff nil)
  (magit-status-goto-file-position t)
  ;; use c-j to jump to live file from magit-status. Or set this:
  ;; (magit-diff-visit-prefer-worktree t)
  :init
  (setq git-commit-fill-column 70)
  :general
  ;; (:keymaps '(magit-popup-mode-map)
  ;;  amd/leader-key 'amd/quit-magit-and-leader)
  (:keymaps '(magit-log-mode-map
              magit-diff-mode-map
              magit-process-mode-map
              magit-status-mode-map)
   "C-d" 'evil-scroll-down
   "C-u" 'evil-scroll-up
   "C-p" 'amd/counsel-git-or-file-jump
   "e" 'magit-section-backward
   "p" nil) ;; hit E for ediff popup instead

  :config
  ;; (evil-define-minor-mode-key 'emacs 'magit-popup-mode [escape] 'magit-popup-quit)

  ;; (defun amd/quit-magit-and-leader ()
  ;;   "Quit Magit Popup and display leader menu."
  ;;   (interactive)
  ;;   (magit-popup-quit)
  ;;   (hydra-leader-menu/body))

  (defun amd/magit-instant-commit ()
    (interactive)
    (magit-commit (list "-a" "-m" "instant-update"))
    (magit-push-current-to-upstream)))

(provide 'amd/magit)
;;; magit.el ends here

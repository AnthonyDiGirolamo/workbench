;;; -*- lexical-binding: t; -*-

;;; dired.el --- Summary
;;; Commentary:
;;; Code:

(use-package dired
  :custom
  ;; Suggest locations for operations, ie midnight commander style copy if another window is open.
  (dired-dwim-target t)
  ;; Auto refresh dired, but be quiet about it
  (dired-auto-revert-buffer t)
  ;; (setq global-auto-revert-non-file-buffers t)
  (auto-revert-verbose nil)
  ;; Always copy/delete recursively
  (dired-recursive-copies 'always)
  (dired-recursive-deletes 'top)
  :init
  (put 'dired-find-alternate-file 'disabled nil)
  (setq wdired-allow-to-change-permissions t)
  (setq insert-directory-program
        (or (executable-find "gls")
            (executable-find "ls")))

  :general
  (:states '(normal)
           ;; global binding like vim vinegar
           "-" 'amd/dired-at-buffer-location)
  (:states '(emacs)
           :keymaps 'dired-mode-map
           ;; "f" 'dired-find-file ;; default
           ;; "a" 'dired-find-alternate-file ;; default - open a file in the same buffer and close dired
           "RET" 'amd/dired-open-thing
           "C-p" 'amd/counsel-git-or-file-jump
           "C-l" (lambda() (interactive) (revert-buffer) (evil-ex-nohighlight) (recenter))
           "gr" 'revert-buffer
           "gg" 'evil-goto-first-line
           "C-d" 'evil-scroll-down
           "C-u" 'evil-scroll-up
           "gd" 'ora-ediff-files
           "G" 'evil-goto-line
           "/" 'swiper
           "C-/" 'swiper
           ;; default dired-writable mode is C-x C-q
           ;;   press C-c C-c to commit
           "C-c C-w" 'dired-toggle-read-only
           ;; colemak keys
           "h" 'left-char
           "l" 'right-char
           "-" 'dired-up-directory
           "(" 'dired-hide-details-mode
           ")" 'dired-omit-mode
           "e" 'dired-previous-line
           "N" 'dired-next-dirline
           "E" 'dired-prev-dirline)
  :config
  (defun amd/dired-at-buffer-location ()
    (interactive)
    (if buffer-file-name
        (dired (file-name-parent-directory buffer-file-name))
      (dired default-directory)))

  (defun amd/dired-open-thing ()
    "If file at point is a directory open a dired buffer in the same window. Else open in a new window."
    (interactive)
    ;; (if (file-directory-p (dired-get-filename nil t))
    ;;     (dired-find-alternate-file)
    ;;   (dired-find-file-other-window))
    (dired-find-file))

  (defun ora-ediff-files ()
    (interactive)
    (let ((files (dired-get-marked-files))
          (wnd (current-window-configuration)))
      (if (<= (length files) 2)
          (let ((file1 (car files))
                (file2 (if (cdr files)
                           (cadr files)
                         (read-file-name
                          "file: "
                          (dired-dwim-target-directory)))))
            (if (file-newer-than-file-p file1 file2)
                (ediff-files file2 file1)
              (ediff-files file1 file2))
            (add-hook 'ediff-after-quit-hook-internal
                      (lambda ()
                        (setq ediff-after-quit-hook-internal nil)
                        (set-window-configuration wnd))))
        (error "No more than 2 files should be marked"))))


  ;; (add-hook 'dired-mode-hook 'all-the-icons-dired-mode)

  ;; (when (or amd/using-android amd/using-pocketchip)
  (add-hook 'dired-mode-hook 'dired-hide-details-mode)
  ;; )

  ;; (defadvice dired-toggle-read-only (after advice-for-dired-toggle-read-only activate)
  ;;   (evil-normal-state))

  (advice-add 'dired-toggle-read-only :after #'evil-normal-state)
  )

(use-package dired-x
  :after dired
  ;; Hide dotfiles
  :config
  (setq dired-omit-files (concat dired-omit-files "\\|^\\..+$")))

(use-package dired-subtree
  :after dired
  :general
  (:states '(emacs) :keymaps '(dired-mode-map)
    "TAB" 'dired-subtree-toggle
    "<backtab>" 'dired-subtree-cycle
    "z" 'dired-subtree-toggle))

(provide 'amd/dired)
;;; dired.el ends here

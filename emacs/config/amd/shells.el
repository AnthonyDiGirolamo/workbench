;;; -*- lexical-binding: t; -*-

;;; shells.el --- Summary
;;; Commentary:
;;; Code:

(use-package eshell
  :commands (eshell
             amd/eshell-or-project-eshell
             projectile-run-eshell)
  :custom
  (eshell-banner-message
   '(format "%s %s\n"
            (propertize (format " %s " (string-trim (buffer-name)))
                        'face 'mode-line-highlight)
            (propertize (current-time-string)
                        'face 'font-lock-keyword-face)))
  :init
  (defun amd/move-modeline-to-header ()
    (interactive)
    (setq header-line-format mode-line-format)
    (hide-mode-line-mode))
  ;; (add-hook 'eshell-mode-hook #'amd/move-modeline-to-header)

  (defun eshell-set-keys ()
    (interactive)
    (general-define-key
     :keymaps '(eshell-mode-map)
     :states '(normal insert)
     "C-l"  'eshell/clear-buffer
     "M-e" 'tmux-window-navigation/move-up
     "M-n" 'tmux-window-navigation/move-down)
    (general-define-key
     :keymaps '(eshell-mode-map)
     :states '(insert)
     ;; Use ivy for tab completion
     ;; "<tab>" (lambda () (interactive) (pcomplete-std-complete))
     ;; "C-e"  'eshell-previous-prompt
     ;; "C-n"  'eshell-next-prompt
     "<down>" 'eshell-next-matching-input-from-input
     "<up>" 'eshell-previous-matching-input-from-input)
    (general-define-key
     :keymaps '(eshell-mode-map)
     :states '(normal)
     "E"  'eshell-previous-prompt
     "N"  'eshell-next-prompt
     "G" 'amd/eshell-goto-prompt
     "o" 'amd/eshell-goto-prompt))
  (add-hook 'eshell-first-time-mode-hook 'eshell-set-keys)

  ;; ;; Use ivy for tab completion
  ;; (add-hook 'eshell-mode-hook
  ;;           (lambda ()
  ;;             (define-key eshell-mode-map (kbd "<tab>")
  ;;               (lambda () (interactive) (pcomplete-std-complete)))))

  ;; C-M-i -> complete-symbol (used for elisp inside eshell)
  ;; See completion-at-point-functions for more info

  ;; Tab complete using fish
  ;; Sources:
  ;;   https://github.com/Ambrevar/dotfiles/blob/master/.emacs.d/lisp/init-eshell.el
  ;;   https://www.reddit.com/r/emacs/comments/6y3q4k/yes_eshell_is_my_main_shell/

  ;; (when (executable-find "fish")
  ;;   (setq eshell-default-completion-function 'eshell-fish-completion))

  (defun amd/eshell-or-project-eshell ()
    "Launch projectile-run-eshell else eshell."
    (interactive)
    (if (eq major-mode 'eshell-mode)
        (delete-window)
      (if (projectile-project-root)
          (projectile-run-eshell nil)
        (eshell))))

  (defun amd/eshell-goto-prompt ()
    "Goto end of the last line of the buffer and enter insert mode."
    (interactive)
    (evil-goto-line)
    (evil-end-of-line)
    (evil-append-line nil))

  (defun eshell-fish-completion ()
    (while (pcomplete-here
            (let ((comp-list
                   (let* ((raw-prompt (buffer-substring-no-properties (save-excursion (eshell-bol) (point)) (point)))
                          ;; Keep spaces at the end with OMIT-NULLS=nil in `split-string'.
                          (toks (split-string raw-prompt split-string-default-separators nil))
                          ;; The first non-empty `car' is the command. Discard
                          ;; leading empty strings.
                          (tokens (progn (while (string= (car toks) "")
                                           (setq toks (cdr toks)))
                                         toks))
                          ;; Fish does not support subcommand completion. We make
                          ;; a special case of 'sudo' and 'env' since they are
                          ;; the most common cases involving subcommands.  See
                          ;; https://github.com/fish-shell/fish-shell/issues/4093.
                          (prompt (if (not (member (car tokens) '("sudo" "env")))
                                      raw-prompt
                                    (setq tokens (cdr tokens))
                                    (while (and tokens
                                                (or (string-match "^-.*" (car tokens))
                                                    (string-match "=" (car tokens))))
                                      ;; Skip env/sudo parameters, like LC_ALL=C.
                                      (setq tokens (cdr tokens)))
                                    (mapconcat 'identity tokens " "))))
                     ;; Completion result can be a filename.  pcomplete expects
                     ;; cannonical file names (i.e. withou '~') while fish preserves
                     ;; non-cannonical results.  If the result contains a directory,
                     ;; expand it.
                     (mapcar (lambda (e) (car (split-string e "\t")))
                             (split-string
                              (with-output-to-string
                                (with-current-buffer standard-output
                                  (call-process "fish" nil t nil "-c" (format "complete -C'%s'" prompt))))
                              "\n" t)))))
              (if (and comp-list (file-name-directory (car comp-list)))
                  (pcomplete-dirs-or-entries)
                comp-list)))))

  (setq eshell-history-size 8192)
  (setq eshell-hist-ignoredups t)
  (setq eshell-cmpl-ignore-case t)

  (setq eshell-buffer-maximum-lines 2048)
  (add-hook 'eshell-output-filter-functions 'eshell-truncate-buffer)
  (add-hook 'eshell-output-filter-functions 'eshell-handle-ansi-color)

  (setq eshell-kill-on-exit t)
  (setq eshell-cd-on-directory t
        eshell-dirtrack-verbose t
        eshell-list-files-after-cd nil
        eshell-pushd-tohome t
        eshell-pushd-dunique t
        eshell-buffer-shorthand t)

  ;; (setq eshell-scroll-to-bottom-on-input t)

  ;; Plan 9 style shell
  ;; Still requires running eshell-smart-initialize in ~/.emacs.d/eshell/login
  ;; (require 'em-smart)
  ;; (setq eshell-where-to-jump 'begin)
  ;; (setq eshell-review-quick-commands t)
  ;; (setq eshell-smart-space-goes-to-end t)

  ;; Disable Company mode
  ;; (add-hook 'eshell-mode-hook (lambda () (company-mode -1)))
  ;; (add-hook 'eshell-mode-hook (lambda () (undo-tree-mode -1)))

  ;; Visual commands
  (with-eval-after-load 'em-term
    (nconc eshell-visual-commands
           '("sudo" "gcert" "ssh" "tail"
             "alsamixer" "htop" "mpv" "mutt"
             "ranger" "watch" "wifi-menu"))
    (setq eshell-visual-subcommands
          '(("git" "log" "l" "diff")
            ("sudo" "wifi-menu")
            ("sudo" "vim"))))

  (setenv "PAGER" "cat")

  (defalias 'eshell/q 'eshell/exit)
  (defalias 'eshell/x 'eshell/exit)
  (defalias 'eshell/e 'find-file-other-window)
  (defalias 'eshell/emacs 'find-file)
  (defalias 'eshell/d 'counsel-esh-directory-history)
  (defalias 'eshell/h 'counsel-esh-history)

  (with-eval-after-load 'em-prompt
    (defun eshell-next-prompt (n)
      "Move to end of Nth next prompt in the buffer.
See `eshell-prompt-regexp'."
      (interactive "p")
      (re-search-forward eshell-prompt-regexp nil t n)
      (when eshell-highlight-prompt
        (while (not (get-text-property (line-beginning-position) 'read-only) )
          (re-search-forward eshell-prompt-regexp nil t n)))
      (eshell-skip-prompt))

    (defun eshell-previous-prompt (n)
      "Move to end of Nth previous prompt in the buffer.
See `eshell-prompt-regexp'."
      (interactive "p")
      (backward-char)
      (eshell-next-prompt (- n))))

  ;; adapted from doom-emacs eshell
  ;; https://github.com/hlissner/doom-emacs/blob/develop/modules/term/eshell/autoload/eshell.el#L289
  (defun amd/eshell-cleanup ()
    "Close window on quit."
    (let ((buf (current-buffer)))
      (when-let* ((win (get-buffer-window buf)))
        (let ((ignore-window-parameters t)
              (popup-p (window-dedicated-p win)))
          (delete-window win)
          (when popup-p
            (cl-loop for win in (window-list)
                     for buf = (window-buffer win)
                     for mode = (buffer-local-value 'major-mode buf)
                     if (eq mode 'eshell-mode)
                     return (select-window win)))))))
  (add-hook 'eshell-exit-hook #'amd/eshell-cleanup)

  (defun eshell-enable-256-colors ()
    (interactive)
    (require 'xterm-color)
    ;; (add-hook 'eshell-mode-hook (lambda ()
    (setq xterm-color-preserve-properties t)
    ;; ))

    (add-to-list 'eshell-preoutput-filter-functions 'xterm-color-filter)
    (setq eshell-output-filter-functions
          (remove 'eshell-handle-ansi-color eshell-output-filter-functions)))

  ;; (require 'xterm-color)
  ;; (progn (add-hook 'comint-preoutput-filter-functions 'xterm-color-filter)
  ;;        (setq comint-output-filter-functions (remove 'ansi-color-process-output comint-output-filter-functions))
  ;;        (setq font-lock-unfontify-region-function 'xterm-color-unfontify-region))

  (defun counsel-esh-directory-history ()
    "Browse Eshell history."
    (interactive)
    (require 'em-dirs)
    (ivy-read
     "Directory History: "
     (cl-loop for index from 0 for dir in (ring-elements eshell-last-dir-ring)
              collect
              (cons
               (format "%-10s %-30s"
                       (propertize (format "cd -%d" index) 'face 'font-lock-builtin-face)
                       dir)
               (format "-%d" index)))
     :action
     (lambda (arg)
       (eshell/cd (cdr arg))
       (when (featurep 'em-smart)
         (eshell-smart-goto-end)))))

  ;; (defun amd/add-icon-to-eshell-ls (old-function &rest arguments)
  ;;   (let* ((file (car arguments))
  ;;          (decorated-file (apply old-function arguments))
  ;;          (is-directory (string= "d" (substring (nth 9 file) 0 1)))
  ;;          (file-icon
  ;;           (if is-directory
  ;;               (cond
  ;;                ((file-symlink-p decorated-file)
  ;;                 (all-the-icons-octicon "file-symlink-directory" :height 1.2))
  ;;                ((all-the-icons-dir-is-submodule decorated-file)
  ;;                 (all-the-icons-octicon "file-submodule"))
  ;;                ((file-exists-p (format "%s/.git" decorated-file))
  ;;                 (all-the-icons-octicon "repo"))
  ;;                (t (all-the-icons-octicon "file-directory")))
  ;;             (all-the-icons-icon-for-file decorated-file)))
  ;;          )
  ;;     (message "%s" decorated-file)
  ;;     (concat file-icon " " decorated-file)
  ;;     ;; decorated-file
  ;;     )
  ;;   )
  ;; (advice-add 'eshell-ls-decorated-name :around #'amd/add-icon-to-eshell-ls)

  (defun eshell/clear-buffer ()
    "Clear all text in the eshell buffer."
    (interactive)
    (save-excursion
      (goto-char eshell-last-output-end)
      (let ((lines (count-lines 1 (point)))
            (inhibit-read-only t))
        (beginning-of-line)
        (let ((pos (point)))
          (delete-region (point-min) (point)))))
    (end-of-buffer)))

(use-package shell
  :general
  (:states '(normal)
   :keymaps '(shell-mode-map)
    "C-d"  'evil-scroll-down)
  (:states '(normal insert)
   :keymaps '(shell-mode-map)
    "C-e"  'comint-previous-prompt
    "C-n"  'comint-next-prompt
    "C-l"  'comint-clear-buffer
    "M-e" 'tmux-window-navigation/move-up
    "M-n" 'tmux-window-navigation/move-down)
  (:states '(insert)
   :keymaps '(shell-mode-map)
    "<down>" 'comint-next-matching-input-from-input
    "<up>" 'comint-previous-matching-input-from-input
    "<tab>" (lambda () (interactive) (pcomplete-std-complete)))

  :init
  (setq term-buffer-maximum-size 2048)
  (setq comint-buffer-maximum-size 2048)
  (add-hook 'comint-output-filter-functions 'comint-truncate-buffer)
  (when (executable-find "fish")
    (setq explicit-shell-file-name (executable-find "fish"))))

(use-package ansi-color
 :custom
 (ansi-color-for-comint-mode 'filter))

(use-package compile
  :init
  (setq compilation-scroll-output 'first-error)
  (setq compilation-skip-threshold 2)
  (setq compilation-auto-jump-to-first-error nil)
  :general
  (:states '(motion)
   :keymaps '(compilation-mode-map)
   "M-n" 'tmux-window-navigation/move-down
   "gf" 'find-file-at-point
   "gg" 'evil-goto-first-line
   "G" 'evil-goto-line)

  ;; ;; this is not working
  ;; (setq compilation-finish-functions 'amd/compile-autoclose)
  ;; (defun amd/compile-autoclose (buffer string)
  ;;   (cond ((string-match "finished" string)
  ;;          ;; (bury-buffer "*compilation*")
  ;;          ;; (winner-undo)
  ;;          (delete-window (get-buffer-window "*compilation**"))
  ;;          (message "Build successful."))
  ;;         (t
  ;;          (message "Compilation exited abnormally: %s" string))))

  :init
  ;; TODO: Figure out how to truncate line by default in compilation mode
  ;; (add-hook 'compilation-start-hook (lambda () (toggle-truncate-lines 1)))
  :config
  (defun amd/split-compilation ()
    "Open/close the *compilation* buffer."
    (interactive)
    (if (string-equal (buffer-name) "*compilation*")
        (delete-window)
      (pop-to-buffer "*compilation*")))

  (setq compilation-finish-function
        (lambda (buf str)
          (if (null (string-match ".*exited abnormally.*" str))
              ;;no errors, make the compilation window go away in a few seconds
              (progn
                (run-at-time
                 "2 sec" nil 'delete-windows-on
                 (get-buffer-create "*compilation*"))
                (message "No Compilation Errors!")))))

  ;; From http://endlessparentheses.com/ansi-colors-in-the-compilation-buffer-output.html
  ;; (require 'ansi-color)
  (defun endless/colorize-compilation ()
    "Colorize from `compilation-filter-start' to `point'."
    (let ((inhibit-read-only t))
      (ansi-color-apply-on-region
       compilation-filter-start (point))))
  (add-hook 'compilation-filter-hook #'endless/colorize-compilation))

(use-package vterm
  :disabled ;; TODO
  :commands (vterm)
  :general
  (:states '(emacs)
   :keymaps '(vterm-mode-map)
   (kbd "<f9>") 'amd/take-svg-screenshot)
  (:states '(normal)
   :keymaps '(vterm-mode-map)
   "C-p" 'vterm--self-insert
   (kbd "<f9>") 'amd/take-svg-screenshot
   "u" 'vterm-undo)
  (:states '(insert)
   :keymaps '(vterm-mode-map)
   "C-p" 'vterm--self-insert
   (kbd "<f9>") 'amd/take-svg-screenshot
   "C-a" 'vterm-send-C-a
   "C-e" 'vterm-send-C-e
   "C-d" 'vterm-send-C-d
   "C-y" 'vterm-yank))

(provide 'amd/shells)
;;; shells.el ends here

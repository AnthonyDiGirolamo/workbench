;;; -*- lexical-binding: t; -*-

;;; functions.el --- Summary
;;; Commentary:
;;; Code:

(define-minor-mode amd-center-buffer-mode
  "Buffer local minor mode for amd-center-buffer"
  :init-value nil
  :lighter ""
  :keymap (make-sparse-keymap) ;; defines amd-center-buffer-mode-map
  :group 'amd-center-buffer
  (if (bound-and-true-p amd-center-buffer-mode)
      (amd/center-buffer 100)
    (amd/center-buffer-disable)))

;; (defun amd-center-buffer-mode-install () (amd-center-buffer-mode 1))
;; (define-globalized-minor-mode global-amd-center-buffer-mode
;;   amd-center-buffer-mode amd-center-buffer-mode-install
;;   "Global minor mode of amd-center-buffer-mode.")

(defun amd/center-buffer-disable ()
  (interactive)
  (setq-local left-margin-width nil
              right-margin-width nil)
  (set-window-buffer (selected-window) (current-buffer)))

(defun amd/center-buffer (width)
  (interactive "nBuffer width: ")
  (let* ((adj (- (window-text-width)
                 width))
         (total-margin (+ adj
                          (or 0 left-margin-width)
                          (or 0 right-margin-width))))
    (setq-local left-margin-width  (/ total-margin 2))
    (setq-local right-margin-width (- total-margin left-margin-width)))
  (set-window-buffer (selected-window) (current-buffer)))

(defun amd/run-lisp-love ()
  (interactive)
  (run-lisp "love ."))

(defun amd/copy-buffer ()
  "Copy entire buffer to clipboard"
  (interactive)
  (clipboard-kill-ring-save (point-min) (point-max)))

(defun amd/recompile-all-elpa-packages ()
  "Recompile elc files"
  (interactive)
  (byte-recompile-directory "~/.emacs.d/elpa/" 0 t))

(defun make-parent-directory ()
  "Make sure the directory of `buffer-file-name' exists."
  (make-directory (file-name-directory buffer-file-name) t))

;; Create parent directories if they don't exist on new files
(add-hook 'find-file-not-found-functions #'make-parent-directory)

(defun run-love2d ()
   "run love2d"
   (interactive)
   (async-shell-command (format "cd %s && love ." (projectile-project-root))))

(defun run-pico8 ()
   "run a pico-8 cartridge then revert buffer"
   (interactive)
   (let ((current-file-path (file-name-base (buffer-file-name (current-buffer))))
         (pico8-command     (cond ((eq system-type 'cygwin)
                                   ;; "/home/anthony/pico-8_win32/pico8.exe -windowed 1 -home C:/cygwin64/home/anthony/heliopause-pico-8 "
                                   "/home/anthony/pico-8_win32/pico8.exe -windowed 1 -home 'C:\cygwin64\home\anthony\heliopause-pico-8' -run ")
                                  ((eq system-type 'windows-nt)
                                   "c:/Users/anthony/pico-8_win32/pico8.exe -windowed 1 -home C:\\Users\\anthony\\heliopause-pico-8 -run ")
                                  (amd/using-pocketchip
                                   "/usr/lib/pico-8/pico8 -run ")
                                  (t
                                   "/home/anthony/apps/pico-8/pico8 -run "))))
     (save-buffer)
     (shell-command (concat pico8-command current-file-path))
     ;; (shell-command pico8-command)
     (revert-buffer nil t)))

(defun run-current-test (&optional line-no only-run-file)
  (interactive)
  (let ((test-file-window (selected-window))
        (test-file-path   (buffer-file-name (current-buffer)))
        (test-command
         (cond (only-run-file "")
               ((string-match "_spec.rb$" (buffer-file-name (current-buffer)))
                "~/.rbenv/shims/ruby ./bin/rspec ")
               ((string-match ".py$" (buffer-file-name (current-buffer)))
                "py.test -v --doctest-modules ")
               ((string-match ".moon$" (buffer-file-name (current-buffer))) "moon ")
               (t
                "unknown_test_framework")))
        (rspec-buffer     (get-buffer-window "*rspec*")))
    ;; if the rspec buffer is open
    (if rspec-buffer
        ;; switch focus to it
        (select-window rspec-buffer)
      (progn
        ;; otherwise create a split and switch focus to it
        (select-window (split-window-right))
        (evil-window-move-far-right)
        ;; open the rspec-buffer
        (switch-to-buffer "*rspec*")))
    (erase-buffer)
    (shell-command
     (concat "cd " (projectile-project-root) " && "
             test-command
             test-file-path " &") "*rspec*")
    (evil-normal-state)
    (select-window test-file-window)))

;; (defun insert-tab-wrapper ()
;;   (interactive)
;;   (if (string-match "^[ \t]+$" (buffer-substring-no-properties (line-beginning-position) (line-end-position)))
;;       (insert (kbd "TAB"))
;;     (evil-complete-previous)))

(defun what-face (pos)
  (interactive "d")
  (let ((face (or (get-char-property (point) 'read-face-name)
                  (get-char-property (point) 'face))))
    (if face
        (let ((face-string (format "%s" face)))
          (kill-new face-string )
          (message "Copied Face: %s" face))
      (message "No face at %d" pos))))

;; Rename file https://sites.google.com/site/steveyegge2/my-dot-emacs-file
(defun rename-file-and-buffer (new-name)
  "Renames both current buffer and file it's visiting to NEW-NAME."
  (interactive (list (read-string "New name:" (buffer-name))))
  (let ((name (buffer-name))
        (filename (buffer-file-name)))
    (if (not filename)
        (message "Buffer '%s' is not visiting a file!" name)
      (if (get-buffer new-name)
          (message "A buffer named '%s' already exists!" new-name)
        (progn
          (rename-file name new-name 1)
          (rename-buffer new-name)
          (set-visited-file-name new-name)
          (set-buffer-modified-p nil))))))

;; Line Bubble Functions
(defun move-line-up ()
  "move the current line up one line"
  (interactive)
  (transpose-lines 1)
  (previous-line 2))

(defun move-line-down ()
  "move the current line down one line"
  (interactive)
  (next-line 1)
  (transpose-lines 1)
  (previous-line 1))

(defun evil-move-lines-up (beg end)
  "Move selected lines up one line."
  (interactive "r")
  (evil-move-lines beg end t))

(defun evil-move-lines-down (beg end)
  "Move selected lines down one line."
  (interactive "r")
  (evil-move-lines beg end))

(defun evil-move-lines (beg end &optional move-up)
  "Move selected lines up or down."
  (let ((text (delete-and-extract-region beg end)))
    (if move-up
        (beginning-of-line 0)  ;; move to the beginning of the previous line
        (beginning-of-line 2)) ;; move to the beginning of the next line
    (insert text)
    (forward-char -1)
    (evil-visual-line (- (point) (string-width text)) (point))))

(defun evil-eval-print-last-sexp ()
  "Eval print when in evil-normal-state."
  (interactive) (forward-char) (previous-line) (eval-print-last-sexp))

(defun align-no-repeat (start end regexp)
  "Alignment with respect to the given regular expression."
  (interactive "r\nsAlign regexp: ")
  (align-regexp start end
                (concat "\\(\\s-*\\)" regexp) 1 1 nil))

(defun align-repeat (start end regexp)
  "Repeat alignment with respect to the given regular expression."
  (interactive "r\nsAlign regexp: ")
  (align-regexp start end
                (concat "\\(\\s-*\\)" regexp) 1 1 t))

(defun align-to-space (begin end)
  "Align region to spaces"
  (interactive "r")
  (align-regexp begin end
                (rx (group (one-or-more (syntax whitespace))) ) 1 1 t)
  (evil-indent begin end))

(defun align-to-comma (begin end)
  "Align region to comma signs"
  (interactive "r")
  (align-regexp begin end
                (rx "," (group (zero-or-more (syntax whitespace))) ) 1 1 t))

(defun align-to-colon (begin end)
  "Align region to colon"
  (interactive "r")
  (align-regexp begin end
                (rx ":" (group (zero-or-more (syntax whitespace))) ) 1 1 ))

(defun align-to-equals (begin end)
  "Align region to equal signs"
  (interactive "r")
  (align-regexp begin end
                (rx (group (zero-or-more (syntax whitespace))) "=") 1 1 ))

(defun align-interactively ()
  "invoke align-regexp interactively"
  (interactive)
  (let ((current-prefix-arg 4)) ;; emulate C-u
    (call-interactively 'align-regexp)))

(defun amd/x-paste ()
  "Paste from the clipboard with wl-paste."
  (interactive)
  (insert (shell-command-to-string "wl-paste")))

(defun amd/x-yank (begin end)
  "Yank to the x clipboard with wl-copy."
  (interactive "r")
  (shell-command-on-region begin end "wl-copy -p"))

(defun amd/edebug-eval-defun ()
  "Run eval-defun with C-u."
  (interactive)
  (let ((current-prefix-arg 4)) ;; emulate C-u
    (call-interactively 'eval-defun)))

(defvar rgbxmlcolour-keywords
  '(("r=\"[0-9]+\" +g=\"[0-9]+\" +b=\"[0-9]+\""
     (0 (put-text-property (match-beginning 0)
                           (match-end 0)
                           'face (list :background
                                       (cl-loop
                                        for color
                                        in (split-string (replace-regexp-in-string "[rgb=\" ]+" " " (match-string-no-properties 0)) " " t)
                                        concat (format "%02X" (string-to-number color)) into colorcode
                                        finally return (concat "#" (downcase colorcode)))
                                       ))))))

(defun rgb-to-hex-comment (beg end)
  (interactive "r")
  (save-excursion
    (goto-char beg)
    (while (re-search-forward "r=\"[0-9]+\" g=\"[0-9]+\" b=\"[0-9]+\"" end)
      (let* ((selected-text (match-string-no-properties 0))
             (hex-color-text (cl-loop
                              for color
                              in (split-string (replace-regexp-in-string "[rgb=\" ]+" " " selected-text) " " t)
                              concat (format "%02X" (string-to-number color)) into colorcode
                              finally return (concat "#" colorcode)))
             )
        (end-of-line)
        (insert " <!-- ")
        (insert hex-color-text)
        (insert " -->")))))

(defun rgbxmlcolour-add-to-font-lock ()
  (interactive)
  (font-lock-add-keywords nil rgbxmlcolour-keywords))

(defvar hexcolour-keywords
  '(("#[abcdef[:digit:]]\\{6\\}"
     (0 (put-text-property (match-beginning 0)
                           (match-end 0)
                           'face (list :background
                                       (match-string-no-properties 0)))))))

(defun hexcolour-add-to-font-lock ()
  (interactive)
  (font-lock-add-keywords nil hexcolour-keywords))

(defun amd/toggle-org-edit-code-block ()
  "Start or finish editing an org code block."
  (interactive)
  (if org-src--beg-marker ;; (cl-find 'org-src-mode minor-mode-list)
      (progn
        (org-edit-src-exit)
        (recenter))
    (progn
      (org-edit-special)
      (recenter))))

(defun amd/disable-loaded-themes ()
  "Remove custom theme settings so all colors are reset to defaults."
  (interactive)
  (cl-loop for theme-name in custom-enabled-themes
           do (funcall #'disable-theme theme-name)))

(defun amd/clear-and-load-theme (theme-name)
  "Disable all loaded themes and load the provided theme."
  (amd/disable-loaded-themes)
  (load-theme (intern theme-name) t))

(defun amd/load-theme ()
  "Interactively load a theme."
  (interactive)
  (let ((this-command 'amd/load-theme))
    (ivy-read
     "Switch theme: "
     (custom-available-themes)
     :action #'amd/clear-and-load-theme)))

(defun amd/set-variable-org-level-heights ()
  "Set variable font heights for org-levels "
  (interactive)
  (custom-set-faces
   '(org-level-1 ((t (:inherit outline-1 :height 1.4))))
   '(org-level-2 ((t (:inherit outline-2 :height 1.2))))
   '(org-level-3 ((t (:inherit outline-3 :height 1.0))))
   '(org-level-4 ((t (:inherit outline-4 :height 1.0))))
   '(org-level-5 ((t (:inherit outline-5 :height 1.0))))
   (set-face-attribute 'org-document-title nil :height 1.8)))

(defun multiply-number-at-point (factor)
  "Multiply the number at point by FACTOR using `calc-eval` and replace it.
If called with a prefix argument (e.g., C-u 3 M-x multiply-number-at-point),
uses that as the factor; otherwise, prompts in the minibuffer."
  (interactive
   (list (if current-prefix-arg
             (prefix-numeric-value current-prefix-arg)
           (read-number "Multiply by: "))))
  (let ((bounds (bounds-of-thing-at-point 'number))
        (num (number-at-point)))
    (if (null bounds)
        (user-error "No number found at point")
      (let* ((num-str (number-to-string num))
             (factor-str (number-to-string factor))
             (expr (format "%s * %s" num-str factor-str))
             (result (calc-eval expr)))
        (delete-region (car bounds) (cdr bounds))
        (insert result)))))

(defun divide-number-at-point-by-two ()
  (interactive)
  (multiply-number-at-point 0.5))

(defun divide-number-at-point-by-four ()
  (interactive)
  (multiply-number-at-point 0.25))

(provide 'amd/functions)
;;; functions.el ends here

;;; -*- lexical-binding: t; -*-

;;; completing-read.el --- Summary
;;; Commentary:
;;; Code:

(use-package amx
  :demand
  ;; :bind
  ;; (("M-x" . amx))
  :config
  (amx-mode))

;;; minibuffer (built-in emacs settings)

(use-package minibuffer
  :ensure nil
  :config
  ;; Ignore case for files, buffers, and generally
  (setq read-file-name-completion-ignore-case t
        read-buffer-completion-ignore-case t
        completion-ignore-case t)

  ;; Do not inform me about the default keybindings to select a
  ;; candidate.
  (setq completion-show-help nil)

  ;; Do not print messages in the echo area that pertain to
  ;; completion---those are distracting.
  (setq completion-show-inline-help nil)

  ;; Show useful annotations in various minibuffer prompts (though the
  ;; `marginalia' package greatly improves this).
  (setq completions-detailed t)

  ;; Do not use rows and columns for completions: a single vertical
  ;; list is easier to follow.
  (setq completions-format 'one-column)

  ;; Put an upper limit to the Completions window, so that it does not
  ;; disorient me.
  (setq completions-max-height 12)

  ;; Rely on previous inputs to surface candidates towards the top of
  ;; the list (enable the built-in `savehist-mode' to persist
  ;; history).
  (setq completions-sort 'historical)

  ;; Show the Completions buffer if I hit TAB but there is no unique match yet.
  (setq completion-auto-help t)

  ;; Never switch to the Completions buffer when I type TAB, because I
  ;; want to select candidates while the minibuffer is still in focus,
  ;; per `minibuffer-visible-completions'.  This has the advantage of
  ;; auto-updating the completions as I type.
  (setq completion-auto-select nil
        minibuffer-visible-completions t)

  ;; Those two are also relevant for the `completion-category-overrides', which I
  ;; cover elsewhere in this article.
  (setq completion-eager-display t)
  (setq completion-eager-update t))

;;; orderless

(use-package orderless
  :custom
  (completion-styles '(orderless basic))
  (completion-category-overrides '((file (styles basic partial-completion)))))

;;; consult

(use-package consult
  ;; :disabled
  ;; Replace bindings. Lazily loaded due by `use-package'.

  :bind
  ;; (;; C-c bindings (mode-specific-map)
  ;;  ("C-c h" . consult-history)
  ;;  ("C-c m" . consult-mode-command)
  ;;  ("C-c k" . consult-kmacro)
  ;;  ;; C-x bindings (ctl-x-map)
  ;;  ("C-x M-:" . consult-complex-command) ;; orig. repeat-complex-command
  ;;  ("C-x b" . consult-buffer)            ;; orig. switch-to-buffer
  ;;  ("C-x 4 b" . consult-buffer-other-window) ;; orig. switch-to-buffer-other-window
  ;;  ("C-x 5 b" . consult-buffer-other-frame) ;; orig. switch-to-buffer-other-frame
  ;;  ("C-x r b" . consult-bookmark)           ;; orig. bookmark-jump
  ;;  ("C-x p b" . consult-project-buffer)     ;; orig. project-switch-to-buffer
  ;;  ;; Custom M-# bindings for fast register access
  ;;  ("M-#" . consult-register-load)
  ;;  ("M-'" . consult-register-store) ;; orig. abbrev-prefix-mark (unrelated)
  ;;  ("C-M-#" . consult-register)
  ;;  ;; Other custom bindings
  ;;  ("M-y" . consult-yank-pop)           ;; orig. yank-pop
  ;;  ("<help> a" . consult-apropos)       ;; orig. apropos-command
  ;;  ;; M-g bindings (goto-map)
  ;;  ("M-g e" . consult-compile-error)
  ;;  ("M-g f" . consult-flymake)           ;; Alternative: consult-flycheck
  ;;  ("M-g g" . consult-goto-line)         ;; orig. goto-line
  ;;  ("M-g M-g" . consult-goto-line)       ;; orig. goto-line
  ;;  ("M-g o" . consult-outline)           ;; Alternative: consult-org-heading
  ;;  ("M-g m" . consult-mark)
  ;;  ("M-g k" . consult-global-mark)
  ;;  ("M-g i" . consult-imenu)
  ;;  ("M-g I" . consult-imenu-multi)
  ;;  ;; M-s bindings (search-map)
  ;;  ("M-s d" . consult-find)
  ;;  ("M-s D" . consult-locate)
  ;;  ("M-s g" . consult-grep)
  ;;  ("M-s G" . consult-git-grep)
  ;;  ("M-s r" . consult-ripgrep)
  ;;  ("M-s l" . consult-line)
  ;;  ("M-s L" . consult-line-multi)
  ;;  ("M-s m" . consult-multi-occur)
  ;;  ("M-s k" . consult-keep-lines)
  ;;  ("M-s u" . consult-focus-lines)
  ;;  ;; Isearch integration
  ;;  ("M-s e" . consult-isearch-history)
  ;;  :map isearch-mode-map
  ;;  ("M-e" . consult-isearch-history)         ;; orig. isearch-edit-string
  ;;  ("M-s e" . consult-isearch-history)       ;; orig. isearch-edit-string
  ;;  ("M-s l" . consult-line) ;; needed by consult-line to detect isearch
  ;;  ("M-s L" . consult-line-multi) ;; needed by consult-line to detect isearch
  ;;  ;; Minibuffer history
  ;;  :map minibuffer-local-map
  ;;  ("M-s" . consult-history)        ;; orig. next-matching-history-element
  ;;  ("M-r" . consult-history))       ;; orig. previous-matching-history-element

  ;; Enable automatic preview at point in the *Completions* buffer. This is
  ;; relevant when you use the default completion UI.
  ;; :hook (completion-list-mode . consult-preview-at-point-mode)

  ;; The :init configuration is always executed (Not lazy)
  :init
  (defun amd/consult-git-or-file-jump ()
    "Run counsel-git if in a git repo, counsel-file-jump otherwise."
    (interactive)
    (if (consult-ls-git--get-project-root)
        (consult-ls-git-ls-files)
      (consult-find)))

  ;; Optionally configure the register formatting. This improves the register
  ;; preview for `consult-register', `consult-register-load',
  ;; `consult-register-store' and the Emacs built-ins.
  (setq register-preview-delay 0.5
        register-preview-function #'consult-register-format)

  ;; Optionally tweak the register preview window.
  ;; This adds thin lines, sorting and hides the mode line of the window.
  (advice-add #'register-preview :override #'consult-register-window)

  ;; Use Consult to select xref locations with preview
  (setq xref-show-xrefs-function #'consult-xref
        xref-show-definitions-function #'consult-xref)

  ;; Configure other variables and modes in the :config section,
  ;; after lazily loading the package.
  :config

  ;; Optionally configure preview. The default value
  ;; is 'any, such that any key triggers the preview.
  (setq consult-preview-key nil)
  ;; (setq consult-preview-key (kbd "M-."))
  ;; (setq consult-preview-key (list (kbd "<S-down>") (kbd "<S-up>")))
  ;; For some commands and buffer sources it is useful to configure the
  ;; :preview-key on a per-command basis using the `consult-customize' macro.
  (consult-customize
   consult-imenu :preview-key 'any
   consult-theme :preview-key '(:debounce 0.2 any)
   ;; consult-ripgrep consult-git-grep consult-grep
   ;; consult-bookmark consult-recent-file consult-xref
   ;; consult--source-bookmark consult--source-file-register
   ;; consult--source-recent-file consult--source-project-recent-file
   ;; ;; :preview-key (kbd "M-.")
   ;; :preview-key '(:debounce 0.4 any)
   )

  ;; Optionally make narrowing help available in the minibuffer.
  ;; You may want to use `embark-prefix-help-command' or which-key instead.
  ;; (define-key consult-narrow-map (vconcat consult-narrow-key "?") #'consult-narrow-help)

  ;; By default `consult-project-function' uses `project-root' from project.el.
  ;; Optionally configure a different project root function.
  ;; There are multiple reasonable alternatives to chose from.
  ;;;; 1. project.el (the default)
  ;; (setq consult-project-function #'consult--default-project--function)
  ;;;; 2. projectile.el (projectile-project-root)
  ;; (autoload 'projectile-project-root "projectile")
  ;; (setq consult-project-function (lambda (_) (projectile-project-root)))
  ;;;; 3. vc.el (vc-root-dir)
  ;; (setq consult-project-function (lambda (_) (vc-root-dir)))
  ;;;; 4. locate-dominating-file
  ;; (setq consult-project-function (lambda (_) (locate-dominating-file "." ".git")))

  ;; Optionally configure the narrowing key.
  ;; Both < and C-+ work reasonably well. ;; (kbd "C-+")
  (setq consult-narrow-key "<"))

;;; embark

(use-package embark
  ;; :disabled
  :bind
  (("C-t" . embark-act)
   ("C-c C-o" . embark-export)
   ("C-;" . embark-dwim)
   ("C-h C-k" . (lambda () (interactive) (embark-bindings t))))
  (:map evil-normal-state-map
        ("C-t" . embark-act)
        ("C-;" . embark-dwim))


  :init
  ;; Optionally replace the key help with a completing-read interface
  (setq prefix-help-command #'embark-prefix-help-command)

  :config
  ;; Hide the mode line of the Embark live/completions buffers
  (add-to-list 'display-buffer-alist
               '("\\`\\*Embark Collect \\(Live\\|Completions\\)\\*"
                 nil
                 (window-parameters (mode-line-format . none)))))

;; Consult users will also want the embark-consult package.
(use-package embark-consult
  :hook
  (embark-collect-mode . consult-preview-at-point-mode))

;;; vertico

(use-package vertico
  ;; :disabled
  :general
  (:keymaps '(vertico-map)
    ;; "C-n" 'vertico-next ;; this is the default
    "C-e" 'vertico-previous
    "<prior>" 'vertico-scroll-down
    "<next>" 'vertico-scroll-up
    "C-u" 'vertico-scroll-down
    "C-d" 'vertico-scroll-up)
  :init
  ;; Different scroll margin
  ;; (setq vertico-scroll-margin 0)

  ;; Show more candidates
  (setq vertico-count 9)

  ;; Grow and shrink the Vertico minibuffer
  ;; (setq vertico-resize t)

  ;; Optionally enable cycling for `vertico-next' and `vertico-previous'.
  ;; (setq vertico-cycle t)

  ;; Must be in the :init section of use-package such that the mode gets
  ;; enabled right away. Note that this forces loading the package.
  (vertico-mode))

;;; marginalia

(use-package marginalia
  ;; :disabled
  :bind (:map minibuffer-local-map
              ("M-A" . marginalia-cycle))
  ;; The :init configuration is always executed (Not lazy!)
  :init
  ;; Must be in the :init section of use-package such that the mode gets
  ;; enabled right away. Note that this forces loading the package.
  (marginalia-mode))

;;; ivy

(use-package ivy
  :custom
  (ivy-display-style 'fancy)
  (ivy-use-virtual-buffers t)
  (ivy-height 10)
  (ivy-fixed-height-minibuffer t)
  :config
  ;; Enable orderless
  (setq ivy-re-builders-alist '((t . orderless-ivy-re-builder)))
  (add-to-list 'ivy-highlight-functions-alist '(orderless-ivy-re-builder . orderless-ivy-highlight))

  (defvar ivy-switch-project-map (make-sparse-keymap))

  (defun ivy-switch-project ()
    (interactive)
    (let ((this-command 'ivy-switch-project))
      (projectile-load-known-projects)
      (ivy-read
       "Switch to project: "
       projectile-known-projects
       :action #'magit-status
       :keymap ivy-switch-project-map)))

  (ivy-set-actions
   'ivy-switch-project
   '(("k"
      (lambda (x) (setq projectile-known-projects
                   (--reject (string= x it) projectile-known-projects))
        (projectile-merge-known-projects)
        (ivy--reset-state ivy-last))
      "remove project")
     ("d" (lambda (x) (dired x))
      "dired")))

  ;; TODO: https://github.com/abo-abo/swiper/issues/2560
  ;; (defun amd/adjust-windows-for-minibuffer (&optional arg1 &rest args)
  ;;   ;; (message "bn: %s" (buffer-name))
  ;;   ;; (message "height: %s" (window-total-height))
  ;; )
  ;; (current-window-configuration)
  ;; (advice-add 'ivy--minibuffer-setup :after #'amd/adjust-windows-for-minibuffer)
  ;; (add-hook 'minibuffer-setup-hook #'amd/adjust-windows-for-minibuffer)
  ;; (add-hook 'minibuffer-exit-hook #'my-minibuffer-exit-hook)

  (defun counsel-calc-units ()
    (interactive)
    (require 'calc-units) ;; needed to access math-standard-units variable
    (let ((this-command 'counsel-calc-units))
      (ivy-read
       "Unit: "
       (mapcar
        (lambda (unit-list)
          (let* ((command (car unit-list))
                 (key (symbol-name command))
                 (doc (delq nil (mapcar (lambda (item) (when (stringp item) item)) (cdr unit-list))))
                 (doc-size (length doc))
                 (definition (cond ((eq doc-size 1) key) ((eq doc-size 2) (car doc)) ((eq doc-size 3) (car (reverse doc)))))
                 (description (cond ((eq doc-size 1) (format "%s (base unit)" (car (reverse doc)))) (t (car (cdr doc))))))
            (cons (format "%-12s %-30s %s" (propertize key 'face 'font-lock-builtin-face) definition description) key)))
        (append math-additional-units math-standard-units))
       :action (lambda (arg) (calc-alg-entry (cdr arg))))))

  (ivy-set-actions
   'counsel-calc-units
   '(("c"
      (lambda (arg) (calc-convert-units nil (cdr arg)))
      "convert"))))

;;; counsel

(use-package counsel
  ;; :disabled
  :after amx
  :demand
  :bind
  (;; ("M-x" . counsel-M-x)
   ;; ("C-h k" . counsel-descbinds)
   ;; ("C-h C-k" . counsel-descbinds)
   ([f9] . amd/take-svg-screenshot))
  :custom
  (counsel-grep-base-command "grep -niE \"%s\" %s")
  :init
  (defun amd/counsel-ag-with-filename-regex (fileregex)
    "counsel-ag with file regex input."
    (interactive "sFilename Regex: ")
    (let* ((ag-command (car (split-string counsel-ag-base-command "%s")))
           (counsel-ag-base-command (concat ag-command " -G '" fileregex "' %s")))
      (counsel-ag)))

  (defun amd/counsel-git-or-file-jump ()
    "Run counsel-git if in a git repo, counsel-file-jump otherwise."
    (interactive)
    (if (counsel--git-root)
        (counsel-git)
      (counsel-file-jump)))

  (defun amd/counsel-rg-with-initial-directory (initial-directory extra-args)
    "counsel-rg with initial directory and extra args prompt."
    (interactive "DInitial Directory: \nsExtra Args: ")
    (counsel-rg nil initial-directory extra-args)))

(provide 'amd/completing-read)
;;; completing-read.el ends here

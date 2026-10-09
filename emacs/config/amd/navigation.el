;;; -*- lexical-binding: t; -*-

;;; navigation.el --- Summary
;;; Commentary:
;;; Code:

;;; tmux-window-navigation
(use-package tmux-window-navigation
  :config
  (global-tmux-window-navigation-mode 1))

;;; tab-bar
(use-package tab-bar
  :if (>= emacs-major-version 27)
  :config
  (defun amd/tab-bar-tab-name-current ()
    "Generate tab name from the buffer of the selected window."
    (format " %s " (buffer-name (window-buffer (minibuffer-selected-window)))))
  (setq tab-bar-tab-name-function #'amd/tab-bar-tab-name-current)

  (defun amd/tab-bar-next-or-new-tab (&optional arg)
    "Switch to next tab or make a new one."
    (interactive "p")
    (unless (integerp arg)
      (setq arg 1))
    (let* ((tabs (funcall tab-bar-tabs-function))
           (from-index (or (tab-bar--current-tab-index tabs) 0))
           (to-index (mod (+ from-index arg) (length tabs))))
      (if (= 0 to-index)
          (tab-bar-new-tab)
        (tab-bar-select-tab (1+ to-index)))))

  (defun amd/tab-bar-string-for-hydra ()
    "Return current tabs as a formatted string."
    (cl-loop
     for tab being the elements of (funcall tab-bar-tabs-function)
     using (index i)
     with current-index = (tab-bar--current-tab-index)
     concat
     (let ((tab-name (alist-get 'name tab)))
       (if (eq i current-index)
           (propertize (format " %s " tab-name) 'face 'tab-bar-tab)
         (propertize (format " %s " tab-name) 'face 'tab-bar-tab-inactive)))
     ;; into current-tab-list
     ;; finally return (format "| %s |" current-tab-list)
     )
    )

  (defhydra hydra-tab-bar (:color red :columns 5)
    "
  %s(amd/tab-bar-string-for-hydra)"
    ("h"  tab-previous                "← prev")
    ("l"  amd/tab-bar-next-or-new-tab "→ next/new")
    ("N"  tab-bar-new-tab             "new")
    ("o"  tab-bar-undo-close-tab      "reopen")
    ("w"  hydra-window-size/body      "window size" :exit t)

    ("H" tab-bar-move-tab-backward "← move")
    ("L"  tab-bar-move-tab         "→ move")
    ("c"  tab-bar-close-tab        "close")
    ("r"  tab-rename               "rename")
    ("f"  hydra-window-frame/body  "window frame" :exit t)

    ("T"  tab-bar-move-window-to-tab "split → new Tab")
    ("F"  tab-bar-detach-tab         "tab → new Frame")
    ("t"  tab-bar-switch-to-tab      "switch")
    ("RET" keyboard-escape-quit      "quit" :exit t))

  (defhydra hydra-window-size (:color red)
    "Window size"
    ("w" evil-window-set-height      "maximize")
    ("h" shrink-window-horizontally  "shrink horizontal")
    ("n" shrink-window               "shrink vertical")
    ("e" enlarge-window              "enlarge vertical")
    ("l" enlarge-window-horizontally "enlarge horizontal"))

  (defhydra hydra-window-frame (:color blue)
    "Frame"
    ("m" toggle-frame-maximized  "toggle maximize-window")
    ("f" toggle-frame-fullscreen "toggle fullscreen")
    ("n" make-frame              "new frame")
    ("c" delete-frame            "delete frame"))
  )

;;; ibuffer:
(use-package ibuffer
  :custom
  (ibuffer-use-header-line t)
  (ibuffer-truncate-lines t)
  (ibuffer-use-other-window t)
  :init
  (add-hook 'ibuffer-mode-hook (lambda () (hl-line-mode 1)))
  (setq ibuffer-formats
        '((mark
           " " (name 32 32 :left)
           " "
           filename-and-process)
          (mark
           ;; modified
           ;; read-only
           ;; locked
           ;; " " (size 9 -1 :right)
           ;; " " (mode 16 16 :left :elide)
           " "
           filename-and-process
           ;; project-relative-file
           "  --  " name)))
  :general
  (:states '(emacs)
   :keymaps 'ibuffer-mode-map
   "e" 'ibuffer-backward-line
   "/" 'swiper
   "C-/" 'swiper
   ;; "RET" 'ibuffer-visit-buffer-other-window ;; default is "o"
   ;; "a" 'ibuffer-visit-buffer                ;; default is "RET"
   "C-d" 'evil-scroll-down
   "C-u" 'evil-scroll-up)
  :config)

;;; ibuffer-vc
(use-package ibuffer-vc
  :init
  (add-hook 'ibuffer-mode-hook (lambda () (ibuffer-auto-mode 1)))
  (add-hook 'ibuffer-hook
    (lambda ()
      (ibuffer-vc-set-filter-groups-by-vc-root)
      (unless (eq ibuffer-sorting-mode 'filename/process)
        (ibuffer-do-sort-by-filename/process)))))

;;; projectile
(use-package projectile
  :diminish
  :custom
  ;; (projectile-completion-system 'ivy)
  (projectile-require-project-root t)  ;; require .git or similar to mark a project
  (projectile-enable-caching nil)
  (projectile-indexing-method 'alien)
  (projectile-globally-ignored-directories '("vendor/ruby"))
  (projectile-switch-project-action
   'projectile-dired
   ;; 'projectile-find-file
   )
  :commands (ibuffer
             ivy-switch-project
             projectile-project-root
             projectile-switch-project
             projectile-load-known-projects
             projectile-run-eshell
             projectile-find-file)
  :init
  ;; (defun amd/projectile-switch-project (old-function &rest arguments)
  ;;   (message "%s" old-function)
  ;;   (message "%s" arguments)
  ;;   (apply old-function arguments))
  ;; (advice-add 'projectile-switch-project-by-name :around #'amd/projectile-switch-project)
  )

;;; winner - window layout undo/redo
(use-package winner
  :config
  (winner-mode 1))

;;; shackle - window positioning rules
(use-package shackle
  :custom
  (help-window-select t) ;; (not shackle) select new help windows when they open
  (shackle-select-reused-windows nil)
  ;; WARNING: This default rule causes transients to always appear
  ;;          on the right side if there is only one window in the frame.
  ;;   (shackle-default-rule '(:select t))
  (shackle-default-rule nil)
  (shackle-default-alignment 'below)
  (shackle-default-size 0.5)
  (shackle-trace-functions
   '(display-buffer
     pop-to-buffer
     pop-to-buffer-same-window
     switch-to-buffer-other-window
     switch-to-buffer-other-frame
     display-buffer-below-selected
     display-buffer-at-bottom
     display-buffer-in-side-window))
  :init
  (setq
   shackle-rules
   '(;; Hidden popups
     ("*Shell Command Output*" :ignore t)
     ("*Async Shell Command*" :ignore t)
     ("*Flycheck error messages*" :ignore t)

     ("\\*[Ii]buffer\\*" :regexp t :same t)
     (compilation-mode :select nil :size 0.3 :align bottom)
     ("*Help*" :size 0.5 :align bottom)
     ("\\*helpful.*\\*" :regexp t :size 0.5 :align bottom)
     ("*Completions*" :size 0.2 :align bottom)
     ('flycheck-error-list-mode :select t :align bottom :size 0.2)
     ('ivy-occur-grep-mode :align bottom :size 0.5)
     ('grep-mode :align bottom :size 0.5)
     ("*Warnings*" :select nil :ignore t :other t)

     ("\\*e?shell.*\\*" :regexp t :popup t :size 0.5 :align bottom)

     ('magit-status-mode :popup t :same t)
     ;; ('magit-log-mode :same t)
     ;; Magit buffers other than status should replace the current buffer.
     ;; ("magit-.*" :same t)
     ;; eww popups should just replace current buffer
     ('eww-bookmark-mode :same t)
     ('eww-history-mode :same t)

     ('dired-mode :other t :align left :size 0.3)

     ;; ('vundo-mode :align below :same t)
     ;; ("\\*vundo-diff.*\\*" :align below :same t)
     ('undo-tree-mode :align right :size 0.4)))
  :config
  (shackle-mode))

;;; ace-window
(use-package ace-window
  :commands (ace-window)
  :after (hydra)
  :init
  (setq aw-keys   '(?n ?e ?i ?l ?u ?y)
        aw-dispatch-always t
        aw-swap-invert t
        aw-dispatch-alist
        '((?c aw-delete-window     "Ace - Delete Window")
          (?r aw-swap-window       "Ace - Swap Window")
          (?s aw-split-window-vert "Ace - Split Vert Window")
          (?v aw-split-window-horz "Ace - Split Horz Window")
          (?o delete-other-windows "Ace - Maximize Window")
          (?p aw-flip-window)
          ;; (?u winner-undo)
          ;; (?r winner-redo)
          (?= balance-windows)))
  :config
  ;; (setq aw-keys '(?t ?n ?s ?e ?d ?h ?r ?i ?a ?o ?b ?k ?g ?j ?v ?m ?p ?l))
  ;; show the window letter in the modeline
  ;; (set-face-attribute 'aw-mode-line-face nil :inherit 'mode-line-buffer-id :foreground "lawn green")
  ;; (ace-window-display-mode t)
  (set-face-attribute 'aw-leading-char-face nil :foreground "deep sky blue" :weight 'bold :height 3.0)
  ;; :background "#303030"
  (add-to-list 'aw-dispatch-alist '(?w hydra-window-size/body) t)
  (add-to-list 'aw-dispatch-alist '(?f hydra-window-frame/body) t)
  )

;;; avy
(use-package avy
  :commands (avy-goto-char avy-goto-word-0 avy-goto-line)
  :config
  (setq avy-keys '(?t ?n ?s ?e ?d ?h ?r ?i ?a ?o ?b ?k ?g ?v ?f ?p ?l ?u ?m))
  (setq avy-background t)
  :general
  (:states '(normal)
    "g ." #'avy-goto-char
    "t"   #'avy-goto-char-timer
    "T"   #'avy-goto-word-0))

;;; ace-link
(use-package ace-link
  :commands (ace-link-nov ace-link--eww-collect info Info-mode Custom-mode)
  :general
  (:states '(motion) :keymaps '(help-mode-map helpful-mode-map)
    "f"   'ace-link-help
    "TAB" 'help-go-forward
    "C-o" 'help-go-back)
  (:states '(motion) :keymaps '(Info-mode-map)
    "f"   'ace-link-info)
  (:states '(motion) :keymaps '(compilation-mode-map)
    "f" 'ace-link-compilation)
  (:states '(motion) :keymaps '(woman-mode-map)
    "f" 'ace-link-woman)
  (:states '(motion) :keymaps '(eww-mode-map)
    "f" 'ace-link-eww)
  (:states '(normal) :keymaps '(custom-mode-map)
    "f" 'ace-link-custom)
  :init
  :config)


(provide 'amd/navigation)
;;; navigation.el ends here

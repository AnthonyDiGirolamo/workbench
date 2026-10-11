;;; -*- lexical-binding: t; -*-

;;; transient.el --- Summary
;;; Commentary:
;;; Code:

(use-package transient
  :demand
  :init
  ;; Show transient pop-up directly below the focused window.
  (setq transient-display-buffer-action
        '(display-buffer-below-selected
          (dedicated . t)
          (inhibit-same-window . t))
        transient-show-during-minibuffer-read t)

  ;; The default is the bottom of the screen (frame):
  ;; (display-buffer-in-side-window (side . bottom) (dedicated . t) (inhibit-same-window . t))
  :config
  (defun amd/major-mode-leader-transient ()
    (interactive)
    (cond
     ((eq major-mode 'org-mode)
      (amd/transient-org-menu))

     ((or (eq major-mode 'lisp-interaction-mode)
          (eq major-mode 'emacs-lisp-mode))
      (amd/transient-elisp-menu))

     ((eq major-mode 'rust-mode)
      (amd/transient-rust-menu))

     ((or (eq major-mode 'nxml-mode)
          (eq major-mode 'xml-mode))
      (amd/transient-xml-menu))

     ;; if no major-mode leader hydra defined, and an org-src buffer is active, use the org hydra
     ((member 'org-src-mode minor-mode-list)
      (amd/transient-org-menu))

     (t
      (keyboard-quit))))

;;; Rust
  (transient-define-prefix amd/transient-rust-menu ()
    "rust-mode menu"
    :transient-non-suffix #'transient--do-exit
    [["Functions"
      ("t" "test" rust-test)
      ("k" "check" rust-check)
      ("l" "clippy" rust-run-clippy)
      ("r" "run" rust-run)
      ("f"  "format" rust-format-buffer)
      ("," "Quit" transient-quit-one)]])

;;; Elisp
  (transient-define-prefix amd/transient-elisp-menu ()
    "emacs-lisp-mode menu"
    :transient-non-suffix #'transient--do-exit
    [["Functions"
      ("e" "[org] toggle code edit" amd/toggle-org-edit-code-block)
      ("d" "eval defun"             eval-defun)
      ("D" "eDebug defun"           amd/edebug-eval-defun)
      ("," "Quit" transient-quit-one)]])

;;; XML
  (transient-define-prefix amd/transient-xml-menu ()
    "xml-mode menu"
    :transient-non-suffix #'transient--do-exit
    [["Functions"
      ("f" "xml format"
       (lambda () (interactive)
         (shell-command-on-region
          (point-min) (point-max)
          "xmllint --format -" (current-buffer) t)))
      ("," "Quit" transient-quit-one)]])

;;; Align
  (transient-define-prefix amd/transient-align-menu ()
    "Align Menu"
    [["Characters"
      (":" "align :" align-to-colon)
      ("=" "align =" align-to-equals)
      ("," "align ," align-to-comma)
      ("s" "align whitespace" align-to-space)]
     ;; Group 2: Buffer Actions
     ["Regex"
      ("r" "align repeat" align-repeat)
      ("n" "align no-repeat" align-no-repeat)
      ("i" "align interactive" align-interactively)]])

;;; Org
  (transient-define-prefix amd/transient-org-menu ()
    "org-mode menu"
    :transient-non-suffix #'transient--do-exit
    [["Capture"
      ("cc" "capture" org-capture)
      ("cl" "store link" org-store-link)
      ("ci" "clock in" org-clock-in)
      ("co" "clock out" org-clock-out)
      ("cd" "clock display" org-clock-display)
      ("o" "open todos" (lambda() (interactive) (find-file org-default-notes-file)))]

     ["Formula"
      ("fc" "formula coords" org-table-toggle-coordinate-overlays)
      ("fd" "formula debug" org-table-toggle-formula-debugger)
      ("fe" "formula edit"
       (lambda() (interactive)
         (let ((current-prefix-arg '(16))) ;; emulate C-u C-u
           (call-interactively 'org-table-eval-formula)
           (evil-insert-state))))
      ("fr" "formula recalc"
       (lambda() (interactive)
         (let ((current-prefix-arg '(4))) ;; emulate C-u
           (call-interactively 'org-table-recalculate))))
      ("tp" "tangle at point"
       (lambda() (interactive)
         ;; (let ((current-prefix-arg 4)) ;; emulate C-u
         ;;   (call-interactively 'org-babel-tangle))
         (org-narrow-to-element)
         (org-babel-tangle)
         (widen)))
      ("ta" "tangle all" org-babel-tangle)]

     ["Headings"
      ("P" "property" org-set-property)
      ("S" "schedule" org-schedule)
      ("D" "due" org-deadline)
      ("r" "refile" org-refile)
      ("p" "priority" org-priority)
      ("ih" "insert header" org-babel-insert-header-arg)]

     ["Agenda/Edit"
      ("a" "agenda" org-agenda)
      ("y" "archive subtree" org-archive-subtree)
      ("R" "restart" org-mode-restart)
      ("l" "change tag (label)" counsel-org-tag)
      ("e" "code edit" amd/toggle-org-edit-code-block)]

     ["Trees"
      ("tt" "todo tree" org-show-todo-tree)
      ("A" "show all"
       (lambda() (interactive) (show-all) (org-remove-occur-highlights)))
      ("w" "widen" widen)
      ("n" "subtree" org-narrow-to-subtree)
      ("gl" "tag tree" org-match-sparse-tree)]

     ;; ["Shift"
     ;;  ("h" "←" org-shiftmetaleft  :transient t)
     ;;  ("l" "→" org-shiftmetaright :transient t)
     ;;  ("n" "↓" org-shiftmetadown  :transient t)
     ;;  ("e" "↑" org-shiftmetaup    :transient t)]

     ["Export"
      ;; ("d" "pandoc" pandoc-main-hydra/body)
      ("hy" "org→html→yank" amd/clipboard-org-buffer-to-html-xclip)
      ("hp" "html→org→paste" amd/clipboard-html-to-org-pandoc-linux)
      ("x" "export" org-export-dispatch)
      ("," "Quit" transient-quit-one)]])

;;; Tab-bar
  (defun amd/tab-bar-string-for-transient ()
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

;;; Helper functions
  (defun amd/transient-checkbox (var message-string)
    "Return current tabs as a formatted string."
    (format "[%s] %s" (if var "*" " ") message-string))

  (defun amd/display-buffer-in-posframe (buffer _alist)
    "Show BUFFER in posframe."
    (unless (posframe-workable-p)
      (error "Posframe is not workable"))
    (posframe-show
     buffer
     :position (point)
     :poshandler #'posframe-poshandler-frame-bottom-left-corner
     :internal-border-width 0)
    (get-buffer-window transient--buffer-name t))

;;; Tab bar
  (transient-define-prefix amd/transient-tab-bar-menu ()
    "tab-bar-mode menu"
    ;; pressing any other key closes the transient
    :transient-non-suffix #'transient--do-exit
    ;; show in a posframe to not leave old transient buffers
    :display-action '(amd/display-buffer-in-posframe)
    [
     :description (lambda () (amd/tab-bar-string-for-transient))
     [("h" "← prev"           tab-previous :transient t)
      ("H" "← move"           tab-bar-move-tab-backward :transient t)
      ("T" "split → new Tab"  tab-bar-move-window-to-tab :transient t)]

     [("l"  "→ next/new"       amd/tab-bar-next-or-new-tab :transient t)
      ("L"  "→ move"           tab-bar-move-tab :transient t)
      ("F"  "tab → new Frame"  tab-bar-detach-tab :transient t)]

     [("N"  "new"               tab-bar-new-tab :transient t)
      ("c"  "close"             tab-bar-close-tab :transient t)
      ("t"  "switch"            tab-bar-switch-to-tab)]

     [("o"  "reopen"            tab-bar-undo-close-tab :transient t)
      ("r"  "rename"            tab-rename :transient t)]

     [("w"  "window size"       amd/transient-window-size-menu)
      ("f"  "window frame"      amd/transient-frame-menu)
      ("RET" "Quit"             transient-quit-all)]
     ])

;;; Window size
  (transient-define-prefix amd/transient-window-size-menu ()
    "window size menu"
    ;; pressing any other key closes the transient
    :transient-non-suffix #'transient--do-exit
    ;; show in a posframe to not leave old transient buffers
    :display-action '(amd/display-buffer-in-posframe)
    [[""
      ("h" "< shrink"  shrink-window-horizontally :transient t)
      ""]
     [("e" "↑ shrink"    shrink-window :transient t)
      ""
      ("n" "↓ enlarge"   enlarge-window :transient t)]
     [""
      ("l" "> enlarge" enlarge-window-horizontally :transient t)
      ""]
     [("w" "maximize"           evil-window-set-height :transient t)
      ("b" "balance"           balance-windows :transient t)
      ("RET" "Quit"             transient-quit-all)]
     ])

;;; Frames
  (transient-define-prefix amd/transient-frame-menu ()
    "frame menu"
    ;; pressing any other key closes the transient
    :transient-non-suffix #'transient--do-exit
    ;; show in a posframe to not leave old transient buffers
    :display-action '(amd/display-buffer-in-posframe)
    ["Frame"
     [("m" "maximize"   toggle-frame-maximized :transient t)
      ("f" "fullscreen" toggle-frame-fullscreen :transient t)
      ("n" "new"        make-frame)
      ("c" "close"      delete-frame)
      ("RET" "Quit"     transient-quit-all)]
     ])

  (defun amd/open-emacs-config ()
    "Open a emacs config .el or .org file."
    (interactive)
    (cl-loop
     with root-dir = "~/workbench/emacs"
     with file-matcher = "\\.\\(el\\|org\\)$"
     for file in (append
                  (directory-files root-dir t file-matcher)
                  (directory-files-recursively (concat root-dir "/config") file-matcher))
     collect (expand-file-name file)
     into file-list
     ;; into current-tab-list
     finally (find-file (completing-read "Select file: " (sort file-list) nil t))
     ))

;;; Leader
  (transient-define-prefix amd/transient-leader-menu ()
    "Top level leader menu"
    :transient-non-suffix #'transient--do-exit
    :display-action '(display-buffer-at-bottom
                      (dedicated . t)
                      (inhibit-same-window . t))
    [["File"
      ("t" "tabs"                      amd/transient-tab-bar-menu)
      ("s" "set-toggles"               amd/transient-toggles-menu)
      ("g" "git"                       magit-status)
      ("d" "find-file"                 counsel-find-file)
      ("u" "vundo"                     vundo)
      ("w" "window"                    ace-window)
      ("c" "calc"                      calc-dispatch)
      ("j" "jump-imenu"                consult-imenu)
      ("v" "open init.el"              amd/open-emacs-config)
      ("V" "open ~/workbench"            (lambda () (interactive) (find-file "~/workbench/")))]

     ["Check"
      ("fc" "flymake"                  flymake-show-buffer-diagnostics)
      ("fn" "flycheck next error"      flymake-goto-next-error :transient t)
      ;; ("fc" "flycheck"                 flycheck-list-errors)
      ;; ("fn" "flycheck next error"      flycheck-next-error)
      ;; ("fp" "flycheck prev error"      flycheck-previous-error)
      ("bb" "buffer switch"            consult-buffer)
      ("bi" "buffer ibuffer"           ibuffer)
      ("bk" "buffer kill"              kill-current-buffer)
      ("br" "buffer revert"            revert-buffer)
      ("yb" "yank buffer"              amd/copy-buffer)
      ("yxy" "x-yank"                  amd/x-yank)
      ("yxp" "x-paste"                 amd/x-paste)]

     ["Edit"
      ("a" "align"                     amd/transient-align-menu)
      ("G"  "search git grep"          counsel-git-grep)
      "TODO ripgrep"
      ;; ("rgg"  "ripgrep"                counsel-rg)
      ("rg"  "ripgrep w/ dir"          amd/counsel-rg-with-initial-directory)
      ("pa" "search ag counsel"        counsel-ag)
      ("pf" "search ag filename regex" amd/counsel-ag-with-filename-regex)
      ;; TODO
      ;; ("pt" "search pt counsel"        counsel-pt)
      ;; ("pp" "search pt project"        projectile-pt)
      ;; ("po" "search pt other"          pt-regexp)
      ("/"  "search grep/swiper"       counsel-grep-or-swiper)
      ("," "major-mode hydra"          amd/major-mode-leader-transient)]

     ["Load"
      ("lt" "load theme"               load-theme)
      ("lc" "list colors"              list-colors-display)
      ("lf" "list faces"               list-faces-display)
      ("lp" "list packages"            package-list-packages)
      ("hk" "help keys"                counsel-descbinds)
      ("hK" "help whichkey"            which-key-show-top-level)
      ("hm" "help mode"
       (lambda () (interactive) (describe-variable 'major-mode)))
      ("bu" "browse url"               browse-url-generic)]

     ["Project"
      ("ps" "project switch"           projectile-switch-project)
      ("pe" "project eshell"           amd/eshell-or-project-eshell)
      ("pc" "project compile"          project-compile)
      ("pr" "project recompile"        project-recompile)
      ("pi" "project clear"            projectile-invalidate-cache)
      ("rf" "recentf"                  consult-recent-file)
      ("rt" "run test"                 run-current-test)
      ("rF" "run file"
       (lambda () (interactive) (run-current-test nil t)))
      ("rp" "run pico8"                run-pico8)
      ("rl" "run love2d"               run-love2d)]

     ["Desktop"
      ("zi" "zoom-in"
       (lambda () (interactive) (text-scale-increase 0.5)) :transient t )
      ("zo" "zoom-out"
       (lambda () (interactive) (text-scale-decrease 0.5)) :transient t )
      ("DS" "desktop-save"             desktop-save)
      ("DC" "desktop-clear"            desktop-clear)
      ("DL" "desktop-read"             desktop-read)
      ("zz" "server-edit done"         server-edit)
      ("WC" "word-count"               count-words)
      ("xx"  "M-x"                     counsel-M-x)]])

;;; Appearance Toggles
  (transient-define-prefix amd/transient-toggles-menu ()
    "File appearance toggles"
    ;; pressing any other key closes the transient
    :transient-non-suffix #'transient--do-exit
    ;; show in a posframe to not leave old transient buffers
    :display-action '(amd/display-buffer-in-posframe)

    [["Line Endings"
      ("t" toggle-truncate-lines
       :description
       (lambda ()
         (amd/transient-checkbox truncate-lines "truncate-lines"))
       :transient t)
      ("a" auto-fill-mode
       :description
       (lambda ()
         (amd/transient-checkbox auto-fill-function "auto-fill-mode"))
       :transient t)
      ("fc" display-fill-column-indicator-mode
       :description
       (lambda ()
         (amd/transient-checkbox display-fill-column-indicator-mode "fill column indicator mode"))
       :transient t)
      ("fr" fringe-mode
       :description
       (lambda ()
         (amd/transient-checkbox fringe-mode "fringe-mode"))
       :transient t)]

     ["Line Numbers"
      ("l" display-line-numbers-mode
       :description
       (lambda ()
         (amd/transient-checkbox display-line-numbers-mode "display-line-numbers-mode"))
       :transient t)
      ("h" hl-line-mode
       :description
       (lambda ()
         (amd/transient-checkbox hl-line-mode "hl-line-mode"))
       :transient t)
      ("C" amd-center-buffer-mode
       :description
       (lambda ()
         (amd/transient-checkbox amd-center-buffer-mode "amd-center-buffer-mode"))
       :transient t)
      ("i" highlight-indent-guides-mode
       :description
       (lambda ()
         (amd/transient-checkbox highlight-indent-guides-mode "highlight-indent-guides-mode"))
       :transient t)]

     ["Appearance"
      ("ff" "Font" amd/transient-font-menu)
      ("r" rainbow-delimiters-mode
       :description
       (lambda ()
         (amd/transient-checkbox rainbow-delimiters-mode "rainbow-delimiters-mode"))
       :transient t)
      ("c" color-identifiers-mode
       :description
       (lambda ()
         (amd/transient-checkbox color-identifiers-mode "color-identifiers-mode"))
       :transient t)
      ("g" glasses-mode
       :description
       (lambda ()
         (amd/transient-checkbox glasses-mode "glasses-mode"))
       :transient t)
      ("w" whitespace-mode
       :description
       (lambda ()
         (amd/transient-checkbox whitespace-mode "hl-line-mode"))
       :transient t)]
     ])

;;; Font Toggles
  (transient-define-prefix amd/transient-font-menu ()
    "Set font transient"
    ;; pressing any other key closes the transient
    :transient-non-suffix #'transient--do-exit
    ;; show in a posframe to not leave old transient buffers
    :display-action '(amd/display-buffer-in-posframe)

    [[;; Size heading
      :description
      (lambda ()
        (format "Size: %.2f" amd/font-size))

      ("h"
       (lambda () (interactive)
         (amd/set-font (- amd/font-size 1.0) amd/font-name))
       :description "smaller"
       :transient t)
      ("l"
       (lambda () (interactive)
         (amd/set-font (+ amd/font-size 1.0) amd/font-name))
       :description "larger"
       :transient t)

      ;; "" ;; Empty Line
      "Options" ;; heading

      ("j"
       (lambda () (interactive)
         (let ((new-value (if amd/font-antialias 'no 'yes)))
           (message "%s" new-value)
           (amd/set-font amd/font-size amd/font-name new-value)))
       :description
       (lambda ()
         (format "[%s] antialias" (if amd/font-antialias "x" " ")))
       :transient t)
      ]

     [;; Font heading
      :description
      (lambda ()
        (format "Font: %s" amd/font-name))

      ("a"
       (lambda () (interactive)
         (amd/set-font amd/font-size "Iosevka SS08 Light"))
       :description
       (lambda ()
         (format "[%s] Iosevka SS08"
                 (if (string-equal amd/font-name "Iosevka SS08 Light") "x" " ")))
       :transient t)
      ("r"
       (lambda () (interactive)
         (amd/set-font amd/font-size "Iosevka Term SS17 Light"))
       :description
       (lambda ()
         (format "[%s] Iosevka Term SS17"
                 (if (string-equal amd/font-name "Iosevka Term SS17 Light") "x" " ")))
       :transient t)
      ("s"
       (lambda () (interactive)
         (amd/set-font amd/font-size "PragmataPro"))
       :description
       (lambda ()
         (format "[%s] PragmataPro"
                 (if (string-equal amd/font-name "PragmataPro") "x" " ")))
       :transient t)
      ("c"
       (lambda () (interactive)
         (amd/set-font amd/font-size "CozetteVector"))
       :description
       (lambda ()
         (format "[%s] CozetteVector"
                 (if (string-equal amd/font-name "CozetteVector") "x" " ")))
       :transient t)
      ]
     ])

  ;; Truncate long lines in all transient buffers
  (add-hook 'transient-setup-buffer-hook (lambda () (setq truncate-lines t)))
  (transient-bind-q-to-quit))


(provide 'amd/transient)
;;; transient.el ends here

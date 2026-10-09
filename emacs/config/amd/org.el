;;; -*- lexical-binding: t; -*-

;;; org.el --- Summary
;;; Commentary:
;;; Code:

;;; org

(use-package org
  :commands org-mode
  :init
  (setq org-default-notes-file "~/org/todo.org")

  (setq org-ellipsis " ▽ ")
  ;; UTF-8 Ellipsis Chars ≫ ↩ • ◐ ▪ ► ■ □ ▢ …
  ;; PragmataPro Chars ☇ ⌔ ⇣ ⍖ ⭿ ❯ ⍢ ⊽ ∨ ▼ ▽ ╲╱ ⬇
  ;;   Double width    ⤑ ⮷ ⮒ ⮐ ⭸ ↲ ↴ ⬎ ﹀

  ;; (setq org-display-internal-link-with-indirect-buffer t)

  ;; Open file links in the same buffer
  (setq
   org-link-frame-setup '((vm . vm-visit-folder-other-frame)
                          (vm-imap . vm-visit-imap-folder-other-frame)
                          ;; (gnus . org-gnus-no-new-news)
                          (file . find-file)
                          ;; (file . find-file-other-window)
                          (wl . wl-other-frame)))


  ;; Square Bullets
  ;; (setq org-bullets-bullet-list (quote ("■" "■" "■" "■" "■" "■" "■" "■")))
  ;; Roman Numeral Bullets
  ;; (setq org-bullets-bullet-list (quote ("Ⅰ" "Ⅱ" "Ⅲ" "Ⅳ" "Ⅴ" "Ⅵ" "Ⅶ" "Ⅷ" "Ⅸ" "Ⅹ" "Ⅺ" "Ⅻ")))
  ;; Nubered Circle Dingbat Bullets
  ;; (setq org-bullets-bullet-list (quote ("❶" "❷" "❸" "❹" "❺" "❻" "❼" "❽" "❾" "❿")))
  ;; (setq org-bullets-bullet-list (quote ("➀" "➁" "➂" "➃" "➄" "➅" "➆" "➇" "➈" "➉")))
  ;; (setq org-bullets-bullet-list (quote ("" "" "" "" "" "" "" "" "" "")))
  ;;               
  ;; (setq org-bullets-bullet-list (quote ("◳" "◲" "◱" "◰" "◷" "◶" "◵" "◴" "◹" "◺" "◿" "◸")))

  (setq org-hide-leading-stars t) ;; can be used instead of org-bullets

  (setq org-catch-invisible-edits 'show)
  (setq org-blank-before-new-entry '((heading . t) (plain-list-item . t)))
  (setq org-src-window-setup 'current-window
        org-src-fontify-natively t)
  (setq org-fontify-whole-heading-line t
        org-fontify-done-headline t
        org-fontify-quote-and-verse-blocks t)
  (setq org-display-inline-images t)
  (setq org-todo-keywords '((sequence "TODO" "DOING" "WAITING" "DONE")))

  ;; (setq org-priority-regexp ".*?\\(\\[P\\([A-Z0-9]\\)\\] ?\\)")

  (defun amd/org-todo-or-checkbox ()
    (interactive)
    (if (org-at-item-checkbox-p) (org-toggle-checkbox) (org-todo)))
  (defun amd/org-next-visible-heading-and-recenter ()
    (interactive)
    (call-interactively 'org-next-visible-heading) (recenter))
  (defun amd/org-previous-visible-heading-and-recenter ()
    (interactive)
    (call-interactively 'org-previous-visible-heading) (recenter))

  :general
  (:states '(normal)
   :keymaps '(org-mode-map)
    "N" 'amd/org-next-visible-heading-and-recenter
    "E" 'amd/org-previous-visible-heading-and-recenter
    "L" 'org-forward-heading-same-level
    "H" 'org-backward-heading-same-level
    "X" 'amd/org-todo-or-checkbox
    "o" 'evil-open-below
    "O" '(lambda () (interactive) (amd/org-bol-call 'org-meta-return))
    "RET" 'org-open-at-point
    "^" 'org-beginning-of-line
    "$" 'org-end-of-line
    "<" 'org-shiftmetaleft
    ">" 'org-shiftmetaright
    "M-H" 'org-metaleft
    "M-L" 'org-metaright
    "M-N" 'org-metadown
    "M-E" 'org-metaup
    "-" 'org-cycle-list-bullet
    "<tab>" 'org-cycle
    "TAB" 'org-cycle
    "f" 'ace-link-org)
  (:states '(insert)
   :keymaps '(org-mode-map)
    ;; Use yankpad instead
    ;; "C-b" 'amd/org-insert-code-block
    "M-H" 'org-metaleft
    "M-L" 'org-metaright
    "M-N" 'org-metadown
    "M-E" 'org-metaup)

  :config
  ;; (evil-define-minor-mode-key 'normal 'org-src-mode (kbd "C-s") 'org-edit-src-save)
  ;; (evil-define-minor-mode-key 'insert 'org-src-mode (kbd "C-s") (lambda() (interactive) (org-edit-src-save) (evil-normal-state)))
  (defun amd/org-eol-call (fun)
    "Go to end of line and call provided function. FUN function callback"
    (end-of-line)
    (funcall fun)
    (evil-append nil))

  (defun amd/org-bol-call (fun)
    "Go to end of line and call provided function. FUN function callback"
    (beginning-of-line)
    (funcall fun)
    (evil-append nil))

  (add-to-list 'org-agenda-files org-default-notes-file)

  ;; Add all ~/org/*.org files to 'org-agenda-files
  (if (file-exists-p "~/org/")
      (cl-loop for org-file-name in (directory-files "~/org/" nil ".*\.org$")
               do (add-to-list 'org-agenda-files
                               (concat "~/org/" org-file-name))))

  ;; prettify-symbols-mode only operates on strings
  ;; (add-hook 'org-mode-hook 'prettify-symbols-mode)
  ;; (add-hook 'org-mode-hook (lambda () (push '((regexp-quote "^**") . " *") prettify-symbols-alist)))

  ;; #+STARTUP: odd
  ;; #+STARTUP: indent
  ;; #+STARTUP: hidestars
  ;; (add-hook 'org-mode-hook 'org-superstar-mode)

  (add-hook 'org-mode-hook 'flyspell-mode)
  ;; (add-hook 'org-mode-hook 'pandoc-mode)

  ;; Org Completion
  ;; (add-hook 'org-mode-hook (lambda () (company-mode -1)))
  (add-hook 'org-mode-hook
            (lambda ()
              (setq completion-at-point-functions
                    '(org-completion-symbols
                      ora-cap-filesystem
                      org-completion-refs))))

  ;; ;; Evil C-p
  ;; evil-complete-previous-func
  ;; evil-complete-previous-line-func
  ;; evil-complete-previous-minibuffer-func

  ;; ;; Evil C-n
  ;; evil-complete-next-func
  ;; evil-complete-next-line-func
  ;; evil-complete-next-minibuffer-func

  (defun org-completion-symbols ()
    (when (looking-back "=[a-zA-Z]+")
      (let (cands)
        (save-match-data
          (save-excursion
            (goto-char (point-min))
            (while (re-search-forward "=\\([a-zA-Z]+\\)=" nil t)
              (cl-pushnew
               (match-string-no-properties 0) cands :test 'equal))
            cands))
        (when cands
          (list (match-beginning 0) (match-end 0) cands)))))

  (defun ora-cap-filesystem ()
    (let (path)
      (when (setq path (ffap-string-at-point))
        (let ((compl
               (all-completions path #'read-file-name-internal)))
          (when compl
            (let ((offset (ivy-completion-common-length (car compl))))
              (list (- (point) offset) (point) compl)))))))

  (defun org-completion-refs ()
    (when (looking-back "\\\\\\(?:ref\\|label\\){\\([^\n{}]\\)*")
      (let (cands beg end)
        (save-excursion
          (goto-char (point-min))
          (while (re-search-forward "\\label{\\([^}]+\\)}" nil t)
            (push (match-string-no-properties 1) cands)))
        (save-excursion
          (up-list)
          (setq end (1- (point)))
          (backward-list)
          (setq beg (1+ (point))))
        (list beg end
              (delete (buffer-substring-no-properties beg end)
                      (nreverse cands))))))

  (defun amd/use-default-paragraph-delimiters ()
    (setq paragraph-start (default-value 'paragraph-start)
          paragraph-separate (default-value 'paragraph-separate)))
  (add-hook 'org-mode-hook 'amd/use-default-paragraph-delimiters)

  ;; Don't really need our own minor mode to make evil keybindings
  ;; (define-minor-mode evil-org-mode
  ;;   "Buffer local minor mode for evil-org"
  ;;   :init-value nil
  ;;   ;; :lighter " EvilOrg"
  ;;   :keymap (make-sparse-keymap) ; defines evil-org-mode-map
  ;;   :group 'evil-org)
  ;; (add-hook 'org-mode-hook 'evil-org-mode) ;; only load with org-mode

  (add-hook 'org-mode-hook
            (lambda ()
              (define-key evil-inner-text-objects-map "h" #'er/mark-org-parent)
              (define-key evil-inner-text-objects-map "c" #'er/mark-org-code-block)
              (setq evil-want-fine-undo 'yes)))

  ;; (add-hook 'org-mode-hook
  ;;           (lambda ()
  ;;             (add-to-list (make-local-variable 'company-backends)
  ;;                          'company-ispell)))

  ;; (advice-add 'org-next-visible-heading :after #'recenter) ;; this doesn't work with recenter?
  ;; (advice-add 'org-previous-visible-heading :after #'recenter) ;; this doesn't work with recenter?

  ;; not working with org-archive-subtree
  ;; (defadvice org-next-visible-heading (after advice-for-org-next-visible-heading activate) (recenter))
  ;; (defadvice org-previous-visible-heading (after advice-for-org-previous-visible-heading activate) (recenter))

  ;; (defadvice org-forward-heading-same-level (after advice-for-org-forward-heading-same-level activate) (recenter))
  ;; (defadvice org-backward-heading-same-level (after advice-for-org-backward-heading-same-level activate) (recenter))

  (advice-add 'org-forward-heading-same-level :after #'recenter)
  (advice-add 'org-backward-heading-same-level :after #'recenter)

  ;; ;; rebind some existing org-mode maps
  ;; (mapc
  ;;  (lambda (state)
  ;;    (evil-define-key state org-mode-map
  ;;      (kbd "M-e") (lambda () (interactive) (tmux-window-navigation/move-up))   ;; was org-forward-sentence
  ;;      (kbd "M-h") (lambda () (interactive) (tmux-window-navigation/move-left)) ;; was org-mark-element
  ;;    ))
  ;;  '(normal insert))

  (org-babel-do-load-languages
   'org-babel-load-languages
   '((shell . t)
     (python . t)
     (ruby . t)
     (ditaa . t)
     (sqlite . t)
     (perl . t)
     (emacs-lisp . t)
     (dot . t)
     (gnuplot . t)
     ))

  (setq org-babel-ruby-command "~/.rbenv/shims/ruby")

  (defun amd/clipboard-org-buffer-to-html-xclip ()
    "Use ox-html export and copy results to the clipboard as HTML"
    (interactive)
    ;; (let ((output-filename (org-html-export-to-html)))
    ;;   (shell-command
    ;;    (format "cat %s | xclip -selection clipboard -i -t text/html &> /dev/null" output-filename))
    ;; )
    (let ((output-buffer (org-html-export-as-html)))
      (switch-to-buffer output-buffer)
      (shell-command-on-region
       1 (point-max)
       ;; "xclip -selection clipboard -i -t text/html &> /dev/null"
       "wl-copy -t text/html &> /dev/null")
      (delete-window))
    (recenter)
    (evil-normal-state))


  (defun amd/clipboard-html-to-org-pandoc-mac ()
    "Convert clipboard contents from HTML to Org and then paste (yank)."
    (interactive)
    (kill-new
     (shell-command-to-string
      "osascript -e 'the clipboard as \"HTML\"' | ruby -ne 'puts([$_[10..-3]].pack(\"H*\"))' | pandoc -f html -t org"))
    (yank))

  (defun amd/clipboard-html-to-org-pandoc-linux ()
    "Convert clipboard contents from HTML to Org and then paste (yank)."
    (interactive)
    (kill-new
     (shell-command-to-string
      ;; "xclip -selection clipboard -o -t text/html | pandoc -f html -t org"
      "wl-paste -t text/html | pandoc -f html -t org"))
    (yank))

  (defun amd/clipboard-html-to-markdown-pandoc-linux ()
    "Convert clipboard contents from HTML to Org and then paste (yank)."
    (interactive)
    (kill-new
     (shell-command-to-string
      ;; "xclip -selection clipboard -o -t text/html | pandoc -f html -t org"
      "wl-paste -t text/html | pandoc -f html -t markdown"))
    (yank))

  (defun amd/clipboard-org-to-html-mac ()
    "Convert the org buffer to html and put it on the clipboard."
    (interactive)
    (let* ((html-output-buffer (org-html-export-as-html)))
      (switch-to-buffer
       html-output-buffer
       (let ((hex-encoded-string
              (cl-loop for line in (string-to-list (buffer-string))
                       concat (format "%02X" line))))
         (message
          (shell-command-to-string
           (concat "osascript -e \"set the clipboard to «data HTML" hex-encoded-string "»\"")))))
      (delete-window)))

  (defun org-agenda-cts ()
    (let ((args (get-text-property
                 (min (1- (point-max)) (point))
                 'org-last-args)))
      (nth 2 args)))

  (defhydra hydra-org-agenda-view (:hint none)
    "
_d_: ?d? day        _g_: time grid=?g? _a_: arch-trees
_w_: ?w? week       _[_: inactive      _A_: arch-files
_t_: ?t? fortnight  _f_: follow=?f?    _r_: report=?r?
_m_: ?m? month      _e_: entry =?e?    _D_: diary=?D?
_y_: ?y? year       _q_: quit          _L__l__c_: ?l?
"
    ("SPC" org-agenda-reset-view)
    ("d" org-agenda-day-view
     (if (eq 'day (org-agenda-cts))
         "[x]" "[ ]"))
    ("w" org-agenda-week-view
     (if (eq 'week (org-agenda-cts))
         "[x]" "[ ]"))
    ("t" org-agenda-fortnight-view
     (if (eq 'fortnight (org-agenda-cts))
         "[x]" "[ ]"))
    ("m" org-agenda-month-view
     (if (eq 'month (org-agenda-cts)) "[x]" "[ ]"))
    ("y" org-agenda-year-view
     (if (eq 'year (org-agenda-cts)) "[x]" "[ ]"))
    ("l" org-agenda-log-mode
     (format "% -3S" org-agenda-show-log))
    ("L" (org-agenda-log-mode '(4)))
    ("c" (org-agenda-log-mode 'clockcheck))
    ("f" org-agenda-follow-mode
     (format "% -3S" org-agenda-follow-mode))
    ("a" org-agenda-archives-mode)
    ("A" (org-agenda-archives-mode 'files))
    ("r" org-agenda-clockreport-mode
     (format "% -3S" org-agenda-clockreport-mode))
    ("e" org-agenda-entry-text-mode
     (format "% -3S" org-agenda-entry-text-mode))
    ("g" org-agenda-toggle-time-grid
     (format "% -3S" org-agenda-use-time-grid))
    ("D" org-agenda-toggle-diary
     (format "% -3S" org-agenda-include-diary))
    ("!" org-agenda-toggle-deadlines)
    ("["
     (let ((org-agenda-include-inactive-timestamps t))
       (org-agenda-check-type t 'timeline 'agenda)
       (org-agenda-redo)))
    ("q" (message "Abort") :exit t))

  (add-hook 'org-agenda-mode-hook (lambda () (define-key org-agenda-mode-map "v" 'hydra-org-agenda-view/body)))

  (defun amd/org-insert-code-block ()
    (interactive)
    ;; For org version < 9.2
    ;; (org-complete-expand-structure-template
    ;;  (point)
    ;;  (--first (equal (car it) "s") org-structure-template-alist))
    ;; For org version >= 9.2
    (org-insert-structure-template "src")))

;; * Easy Templates
;;
;; Typing ~<s~ followed by ~TAB~ will expand blocks.
;;
;; Supported Types: [[info:org#Easy%20templates][info:org#Easy templates]] ([[http://orgmode.org/org.html#Easy-templates][The Org Manual - Easy Templates]])

;;; org exporting

(use-package ox-html
  :after org
  :custom
  (org-html-html5-fancy t))

(use-package ox
  :after org
  :init
  (defun amd/org-export-html-wrap-src-blocks-in-tables (text backend info)
    "Add ``` to the beginning and end of src blocks."
    (when (org-export-derived-backend-p backend 'html)
      (with-temp-buffer
        (insert text)
        (goto-char (point-min))
        ;; find starting <pre> tag
        (re-search-forward "<pre class=\"src src-[^\"]*\">")
        ;; start a table tag
        (insert "<table class=\"kodify\"><tbody><tr><td>")
        ;; find the end </pre> tag
        (search-forward "\n</pre>")
        ;; delete the \n before the </pre> tag
        (goto-char (match-beginning 0))
        (delete-char 1)
        ;; close the table tag
        (search-forward "</pre>")
        (insert "</td></tr></tbody></table>")
        (buffer-string))))
  :config
  ;; TODO: this is broken with error:
  ;;   progn: search failed "</pre>"
  ;; (add-to-list 'org-export-filter-src-block-functions 'amd/org-export-html-wrap-src-blocks-in-tables)
  )

(use-package ox-gfm
  :after ox)

;;; org-capture

(use-package org-capture
  :after org
  :config
  (setq org-capture-templates
        `(("b"
           ,(format "  ~/workbench/bookmarks.org & selected text")
           entry (file+olp+datetree "~/workbench/bookmarks.org" "Bookmarks")
           "* %U %a\n  %i\n"
           :empty-lines 1)

          ("t" ,(format " Tasks"))

          ("th"
           ,(format "  headline w/ date+link & selected text")
           entry (file+headline org-default-notes-file "Inbox")
           "* %?\n  Source: %u %a\n\n  %i\n"
           :empty-lines 1)

          ("tc"
           ,(format
             "  code w/ date+link")
           entry (file+headline org-default-notes-file "Inbox")
           "* %^{Title}%?\n  Source: %u %a\n\n  #+begin_src %^{language}\n    %i\n  #+end_src\n"
           :empty-lines 1)

          ("tt"
           ,(format "  TODO")
           entry (file+headline org-default-notes-file "Inbox")
           "* TODO %?\n  SCHEDULED: %t\n  %a\n\n  %i\n")
          ))
  (add-hook 'org-capture-mode-hook 'evil-insert-state))

(use-package org-tempo
  ;; For inserting structured templates by typing: < s TAB
  :after org)

;;; org-protocol

(use-package org-protocol
  :after org)

;;; Extras

(use-package kanban
  :after org
  :init
  (setq kanban-max-column-width 80))

(use-package toc-org
  :after org
  :config
  (add-hook 'org-mode-hook 'toc-org-enable))

(provide 'amd/org)
;;; org.el ends here

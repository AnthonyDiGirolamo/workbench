;;; -*- lexical-binding: t; -*-

;;; languages.el --- Summary
;;; Commentary:
;;; Code:

(use-package prog-mode
  :config
  (when (display-graphic-p)
    ;; (global-prettify-symbols-mode 1)
    (setq
     prettify-symbols-unprettify-at-point t
     prettify-symbols-alist
     '(("lambda" . ?ƛ)
       ("self." . ?ⓢ)
       ;; ("->" . (?\s (Br . Bl) ?))
       ;; ("-->" . (?\s (Br . Bl) ?\s (Br . Bl) ?))
       ;; ("==>" . (?\s (Br . Bl) ?\s (Br . Bl) ?))
       ;; ("=>" . (?\s (Br . Bl) ?))
       ;; ("--" . (?\s (Br . Bl) ?))
       ;; ("!=" . (?\s (Br . Bl) ?))
       ;; ("==" . (?\s (Br . Bl) ?))
       ;; (">=" . (?\s (Br . Bl) ?))
       ;; ("<=" . (?\s (Br . Bl) ?))
       ;; ("~=" . (?\s (Br . Bl) ?))
       ;; ("&&" . (?\s (Br . Bl) ?))
       ;; ("#{" . (?\s (Br . Bl) ?))
       ;; ("ERROR" . (?\s (Br . Bl) ?\s (Br . Bl) ?\s (Br . Bl) ?\s (Br . Bl) ?\s (Br . Bl) ?))
       ;; ("DEBUG" . (?\s (Br . Bl) ?\s (Br . Bl) ?\s (Br . Bl) ?\s (Br . Bl) ?\s (Br . Bl) ?))
       ))))

(use-package emacs-lisp
  :general
  (:states
   '(normal visual)
   :keymaps '(emacs-lisp-mode-map)
   ;; "N" 'forward-sexp
   ;; "E" 'backward-sexp
   "N" 'outline-next-heading
   "E" 'outline-previous-heading
  ))

(use-package outli
  :config
  (add-hook 'emacs-lisp-mode-hook 'outli-mode)
  )

(use-package lispy
  :disabled ;; TODO
  :diminish
  :commands (emacs-lisp-mode)
  :general
  (:keymaps '(lispy-mode-map)
   ;; was lispy-left
   "M-n" 'tmux-window-navigation/move-down)
  :init
  (add-hook 'emacs-lisp-mode-hook
            (lambda () (lispy-mode 1)))
  :config)

(use-package lispyville
  :disabled ;; TODO
  :diminish
  :after lispy
  :general
  (:states '(motion)
   :keymaps '(lispyville-mode-map)
   ;; was lispyville-{beginning,end}-of-defun
   ;; from key theme: additional-motions
   "M-h" 'tmux-window-navigation/move-left
   "M-l" 'tmux-window-navigation/move-right)
  :init
  (add-hook 'lispy-mode-hook #'lispyville-mode)
  :config
  (lispyville-set-key-theme
   '(operators
     ;; additional-motions
     slurp/barf-cp
     commentary)))

(use-package eldoc
  :diminish)

(use-package lua-mode
  :custom
  (lua-indent-level 2))

;; Markdown mode
(use-package markdown-mode
  :defer t
  :general
  (:states
   '(normal visual)
   :keymaps '(markdown-mode-map)
   "N" 'markdown-outline-next
   "E" 'markdown-outline-previous)
  :init
  (add-to-list 'auto-mode-alist '("\\.text\\'" . markdown-mode))
  (add-to-list 'auto-mode-alist '("\\.markdown\\'" . markdown-mode))
  (add-to-list 'auto-mode-alist '("\\.md\\'" . markdown-mode)))

(use-package rst-mode
  :defer t
  :init
  (add-hook 'rst-mode-hook 'flyspell-mode)
  (add-hook 'rst-mode-hook (lambda () (setq-local fill-column 80) (auto-fill-mode)))
  :config
  (defun amd/move-rst-section (beg end &optional move-up)
    "Move rst section."
    (interactive "r")
    (let ((text (delete-and-extract-region beg end)))
      (if move-up
          (call-interactively 'rst-backward-section)
        (call-interactively 'rst-forward-section))
      (insert text)
      (call-interactively 'rst-backward-section)))
  (defun amd/move-rst-section-down ()
    (interactive)
    (rst-mark-section)
    (amd/move-rst-section (region-beginning) (region-end) nil))
  (defun amd/move-rst-section-up ()
    (interactive)
    (rst-mark-section)
    (amd/move-rst-section (region-beginning) (region-end) t))
  :general
  (:states '(motion) :keymaps '(rst-mode-map)
   "E" 'rst-backward-section
   "N" 'rst-forward-section
   "M-<down>" 'amd/move-rst-section-down
   "M-<up>" 'amd/move-rst-section-up))

;; Web Settings
(use-package web-mode
  :defer t
  :general
  (:states '(insert) :keymaps '(web-mode-map)
   "C-e" 'emmet-expand-line)
  :init
  (setq web-mode-markup-indent-offset 2
        web-mode-css-indent-offset 2
        web-mode-code-indent-offset 2)
  (setq web-mode-style-padding 2
        web-mode-script-padding 2
        web-mode-block-padding 0)
  (setq web-mode-enable-current-element-highlight t)
  (setq web-mode-enable-current-column-highlight t)
  (setq web-mode-engines-alist '(("liquid" . "\\.html\\'")))
  (add-to-list 'auto-mode-alist '("\\.erb\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.html?\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.hbs\\'" . web-mode)))

(use-package python
  :commands python-mode
  :init
  (add-hook 'python-mode-hook (lambda () (setq-local fill-column 80)))
  (setq python-shell-interpreter "ipython"
        python-shell-interpreter-args "-i"))

;; Python Settings
(use-package elpy
  ;; https://github.com/jorgenschaefer/elpy
  :disabled
  :custom
  (elpy-rpc-python-command "python3")
  (elpy-modules '(elpy-module-sane-defaults
                  ;; elpy-module-company
                  elpy-module-eldoc
                  elpy-module-flymake
                  ;; elpy-module-highlight-indentation
                  elpy-module-pyvenv
                  ;; elpy-module-yasnippet
                  elpy-module-django)))

(use-package js2-mode
  :defer t
  :init
  ;; (add-hook 'js-mode-hook 'js2-minor-mode)
  (add-to-list 'auto-mode-alist '("\\.js\\'" . js2-mode)))

;; (use-package ac-js2
;;   :defer t
;;   :init
;;   (add-hook 'js2-mode-hook 'ac-js2-mode))

;; Ruby Settings
(use-package robe
  :disabled
  :defer t
  :init
  (setq ruby-deep-indent-paren nil)
  (add-hook 'ruby-mode-hook 'robe-mode)
  (add-hook 'robe-mode-hook 'ac-robe-setup)
  ;; (push 'company-robe company-backends)

  (add-hook 'ruby-mode-hook (lambda () (modify-syntax-entry ?_ "w")))
  ;; super word should handle the above
  ;; (add-hook 'ruby-mode-hook 'superword-mode)

  ;; (add-to-list 'load-path "~/.emacs.d/xmpfilter")
  ;; (require 'rcodetools)
  ;; (global-set-key (kbd "C-c C-c") 'xmp)
  (eval-after-load 'inf-ruby
    `(add-to-list 'inf-ruby-implementations '("bundle console"))))

;; Set Evil indentation amount to python indent amount. Necessary if a value other than the default of 4.
(add-hook 'python-mode-hook
          (function (lambda ()
                      (setq evil-shift-width python-indent-offset))))
(add-hook 'ruby-mode-hook
          (function (lambda ()
                      (setq evil-shift-width ruby-indent-level))))

(use-package yari
  :disabled)

(add-to-list 'auto-mode-alist '("\\.ino\\'" . c++-mode))
(add-to-list 'auto-mode-alist '("\\.p8\\'" . lua-mode))

(defun amd/make-underscore-word-character ()
  (interactive)
  (modify-syntax-entry ?_ "w"))

;; (add-hook 'prog-mode-hook #'(lambda () (modify-syntax-entry ?_ "w")))
;; (add-hook 'c-mode-common-hook 'amd/make-underscore-word-character)
;; (add-hook 'rust-mode-hook 'amd/make-underscore-word-character)

(use-package flycheck
  :disabled ;; TODO
  :diminish
  ;; :commands (flycheck-list-errors)
  :demand
  :custom
  ;; (flycheck-display-errors-function 'flycheck-display-error-messages-unless-error-list)
  (flycheck-display-errors-function nil)
  (flycheck-check-syntax-automatically '(save new-line mode-enabled)) ;; idle-change
  :general
  (:states '(motion) :keymaps '(flycheck-error-list-mode-map)
           "RET" 'flycheck-error-list-goto-error
           "E" 'flycheck-error-list-explain-error
           "F" 'flycheck-error-list-reset-filter
           "f" 'flycheck-error-list-set-filter
           "g" 'flycheck-error-list-check-source
           "C-n" 'flycheck-error-list-next-error
           "C-p" 'flycheck-error-list-previous-error)
  :init
  ;; (setq flycheck-c/c++-gcc-executable "/home/chrx/apps/arduino-1.8.5/hardware/teensy/../tools/arm/bin/arm-none-eabi-gcc")
  ;; -E -CC -x c++ -w  -g -Wall -ffunction-sections -fdata-sections -nostdlib -fno-exceptions -felide-constructors -std=gnu++14 -fno-rtti -mthumb -mcpu=cortex-m4 -mfloat-abi=hard -mfpu=fpv4-sp-d16 -fsingle-precision-constant -D__MK66FX1M0__ -DTEENSYDUINO=141 -DARDUINO=10805 -DF_CPU=180000000 -DUSB_SERIAL -DLAYOUT_US_ENGLISH
  ;; (setq flycheck-gcc-include-path
  ;;       '("/home/chrx/apps/arduino-1.8.5/hardware/teensy/avr/cores/teensy3"
  ;;         "/home/chrx/apps/arduino-1.8.5/hardware/teensy/avr/libraries/Audio"
  ;;         "/home/chrx/apps/arduino-1.8.5/hardware/teensy/avr/libraries/SPI"
  ;;         "/home/chrx/apps/arduino-1.8.5/hardware/teensy/avr/libraries/SD"
  ;;         "/home/chrx/apps/arduino-1.8.5/hardware/teensy/avr/libraries/SerialFlash"
  ;;         "/home/chrx/apps/arduino-1.8.5/hardware/teensy/avr/libraries/Wire"
  ;;         "/home/chrx/apps/arduino-1.8.5/hardware/teensy/avr/libraries/EEPROM"
  ;;         "/home/chrx/apps/arduino-1.8.5/hardware/teensy/avr/libraries/SPI"
  ;;         "/home/chrx/Arduino/libraries/Gameduino2"))

  :config
  (setq flycheck-error-list-format
        [("File" 16)
         ("Line" 5 flycheck-error-list-entry-< :right-align t)
         ("Col" 4 nil :right-align t)
         ("Level" 8 flycheck-error-list-entry-level-<)
         ("ID" 20 t)
         (#("Message (Checker)" 9 16
            (face flycheck-error-list-checker-name))
          0 t)])

  (add-to-list 'evil-motion-state-modes 'flycheck-error-list-mode)
  ;; larger fringe on the left, no fringe on the right
  (add-to-list 'fringe-styles '("large" 17 . 0))
  (fringe-mode (cons 17 0))
  ;; double size fringe bitmap
  (define-fringe-bitmap 'flycheck-fringe-bitmap-double-arrow
    (vector #b0000000000000000
            #b0000000000000000
            #b0000111111110000
            #b0000111111110000
            #b0000111111110000
            #b0000111111110000
            #b0000111111110000
            #b0000111111110000
            #b0000111111110000
            #b0000111111110000
            #b0000111111110000
            #b0000111111110000
            #b0000111111110000
            #b0000111111110000
            #b0000111111110000
            #b0000111111110000
            #b0000111111110000
            #b0000111111110000
            #b0000111111110000
            #b0000111111110000
            #b0000111111110000
            #b0000111111110000
            #b0000111111110000
            #b0000111111110000
            #b0000000000000000
            #b0000000000000000
            #b0000000000000000
            #b0000000000000000
            #b0000111111110000
            #b0000111111110000
            #b0000111111110000
            #b0000111111110000
            #b0000000000000000
            #b0000000000000000))
  (global-flycheck-mode))

(use-package flycheck-eglot
  :disabled
  :after (flycheck eglot)
  :config
  (global-flycheck-eglot-mode 1))

(use-package flycheck-rust
  :defer t
  :init
  (add-hook 'rust-mode-hook 'flycheck-rust-setup))

(use-package flymake-ruby
  :defer t
  :init
  (add-hook 'ruby-mode-hook 'flymake-ruby-load))

(use-package flymake-haml
  :defer t
  :init
  (add-hook 'haml-mode-hook 'flymake-haml-load))

(use-package sql
  :defer t
  :general
  (:states '(normal)
   :keymaps '(sql-interactive-mode-map)
    "C-d"  'evil-scroll-down)
  (:states '(insert)
   :keymaps '(sql-interactive-mode-map)
    "<up>"   'comint-previous-input
    "<down>" 'comint-next-input)
  (:states '(normal insert)
   :keymaps '(sql-interactive-mode-map)
    "C-e" 'comint-previous-prompt
    "C-n" 'comint-next-prompt
    "C-l" 'comint-clear-buffer
    "M-e" 'tmux-window-navigation/move-up
    "M-n" 'tmux-window-navigation/move-down))

(use-package sqlup-mode
  :defer t
  :init
  (add-hook 'sql-mode-hook 'sqlup-mode))

(use-package sql-indent
  :defer t
  :after sql
  :init
  (setq sql-indent-offset 2)
  (setq sql-indent-first-column-regexp
        (concat
         "\\(^\\s-*"
         (regexp-opt
          '("select" "update" "insert" "delete"
            "union" "intersect"
            "from" "where" "into" "group" "having" "order" "limit"
            "join" "right join" "left join" "right outer join" "left outer join" "right inner join" "left inner join"
            "set"
            "create" "drop" "truncate"
            "define" "eof" "export"
            "alter" "grant"
            ")"
            "--") t) "\\(\\b\\|\\s-\\)\\)\\|\\(^```$\\)")))

(use-package scad-mode
  :defer t
  :init
  (when (eq system-type 'darwin)
    (setq scad-command "/Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD")))

(use-package graphviz-dot-mode
  :defer t
  :init
  (setq graphviz-dot-auto-indent-on-semi nil
        graphviz-dot-auto-indent-on-newline nil
        graphviz-dot-dot-program "dot"
        graphviz-dot-preview-extension "svg"))

(use-package mmm-mode
  :defer t
  )

(use-package mmm-jinja2
  :defer t
  :config
  (add-to-list 'auto-mode-alist '("\\.rs.jinja\\'" . rust-mode))
  (mmm-add-mode-ext-class 'rust-mode "\\.rs.jinja'" 'jinja2))

(use-package jinja2-mode
  :defer t
  :config
  ;; (add-to-list 'auto-mode-alist '("\\.jinja\\'" . jinja2-mode))
  )

(use-package forth-mode :defer t)
(use-package forth-block-mode :defer t)

(use-package gn-mode
  :defer t
  :custom
  (gn-indent-method 'gn-indent-line-inductive)
  :config
  (add-to-list 'auto-mode-alist '("\\.gn\\'" . gn-mode))
  (add-to-list 'auto-mode-alist '("\\.gni\\'" . gn-mode)))

(use-package ninja-mode :defer t)

(use-package rust-mode
  :defer t
  :custom
  (rust-format-on-save nil))

(provide 'amd/languages)
;;; languages.el ends here

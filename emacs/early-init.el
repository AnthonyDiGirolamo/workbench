;;; -*- lexical-binding: t; -*-

;;; early-init.el --- Summary
;;; Commentary:
;;; Code:

;; Don't garbage collect durring init
(setq gc-cons-threshold 1024000000
      gc-cons-percentage 0.5)

;; Loading done, restore gc-cons-threshold
(add-hook 'emacs-startup-hook
          (lambda ()
            (setq gc-cons-threshold 16000000
                  gc-cons-percentage 0.1)))

;; Disable garbage collection when the minibuffer is active
(defun my-minibuffer-setup-hook ()
  (setq gc-cons-threshold 1024000000
        gc-cons-percentage 0.5))

(defun my-minibuffer-exit-hook ()
  (setq gc-cons-threshold 16000000
        gc-cons-percentage 0.1))

(add-hook 'minibuffer-setup-hook #'my-minibuffer-setup-hook)
(add-hook 'minibuffer-exit-hook #'my-minibuffer-exit-hook)

;; Don’t compact font caches during GC.
(setq inhibit-compacting-font-caches t)

;; https://emacs-lsp.github.io/lsp-mode/page/performance/
(setq read-process-output-max (* 4 1024 1024)) ;; 4MB

;; Disable syntax-highlighting on text you’re actively typing.
(setq redisplay-skip-fontification-on-input t)

;; Use package-quickstart - requires running
;; (package-quickstart-refresh) when installing new packages.
(setq package-quickstart t)

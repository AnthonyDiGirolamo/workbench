;;; -*- lexical-binding: t; -*-

;;; init.el --- Summary
;;; Commentary:
;;; Code:

;; Keep track of loading time
(defconst emacs-start-time (current-time))

;; (setq amd/settings-file (expand-file-name "~/.emacs.d/README.el")
;;       amd/local-settings-file (expand-file-name "~/.emacs-local.el")
;;       amd/settings-org-file (expand-file-name "~/.emacs.d/README.org"))
(setq hostname (string-trim (shell-command-to-string "uname -n")))
(setq amd/uname (shell-command-to-string "uname -a"))
(setq amd/using-android (string-match "Android" amd/uname))
;; (setq amd/using-pocketchip (string-match "chip" amd/uname))
;; (setq amd/using-pc (and (not amd/using-pocketchip)
;;                         (not amd/using-android)))

;; keep customize settings in their own file
(setq custom-file (concat user-emacs-directory "custom.el"))
;; (setq custom-file "~/.emacs.d/custom.el")
(when (file-exists-p custom-file)
  (load custom-file 'noerror))

;; Initialize all ELPA packages
(require 'package)
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))
(add-to-list 'package-archives '("melpa-stable" . "http://stable.melpa.org/packages/" ) t)

(package-initialize)

(let ((elapsed (float-time (time-subtract (current-time) emacs-start-time))))
  (message "Loaded packages, elapsed time: %.3fs" elapsed))

;; Load use-package, used for loading packages
(require 'use-package)

;; Only tangle README.org if README.el isn't available
;; Manually tangle with (amd/tangle-init) when needed.
;; (if (file-exists-p amd/settings-file)
;;     (load amd/settings-file)
;;   (progn
;;     (org-babel-load-file amd/settings-org-file)))


;; Message how long it took to load everything (minus packages)
(let ((elapsed (float-time (time-subtract (current-time) emacs-start-time))))
  (message "Loaded settings, elapsed time: %.3fs" elapsed))

;; Disable Bidirectional Text Scanning
(setq-default bidi-display-reordering 'left-to-right
              bidi-paragraph-direction 'left-to-right)
(setq bidi-inhibit-bpa t)

;; Disable syntax-highlighting on text you’re actively typing.
(setq redisplay-skip-fontification-on-input t)

;; Hide cursors in non focused windows.
(setq-default cursor-in-non-selected-windows nil)
(setq highlight-nonselected-windows nil)

;; https://www.masteringemacs.org/article/speed-up-emacs-libjansson-native-elisp-compilation
(if (and (fboundp 'native-comp-available-p)
         (native-comp-available-p))
    (setq comp-deferred-compilation t
          package-native-compile t)
  (message "Native complation is *not* available"))

(unless (functionp 'json-serialize)
  (message "Native JSON is *not* available"))

;; do not steal focus while doing async compilations
(setq warning-suppress-types '((comp)))

;; (when (file-exists-p amd/local-settings-file)
;;   (load amd/local-settings-file))

;; Add use-package config files to the load path
(dolist (dir '("config"))
  (push (expand-file-name dir user-emacs-directory) load-path))

(require 'amd/emacs)
(require 'amd/evil)
(require 'amd/help)
(require 'amd/completing-read)
(require 'amd/searching)
(require 'amd/transient)
(require 'amd/shells)
(require 'amd/navigation)
(require 'amd/dired)
(require 'amd/magit)
(require 'amd/org)
(require 'amd/functions)
(require 'amd/tools)
(require 'amd/languages)
(require 'amd/code-completion)
(require 'amd/appearance)
(require 'amd/themes)

;; lastly, start a server
;; (unless (and (fboundp 'server-running-p) (server-running-p))
;;   (server-start))


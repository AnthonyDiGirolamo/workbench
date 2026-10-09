;;; -*- lexical-binding: t; -*-

;;; tools.el --- Summary
;;; Commentary:
;;; Code:

(use-package calc
  :general
  (:states
   '(emacs)
   :keymaps '(calc-mode-map)
   "C-c h" 'hydra-calc-cs/body
   "<prior>" 'amd/calc-roll-entire-stack-up
   "<next>" 'amd/calc-roll-entire-stack-down
   "ru" 'amd/calc-roll-entire-stack-up
   "rd" 'amd/calc-roll-entire-stack-down)

  :config
  (defun amd/calc-roll-entire-stack-down ()
    (interactive)
    (calc-roll-down-stack (calc-stack-size))
    (calc-refresh))

  (defun amd/calc-roll-entire-stack-up ()
    (interactive)
    (calc-roll-up-stack (calc-stack-size))
    (calc-refresh))

;;   (defhydra hydra-calc-cs (:color blue :hint nil)
;;     "
;; ^Display^            ^Binary Ops^         ^Units^
;; ^^^^^^^^-----------------------------------------------
;; _R_: change radix    _a_: and             _c_: convert
;; _z_: leading zeros   _o_: or              ^ ^
;; ^ ^                  _x_: xor             ^ ^
;; ^ ^                  _n_: not             ^ ^
;; ^ ^                  _d_: diff            ^ ^
;; ^ ^                  _r_: right shift     ^ ^
;; ^ ^                  _l_: left shift      ^ ^
;;     "
;;     ("R" calc-radix)
;;     ("z" calc-leading-zeros)
;;     ("a" calc-and)
;;     ("o" calc-or)
;;     ("x" calc-xor)
;;     ("n" calc-not)
;;     ("d" calc-diff)
;;     ("r" calc-rshift-binary)
;;     ("l" calc-lshift-binary)
;;     ("c" calc-convert-units))

  ;; (setq math-additional-units
  ;;       '((bit    nil           "Bit")
  ;;         (byte   "8 * bit"     "Byte")
  ;;         (bps    "bit / s"     "Bit per second"))
  ;;       math-units-table nil)

  (defun calcFunc-dateDiffToHMS (date1 date2 worktime-per-day)
    "Calculate the difference of DATE1 and DATE2 in HMS form.
    Each day counts with WORKTIME-PER-DAY hours."
    (cl-labels ((dateTrunc (date)
                           (calcFunc-date (calcFunc-year date)
                                          (calcFunc-month date)
                                          (calcFunc-day date)))
                (datep (date)
                       (and (listp date)
                            (eq (car date) 'date))))
      (if (and (datep date1)
               (datep date2))
          (let* ((business-days (calcFunc-bsub
                                 (dateTrunc date1)
                                 (dateTrunc date2))))
            (calcFunc-add
             (calcFunc-hms (calcFunc-mul business-days worktime-per-day) 0 0)
             (calcFunc-sub (calcFunc-time date1) (calcFunc-time date2))))
        0))))

(use-package proced
  :general
  (:states '(emacs)
   :keymaps 'proced-mode-map
   "zz" 'recenter
   "/" 'swiper
   "n" 'next-line
   "g" (lambda() (interactive) (revert-buffer) (recenter))
   "e" 'previous-line)
 :custom
 (proced-sort 'pid)
 (proced-tree-flag t))

(use-package eww
  :after evil
  :commands (eww)
  :init
  (when (eq system-type 'gnu/linux)
         (setq browse-url-browser-function 'browse-url-generic
               browse-url-generic-program "xdg-open")
         (when amd/using-android
           (setq browse-url-generic-program "termux-open-url")))

  (setq eww-search-prefix "http://www.google.com/search?q=")

  :general
  (:states '(motion)
   :keymaps '(eww-mode-map)
    "H" 'eww-back-url
    "L" 'eww-forward-url
    "b" 'eww-list-bookmarks)
  (:states '(motion)
   :keymaps '(eww-bookmark-mode-map)
    "RET" 'eww-bookmark-browse)
  :config
  (add-to-list 'evil-motion-state-modes 'eww-bookmark-mode))

(use-package nov
  :disabled ;; TODO
  :general
  (:states '(motion)
   :keymaps '(nov-mode-map)
   "g r" 'nov-render-document
   "C-n" 'nov-next-document
   "C-p" 'nov-previous-document
   "T" 'nov-goto-toc
   "C-d" 'nov-scroll-up
   "C-u" 'nov-scroll-down
   "d" 'nov-scroll-up
   "u" 'nov-scroll-down
   "RET" 'nov-browse-url
   "f" 'ace-link-nov)

  :config
  (add-to-list 'evil-motion-state-modes 'nov-mode)
  :init
  (setq nov-text-width nil
        nov-variable-pitch t)

  (add-to-list 'auto-mode-alist '("\\.epub\\'" . nov-mode))

  (defun amd/nov-font-setup ()
    (interactive)
    (face-remap-add-relative
     'variable-pitch
     ;; :family "Liberation Serif"
     ;; :family "Roboto Medium"
     ;; :family "Noto Serif Light"
     :family "Dejavu Serif Condensed"
     :height 1.0))
  (add-hook 'nov-mode-hook 'amd/nov-font-setup)

  (defun ace-link-nov ()
    "Open a visible link in an `nov-mode' buffer."
    (interactive)
    (let ((pt (avy-with ace-link-eww
                (avy--process
                 (mapcar #'cdr (ace-link--eww-collect))
                 (avy--style-fn avy-style)))))
      (ace-link--nov-action pt)))

  (defun ace-link--nov-action (pt)
    (when (number-or-marker-p pt)
      (goto-char (1+ pt))
      (nov-browse-url))))

(use-package elfeed
  :disabled ;; TODO
  :general
  (:states '(motion)
   :keymaps '(elfeed-search-mode-map)
   "RET" 'elfeed-search-show-entry
   )
  (:states '(motion)
   :keymaps '(elfeed-show-mode-map)
   "TAB" 'shr-next-link
   "<backtab>" 'shr-previous-link
   )

  :config
  (add-to-list 'evil-motion-state-modes 'elfeed-search-mode)
  (add-to-list 'evil-motion-state-modes 'elfeed-show-mode)
)

(use-package zone
  :config
  ;; (zone-when-idle 180)
  (defun zone-choose ()
    "Choose a PGM to run for `zone'."
    (interactive)
    (let ((current-prefix-arg 4)) ;; emulate C-u
      (call-interactively 'zone))))

(use-package retris
  :disabled
  :commands retris
  :load-path "retris"
  :init
  :config
  (add-to-list 'evil-emacs-state-modes 'retris-mode))

(use-package 2048-game
  :disabled
  :commands 2048-game
  :init
  :config
  (add-to-list 'evil-emacs-state-modes '2048-mode))

(use-package tramp
  :defer t
  :init
  (setq enable-remote-dir-locals t)
  ;; (setq tramp-verbose 6)
  ;; (getenv "GIT_SSH")
  ;; (shell-command-to-string (concat (getenv "GIT_SSH") " -V"))

  (if (eq system-type 'windows-nt)
      (progn
        (setenv "GIT_SSH" "C:\\Users\\anthony\\PortableGit\\cmd\\plink.exe")
        (setq tramp-default-method "plink"))
    (setq tramp-default-method "ssh"))

  (defun sudo-edit-current-file ()
    (interactive)
    (let ((position (point)))
      (find-alternate-file
       (if (file-remote-p (buffer-file-name))
           (let ((vec (tramp-dissect-file-name (buffer-file-name))))
             (tramp-make-tramp-file-name
              "sudo"
              (tramp-file-name-user vec)
              (tramp-file-name-host vec)
              (tramp-file-name-localname vec)))
         (concat "/sudo:root@localhost:" (buffer-file-name))))
      (goto-char position))))

(provide 'amd/tools)
;;; tools.el ends here

(require 'core-evil)
(require 'core-lib)
(require 'core-shackle)

(use-package no-littering :defer t)

(ef-customize
  ;; Tabs are just awful
  (indent-tabs-mode nil)

  ;; Disable bell completely
  (ring-bell-function 'ignore)

  ;; Keep the filesystem clean
  (make-backup-files nil)
  (auto-save-default nil)

  ;; Scroll one line at a time
  (scroll-margin 0)
  (scroll-conservatively 100000)
  (scroll-preserve-screen-position 1)

  ;; Don't display splash screen after start up
  (inhibit-splash-screen t)
  (inhibit-startup-message t)

  ;; Don't wrap long lines
  (truncate-lines -1)

  ;; Empty scratch buffer by default
  (initial-scratch-message "")

  ;; Ignore unsafe local variables
  (enable-local-variables :safe)

  ;; Keep auto-save files separately
  (auto-save-file-name-transforms
   `((".*" ,(no-littering-expand-var-file-name "auto-save/") t))))

;; Enable y/n answers
(fset 'yes-or-no-p #'y-or-n-p)

;; No GNU ads in minibuffer
(fset #'display-startup-echo-area-message #'ignore)

;; Show columns in mode-line
(column-number-mode t)

;; Never use TUI pagers in sub-processes
(setenv "PAGER" (executable-find "cat"))

(use-package autorevert
  :custom
  (auto-revert-interval 1)
  (auto-revert-verbose nil)
  (global-auto-revert-non-file-buffers t)
  :config
  (global-auto-revert-mode 1))

(use-package dired
  :general
  (:states 'normal :prefix ef-prefix
	   "d" 'dired))

(use-package cus-edit
  :defer t
  :after no-littering
  :custom
  (custom-file (no-littering-expand-etc-file-name "custom.el")))

(use-package comint
  :defer t
  :custom
  (comint-move-point-for-output 'others)
  :general
  (:states 'insert :keymaps 'comint-mode-map
	   "<up>" 'comint-previous-input
	   "<down>" 'comint-next-input)
  :config
  (ef-add-hook comint-mode-hook
    "Do not use `truncate-lines' in comint buffers.."
    (setq-local truncate-lines nil)
    (set (make-local-variable 'truncate-partial-width-windows) nil)))

(use-package compile
  :defer t
  :custom
  (compilation-always-kill t)
  (compilation-ask-about-save nil)
  (compilation-message-face 'default)
  (compilation-scroll-output 'first-error)
  :functions (ef-compilation-exit-autoclose)
  :hook
  ;; Avoid dropping into insert mode in compilation windows
  (compilation-start . evil-normal-state)
  :config
  (defun ef-compilation-exit-autoclose (buffer msg)
    (when (string-match-p (regexp-quote "finished") msg)
      (if (> (length (window-list)) 1)
          (delete-window (get-buffer-window buffer))
        (bury-buffer buffer))))

  (add-to-list 'compilation-finish-functions #'ef-compilation-exit-autoclose)

  (ef-add-hook compilation-mode-hook
    "Enable `visual-line-mode' for compilation buffers."
    (setq-local bidi-display-reordering nil)
    (visual-line-mode t)))

(use-package delsel
  :config
  ;; Type over region: Treat an Emacs region much like a typical selection
  ;; outside of Emacs
  (delete-selection-mode t))

(use-package face-remap
  :general
  (:states 'normal :prefix ef-prefix
	   "+" 'text-scale-adjust
	   "-" 'text-scale-adjust
	   "0" 'text-scale-adjust))

(use-package files
  :unless noninteractive
  :config
  (setq save-silently t)
  (ef-add-hook after-save-hook :fn ef-after-save-message-hook
    (message "\"%s\" %dL, %dC written"
	     (buffer-name)
	     (count-lines (point-min) (point-max))
	     (buffer-size))))

(use-package hl-line
  :config
  (global-hl-line-mode 1))

(use-package hideshow
  :commands hs-minor-mode
  :hook (prog-mode . hs-minor-mode))

(use-package ibuffer
  :general
  (:states 'normal :prefix ef-prefix
	   "b" 'ibuffer))

(use-package imenu
  :general
  (:states 'normal :prefix ef-prefix
	   "i" 'imenu))

(use-package minibuffer
  :custom
  (ef-minibuffer-gc-cons-threshold gc-cons-threshold)
  (enable-recursive-minibuffers t)
  :config
  ;; Escape minibuffer with single escape
  (define-key minibuffer-local-map [escape] 'minibuffer-keyboard-quit)
  (define-key minibuffer-local-ns-map [escape] 'minibuffer-keyboard-quit)
  (define-key minibuffer-local-completion-map [escape] 'minibuffer-keyboard-quit)
  (define-key minibuffer-local-must-match-map [escape] 'minibuffer-keyboard-quit)
  (define-key minibuffer-local-isearch-map [escape] 'minibuffer-keyboard-quit)

  (ef-add-hook minibuffer-setup-hook
    "Increase `gc-cons-threshold' while in minibuffer."
    (setq gc-cons-threshold most-positive-fixnum))

  (ef-add-hook minibuffer-exit-hook
    "Restore `gc-cons-threshold' to default."
    (setq gc-cons-threshold (car (get 'gc-cons-threshold 'standard-value)))))

(use-package prog-mode
  :general
  (:states 'normal :keymaps 'prog-mode-map
	   "<tab>" 'indent-for-tab-command)
  (:states 'normal :prefix ef-prefix :keymaps 'prog-mode-map
	   "<tab>" 'ef-indent-buffer
	   "." 'pop-tag-mark)
  (:states 'visual :prefix ef-prefix :keymaps 'prog-mode-map
	   "=" 'ef-align-to-=)
  (:states 'visual :keymaps 'prog-mode-map
	   "<tab>" 'indent-region)
  :config
  (global-prettify-symbols-mode -1))

(use-package recentf
  :defer t
  :after no-littering
  :config
  (add-to-list 'recentf-exclude no-littering-var-directory)
  (add-to-list 'recentf-exclude no-littering-etc-directory))

(use-package savehist
  :defer 1
  :custom
  (history-length 1000)
  (savehist-additional-variables '(search ring regexp-search-ring))
  (savehist-autosave-interval 60)
  :config
  (savehist-mode t))

(use-package saveplace
  :custom
  (save-place-limit nil)
  :init
  (save-place-mode t)
  :config
  (setq-default save-place t))

(use-package smerge-mode
  :commands smerge-mode
  :custom
  (smerge-command-prefix (kbd "C-s"))
  :init
  (ef-add-hook (find-file-hook after-revert-hook) :fn ef-enable-smerge-maybe
    "Auto-enable `smerge-mode' when merge conflict is detected."
    (save-excursion
      (goto-char (point-min))
      (when (re-search-forward "^<<<<<<< " nil :noerror)
        (smerge-mode t)))))

(use-package so-long
  :config
  (global-so-long-mode 1))

(use-package uniquify
  :custom
  (uniquify-after-kill-buffer-p t)
  (uniquify-buffer-name-style 'post-forward-angle-brackets)
  (uniquify-ignore-buffers-re "^\\*")
  (uniquify-separator ":"))

(use-package whitespace
  :custom
  (show-trailing-whitespace nil)
  (whitespace-style (quote (face trailing)))
  :config
  (global-whitespace-mode 1))

(use-package xref
  :defer t
  :custom
  (xref-marker-ring-length 1024)
  :config
  (ef-shackle '("*xref*" :align below :size .4 :popup t :select t))

  (defadvice xref-goto-xref (after my activate)
    (delete-window (get-buffer-window (get-buffer "*xref*")))))

(provide 'core-emacs)
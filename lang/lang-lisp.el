(use-package lisp-mode
  :config
  (defun ts/lisp-mode-hook ()
    (setq mode-name "λ"))

  (add-hook 'lisp-mode-hook 'ts/lisp-mode-hook))

(use-package slime
  :ensure t
  :defer t
  :commands (slime slime-lisp-mode-hook slime-mode)
  :config
  (setq slime-contribs
        '(slime-fancy slime-asdf slime-quicklisp))

  (setq inferior-lisp-program "sbcl"
        slime-net-coding-system 'utf-8-unix
        slime-complete-symbol*-fancy t
        slime-complete-symbol-function 'slime-fuzzy-complete-symbol)

  (slime-setup '(slime-fancy slime-asdf slime-quicklisp slime-company))

  (dolist (buf '("*slime-apropos*"
                 "*slime-macroexpansion*"
                 "*slime-description*"
                 "*slime-xref*"
                 slime-connection-list-mode
                 slime-repl-mode))
    (push buf popwin:special-display-config))

  (push '("*slime-compilation*" :noselect t) popwin:special-display-config)

  (ts/define-repl ts/repl-slime "*slime-repl sbcl*" 'slime-repl)
  (evil-define-key 'normal lisp-mode-map ",r" 'ts/repl-slime)
  (evil-define-key 'normal slime-repl-mode-map ",r" 'ts/repl-slime))

(use-package slime-company
  :ensure t
  :defer t
  :commands slime-company)

(use-package elisp-mode
  :commands (emacs-lisp-mode lisp-interaction-mode)
  :config
  (evil-define-key 'normal emacs-lisp-mode-map ",eb" 'eval-buffer)
  (evil-define-key 'normal emacs-lisp-mode-map ",ee" 'eval-expression)
  (evil-define-key 'visual emacs-lisp-mode-map ",er" 'eval-region)
  (evil-define-key 'normal emacs-lisp-mode-map ",r" 'ts/repl-ielm)
  (evil-define-key 'normal lisp-interaction-mode-map ",eb" 'eval-buffer)
  (evil-define-key 'normal lisp-interaction-mode-map ",ee" 'eval-expression)
  (evil-define-key 'visual lisp-interaction-mode-map ",er" 'eval-region)
  (evil-define-key 'normal lisp-interaction-mode-map ",r" 'ts/repl-ielm)
  (evil-define-key 'normal ielm-map ",r" 'ts/repl-ielm)

  (defun ts/emacs-lisp-recompile ()
    "Recompile elc file correspinding to buffer-file-name, if it exists."
    (interactive)
    (when (file-exists-p (byte-compile-dest-file buffer-file-name))
      (emacs-lisp-byte-compile)))

  (defun ts/emacs-lisp-mode-hook ()
    (add-hook 'after-save-hook 'ts/emacs-lisp-recompile nil t)
    (setq mode-name "Emacs λ"))

  (add-hook 'emacs-lisp-mode-hook 'ts/emacs-lisp-mode-hook))

(use-package ielm
  :defer t
  :commands (ielm)
  :init
  (ts/define-repl ts/repl-ielm "*ielm*" 'ielm)
  :config
  (defun ts/inferior-emacs-lisp-mode-hook ()
    (eldoc-mode t))

  (add-hook 'ielm-mode-hook 'ts/inferior-emacs-lisp-mode-hook))

(use-package elisp-slime-nav
  :defer t
  :ensure t
  :diminish elisp-slime-nav-mode
  :commands (elisp-slime-nav-mode)
  :init
  (dolist (hook '(emacs-lisp-mode-hook ielm-mode-hook lisp-interaction-mode-hook))
    (add-hook hook 'elisp-slime-nav-mode))
  :config
  (evil-define-key 'normal emacs-lisp-mode-map ",," 'elisp-slime-nav-find-elisp-thing-at-point)
  (evil-define-key 'normal emacs-lisp-mode-map ",." 'pop-tag-mark)
  (evil-define-key 'normal lisp-interaction-mode-map ",," 'elisp-slime-nav-find-elisp-thing-at-point)
  (evil-define-key 'normal lisp-interaction-mode-map ",." 'pop-tag-mark))

(use-package macrostep
  :ensure t
  :config
  (evil-define-key 'normal emacs-lisp-mode-map ",xe" 'macrostep-expand)
  (evil-define-key 'normal lisp-interaction-mode-map ",xe" 'macrostep-expand)
  (evil-define-key 'normal macrostep-keymap "q" 'macrostep-collapse-all))

(provide 'lang-lisp)

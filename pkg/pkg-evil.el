(use-package evil
  :ensure t
  :config

  (evil-mode 1)

  (setq-default evil-auto-indent t
                evil-cross-lines t
                evil-default-cursor t
                evil-default-state 'normal
                evil-echo-state nil
                evil-ex-search-case 'smart
                evil-ex-search-vim-style-regexp t
                evil-magic 'very-magic
                evil-search-module 'evil-search
                evil-shift-width 2)

  ;; Avoid dropping into insert mode in compilation windows
  (add-hook 'compilation-start-hook 'evil-normal-state)

  (defun ts/kill-other-buffers ()
    "Kill all other buffers."
    (interactive)
    (mapc 'kill-buffer (delq (current-buffer) (buffer-list))))

  (define-key evil-normal-state-map ",kob" 'ts/kill-other-buffers)
  (define-key evil-normal-state-map ",kb" 'kill-this-buffer)

  (defun ts/kill-buffer-or-delete-window ()
    "If more than one window is open, delete the current window, otherwise kill current buffer"
    (interactive)
    (if (> (length (window-list)) 1)
        (delete-window)
      (kill-buffer)))

  (evil-ex-define-cmd "q" 'ts/kill-buffer-or-delete-window)

  (defun ts/indent-buffer ()
    "Indent the currently visited buffer."
    (interactive)
    (indent-region (point-min) (point-max)))

  (define-key evil-normal-state-map (kbd ", TAB") 'ts/indent-buffer)

  (define-key evil-visual-state-map (kbd "TAB") 'indent-region)
  (define-key evil-normal-state-map (kbd "TAB") 'indent-for-tab-command)

  (define-key evil-normal-state-map ",i" 'imenu)
  (define-key evil-normal-state-map ",ws" 'delete-trailing-whitespace)

  ;; Alignment
  (defun ts/align-to-= (begin end)
    "Align region to = signs"
    (interactive "r")
    (align-regexp begin end "\\(\\s-*\\)=" 1 1 ))

  (evil-define-key 'visual prog-mode-map ",=" 'ts/align-to-=)

  ;; Easier window navigation
  (define-key evil-normal-state-map (kbd "s-h") 'evil-window-left)
  (define-key evil-normal-state-map (kbd "s-j") 'evil-window-down)
  (define-key evil-normal-state-map (kbd "s-k") 'evil-window-up)
  (define-key evil-normal-state-map (kbd "s-l") 'evil-window-right)

  (define-key evil-normal-state-map (kbd ",u") 'undo-tree-visualize)

  ;; Comint history
  (evil-define-key 'insert comint-mode-map (kbd "<up>") 'comint-previous-input)
  (evil-define-key 'insert comint-mode-map (kbd "<down>") 'comint-next-input)

  ;; Unset some annoying keys
  (define-key evil-motion-state-map "K" nil)
  (define-key evil-normal-state-map "K" nil)

  (evil-add-hjkl-bindings package-menu-mode-map 'emacs
    "H" 'package-menu-quick-help))

(use-package evil-cleverparens
  :after evil
  :ensure t
  :diminish evil-cleverparens-mode
  :commands (evil-cleverparens-mode)
  :init
  (add-hook 'emacs-lisp-mode-hook 'evil-cleverparens-mode)
  (setq evil-cleverparens-use-additional-movement-keys nil))

(use-package evil-nerd-commenter
  :after evil
  :defer 1
  :ensure t
  :commands (evilnc-comment-or-uncomment-lines)
  :init
  (define-key evil-normal-state-map (kbd "\\") 'evilnc-comment-or-uncomment-lines)
  (define-key evil-visual-state-map (kbd "\\") 'evilnc-comment-or-uncomment-lines))

(use-package evil-surround
  :after evil
  :defer 1
  :ensure t
  :config
  (global-evil-surround-mode 1))

(use-package undo-tree
  :after evil
  :ensure t
  :diminish undo-tree-mode
  :config
  (global-undo-tree-mode)
  (setq undo-tree-visualizer-timestamps t)
  (setq undo-tree-visualizer-lazy-drawing nil)
  (setq undo-tree-auto-save-history t)
  (let ((undo-dir (expand-file-name "undo" user-emacs-directory)))
    (setq undo-tree-history-directory-alist (list (cons "." undo-dir)))))

(provide 'pkg-evil)

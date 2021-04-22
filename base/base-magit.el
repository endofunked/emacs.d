(use-package magit
  :ensure t
  :commands (magit-blame
             magit-checkout
             magit-diff
             magit-log-all
             magit-log
             magit-status)
  :custom
  (magit-completing-read-function 'ivy-completing-read)
  (magit-revision-show-gravatars '("^Author:     " . "^Commit:     "))
  :init
  (define-key evil-normal-state-map ",gd" 'magit-diff)
  (define-key evil-normal-state-map ",gs" 'magit-status)
  (define-key evil-normal-state-map ",gl" 'magit-log)
  (define-key evil-normal-state-map ",gL" 'magit-log-all)
  (define-key evil-normal-state-map ",gb" 'magit-blame)
  (define-key evil-normal-state-map ",gc" 'magit-checkout)
  :config
  (ef-add-hook git-commit-setup-hook :fn ef-git-commit-jira-ticket-hook
    (if-let* ((branch (magit-get-current-branch))
              (segments (split-string branch "[\\/\\.-]"))
              (_ (string-match "^[A-Z]+-[0-9]+" branch))
              (label (format "[%s-%s] " (car segments) (cadr segments))))
        (unless (string-match (regexp-quote label) (buffer-string))
          (insert label)))
    (end-of-line))

  (ef-shackle '(magit-diff-mode :align right :size .5 :popup t :select nil))

  (transient-append-suffix 'magit-pull "C"
    '("A" "Autostash" "--autostash"))

  (setenv "GIT_PAGER" ""))

(use-package transient
  :defer t
  :ensure t
  :config
  (transient-bind-q-to-quit)

  (defadvice transient-setup (before transient-setup activate)
    (ef-transient-suspend-shackle-mode))

  (defun ef-transient-suspend-shackle-mode ()
    (when (bound-and-true-p shackle-mode)
      (shackle-mode -1)
      (add-hook 'post-transient-hook 'ef-transient-resume-shackle-mode)))

  (defun ef-transient-resume-shackle-mode ()
    (unless transient--prefix
      (shackle-mode t)
      (remove-hook 'post-transient-hook 'ef-transient-resume-shackle-mode))))

(use-package evil-magit
  :after (evil magit)
  :ensure t
  :config
  (evil-magit-init)
  ;; Don't let magit-status mess up window configurations
  ;; http://whattheemacsd.com/setup-magit.el-01.html
  (defadvice magit-status (around magit-fullscreen activate)
    (when (fboundp 'ef-flycheck-close-window)
      (ef-flycheck-close-window))
    (window-configuration-to-register :magit-fullscreen)
    ad-do-it
    (delete-other-windows))

  (defun ef-magit-quit-session ()
    "Restores the previous window configuration and kills the magit buffer"
    (interactive)
    (kill-buffer)
    (jump-to-register :magit-fullscreen))

  (evil-define-key 'normal magit-status-mode-map "q" #'ef-magit-quit-session)
  (evil-define-key 'visual magit-status-mode-map "q" #'ef-magit-quit-session))


(provide 'base-magit)
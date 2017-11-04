(use-package org
  :ensure org-plus-contrib
  :pin melpa
  :config
  (require 'org-install)
  (setq org-confirm-babel-evaluate nil
        org-src-fontify-natively t
        org-fontify-quote-and-verse-blocks t
        org-src-tab-acts-natively t)

  (set-face-attribute 'org-document-title nil :height 1.0 :weight 'medium)

  (org-babel-do-load-languages
   'org-babel-load-languages
   '((shell . t)
     (emacs-lisp . t)
     (latex . t)
     (ruby . t)))

  (when (display-graphic-p)
    (define-key org-mode-map (kbd "M-RET") 'toggle-frame-fullscreen)))

(use-package org-bullets
  :after org
  :ensure t
  :config
  (add-hook 'org-mode-hook 'org-bullets-mode))

(use-package org-tree-slide
  :after org
  :ensure t
  :config
  (require 'ox)
  (require 'ox-latex)

  (setq org-tree-slide-deactivate-message ""
        org-tree-slide-activate-message ""
        org-tree-slide-header nil
        org-tree-slide-slide-in-effect nil)

  (defun ef-org-tree-slide-play-hook ()
    (flyspell-mode nil)
    (flyspell-delete-all-overlays)
    (let ((org-format-latex-options
           (plist-put (copy-tree org-format-latex-options)
		      :scale 4)))
      (org-preview-latex-fragment '(16)))

    (setq-local global-hl-line-mode nil))

  (add-hook 'org-tree-slide-play-hook 'ef-org-tree-slide-play-hook)

  (defun ef-org-tree-slide-stop-hook ()
    (flyspell-mode t)
    (org-remove-latex-fragment-image-overlays)
    (setq-local global-hl-line-mode nil)
    (setq-local global-hl-line-mode t))

  (add-hook 'org-tree-slide-stop-hook 'ef-org-tree-slide-stop-hook))

(use-package demo-it
  :ensure t
  :config
  (setq demo-it--text-scale 5
        demo-it--presentation-hide-mode-line nil
        demo-it--presentation-variable-width t))

(use-package expand-region
  :after demo-it
  :ensure t)

(use-package fancy-narrow
  :after demo-it
  :ensure t)

(provide 'pkg-org)

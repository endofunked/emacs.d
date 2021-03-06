(require 'core-evil)
(require 'core-flycheck)
(require 'core-shackle)
(require 'core-projectile)

(use-package lsp-mode
  :commands lsp
  :custom
  (lsp-auto-guess-root t)
  (lsp-completion-show-kind nil)
  (lsp-enable-folding nil)
  (lsp-enable-on-type-formatting nil)
  (lsp-enable-snippet nil)
  (lsp-enable-symbol-highlighting nil)
  (lsp-enable-text-document-color nil)
  (lsp-headerline-breadcrumb-enable nil)
  (lsp-lens-enable nil)
  (lsp-signature-auto-activate nil)
  (lsp-signature-doc-lines 1)
  (lsp-signature-render-documentation nil)
  (lsp-ui-doc-enable nil)
  (lsp-ui-sideline-enable nil)
  (lsp-ui-sideline-show-hover nil)
  :hook
  ;; Sometime evil-mode gets into a weird state when lsp gets enabled in a hook
  ;; and keybinds don't appear to work correctly, so force it into normal state
  ;; when lsp-mode gets enabled.
  (lsp-mode . evil-normal-state)
  :ensure t
  :config
  (require 'lsp-modeline)
  (require 'lsp-headerline)
  (require 'lsp-ui)
  (require 'lsp-diagnostics)

  (if (boundp 'read-process-output-max)
      (setq read-process-output-max (* 1024 1024)))

  (ef-add-popup "*lsp-performance*" :ephemeral t :size 0.15)
  (ef-add-popup "*lsp session*" :ephemeral t)
  (ef-add-popup "*lsp-help*" :ephemeral t :size 0.2))

(use-package lsp-ui
  :defer t
  :ensure t)

(ef-deflang lsp
  :compile-backend-connect lsp
  :compile-backend-reconnect lsp-workspace-restart
  :compile-backend-quit lsp-disconnect
  :compile-nav-jump lsp-find-definition
  :compile-nav-pop-back pop-tag-mark

  :doc-point lsp-describe-thing-at-point

  :refactor-imports lsp-organize-imports
  :refactor-rename lsp-rename

  :xref-apropos consult-lsp-symbols
  :xref-definitions lsp-find-declaration
  :xref-references lsp-find-references)

(provide 'core-lsp)

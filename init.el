(defun ef-init-debug-p ()
  "Returns true if the EMACS_INIT_DEBUG environment variable is set."
  (stringp (getenv "EMACS_INIT_DEBUG")))

;; Less warnings unless we're in debug mode.
(when (ef-init-debug-p)
  (setq-default warning-minimum-level :error))

(setq-default
 ;; Increase *Messages* buffer size
 message-log-max 16384
 ;; Silence ad-handle-definition about advised functions getting redefined.
 ad-redefinition-action 'accept
 ;; Less byte-compiler noise
 byte-compile-warnings '(not free-vars unresolved noruntime lexical make-local)
 byte-compile-verbose (ef-init-debug-p))

(let ((default-directory (expand-file-name "elpa" user-emacs-directory)))
  (unless (file-exists-p default-directory)
    (make-directory default-directory))
  (normal-top-level-add-subdirs-to-load-path))

(unless (fboundp 'package-installed-p)
  (package-initialize t))

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(custom-set-variables '(use-package-enable-imenu-support t))
(require 'use-package)

(if (ef-init-debug-p)
    (setq-default use-package-verbose t))

;; Require no-littering as early as possible so we don't end up storing files
;; before our directory structure has been set up.
(use-package no-littering
  :ensure t
  :custom
  (auto-save-file-name-transforms
   `((".*" ,(no-littering-expand-var-file-name "auto-save/") t))))

(let* ((src-dir (expand-file-name "src" user-emacs-directory))
       (paths (list (expand-file-name "core" src-dir)
                    (expand-file-name "base" src-dir)
                    (expand-file-name "lang" src-dir)
                    (expand-file-name "private" user-emacs-directory))))
  (add-to-list 'load-path (expand-file-name "vendor" src-dir))

  (dolist (path paths)
    (dolist (file (directory-files-recursively path "\\.el$"))
      (add-to-list 'load-path (file-name-directory file))
      (require (intern (file-name-sans-extension (file-name-base file))) nil t))))

(provide 'init)

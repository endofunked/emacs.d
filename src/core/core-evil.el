(require 'core-lib)

(use-package evil
  :ensure t
  :demand t
  :general
  (:states 'normal :prefix ef-prefix
           ":"        '(eval-expression :wk "Eval Expression")
	   "<return>" '(ef-toggle-window-fullscreen :wk "Toggle Frame Fullscreen")
           "i"        '(imenu :wk "Open imenu")
           "U"        '(universal-argument :wk "Universal Argument")

           ;; Buffer
           "b"        '(nil :wk "Buffer")
	   "bb"       '(bury-buffer :wk "Bury Buffer")
           "bc"       '(clone-indirect-buffer :wk "Clone Buuffer")
           "bC"       '(clone-indirect-buffer-other-window :wk "Clone Buffer Other Window")
	   "bi"       '(ibuffer :wk "Open ibuffer")
           "bk"       '(nil :wk "Kill")
	   "bka"      '(ef-kill-all-other-buffer :wk "Kill All Other Buffers")
	   "bkk"      '(kill-current-buffer :wk "Kill Buffer")
	   "bkK"      '(kill-buffer-and-window :wk "Kill Buffer & Window")
	   "bko"      '(ef-kill-other-buffers :wk "Kill Other File Buffers")
	   "bks"      '(kill-some-buffers :wk "Kill Some Buffers")
	   "bl"       '(evil-switch-to-windows-last-buffer :wk "Last Buffer")
	   "bn"       '(next-buffer :wk "Next Buffer")
	   "bp"       '(previous-buffer :wk "Previous Buffer")
	   "bN"       '(evil-buffer-new :wk "New Buffer")
	   "br"       '(revert-buffer :wk "Revert Buffer")

           ;; Insert
           "I"        '(nil :wk "Insert")
           "It"       '(nil :wk "Time")
           "Iti"      '(ef-insert-iso-datetime :wk "ISO Date/Time")
           "Ito"      '(ef-insert-ordinal-date :wk "Ordinal Date")
           "Itu"      '(ef-insert-unix-time :wk "UNIX Timestamp")
           "Iu"       '(ef-insert-uuid :wk "UUID")
           "IU"       '(insert-char :wk "Unicode")

           ;; Whitespace
           "w"        '(nil :wk "Whitespace")
	   "wt"       '(tabify :wk "Spaces to Tabs")
	   "ws"       '(delete-trailing-whitespace :wk "Strip Trailing Whitespace")
	   "wu"       '(untabify :wk "Tabs to Spaces")

           ;; Window
           "W"        '(nil :wk "Window")
	   "W+"       '(text-scale-adjust :wk "Increase Text Scale")
	   "W-"       '(text-scale-adjust :wk "Decrease Text Scale")
	   "W0"       '(text-scale-adjust :wk "Reset Text Scale")
	   "Wd"       '(delete-window :wk "Delete"))
  :custom
  (evil-auto-indent t)
  (evil-cross-lines t)
  (evil-default-cursor t)
  (evil-default-state 'normal)
  (evil-echo-state nil)
  (evil-ex-interactive-search-highlight 'selected-window)
  (evil-ex-search-case 'smart)
  (evil-ex-search-vim-style-regexp t)
  (evil-kbd-macro-suppress-motion-error t)
  (evil-magic 'very-magic)
  (evil-search-module 'evil-search)
  (evil-shift-width 2)
  (evil-undo-system 'undo-tree)
  (evil-undo-function 'undo-tree-undo)
  (evil-redo-function 'undo-tree-redo)
  ;; Required for evil-collection:
  (evil-want-integration t)
  (evil-want-keybinding nil)
  :init
  (declare-function evil-ex-define-cmd "evil-ex")
  :config
  (require 'evil-ex)
  (evil-mode 1)
  (evil-ex-define-cmd "q" 'ef-kill-buffer-or-delete-window))

(use-package eldoc
  :after evil
  :defer t
  :config
  ;; Trigger `eldoc' after changing evil states
  (eldoc-add-command 'evil-normal-state
                     'evil-insert
                     'evil-change
                     'evil-delete
                     'evil-replace))

(use-package evil-nerd-commenter
  :after evil
  :defer t
  :ensure t
  :commands (evilnc-comment-or-uncomment-lines)
  :general
  (:states '(normal visual) :keymaps 'prog-mode-map
	   "\\" 'evilnc-comment-or-uncomment-lines
	   "#" 'evilnc-comment-or-uncomment-lines))

(use-package evil-surround
  :after evil
  :defer 1
  :ensure t
  :config
  (global-evil-surround-mode 1))

(use-package undo-tree
  :after evil
  :ensure t
  :demand t
  :custom
  (undo-tree-auto-save-history t)
  (undo-tree-enable-undo-in-region t)
  (undo-tree-visualizer-timestamps t)
  (undo-tree-visualizer-lazy-drawing nil)
  :general
  (:states 'normal :prefix ef-prefix
	   "u" '(undo-tree-visualize :wk "Open undo-tree"))
  :config
  (global-undo-tree-mode))

(use-package evil-collection
  :after evil
  :ensure t
  :custom
  (evil-collection-company-use-tng nil)
  :config
  (evil-collection-init))

(use-package anzu
  :after evil
  :ensure t
  :config
  (global-anzu-mode t))

(use-package evil-anzu
  :after (anzu evil)
  :ensure t)

(use-package evil-lion
  :after evil
  :ensure t
  :config
  (evil-lion-mode t))

(provide 'core-evil)

(use-package shackle
  :ensure t
  :config
  (setq shackle-select-reused-windows nil
        shackle-default-alignment 'below
        shackle-default-size 0.4
        shackle-default-rule '(:same t))

  (when (not shackle-rules)
    (setq shackle-rules '()))

  (defun ts/shackle (shackle &rest rest)
    "Adds one or more shackle rules to `shackle-rules'"
    (if (eq 0 (length rest))
        (add-to-list 'shackle-rules shackle)
      (dolist (s (cons shackle rest))
        (ts/shackle s))))

  (ts/shackle '(" *undo-tree*" :align below :size .4 :popup t :select t)
              '("*Help*" :align below :size .4 :popup t :select t))

  (shackle-mode t)

  (defmacro ts/define-repl (name buf fn)
    "Define a shackle REPL wrapper function with `name' for buffer `buf'
created by calling function `fn'"
    `(progn
       (add-to-list 'shackle-rules
                    '(,buf :align bottom :size .4 :popup t :select t))
       (defun ,name ()
         (interactive)
         (let ((buffer (get-buffer ,buf))
               (window (get-buffer-window ,buf t)))
           (cond ((null buffer)
                  (funcall ,fn))
                 (window
                  (delete-window window))
                 (t
                  (pop-to-buffer ,buf))))))))


(provide 'pkg-shackle)

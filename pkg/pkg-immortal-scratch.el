(use-package immortal-scratch
  :defer 2
  :ensure t
  :config
  (run-with-idle-timer 1 t 'immortal-scratch-respawn))

(provide 'pkg-immortal-scratch)

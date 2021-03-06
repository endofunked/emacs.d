(require 'core-lib)
(require 'core-shackle)

(use-package cpbooster
  :after cc-mode
  :load-path "vendor/"
  :general
  (:prefix ef-prefix
   :states '(normal visual)
   "q" '(nil :wk "cpbooster")
   "qc" '(cpbooster-clone :wk "Clone")
   "qd" '(cpbooster-debug :wk "Debug")
   "qt" '(cpbooster-test :wk "Test"))
  :config
  (ef-add-popup "*cpbooster*" :size .3 :select nil :align 'right))

(provide 'util-cpbooster)

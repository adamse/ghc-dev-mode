;;; ghc-dev-mode.el ---

;; Copyright (c) 2014 Adam Sandberg Eriksson. All rights reserved.

;;; Settings

(defgroup ghc-dev nil "GHC dev mode" :prefix 'ghc :group 'haskell)

(defcustom ghc-source-location "~/src/ghc"
  "GHC source code location"
  :type 'directory
  :group 'ghc-dev)

(defcustom ghc-compile-command "cd ghc; make 2"
  "GHC compile command, run from inside ghc-source-location"
  :type 'string
  :group 'ghc-dev)

(defcustom ghc-base-revision "master"
  "GHC base revision, for lint to compare with"
  :type 'string
  :group 'ghc-dev)

;;; Functions

(defun ghc-rgrep (regexp)
  (interactive (list (progn (grep-compute-defaults) (grep-read-regexp))))
  (rgrep regexp "*hs" (concat ghc-source-location "/compiler/")))

(defun ghc-compile ()
  (interactive)
  (save-some-buffers (not compilation-ask-about-save)
                     (if (boundp 'compilation-save-buffers-predicate) ;; since Emacs 24.1(?)
                         compilation-save-buffers-predicate))
  (let ((compile-command
         (concat "EXTRA_HC_OPTS=-ferror-spans "
                 "cd " ghc-source-location "; "
                 ghc-compile-command)))
    (compilation-start compile-command 'haskell-compilation-mode))
  (set-buffer "*haskell-compilation*")
  (setq default-directory ghc-source-location))

(defun ghc-lint ()
  (interactive)
  (compile (concat "cd " ghc-source-location "; "
                   "arc lint --output compiler --rev " ghc-base-revision))
  (set-buffer "*compilation*")
  (setq default-directory ghc-source-location))

;;; Keys

(defvar ghc-dev-mode-map
  (let ((map (make-sparse-keymap)))
    (define-key map (kbd "C-q") 'ghc-compile)
    map))

(easy-menu-define ghc-dev--mode-menu ghc-dev-mode-map
  "Menu for the GHC dev minor mode"
  `("GHC"
    ["Compile GHC" ghc-compile t]
    ["Run arc lint" ghc-lint t]
    "--------"
    ["Customize ghc-dev-mode" (customize-group 'ghc-dev) t]
    ))

;;; Mode definition

;;;###autoload
(define-minor-mode ghc-dev-mode
  "Develop GHC with ease!"
  :lighter " GHC"
  :keymap ghc-dev-mode-map
  :group 'ghc-dev)

(provide 'ghc-dev-mode)

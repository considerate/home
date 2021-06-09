(require 'package)
(setq package-archives nil)
(package-initialize)
(require 'use-package)
(use-package use-package-ensure-system-package :ensure t)

(use-package direnv
  :config
  (direnv-mode))

(use-package company
  :bind
  (:map company-active-map
        ("C-n" . company-select-next)
        ("C-p" . company-select-previous))
  :config
  (setq company-idle-delay 0.1)
  (global-company-mode t)
  )

(use-package eglot
  :config
  (add-to-list 'eglot-server-programs '(haskell-mode . ("haskell-language-server" "--lsp")))
  )


(use-package reformatter
 :ensure t
 )

(use-package ormolu
 :after reformatter
 :hook (haskell-mode . ormolu-format-on-save-mode)
 :bind
 (:map haskell-mode-map
   ("C-c r" . ormolu-format-buffer)))

(add-hook 'haskell-mode-hook 'format-all-mode)
(add-hook 'haskell-mode-hook 'eglot-ensure)

(use-package haskell-mode
  :interpreter
  ("hs" . haskell-mode)
  )


(use-package base16-theme
  :ensure t
  :config
  (load-theme 'base16-ocean t))

(use-package markdown-mode
  :ensure t
  :commands (markdown-mode gfm-mode)
  :mode (("README\\.md\\'" . gfm-mode)
         ("\\.md\\'" . markdown-mode)
         ("\\.markdown\\'" . markdown-mode))
  :init (setq markdown-command "multimarkdown"))

(defvar --backup-directory (concat user-emacs-directory "backups"))
(if (not (file-exists-p --backup-directory)) (make-directory --backup-directory t))
(setq backup-directory-alist '(("." . ,--backup-directory)))
(setq resize-mini-windows nil) ; don't resize the minibuffer (echo area)

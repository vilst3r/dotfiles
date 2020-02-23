;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Custom variables
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(setq custom-file "~/.emacs.d/custom.el")
(ignore-errors (load custom-file)) ;; It may not yet exist.

(setq enable-local-variables :safe)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Package
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(require 'package)

;; Configure registry to install packages
(setq package-archives '(("org"       . "http://orgmode.org/elpa/")
			 ("gnu"       . "http://elpa.gnu.org/packages/")
			 ("melpa"     . "http://melpa.org/packages/")))

;; Temporay bug fix for 26.2 MacOS Emacs - Fail to download 'gnu' archive
(customize-set-variable 'gnutls-algorithm-priority "NORMAL:-VERS-TLS1.3")

;; Activate all installed packages
(package-initialize)

;; Installs missing packages via boostrapping to the 'use-package' module
(unless (package-installed-p 'use-package)
  (package-install 'use-package))
(require 'use-package)

(setq use-package-always-ensure t)

;; Automatically update old packages
(use-package auto-package-update
	     :defer 10
	     :config
	     (setq auto-package-update-delete-old-versions t)
	     (setq auto-package-update-hide-results t)
	     (auto-package-update-maybe))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; IDE Initialization
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Transparency function
(defun toggle-transparency ()
  "Toggle transparency of Emacs on & off. (Active-Opacity . Inactie-Opacity)."
  (interactive)
  (if (equal (frame-parameter (selected-frame) 'alpha) '(100 . 85))
      (set-frame-parameter (selected-frame) 'alpha '(85 . 75))
    (set-frame-parameter (selected-frame) 'alpha '(100 . 85))))

(define-key global-map (kbd "C-c t") 'toggle-transparency)

;; Load full screen on startup
(add-to-list 'default-frame-alist '(fullscreen . maximized))
;; Load at 85% transparency on startup
(set-frame-parameter (selected-frame) 'alpha '(85 . 75))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; General
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Start Up files & window
(split-window-right)
(other-window 1)
(find-file "~/.emacs.d/init.el")
(other-window 1)
(find-file "~/todo.org")

;; GUI features
(setq inhibit-startup-message t)
(mouse-avoidance-mode 'animate)
(global-hl-line-mode t)

;; Hide unused GUI features to gain more screen pixels
(tool-bar-mode   -1)  ;; Remove the large Word-like editing icons at the top
(menu-bar-mode   -1)  ;; Remove the large Mac OS top pane menu options

;; Highlight cursor during navigation
(use-package beacon
  :diminish
  :config
  (setq beacon-color "#666600")
  (beacon-mode 1))

;; Visual Styling - Doom theme
(use-package doom-modeline)
(use-package all-the-icons)
(use-package doom-themes
  :requires doom-modeline
  :config
  (load-theme 'doom-city-lights t)
  (setq doom-themes-enable-bold t)
  (setq doom-themes-enable-italic t)
  (doom-modeline-mode 1)
  (doom-themes-visual-bell-config)
  (doom-themes-org-config))

;; Buffer formatting
(setq column-number-mode t)
(setq size-indication-mode t)
(setq fill-column 80)
(setq echo-keystrokes .1)
(setq-default display-line-numbers 'relative)

;; Utilities
(electric-pair-mode 1) ;; Inserts registered paired s-expressions during editing
(show-paren-mode 1)
(customize-set-variable 'show-paren-delay 0)
(customize-set-variable 'show-paren-style 'parenthesis)
(fset 'yes-or-no-p 'y-or-n-p) ;; Shorten yes/no prompts

;; Configure which key package to highlight candidate commands
(use-package which-key
  :defer 5
  :config
  (which-key-mode)
  (which-key-setup-side-window-bottom)
  (setq which-key-idle-delay 0.05))

;; Sync PATH variable from bash shell to the emacs environment
(use-package exec-path-from-shell
  :config
  (when (memq window-system '(mac ns x))
    (exec-path-from-shell-initialize)))

;; Simple split window navigation
(use-package ace-window
  :config
  (global-set-key (kbd "M-o") 'ace-window))

;; Scrolling window with fixed cursor
(global-set-key (kbd "M-n") (kbd "C-u 1 C-v"))
(global-set-key (kbd "M-p") (kbd "C-u 1 M-v"))

;; Set autocomplete across all modes
(use-package company
  :hook (after-init . global-company-mode))

(use-package markdown-mode)

(use-package page-break-lines
  :hook ((emacs-lisp-mode markdown-mode) . page-break-lines-mode))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Magit
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package magit
  :config
  (global-set-key (kbd "C-x g") 'magit-status)
  (global-set-key (kbd "C-x p") 'magit-list-repositories))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Projectile
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package projectile
  :config
  (define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map)
  (projectile-mode +1))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Evil
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package evil  ;; This package installs undo-tree as a dependency
  :init
  (setq evil-want-C-u-scroll t)              ;; Override undo-tree with C-U when using evil mode
  (setq undo-tree-visualizer-timestamps t)   ;; Each node in the undo tree should have a timestamp.
  (setq undo-tree-visualizer-diff t))        ;; Show a diff window displaying changes between undo nodes.

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Helm
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package helm-descbinds)
(use-package helm
  :config
  (global-set-key (kbd "C-x m") 'helm-M-x)
  (global-set-key (kbd "C-x b") 'helm-mini)
  (global-set-key (kbd "C-c i") 'helm-imenu)
  (global-set-key (kbd "C-h b") 'helm-descbinds)
  (global-set-key (kbd "C-x C-r") 'helm-recentf)
  (global-set-key (kbd "C-x C-f") 'helm-find-files)
  (global-set-key (kbd "C-x r b") 'helm-filtered-bookmarks)
  (global-set-key (kbd "M-y") 'helm-show-kill-ring)
  (with-eval-after-load 'helm
    (define-key helm-map (kbd "<tab>") 'helm-execute-persistent-action) ;; Enable TABs to persist helm options
    (define-key helm-map (kbd "C-z") 'helm-select-action)))

(use-package helm-projectile
  :config
  (helm-projectile-on))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Latex Setup
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package tex
  :ensure auctex
  :hook
  ((TeX-mode . flyspell-mode)		      ;; Highlights all misspelled words
   (TeX-mode . (lambda () (TeX-fold-mode 1))) ;; Highlights all misspelled words in comments and strings
   (emacs-lisp-mode . flyspell-prog-mode))    ;; Activate TeX-fold-mode.
  :config
  (setq TeX-auto-save t)
  (setq TeX-parse-self t)
  (setq-default TeX-master nil)
  (setq TeX-PDF-mode t)                                ;; Enable default compilation to PDF
  (setq ispell-dictionary "english")                   ;; Default Dictionary
  (customize-set-variable 'LaTeX-babel-hyphen nil))    ;; Disable language-specific hyphen insertion

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Org mode
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package org
  :ensure org-plus-contrib
  :hook (before-save . whitespace-cleanup)
  :config
  (setq org-default-notes-file "~/todo.org")
  (setq org-todo-keywords
	'((sequence "TODO" "IN-PROGRESS" "WAITING" "REDO" "REVIEW-SOLUTION" "DONE"))) ;; Subheading States
  (setq org-ellipsis " ⤵")
  (setq org-catch-invisible-edits 'show)
  (setq org-return-follows-link t)
  (setq org-enforce-todo-dependencies t)
  (setq org-reverse-note-order nil)
  (setq org-agenda-files (list org-default-notes-file))
  (global-set-key (kbd "C-c c") 'org-capture)
  (global-set-key (kbd "C-c a") 'org-agenda))

(use-package org-bullets
  :hook (org-mode . org-bullets-mode))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Normal Development Setup
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package flycheck
  :init (global-flycheck-mode))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Python Development Setup
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package elpy
  :init
  (elpy-enable)
  :config
  (setq python-shell-interpreter "python3")
  (setq elpy-modules (delq 'elpy-module-flymake elpy-modules))) ;; Force elpy to use python 3

(use-package py-autopep8
  :hook ((elpy-mode python-mode) . py-autopep8-enable-on-save))

(use-package blacken
  :hook ((elpy-mode python-mode) . blacken-mode))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Javascript Development Setup
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package js2-refactor)
(use-package xref-js2)

(use-package js2-mode
  :requires (js2-refactor xref-js2)
  :init
  (add-to-list 'auto-mode-alist '("\\.js\\'" . js2-mode))
  :hook ((js2-mode . js2-imenu-extras-mode)
	 (js2-mode . js2-refactor-mode)
	 (xref-backend-functions . (lambda ()
				    (add-hook 'xref-backend-functions #'xref-js2-xref-backend nil t))))
  :config
  (setq js2-basic-offset 2)
  (add-to-list 'auto-mode-alist '("\\.js\\'" . js2-mode))
  (js2r-add-keybindings-with-prefix "C-c C-r")
  (define-key js2-mode-map (kbd "C-k") #'js2r-kill)     ;; Kill to EOL while keeping AST valid
  (define-key js-mode-map (kbd "M-.") nil))

;; Typescript Configuration
(defun setup-tide-mode ()
  (interactive)
  (tide-setup)
  (flycheck-mode +1)
  (setq flycheck-check-syntax-automatically '(save mode-enabled))
  (eldoc-mode +1)
  (tide-hl-identifier-mode +1)
  (company-mode +1))

(use-package tide
  :after (typescript-mode company flycheck)
  :hook ((typescript-mode . setup-tide-mode)
	 (before-save . tide-format-before-save))
  :config
  (setq flycheck-check-syntax-automatically '(save mode-enabled))
  (setq company-tooltip-align-annotations t))    ;; aligns annotation to the right hand side

;; React Configuration
(use-package web-mode
  :init
  (add-to-list 'auto-mode-alist '("\\.tsx\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.jsx\\'" . web-mode))
  :hook ((web-mode . (lambda ()
		       (when (string-equal "tsx" (file-name-extension buffer-file-name))
			(setup-tide-mode))))
	 (web-mode . (lambda ()
		       (when (string-equal "jsx" (file-name-extension buffer-file-name))
			 (setup-tide-mode)))))
  :config
  ;; enable typescript-tslint checker
  (flycheck-add-mode 'typescript-tslint 'web-mode)
  ;; configure jsx-tide checker to run after your default jsx checker
  (flycheck-add-mode 'javascript-eslint 'web-mode))

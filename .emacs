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
(setq gnutls-algorithm-priority "NORMAL:-VERS-TLS1.3")

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

;; GUI features
(setq inhibit-startup-message t)
(mouse-avoidance-mode 'animate)

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
(setq default-fill-column 80)
(setq echo-keystrokes .1)
(setq-default display-line-numbers 'relative)

;; Utilities
(show-paren-mode 1)
(setq show-paren-delay 0)
(setq show-paren-style 'parenthesis)

;; Configure which key package to highlight candidate commands
(use-package which-key
  :diminish
  :defer 5
  :config
  (which-key-mode)
  (which-key-setup-side-window-bottom)
  (setq which-key-idle-delay 0.05))

;; Sync shell PATH variables from bash shell to emacs
(use-package exec-path-from-shell
  :config  
  (when (memq window-system '(mac ns x))
    (exec-path-from-shell-initialize)))

;; Window navigation
(global-set-key (kbd "M-o") 'ace-window)

;; Scrolling window with fixed cursor
(global-set-key "\M-n" "\C-u1\C-v")
(global-set-key "\M-p" "\C-u1\M-v")

;; Set autocomplete across all modes
(use-package company)
(setq global-company-mode t)

(use-package markdown-mode)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Magit
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package magit
  :config
  (global-set-key (kbd "C-x g") 'magit-status)
  (global-set-key (kbd "C-x p") 'magit-list-repositories))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Evil
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package evil
  :init
  (setq evil-want-C-u-scroll t)    ;; Override undo-tree with C-U when using evil mode
  :config
  (evil-mode 0))                   ;; Turn off evil mode by default

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Helm
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package helm-descbinds)
(use-package helm-ls-git)
(use-package helm
  :config
  (require 'helm-config)
  ;; Global helm commands
  (global-set-key (kbd "C-x b") 'helm-buffers-list)
  (global-set-key (kbd "C-x r b") 'helm-bookmarks)
  (global-set-key (kbd "C-x m") 'helm-M-x)
  (global-set-key (kbd "C-x C-f") 'helm-find-files)
  (global-set-key (kbd "C-h b") 'helm-descbinds)
  (global-set-key (kbd "M-y") 'helm-show-kill-ring)
  (global-set-key (kbd "C-x C-d") 'helm-browse-project)
  (global-set-key (kbd "C-x r p") 'helm-projects-history)
  (global-set-key (kbd "C-x C-g") 'helm-grep-do-git-grep)
  ;; Allow smooth navigation through directories with TAB
  (with-eval-after-load 'helm
    (define-key helm-map (kbd "<tab>") 'helm-execute-persistent-action)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Latex Setup
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package tex
  :ensure auctex
  :init
  (add-hook 'TeX-mode-hook 'flyspell-mode)             ;; Highlights all misspelled words
  (add-hook 'emacs-lisp-mode-hook 'flyspell-prog-mode) ;; Highlights all misspelled words in comments and strings
  (add-hook 'TeX-mode-hook                             ;; Activate TeX-fold-mode.
          (lambda () (TeX-fold-mode 1)))
  :config
  (setq TeX-auto-save t)
  (setq TeX-parse-self t)
  (setq-default TeX-master nil)
  (setq TeX-PDF-mode t)                                ;; Enable default compilation to PDF
  (setq ispell-dictionary "english")                   ;; Default Dictionary
  (setq LaTeX-babel-hyphen nil))                       ;; Disable language-specific hypthen insertion

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Org mode
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package org
  :config
  (setq org-todo-keywords
	'((sequence "TODO" "IN-PROGRESS" "WAITING" "REDO" "TEST" "REVIEW-SOLUTION" "DONE"))))   ;; Subheading States

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
  :hook 'elpy-mode 'py-autopep8-enable-on-save)

;; For EPI problems
(defun epi-judge ()
  "Use this to compile EPI problems through Python."
  (interactive)
  (compile (format "%s %s"  python-shell-interpreter (buffer-name))))

;; Solution to render linux based color codes in python interpreter output for epi-judge()
(ignore-errors
  (require 'ansi-color)
  (defun my-colorize-compilation-buffer ()
    (when (eq major-mode 'compilation-mode)
      (ansi-color-apply-on-region compilation-filter-start (point-max))))
  (add-hook 'compilation-filter-hook 'my-colorize-compilation-buffer))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Javascript Development Setup
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package js2-refactor)
(use-package xref-js2
  :hook 'xref-backend-functions #'xref-js2-xref-backend nil t)


(use-package js2-mode
  :requires js2-refactor
  :hook 'js2-mode #'js2-imenu-extras-mode               ;; Better imenu
  :hook 'js2-mode #'js2-refactor-mode
  :hook 'js2-mode 'xref-backend-functions
  :config
  (setq js2-basic-offset 2)
  (add-to-list 'auto-mode-alist '("\\.js\\'" . js2-mode))
  (js2r-add-keybindings-with-prefix "C-c C-r")
  (define-key js2-mode-map (kbd "C-k") #'js2r-kill)     ;; Kill to EOL while keeping AST valid
  (define-key js-mode-map (kbd "M-.") nil))

;; Typescript Configuration
(use-package tide
  :hook 'before-save 'tide-format-before-save ;; formats the buffer before saving
  :hook 'typescript-mode #'setup-tide-mode
  :config	     
  (defun setup-tide-mode ()
    (interactive)
    (tide-setup)
    (flycheck-mode +1)
    (setq flycheck-check-syntax-automatically '(save mode-enabled))
    (eldoc-mode +1)
    (tide-hl-identifier-mode +1)
    ;; company is an optional dependency. You have to
    ;; install it separately via package-install
    ;; `M-x package-install [ret] company`
    (company-mode +1))
  (setq company-tooltip-align-annotations t))  ;; aligns annotation to the right hand side


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Auto Configuration
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; State of configuration of packages
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(org-export-backends (quote (ascii html icalendar latex md odt)))
 '(package-selected-packages
   (quote
    (## tide helm-ls-git markdown-mode evil ag js2-refactor xref-js2 js2-mode ace-window blacken elpy py-autopep8 flycheck exec-path-from-shell jedi doom-modeline helm-descbinds magit helm gruvbox-theme doom-themes))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

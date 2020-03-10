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
(global-hl-line-mode 1)

;; Hide unused GUI features to gain more screen pixels
(tool-bar-mode   -1)  ;; Remove the large Word-like editing icons at the top
(scroll-bar-mode -1)  ;; Remove visual scroll bar & rely on modeline buffer percentage
(menu-bar-mode   -1)  ;; Remove the large Mac OS top pane menu options

;; Highlight cursor during navigation
(use-package beacon
  :diminish
  :config
  (setq beacon-color "#539AFC")
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
(setq echo-keystrokes .1)
(setq-default display-line-numbers 'relative)
(setq-default fill-column 80          ;; Let's avoid going over 80 columns
              truncate-lines nil      ;; I never want to scroll horizontally
              indent-tabs-mode nil)   ;; Use spaces instead of tabs

;; Mark line limit
(use-package fill-column-indicator
  :hook
  ((emacs-lisp-mode . (lambda ()
                        (setq fill-column 100)
                        (turn-on-auto-fill))))
  (prog-mode . fci-mode)
  :config
  (setq fci-rule-width 2)
  (setq fci-rule-color "#D95468"))

;; Wrap lines
(setq visual-line-fringe-indicators '(left-curly-arrow right-curly-arrow))
(global-visual-line-mode 1)

;; Utilities
(electric-pair-mode 1) ;; Inserts registered paired s-expressions during editing
(setq show-paren-delay 0)
(setq show-paren-style 'parenthesis)
(show-paren-mode 1)
(fset 'yes-or-no-p 'y-or-n-p) ;; Shorten yes/no prompts

;; Configure which key package to highlight candidate commands
(use-package which-key
  :config
  (which-key-setup-side-window-bottom)
  (setq which-key-idle-delay 1)
  (which-key-mode))

;; Sync PATH variable from bash shell to the emacs environment
(use-package exec-path-from-shell
  :config
  (when (memq window-system '(mac ns x))
    (exec-path-from-shell-initialize)))

;; Simple split window navigation
(use-package ace-window
  :bind ("M-o" . ace-window))

;; Emulate iTerm window navigation
(global-set-key (kbd "s-]") (lambda () (interactive) (other-window 1)))
(global-set-key (kbd "s-[") (lambda () (interactive) (other-window -1)))
(global-set-key (kbd "s-w") 'delete-window)
(global-set-key (kbd "s-d") 'split-window-right)

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
  :bind ("C-x g" . magit-status))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Projectile
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package projectile
  :bind
  (:map projectile-mode-map
        ("C-c p" . projectile-command-map))
   :config
  (projectile-mode +1))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Evil
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package evil  ;; This package installs undo-tree as a dependency
  :hook
  (prog-mode . hs-minor-mode)
  :init
  (setq evil-want-C-u-scroll t)              ;; Override undo-tree with C-U when using evil mode
  (setq evil-default-state 'emacs)           ;; Emacs on default for all buffers
  (setq undo-tree-visualizer-timestamps t)   ;; Each node in the undo tree should have a timestamp.
  (setq undo-tree-visualizer-diff t) ;; Show a diff window displaying changes between undo nodes.
  (evil-mode 1))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Helm
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package helm-descbinds)
(use-package helm
  :init (helm-mode t)
  :bind (("C-x m" . helm-M-x)
         ("C-x b" . helm-mini)
         ("C-c i" . helm-imenu)
         ("C-h b" . helm-descbinds)
         ("C-x C-f" . helm-find-files)
         ("C-x r b" . helm-filtered-bookmarks)
         ("M-y" . helm-show-kill-ring)
         :map helm-map
         ("TAB" . helm-execute-persistent-action)
         ("<tab>" . helm-execute-persistent-action)
         ("C-z" . helm-select-action)))


(use-package helm-projectile
  :config
  (helm-projectile-on))

 ;; Helm for org headlines and keywords completion.
(use-package helm-org
  :config
  (add-to-list 'helm-completing-read-handlers-alist
               '(org-set-tags-command . helm-org-completing-read-tags)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Latex Setup
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package tex
  :ensure auctex
  :hook
  ((TeX-mode . flyspell-mode)		      ;; Highlights all misspelled words
   (TeX-mode . (lambda () (TeX-fold-mode 1))) ;; Highlights all misspelled words in comments &
                                              ;; strings
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
  :bind (("C-c c" . org-capture)
         ("C-c a" . org-agenda))
  :hook ((before-save . whitespace-cleanup)
         (org-mode . turn-on-auto-fill)
         (text-mode . turn-on-auto-fill))
  :config
  (setq org-default-notes-file "~/todo.org")
  (setq org-todo-keywords '((sequence "TODO(t)" "IN-PROGRESS(i)" "WAITING(w)" "REDO(r)"
                                      "EXAMINE-SOLUTION(e)" "DONE(d)"))) ;; Subheading States
  (setq org-ellipsis " ⤵")
  (setq org-catch-invisible-edits 'show)
  (setq org-return-follows-link t)
  (setq org-enforce-todo-dependencies t)
  (setq org-reverse-note-order nil)
  (setq org-agenda-files (list org-default-notes-file))
  (setq org-agenda-tags-column -10)
  (setq org-agenda-show-all-dates t)
  (setq org-agenda-skip-scheduled-if-done t)
  (setq org-agenda-skip-deadline-if-done  t)
  (setq org-agenda-text-search-extra-files '(agenda-archives))
  (setq org-agenda-restore-windows-after-quit t)
  (setq org-log-redeadline 'time)
  (setq org-log-reschedule 'time)
  (setq org-agenda-custom-commands
        '(("c" "Completed tasks for archiving" todo "DONE"
           ((org-agenda-overriding-header "Completed tasks for archiving")))
          ("u" "Unscheduled TODO tasks" tags-todo "tasks"
           ((org-agenda-skip-function
             (lambda ()
               (org-agenda-skip-entry-if 'scheduled 'deadline 'regexp  "\n]+>")))
            (org-agenda-overriding-header "Unscheduled TODO Tasks: ")))
          ("i" "Dangling tasks in progress" tags-todo "+tasks+TODO=\"IN-PROGRESS\""
           ((org-agenda-overriding-header "Dangling tasks in progress")))))
  (setq org-capture-templates
        '(("t" "Tasks" entry (file+headline org-default-notes-file "Tasks")
           "* TODO %?\n CREATED: %U")
          ("c" "Curious Questions" entry (file+headline org-default-notes-file "Curious Questions")
           "* TODO %?\n CREATED: %U")))
  ;; support for source code execution in org file
  (org-babel-do-load-languages
   'org-babel-load-languages
   '((emacs-lisp . t)
     (shell      . t)
     (python     . t)
     (haskell    . t)
     (ruby       . t)
     (ocaml      . t)
     (C          . t)  ;; Captial “C” gives access to C, C++, D
     (dot        . t)
     (latex      . t)
     (org        . t)
     (makefile   . t)))
  ;; Preserve my indentation for source code during export.
  (setq org-src-preserve-indentation t)
  (setq org-latex-listings 'minted
        org-latex-packages-alist '(("" "minted")))
  (setq org-lowest-priority ?D) ;; Now org-speed-key ‘C-c ,’ gives 4 options
  (setq org-priority-faces
        '((?A :foreground "red" :weight bold)
          (?B . "orange")
          (?C . "yellow")
          (?D . "green"))))

(use-package org-bullets
  :hook (org-mode . org-bullets-mode))

(use-package org-fancy-priorities
  :diminish t
  :hook   (org-mode . org-fancy-priorities-mode)
  :custom (org-fancy-priorities-list '("HIGH" "MID" "LOW" "OPTIONAL")))

;; org export configurations
(use-package ox-twbs) ;; Clean bootstrap HTML exports

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Normal Development Setup
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package flycheck
  :init (global-flycheck-mode))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Python Development Setup
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package elpy
  :hook
  (elpy-mode . (lambda ()
                 (setq fill-column 80)
                 (setq tab-width 4)
                 (setq whitespace-style 'indentation)
                 (turn-on-auto-fill)))
  :init
  (elpy-enable)
  :config
  (setq python-shell-interpreter "python3")
  (setq elpy-modules (delq 'elpy-module-flymake elpy-modules)))

(use-package blacken
  :hook
  (elpy-mode . blacken-mode))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Javascript Development Setup
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package js2-refactor)
(use-package xref-js2)

(use-package js2-mode
  :requires (js2-refactor xref-js2)
  :mode ("\\.js\\'" . js2-mode)
  :bind (:map js2-mode-map
              ("C-k" . js2r-kill) ;; Kill to EOL while keeping AST valid
              :map js-mode-map
              ("M-." . nil))
  :hook ((js2-mode . js2-imenu-extras-mode)
         (js2-mode . js2-refactor-mode)
         (xref-backend-functions . (lambda () (add-hook 'xref-backend-functions
                                                        #'xref-js2-xref-backend nil t))))
  :config
  (setq js2-basic-offset 2)
  (js2r-add-keybindings-with-prefix "C-c C-r"))

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
  :mode (("\\.tsx\\'" . web-mode)
         ("\\.jsx\\'" . web-mode))
  :hook ((web-mode . (lambda ()
                       (when (or (string-equal "tsx" (file-name-extension buffer-file-name))
                                 (string-equal "jsx" (file-name-extension buffer-file-name)))
                         (setup-tide-mode)))))
  :config
  (flycheck-add-mode 'typescript-tslint 'web-mode)  ;; enable typescript-tslint checker
  (flycheck-add-mode 'javascript-eslint 'web-mode))   ;; configure jsx-tide checker to run after
                                                      ;; your default jsx checker


;; Start up files & windows after all packages are loaded & configured
(split-window-right)
(other-window 1)
(find-file "~/.emacs.d/init.el")
(other-window 1)
(find-file "~/todo.org")

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
(setq package-archives '(("org"   . "http://orgmode.org/elpa/")
                         ("gnu"   . "http://elpa.gnu.org/packages/")
                         ("melpa" . "http://melpa.org/packages/")))

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
;; GUI 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun toggle-transparency ()
  "Toggle transparency of Emacs on & off. (Active-Opacity . Inactie-Opacity)."
  (interactive)
  (if (equal (frame-parameter (selected-frame) 'alpha) '(100 . 85))
      (set-frame-parameter (selected-frame) 'alpha '(85 . 75))
    (set-frame-parameter (selected-frame) 'alpha '(100 . 85))))

(define-key global-map (kbd "C-c t") 'toggle-transparency)

(add-to-list 'default-frame-alist '(fullscreen . maximized)) ;; Load full screen on startup
(set-frame-parameter (selected-frame) 'alpha '(85 . 75)) ;; Load at 85% transparency on startup

;; Hide unused GUI features to gain more screen pixels
(tool-bar-mode   -1)  ;; Remove the large Word-like editing icons at the top
(scroll-bar-mode -1)  ;; Remove visual scroll bar & rely on modeline buffer percentage
(menu-bar-mode   -1)  ;; Remove the large Mac OS top pane menu options

;; GUI features
(setq inhibit-startup-message t)
(setq visual-line-fringe-indicators '(left-curly-arrow right-curly-arrow)) ;; Soft wrap lines
(global-visual-line-mode 1)
(global-hl-line-mode 1)
(mouse-avoidance-mode 'animate)
(fset 'yes-or-no-p 'y-or-n-p) ;; Shorten yes/no prompts

(setq async-shell-command-display-buffer nil) ;; No pop-up after async command
(global-undo-tree-mode) ;; Unable simple redo key + visual undo tree to checkout branches

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; General
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Parenthesis configurations
(electric-pair-mode 1) ;; Inserts registered paired s-expressions during editing
(setq show-paren-delay 0)
(setq show-paren-style 'parenthesis)
(show-paren-mode 1)

;; Emulate iTerm window navigation
(global-set-key (kbd "s-]") (lambda () (interactive) (other-window 1)))
(global-set-key (kbd "s-[") (lambda () (interactive) (other-window -1)))
(global-set-key (kbd "s-w") 'delete-window)
(global-set-key (kbd "s-d") 'split-window-right)

;; Scrolling window with fixed cursor
(global-set-key (kbd "M-n") (kbd "C-u 1 C-v"))
(global-set-key (kbd "M-p") (kbd "C-u 1 M-v"))

(global-set-key (kbd "C-j") (lambda () (interactive) (join-line -1))) ;; Join line to next line

;; Buffer formatting
(setq column-number-mode t)
(setq size-indication-mode t)
(setq echo-keystrokes .1)

(setq-default display-line-numbers 'relative)
(setq-default whitespace-style '(face lines-tail) ;; Highlight lines past fill column
              truncate-lines nil                  ;; I never want to scroll horizontally
              indent-tabs-mode nil)               ;; Use spaces instead of tabs

(defun setup-autofill (value &optional toggle-whitespace-mode)
  "Initializes fill column, highlights characters past fill column & hard wraps on newline"
  (interactive)
  (setq fill-column value)
  (auto-fill-mode 1)
  (when toggle-whitespace-mode
    (whitespace-mode 0)    
    (setq whitespace-line-column value)
    (whitespace-mode 1)))

(add-hook 'before-save-hook 'whitespace-cleanup)

(add-hook 'prog-mode-hook (lambda () (setup-autofill 80 t)))
(add-hook 'text-mode-hook (lambda () (setup-autofill 80 nil)))

(add-hook 'emacs-lisp-mode-hook (lambda () (setup-autofill 100 t)))
(add-hook 'markdown-mode-hook (lambda () (setup-autofill 80 t)))

;; Visual Styling - Doom theme
(use-package doom-modeline)
(use-package all-the-icons)
(use-package doom-themes
  :config
  (load-theme 'doom-city-lights t)
  (setq doom-themes-enable-bold t)
  (setq doom-themes-enable-italic t)
  (doom-modeline-mode 1)
  (doom-themes-visual-bell-config)
  (doom-themes-org-config))

;; Highlight cursor during navigation
(use-package beacon
  :config
  (setq beacon-color "#539AFC")
  (beacon-mode 1))

(use-package markdown-mode)

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

;; Set autocomplete across all modes
(use-package company
  :hook (after-init . global-company-mode))

(use-package page-break-lines
  :hook ((emacs-lisp-mode text-mode) . page-break-lines-mode))

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
   (projectile-mode +1)
   (setq projectile-use-git-grep 1))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Helm
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package helm-descbinds)
(use-package helm
  :init (helm-mode t)
  :bind (("C-c i" . helm-imenu)
         ("M-y" . helm-show-kill-ring)
         :map ctl-x-map
         ("m" . helm-M-x)
         ("b" . helm-mini)
         ("C-f" . helm-find-files)
         ("r b" . helm-filtered-bookmarks)
         :map help-map
         ("b" . helm-descbinds)
         ("d" . helm-apropos)
         :map helm-map
         ("TAB" . helm-execute-persistent-action)
         ("<tab>" . helm-execute-persistent-action)
         ("C-z" . helm-select-action)))

;; Helm for projectile search
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
  :config
  (setq org-default-notes-file "~/todo.org")
  (setq org-todo-keywords '((sequence "TODO(t)" "IN-PROGRESS(i)" "WAITING(w)" "REDO(r)"
                                      "EXAMINE-SOLUTION(e)" "DONE(d)"))) ;; Subheading States
  (setq org-ellipsis " ⤵")
  (setq org-catch-invisible-edits 'show)
  (setq org-src-preserve-indentation t)
  (setq org-src-tab-acts-natively t)
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
  (setq org-src-preserve-indentation t)   ;; Preserve my indentation for source code during export
  (setq org-latex-listings 'minted
        org-latex-packages-alist '(("" "minted")))
  (setq org-lowest-priority ?D) ;; Now org-speed-key ‘C-c ,’ gives 4 options
  (setq org-priority-faces
        '((?A :foreground "red" :weight bold)
          (?B . "orange")
          (?C . "yellow")
          (?D . "green")))
  ;; support for source code execution in org file
  (org-babel-do-load-languages
   'org-babel-load-languages '((emacs-lisp . t)
                               (shell      . t)
                               (python     . t)
                               (haskell    . t)
                               (ruby       . t)
                               (C          . t)  ;; Captial “C” gives access to C, C++, D
                               (dot        . t)
                               (latex      . t))))

(use-package org-bullets
  :hook (org-mode . org-bullets-mode))

(use-package org-fancy-priorities
  :hook   (org-mode . org-fancy-priorities-mode)
  :custom (org-fancy-priorities-list '("HIGH" "MID" "LOW" "OPTIONAL")))

;; Export a Twitter Bootstrap HTML format of org file
(use-package ox-twbs)

(use-package flycheck
  :init (global-flycheck-mode)
  :config
  (setq-default flycheck-disabled-checkers '(emacs-lisp-checkdoc)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Python Configurations
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package elpy
  :init
  (elpy-enable)
  :hook
  (elpy-mode . py-autopep8-enable-on-save)
  (elpy-mode . (lambda () (highlight-indentation-mode -1)))
  (elpy-mode . (lambda () (unless pyvenv-virtual-env
                            (pyvenv-activate "venv")))))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Initial window setup
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Start up files & windows after all packages are loaded & configured
(split-window-right)
(other-window 1)
(find-file "~/.emacs.d/init.el")
(other-window 1)
(find-file "~/todo.org")

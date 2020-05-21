;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                                          Custom variables                                      ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Set custom file & load it if it exists without error
(setq custom-file "~/.emacs.d/custom.el")
(ignore-errors (load custom-file))

(setq enable-local-variables :safe)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                                              Package                                           ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(require 'package)

;; Configure registry sources to install packages from
(setq package-archives '(("org"   . "http://orgmode.org/elpa/")
                         ("gnu"   . "http://elpa.gnu.org/packages/")
                         ("melpa" . "http://melpa.org/packages/")))

;; Activate all installed packages
(package-initialize)

;; Install 'use-package to configure packages with its macros
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(require 'use-package)

(setq use-package-always-ensure t)      ; Automatically installs all packages that are missing

;; Automatically update old packages
(use-package auto-package-update
  :defer 10
  :config
  (setq auto-package-update-delete-old-versions t)
  (setq auto-package-update-hide-results t)
  (auto-package-update-maybe))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                                                GUI                                             ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defvar default-frame-alpha '(100 . 85)
  "Default frame parameter with no transparency")
(defvar transparent-frame-alpha '(85 . 75)
  "Frame parameter with my configured measure of transparency")

(defun toggle-transparency ()
  "Toggle transparency of the current emacs frame. (active-frame-opacity . inactive-frame-opacity)."
  (interactive)
  (if (equal (frame-parameter (selected-frame) 'alpha) default-frame-alpha)
      (set-frame-parameter (selected-frame) 'alpha transparent-frame-alpha)
    (set-frame-parameter (selected-frame) 'alpha default-frame-alpha)))

(global-set-key (kbd "C-c t") 'toggle-transparency)

;; Default frame parameters
(add-to-list 'default-frame-alist '(fullscreen . maximized))
(add-to-list 'default-frame-alist `(alpha . ,transparent-frame-alpha))

;; Hide unused GUI features to gain more screen pixels
(tool-bar-mode   -1)  ; Remove the large Word-like editing icons at the top
(scroll-bar-mode -1)  ; Remove visual scroll bar & rely on modeline buffer percentage
(menu-bar-mode   -1)  ; Remove the large Mac OS top pane menu options

(setq inhibit-startup-message t)
(setq async-shell-command-display-buffer nil)                              ; No async pop-ups
(setq visual-line-fringe-indicators '(left-curly-arrow right-curly-arrow)) ; Soft wrap lines

(global-visual-line-mode 1)
(global-hl-line-mode 1)
(mouse-avoidance-mode 'animate)
(fset 'yes-or-no-p 'y-or-n-p)           ; Shorten yes/no prompts

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                                              General                                           ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Parenthesis configurations
(setq show-paren-delay 0)
(setq show-paren-style 'parenthesis)
(show-paren-mode 1)                     ; Highlights matching parenthesis
(electric-pair-mode 1)                  ; Inserts registered paired s-expressions

;; Scrolling window with fixed cursor
(global-set-key (kbd "M-n") (lambda () (interactive) (scroll-up-command 1)))
(global-set-key (kbd "M-p") (lambda () (interactive) (scroll-down-command 1)))

;; Efficient general bindings
(global-set-key (kbd "C-w") 'backward-kill-word)
(global-set-key (kbd "C-x C-k") 'kill-region)
(global-set-key (kbd "C-c C-k") 'kill-region)
(global-set-key (kbd "C-x k") 'kill-current-buffer)
(global-set-key (kbd "C-j") (lambda () (interactive) (join-line -1))) ; Vim's join line

;; Buffer formatting
(setq column-number-mode t)
(setq size-indication-mode t)
(setq echo-keystrokes .1)

(setq-default whitespace-style '(face lines-tail) ; Highlight lines past fill column
              truncate-lines nil                  ; Disable horizontal scroll
              indent-tabs-mode nil)               ; Use spaces instead of tabs

(defun setup-autofill (value &optional toggle-whitespace-mode)
  "Initializes fill column, highlights characters past fill column & hard wraps on newline"
  (interactive)
  (setq fill-column value)
  (auto-fill-mode 1)
  (when toggle-whitespace-mode          ; Reset whitespace value if it exists
    (whitespace-mode 0)    
    (setq whitespace-line-column value)
    (whitespace-mode 1)))

(add-hook 'before-save-hook 'whitespace-cleanup)
(add-hook 'prog-mode-hook (lambda () (setup-autofill 80 t)))
(add-hook 'text-mode-hook (lambda () (setup-autofill 80 nil)))
(add-hook 'emacs-lisp-mode-hook (lambda () (setup-autofill 100 t) (flyspell-prog-mode)))
(add-hook 'markdown-mode-hook (lambda () (setup-autofill 80 t)))
(add-hook 'LaTeX-mode-hook (lambda () (setup-autofill 80 t)))

;; Visual Styling - Doom theme
(use-package all-the-icons)
(use-package doom-modeline
  :ensure t
  :init (doom-modeline-mode 1))
(use-package doom-themes
  :config
  (load-theme 'doom-city-lights t)
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
  (setq which-key-idle-delay 3.0)       ; Emacs freezes if delay is too soon
  (which-key-setup-side-window-bottom)
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
  :hook (after-init . global-company-mode)
  :config
  (setq company-selection-wrap-around t))

(use-package page-break-lines
  :init
  (global-page-break-lines-mode 1))

(use-package expand-region
  :bind
  ("C-=" . er/expand-region))

(use-package undo-tree
  :config
  (global-undo-tree-mode))              ; Enable simple redo key & undo tree graph

(use-package flycheck
  :init (global-flycheck-mode)
  :config
  (setq-default flycheck-disabled-checkers '(emacs-lisp-checkdoc)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                                               Magit                                            ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package magit
  :bind ("C-x g" . magit-status))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                                             Projectile                                         ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package projectile
  :bind
  (:map projectile-mode-map
        ("C-c p" . projectile-command-map))
   :config
   (setq projectile-use-git-grep 1)
   (projectile-mode))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                                                Helm                                            ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

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
         ("C-w" . backward-kill-word)
         ("TAB" . helm-execute-persistent-action)
         ("<tab>" . helm-execute-persistent-action)
         ("C-z" . helm-select-action)))

;; Helm for projectile search
(use-package helm-projectile
  :config
  (helm-projectile-on))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                                            Latex Setup                                         ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package tex
  :ensure auctex
  :hook
  ((TeX-mode . (lambda ()
                 (flyspell-mode 1)      ; Highlight all misspelled words based on dictionary
                 (TeX-fold-mode 1))))   ; Enable folding of items/macros & etc in latex document
  :config
  (setq TeX-auto-save t)
  (setq TeX-parse-self t)
  (setq TeX-PDF-mode t)                 ; Enable default compilation to PDF
  (setq ispell-dictionary "english")    ; Default Dictionary for TeX         
  (setq LaTeX-babel-hyphen nil))        ; Disable language-specific hyphen insertion

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                                              Org mode                                          ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package org
  :ensure org-plus-contrib
  :bind (("C-c c" . org-capture)
         ("C-c a" . org-agenda))
  :config
  ;; General settings
  (setq org-default-notes-file "~/todo.org")
  (setq org-todo-keywords '((sequence
                             "TODO(t)" "IN-PROGRESS(i)" "WAITING(w)" "REDO(r)" "EXAMINE-SOLUTION(e)"
                             "|" "DONE(d)" "UNRESOLVED(u)" "SKIPPED(s)")))
  (setq org-ellipsis " ⤵")
  (setq org-return-follows-link t)  
  (setq org-catch-invisible-edits 'show)
  (setq org-enforce-todo-dependencies t)  
  ;; Org Agenda Settings
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
  ;; Org Capture settings
  (setq org-capture-templates
        '(("t" "Tasks" entry (file+headline org-default-notes-file "Tasks")
           "* TODO %?\n CREATED: %U")
          ("c" "Curious Questions" entry (file+headline org-default-notes-file "Curious Questions")
           "* TODO %?\n CREATED: %U")))
  ;; Org Export settings
  (setq org-src-preserve-indentation t) ; Preserve indentation during export
  (setq org-latex-listings 'minted      ; Clean exports for pdfs
        org-latex-packages-alist '(("" "minted")))
  ;; Org src block code settings
  (setq org-src-tab-acts-natively t)    ; Native indentation settings of language in src block
  (setq org-confirm-babel-evaluate nil) ; No confirmation upon execution
  (org-babel-do-load-languages          ; Languages supported for execution
   'org-babel-load-languages '((emacs-lisp . t)
                               (clojure    . t)
                               (css        . t)
                               (C          . t) ; Captial “C” gives access to C, C++, D
                               (shell      . t)
                               (java       . t)
                               (js         . t)
                               (latex      . t)
                               (lisp       . t)
                               (makefile   . t)
                               (python     . t)
                               (ruby       . t)
                               (sass       . t)
                               (sql        . t))))

(use-package org-bullets
  :hook (org-mode . org-bullets-mode))

(use-package org-fancy-priorities
  :hook   (org-mode . org-fancy-priorities-mode)
  :config
  (setq org-lowest-priority ?D)         ; org-speed-key ‘C-c ,’ gives 4 priority options
  (setq org-priority-faces
        '((?A :foreground "red" :weight bold)
          (?B . "orange")
          (?C . "yellow")
          (?D . "green")))  
  (setq org-fancy-priorities-list '("HIGH" "MID" "LOW" "OPTIONAL")))

;; Export a Twitter Bootstrap HTML format of org file
(use-package ox-twbs)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                                       Python Configurations                                    ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package elpy
  :init
  (elpy-enable)
  :hook
  (elpy-mode . py-autopep8-enable-on-save)
  (elpy-mode . (lambda () (highlight-indentation-mode -1)))
  (elpy-mode . (lambda () (unless pyvenv-virtual-env
                            (pyvenv-activate "venv")))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                                     Javascript Configurations                                  ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package xref-js2)

(defun configure-xref-js2-jtd ()
  "This replaces the js2-mode jtd with xref-js2 (using ag search) instead"
  (define-key js-mode-map (kbd "M-.") nil)
  (js2-imenu-extras-mode)
  (add-hook 'xref-backend-functions #'xref-js2-xref-backend nil t))

(use-package js2-mode
  :requires xref-js2
  :mode ("\\.js\\'" . js2-mode)
  :hook (js2-mode . configure-xref-js2-jtd)
  :config
  (setq js2-basic-offset 2)
  (setq js2-indent-level 2))

;; Typescript configurations
(defun setup-tide-mode ()
  "Interactively initializes the tide"
  (interactive)
  (tide-setup)
  (tide-hl-identifier-mode))

(use-package tide
  :after (typescript-mode company flycheck)
  :hook ((typescript-mode . setup-tide-mode)
         (before-save . tide-format-before-save))
  :config
  (setq company-tooltip-align-annotations t))    ;; aligns annotation to the right hand side

;; React Configuration
(defun current-file-is-react ()
  "Returns t if the current source file is a react template otherwise nil"
  (or (string-equal "tsx" (file-name-extension buffer-file-name))
      (string-equal "jsx" (file-name-extension buffer-file-name))))

(use-package web-mode
  :mode (("\\.tsx\\'" . web-mode)
         ("\\.jsx\\'" . web-mode)
         ("\\.html\\'" . web-mode)
         ("\\.css\\'" . web-mode))
  :hook (web-mode . (lambda () (when (current-file-is-react)
                                 (setup-tide-mode)))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                                                Misc                                            ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun move-to-column-force (column)
  "Go to column number, adding whitespaces if necessary"
  (interactive "nColumn: ")
  (move-to-column column t))

(global-set-key (kbd "M-g TAB") 'move-to-column-force)

(defun latex-reload-pdf ()
  "Compiles & opens the TeX-mode document while removing the pop up shell output window.
This still requires you to quit Acrobat Reader with S-q"
  (interactive)
  (let ((base-name (file-name-base (buffer-file-name))))
    (shell-command (format "lualatex %s.tex && open %s.pdf" base-name base-name)
                   "*TeX-output-log*"
                   "*TeX-error-log*")
    (other-window 1)
    (kill-buffer-and-window)))

(eval-after-load 'latex
  '(define-key LaTeX-mode-map (kbd "C-c r") 'latex-reload-pdf))

(defun org-update-last-edit-timestamp ()
  "Updates the date header in the todo document"
  (interactive)
  (when (and (string-equal major-mode "org-mode")
             (string-equal (file-name-base) "todo"))
    (save-excursion
      (goto-char (point-min))
      (setq org-date-pattern "#\\+DATE: \\(.*\\) (last updated)")
      (setq current-timestamp (string-trim-right (shell-command-to-string "date")))
      (if (re-search-forward org-date-pattern nil t 1)
          (replace-match (format "#+DATE: %s (last updated)" current-timestamp))))))

(add-hook 'before-save-hook 'org-update-last-edit-timestamp)

(defun epi-judge-config ()
  "Turn off syntax checking & auto-completion when working on EPIJudge"
  (when (string-equal (projectile-project-name) "EPIJudge")
    (company-mode 0)
    (flymake-mode 0)
    (flycheck-mode 0)))

(add-hook 'elpy-mode-hook 'epi-judge-config)
(add-hook 'c++-mode-hook 'epi-judge-config)

(defun epi-judge-execute ()
  " Execute program against the EPI Judge test cases "
  (interactive)
  (let ((output-buffer "*EPIJudge Output*")
        (error-buffer "*EPIJudge Error*")
        (command (cond ((string-equal "c++-mode" major-mode)
                        (format "make %s" (file-name-base)))
                       ((string-equal "python-mode" major-mode)
                        (format "python3 %s.py" (file-name-base)))
                       (t "echo \"File & major mode not supported for the EPI Judge\""))))
    (when (get-buffer error-buffer)
      (kill-buffer error-buffer))
    (save-selected-window
      (shell-command command output-buffer error-buffer)
      (switch-to-buffer-other-window output-buffer)
      (special-mode)                    ; Enable quick exits
      (if (get-buffer error-buffer)
          (progn
            (switch-to-buffer error-buffer)
            (special-mode)
            (goto-char (point-min)))
        (goto-char (point-max))))))

(global-set-key (kbd "C-c e") 'epi-judge-execute)

;; Private/Local Packages
(eval-when-compile
  (setq spotify-path "~/.emacs.d/private-packages/spotify.el")
  (add-to-list 'load-path spotify-path)
  (require 'spotify))

(defun prompt-spotify-oauth-credentials (client-id client-secret)
  "Setup the user's Spotify to use within emacs. Depends on `spotify.el'"
  (interactive "sEnter your Client ID for Spotify: \nsEnter your Client Secret for Spotify: ")
  (customize-save-variable 'spotify-oauth2-client-id client-id)
  (customize-save-variable 'spotify-oauth2-client-secret client-secret))

(when (and (featurep 'spotify)
           (eq spotify-oauth2-client-id "")
           (eq spotify-oauth2-client-secret ""))
  (call-interactively #'prompt-spotify-oauth-credentials))

(use-package spotify
  :bind (:map spotify-mode-map
              ("C-c ." . spotify-command-map))
  :config
  (setq spotify-helm-integration 1)
  (global-spotify-remote-mode 1))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                                        Initial window setup                                    ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun initialize-screen ()
  " Sets up buffers & windows upon loading "
  (split-window-right)
  (other-window 1)
  (find-file "~/.emacs.d/init.el")
  (other-window 1)
  (find-file "~/todo.org"))

(initialize-screen)

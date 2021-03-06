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

;; Default frame parameters
(add-to-list 'default-frame-alist '(fullscreen . maximized))

(global-set-key (kbd "C-c f") 'toggle-frame-fullscreen)

;; Hide unused GUI features to gain more screen pixels
(tool-bar-mode   -1)  ; Remove the large Word-like editing icons at the top
(scroll-bar-mode -1)  ; Remove visual scroll bar & rely on modeline buffer percentage
(menu-bar-mode   -1)  ; Remove the large Mac OS top pane menu options

(setq display-time-day-and-date t)
(setq display-time-24hr-format t)
(setq display-time-default-load-average nil)
(setq inhibit-startup-message t)
(setq async-shell-command-display-buffer nil)                              ; No async pop-ups
(setq visual-line-fringe-indicators '(left-curly-arrow right-curly-arrow)) ; Soft wrap lines

(global-visual-line-mode 1)
(display-battery-mode 1)
(display-time-mode 1)
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
(global-set-key (kbd "s-/") 'comment-dwim)
(global-set-key (kbd "C-j") (lambda () (interactive) (join-line -1))) ; Vim's join line

;; Buffer formatting
(setq column-number-mode t)
(setq size-indication-mode t)
(setq echo-keystrokes .1)

(setq-default truncate-lines nil                  ; Disable horizontal scroll
              indent-tabs-mode nil)               ; Use spaces instead of tabs

(defun setup-autofill (fill-value)
  "Initializes fill column, draws ruler & hard wraps on newline"
  (interactive)
  (setq fill-column fill-value)
  (auto-fill-mode 1)
  (unless (string-equal major-mode "org-mode")
    (display-fill-column-indicator-mode)))

(add-hook 'before-save-hook 'whitespace-cleanup)
(add-hook 'prog-mode-hook (lambda () (setup-autofill 80)))
(add-hook 'text-mode-hook (lambda () (setup-autofill 80)))
(add-hook 'emacs-lisp-mode-hook (lambda () (setup-autofill 100)))

;; Visual Styling - Doom theme
(use-package all-the-icons)
(use-package doom-modeline
  :ensure t
  :config
  (setq doom-modeline-modal-icon nil)
  (doom-modeline-mode 1))
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

;; Auto-completion
(use-package company
  :hook (prog-mode . company-mode)
  :bind (:map company-active-map
              ("C-p" . company-select-previous)
              ("C-n" . company-select-next)
              ("<tab>" . company-complete-selection)
              ("TAB" . company-complete-selection))
  :config
  (setq company-selection-wrap-around t))

(use-package page-break-lines
  :init
  (global-page-break-lines-mode 1))

(use-package expand-region
  :bind ("C-=" . er/expand-region))

(use-package undo-tree
  :config
  (setq undo-tree-visualizer-timestamps t) ; Each node in the undo tree should have a timestamp
  (setq undo-tree-visualizer-diff t)       ; Show diff window displaying changes between undo nodes
  (global-undo-tree-mode))                 ; Enable simple redo key & undo tree graph

(use-package flycheck
  :init (global-flycheck-mode)
  :config
  (setq-default flycheck-disabled-checkers '(emacs-lisp-checkdoc))
  (add-hook 'c++-mode-hook
            (lambda () (setq flycheck-clang-language-standard "c++17"))))

(use-package yasnippet-snippets
  :config
  (yas-reload-all)
  (setq yas-triggers-in-field t)
  (yas-global-mode 1))

(use-package  string-inflection
  :after helm
  :bind (("C-c C-u" . string-inflection-all-cycle)
         :map helm-map
         ("C-c C-u" . string-inflection-all-cycle)))

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
  :bind (("C-x m" . helm-M-x)
         ("C-x b" . helm-mini)
         ("C-x C-f" . helm-find-files)
         ("C-x r b" . helm-filtered-bookmarks)
         ("C-h b" . helm-descbinds)
         ("C-h d" . helm-apropos)
         ("C-c i" . helm-imenu)
         ("M-y" . helm-show-kill-ring)
         :map helm-map
         ("C-w" . backward-kill-word)
         ("TAB" . helm-execute-persistent-action)
         ("<tab>" . helm-execute-persistent-action)
         ("C-z" . helm-select-action)))

(use-package helm-swoop
  :bind ("M-s" . helm-swoop)
  :config
  (setq helm-swoop-split-direction 'split-window-horizontally)
  (setq helm-swoop-pre-input-function
        (lambda ()                      ; Use marked region as query if selected
          (if mark-active
              (buffer-substring-no-properties (mark) (point))
            ""))))

;; Helm for projectile search
(use-package helm-projectile
  :config
  (helm-projectile-on))

;; Helm Ag for file search
(use-package helm-ag
  :bind ("C-c s" . helm-ag))

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
  :hook
  (org-mode . flyspell-mode)
  (org-mode . org-document-imenu-depth)
  (org-mode . (lambda () (company-mode -1)))
  (org-src-mode . org-toggle-src-content-indentation)
  :bind ("C-c c" . org-capture)
  :config
  ;; General settings
  (setq org-startup-folded t)
  (setq org-default-notes-file "~/todo.org")
  (setq org-todo-keywords '((sequence "TODO(t)" "IN-PROGRESS(i)" "REDO(r)" "|" "DONE(d)")))
  (setq org-ellipsis " ⤵")
  (setq org-return-follows-link t)
  (setq org-catch-invisible-edits 'show)
  (add-to-list 'org-link-frame-setup  '(file . find-file)) ; visit links in same window
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
  (setq org-babel-C++-compiler
        "g++ -std=c++17 -pthread -Werror -Wno-unused-variable -Wno-sign-compare -Wuninitialized")
  (setq org-babel-python-command "python3")
  (org-babel-do-load-languages          ; Languages supported for execution
   'org-babel-load-languages '((C          . t) ; Captial “C” gives access to C, C++, D
                               (java       . t)
                               (python     . t))))

(use-package org-bullets
  :hook (org-mode . org-bullets-mode))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                                           Evil Mode                                            ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package evil                       ; ',' -> leader key
  :init
  (setq evil-want-C-u-scroll t)         ; Override undo-tree with C-U when using evil mode
  (setq evil-want-C-u-delete t)
  :config
  (setq evil-insert-state-cursor nil    ; Default caret for insert & operator mode
        evil-operator-state-cursor nil
        evil-replace-state-cursor nil)
  (evil-set-undo-system 'undo-tree)
  (evil-set-leader 'normal (kbd ","))
  (evil-define-key 'normal 'global (kbd "<leader>ms") 'sync-make-current-file)
  (evil-define-key 'normal 'global (kbd "<leader>ma") 'async-make-current-file)
  (evil-define-key 'visual 'global (kbd ".s") 'sort-lines)
  (setq evil-complete-next-func 'company-select-next ; Use company over dabbrev for autocompletion
        evil-complete-previous-func 'company-select-previous))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                                     Development Configurations                                 ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package dockerfile-mode)
(use-package vimrc-mode)
(use-package yaml-mode)
(use-package gitignore-mode)
(use-package terraform-mode)
(use-package go-mode)

(use-package lsp-mode
  :commands lsp
  :hook ((c-mode . lsp)
         (c-or-c++-mode . lsp)
         (python-mode . lsp)
         (ruby-mode . lsp)
         (web-mode . lsp)
         (css-mode . lsp)
         (cmake-mode . lsp)
         (go-mode . lsp)
         (sh-mode . lsp)
         (dockerfile-mode . lsp)
         (yaml-mode . lsp)
         (terraform-mode . lsp)
         (vimrc-mode . lsp)
         (lsp-mode . lsp-enable-which-key-integration))
  :config
  (setq gc-cons-threshold 100000000)    ; 100MB GC threshold (value in bytes)
  (setq read-process-output-max (* 1024 1024)) ;; 1MB read threshold (value in bytes)
  (setq lsp-idle-delay 0.500)
  (setq lsp-keymap-prefix "s-l")
  (setq lsp-enable-symbol-highlighting nil)
  (setq lsp-headerline-breadcrumb-enable nil))

(use-package company-box
  :hook (company-mode . company-box-mode))

(use-package ccls
  ;; Remember the following:
  ;;   1. Build CCLS through CMake
  ;;   2. Initialize the 'ccls-executable' symbol into the custom files
  ;;   3. Copy paste any missing include files to the include directory used by ccls
  :hook ((c-mode c++-mode objc-mode cuda-mode) .
         (lambda () (require 'ccls) (lsp))))

(use-package lsp-ui
  :bind (("C-c j" . lsp-ui-doc-show)
         ("C-c l f" . lsp-ui-flycheck-list))
  :config
  (define-key lsp-ui-mode-map [remap js-find-symbol] #'lsp-ui-peek-find-definitions)
  (define-key lsp-ui-mode-map [remap xref-find-definitions] #'lsp-ui-peek-find-definitions)
  (define-key lsp-ui-mode-map [remap xref-find-references] #'lsp-ui-peek-find-references)
  (setq lsp-ui-doc-enable nil)
  (setq lsp-ui-doc-include-signature t)
  (setq lsp-ui-doc-position 'at-point))

(use-package helm-lsp
  :bind ([remap xref-find-apropos] . helm-lsp-workspace-symbol)
  :commands helm-lsp-workspace-symbol)

(use-package lsp-pyright
  :ensure t
  :hook (python-mode . (lambda () (require 'lsp-pyright) (lsp)))) ; or lsp-deferred

(use-package py-autopep8
  :hook
  (python-mode . py-autopep8-enable-on-save))

(use-package py-isort
  :after python
  :hook ((python-mode . pyvenv-mode)
         (before-save . py-isort-before-save)))

(use-package pyvenv
  :after python
  :bind (("C-c 1 w" . pyvenv-workon)
         ("C-c 1 c" . pyvenv-create)
         ("C-c 1 d" . pyvenv-deactivate))
  :hook (python-mode . pyvenv-mode)
  :custom
  (pyvenv-default-virtual-env-name "env")
  (pyvenv-mode-line-indicator '(pyvenv-virtual-env-name ("[venv:\""
                                                         pyvenv-virtual-env-name "\"]")))
  :config
  (add-hook 'pyvenv-post-create-hooks 'save-and-reload-buffer)
  (add-hook 'pyvenv-post-activate-hooks 'save-and-reload-buffer)
  (add-hook 'pyvenv-post-deactivate-hooks 'save-and-reload-buffer))

(use-package web-mode
  :ensure t
  :mode (("\\.js\\'" . web-mode)
           ("\\.jsx\\'" . web-mode)
           ("\\.ts\\'" . web-mode)
           ("\\.tsx\\'" . web-mode)
           ("\\.html\\'" . web-mode)
           ("\\.vue\\'" . web-mode)
           ("\\.json\\'" . web-mode))
  :commands web-mode
  :config
  (setq company-tooltip-align-annotations t)
  (setq web-mode-markup-indent-offset 2)
  (setq web-mode-css-indent-offset 2)
  (setq web-mode-code-indent-offset 2)
  (setq web-mode-enable-part-face t)
  (setq web-mode-content-types-alist
          '(("jsx" . "\\.js[x]?\\'"))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                                                Misc                                            ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun shuffle-array (start end)
  "Shuffle elements of an array into a new permutation with PRNG (use without enclosing delimiters)"
  (interactive "r\n")
  (let* ((str (buffer-substring-no-properties start end))
         (arr (split-string-and-unquote str "[,\s]+"))
         (n (length arr)))
    (dotimes (i n)
      (let* ((num-of-candidates (- n i))
             (value (random num-of-candidates))
             (idx (+ i value))
             (i-copy (elt arr i)))
        (setf (nth i arr) (nth idx arr))
        (setf (nth idx arr) i-copy)))
    (delete-region start end)
    (insert (mapconcat (lambda (x) x) arr ", "))))

(defun copy-relative-path ()
  "Copies the relative path into the clipboard from the root of the projectile if it exists"
  (interactive)
  (let ((path (file-relative-name buffer-file-name (projectile-project-root))))
    (with-temp-buffer
      (insert path)
      (clipboard-kill-region (point-min) (point-max)))))

(defun copy-current-path ()
  "Copies the current path of the buffer into the clipboard"
  (interactive)
  (let ((path (buffer-file-name)))
    (with-temp-buffer
      (insert path)
      (clipboard-kill-region (point-min) (point-max)))))

(defun move-to-column-force (column)
  "Go to column number, adding whitespaces if necessary"
  (interactive "nColumn: ")
  (move-to-column column t))

(global-set-key (kbd "M-g TAB") 'move-to-column-force)
(global-set-key (kbd "C-c 2 c") 'copy-current-path)
(global-set-key (kbd "C-c 2 r") 'copy-relative-path)

(defun save-and-reload-buffer ()
  "Saves & reloads buffer to update environment values in the modeline or reload the LSP client
through hooks"
  (save-buffer)
  (revert-buffer :ignore-auto :noconfirm))

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

(defun org-toggle-src-content-indentation ()
  "Toggle indentation settings between editing & exporting code blocks"
  (interactive)
  (setq org-src-preserve-indentation nil)
  (setq org-edit-src-content-indentation 0)
  (setq org-src-ask-before-returning-to-edit-buffer nil))

(defun org-document-imenu-depth ()
  "Set imenu depth for helm to use for specific org mode documents"
  (interactive)
  (when (and (string-equal major-mode "org-mode") (buffer-file-name))
    (cond ((or (string-equal (file-name-base) "cpp_reference_list")
               (string-equal (file-name-base) "python_reference_list"))
           (setq org-imenu-depth 3))
          (t
           (setq org-imenu-depth 2)))))

(defun org-update-last-edit-timestamp ()
  "Updates the date header in a org document"
  (interactive)
  (when (string-equal major-mode "org-mode")
    (save-excursion
      (goto-char (point-min))
      (setq org-date-pattern "#\\+DATE: \\(.*\\) (last updated)")
      (setq current-timestamp (string-trim-right (shell-command-to-string "date")))
      (if (re-search-forward org-date-pattern nil t 1)
          (replace-match (format "#+DATE: %s (last updated)" current-timestamp))))))

(add-hook 'before-save-hook 'org-update-last-edit-timestamp)

(defcustom projectile-evil-mode-cache nil
  "List of cached projects last used during evil-mode"
  :type 'list
  :group 'projectile)

(define-minor-mode custom-evil-mode
  "Toggle customized settings between default emacs & vim (evil)"
  :lighter custom-evil-mode
  (evil-local-mode (if custom-evil-mode t -1))
  (setq-local display-line-numbers (when custom-evil-mode 'relative)))

(defun toggle-evil-interactive ()
  "Toggles customized evil mode with persistent settings for projects under projectile"
  (interactive)
  (if custom-evil-mode
      (custom-evil-mode 0)
    (custom-evil-mode 1))
  (when (not (string-equal (projectile-project-name) "-")) ; cache projectile settings
    (if (member (projectile-project-name) projectile-evil-mode-cache)
        (customize-save-variable 'projectile-evil-mode-cache
                                 (delete (projectile-project-name)
                                         projectile-evil-mode-cache))
      (customize-save-variable 'projectile-evil-mode-cache
                               (add-to-list 'projectile-evil-mode-cache
                                            (projectile-project-name))))))

(add-hook 'prog-mode-hook (lambda ()
                            (when (member (projectile-project-name) projectile-evil-mode-cache)
                              (custom-evil-mode))))

(define-key prog-mode-map (kbd "C-c v") 'toggle-evil-interactive)
(define-key prog-mode-map (kbd "C-c C-q") 'apply-macro-to-region-lines)

(define-key lisp-interaction-mode-map (kbd "C-j") nil) ;; use vim join line from global map

(define-minor-mode algorithm-mode
  "Toggle mode for practicing coding problems or algorithms"
  :lighter algorithm-mode
  (company-mode (if algorithm-mode 0 1))
  (flymake-mode (if algorithm-mode 0 1))
  (flycheck-mode (if algorithm-mode 0 1)))

(defun practice-config ()
  "Turn off syntax checking & auto-completion for practice purposes"
  (setq selected-files '("codeforces" "leetcode" "atcoder"))
  (when (or (string-equal (projectile-project-name) "EPIJudge")
            (and (buffer-file-name)
                 (member (file-name-base (buffer-file-name)) selected-files)))
    (algorithm-mode)))

(add-hook 'c++-mode-hook 'practice-config)
(add-hook 'python-mode-hook 'practice-config)

(defun get-executable-command ()
  "Modify command to appropriate make command for Python & C++ "
  (cond ((string-equal major-mode "c++-mode")
         (if (string-equal (projectile-project-name) "EPIJudge")
             (format "make %s" (file-name-base))
           (format "make %s -C build && build/%s" (file-name-base) (file-name-base))))
        ((string-equal major-mode "python-mode")
         (format "python3 %s.py" (file-name-base)))
        (t nil)))

(defun sync-make-current-file (&optional split-window)
  "Execute Makefile or run the current file synchronously"
  (interactive "P")
  (when-let ((command (get-executable-command)))
    (if split-window
        (save-excursion
          (shell-command command)
          (pop-to-buffer "*Shell Command Output*")
          (help-mode)
          (goto-char (point-max))
          (other-window -1))
      (progn
        (save-window-excursion
          (shell-command command)
          (with-current-buffer "*Shell Command Output*" (help-mode)))
        (switch-to-buffer "*Shell Command Output*")
        (goto-char (point-max))))))

(defun async-make-current-file (&optional split-window)
  "Execute Makefile or run the current file asynchronously"
  (interactive "P")
  (when-let ((command (get-executable-command)))
    (async-shell-command command)
    (if split-window
        (pop-to-buffer "*Async Shell Command*")
      (switch-to-buffer "*Async Shell Command*"))
    (if (process-live-p (get-buffer-process (current-buffer)))
        (set-process-sentinel (get-buffer-process (current-buffer))
                              (lambda (process signal)
                                (when (memq (process-status process) '(exit signal))
                                  (help-mode)
                                  (shell-command-sentinel process signal))))
      (message "No async process running"))))

(with-eval-after-load 'cc-mode
  (define-key c++-mode-map (kbd "C-c m a") 'async-make-current-file)
  (define-key c++-mode-map (kbd "C-c m s") 'sync-make-current-file))
(with-eval-after-load 'python
  (define-key python-mode-map (kbd "C-c m a") 'async-make-current-file)
  (define-key python-mode-map (kbd "C-c m s") 'sync-make-current-file))

(defun cpp-auto-format ()
  "Format cpp buffer on each save, formatting lines of code"
  (interactive)
  (when (string-equal major-mode "c++-mode")
    (c-indent-region (point-min) (point-max)))
  (when (and (string-equal major-mode "org-mode")
             (org-in-src-block-p))
    (org-edit-special)
    (indent-region (point-min) (point-max))
    (org-edit-src-exit)))

(add-hook 'before-save-hook 'cpp-auto-format)

;; iTerm compatible-config (Note - Evil Mode doesn't work in terminal emacs)
(unless (display-graphic-p)
  (beacon-mode 0)
  (global-set-key (kbd "C-[ [ =") 'er/expand-region)
  (global-set-key (kbd "C-[ [ ?") 'undo-tree-redo)
  (org-defkey org-mode-map (kbd "C-[ [ ]") 'org-insert-heading-respect-content)
  (org-defkey org-mode-map (kbd "C-[ [ s ]") 'org-insert-todo-heading-respect-content)
  (org-defkey org-mode-map (kbd "C-[ [ 1 1") 'org-metaleft)
  (org-defkey org-mode-map (kbd "C-[ [ 1 2") 'org-metaup)
  (org-defkey org-mode-map (kbd "C-[ [ 1 3") 'org-metadown)
  (org-defkey org-mode-map (kbd "C-[ [ 1 4") 'org-metaright))

;; Private/Local Packages
(setq spotify-path "~/.emacs.d/private-packages/spotify.el")

(eval-when-compile
  (when (file-exists-p spotify-path)
    (add-to-list 'load-path spotify-path)
    (require 'spotify)))

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
  ;; Make sure to use local forked version with helm integration if it's still not merged to master"
  :bind
  (("C-c g s" . global-spotify-remote-mode)
   :map spotify-mode-map
              ("C-c ." . spotify-command-map)
              ("C-c . r" . spotify-recently-played))
  :config
  (global-spotify-remote-mode -1) ; Enabling will start a background server to handle the oath token
  (setq spotify-helm-integration 1))

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

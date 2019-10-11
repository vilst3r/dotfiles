(require 'package)

;; Configure registry to install packages
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
;; Load full screen on startup
(add-to-list 'default-frame-alist '(fullscreen . maximized))
;; Load at 85% transparency on startup
(set-frame-parameter (selected-frame) 'alpha '(85 . 75))

;; Activate all installed packages
(package-initialize)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;asdfasdfasdf
;; Baseline configuration

;; GUI features
(setq visible-bell t)
(setq inhibit-startup-message t) 
(mouse-avoidance-mode 'animate)

;; Visual Styling
(load-theme 'doom-city-lights t)
(doom-modeline-mode 1)

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

;; Add transparency toggle
(setq transparency_level 0)
(defun my:change_transparency ()
  "Toggles transparency of Emacs between 3 settings (none, mild, moderate)."
  (interactive)
  (if (equal transparency_level 0)
      (progn (set-frame-parameter (selected-frame) 'alpha '(100 . 85))
	     (setq transparency_level 1))
    (if (equal transparency_level 1)
    (progn (set-frame-parameter (selected-frame) 'alpha '(85 . 75))
	   (setq transparency_level 0))
    )))
(define-key global-map (kbd "C-c t") 'my:change_transparency)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Evil
(add-to-list 'load-path "~/.emacs.d/evil")
(require 'evil)
(evil-mode 1)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Helm

(require 'helm-config)

(global-set-key (kbd "C-x b") 'helm-buffers-list)
(global-set-key (kbd "C-x r b") 'helm-bookmarks)
(global-set-key (kbd "C-x m") 'helm-M-x)
(global-set-key (kbd "C-x C-f") 'helm-find-files)
(global-set-key (kbd "C-h b") 'helm-descbinds)

(global-set-key (kbd "M-y") 'helm-show-kill-ring)

(with-eval-after-load 'helm
  (define-key helm-map (kbd "<tab>") 'helm-execute-persistent-action))
  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Org

(setq org-todo-keywords
  '((sequence "TODO" "IN-PROGRESS" "WAITING" "REDO" "REVIEW-SOLUTION" "DONE")))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; State of configuration of packages
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(org-export-backends (quote (ascii html icalendar latex md odt)))
 '(package-selected-packages
   (quote
    (doom-modeline helm-descbinds magit helm gruvbox-theme doom-themes))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;; Set up package.el to work with MELPA
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)

(add-to-list 'load-path "~/.emacs.d/plugins")
(require 'evil-leader)
(global-evil-leader-mode)
(evil-leader/set-leader "<SPC>")
(evil-leader/set-key "e" 'find-file)

(menu-bar-mode 0)
(tool-bar-mode 0)

;; Download Evil
(unless (package-installed-p 'evil)
  (package-install 'evil))

;; Enable Evil
(require 'evil)
(evil-mode 1)

;;(load-theme 'catppuccin :no-confirm)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(telephone-line darkokai-theme evil)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(load-theme 'darkokai t)

(global-display-line-numbers-mode 1)
(setq display-line-numbers-type 'relative)

(unless (package-installed-p 'telephone-line)
  (package-install 'telephone-line))

(unless (package-installed-p 'magit)
  (package-install 'magit))

(require 'telephone-line)
(telephone-line-mode 1)

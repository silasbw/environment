;; .emacs

;;; uncomment this line to disable loading of "default.el" at startup
;;(setq inhibit-default-init t)

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

;; aligns annotation to the right hand side
(setq company-tooltip-align-annotations t)

;; formats the buffer before saving
(add-hook 'before-save-hook 'tide-format-before-save)

(add-hook 'typescript-mode-hook #'setup-tide-mode)

;; turn on font-lock mode
(when (fboundp 'global-font-lock-mode)
  (global-font-lock-mode t))

;; enable visual feedback on selections
;(setq transient-mark-mode t)

(add-to-list 'load-path "~/.emacs.d/el-get/el-get")

(add-to-list 'load-path "~/.emacs.d/vendor")
(require 'mustache-mode)

;(add-to-list 'load-path "~/.emacs.d/elpa/mustache-mode-1.3")
;(require 'mustache-mode)

(unless (require 'el-get nil 'noerror)
  (with-current-buffer
      (url-retrieve-synchronously
       "https://raw.githubusercontent.com/dimitri/el-get/master/el-get-install.el")
    (goto-char (point-max))
    (eval-print-last-sexp)))

(add-to-list 'el-get-recipe-path "~/.emacs.d/el-get-user/recipes")
(el-get 'sync)

;; default to better frame titles
(setq frame-title-format
      (concat  "%b - emacs@" system-name))

;; default to unified diffs
(setq diff-switches "-u")

;; tab, indent
(setq c-basic-offset 2)
(setq tab-width 2)
(setq-default indent-tabs-mode nil)
(setq indent-tabs-mode nil)

(setq make-backup-files nil)
(menu-bar-mode -1)
(setq scroll-step 1)

;;(set-foreground-color "lightgrey")
;;(set-background-color "black")

;;(defun forward-ten
;;  "move forward ten lines"
;;  (interactive)
;;  (forward-line 10))

;; keymap
(global-set-key "\C-xl" 'goto-line)
(global-set-key "\C-xj" 'compile)

;;(setq compile-command "make -C /home/sbw/linux.ar O=obj/ -j2")
;;(setq compile-command "make -C /home/sbw/linux-2.6/ud")
;;(setq compilation-read-command nil)

(defun match-paren (arg)
  "Go to the matching paren if on a paren"
  (interactive "p")
  (cond ((looking-at "\\s\(") (forward-list 1) (backward-char 1))
	((looking-at "\\s\)") (forward-char 1) (backward-list 1))
	(t (message "no paren under cursor"))))

(defun forward-open-curly ()
  (interactive)
  (forward-char) (search-forward "{" nil t) (backward-char))
(defun forward-closed-curly ()
  (interactive)
  (forward-char) (search-forward "}" nil t) (backward-char))
(defun backward-open-curly ()
  (interactive)
  (backward-char) 
  (if (equal nil (search-backward "{" nil t))
      (forward-char)))
(defun backward-closed-curly ()
  (interactive)
  (backward-char) 
  (if (equal nil (search-backward "}" nil t))
      (forward-char)))

;;;;
;; navigation 
;;;;
;; based on xterm, C-q then a key gives you char
(global-set-key "\e[1;5A" 'backward-paragraph) ;; C-up
(global-set-key "\e[1;5B" 'forward-paragraph) ;; C-down
(global-set-key "\e[1;5C" 'forward-word) ;; C-right
(global-set-key "\e[1;5D" 'backward-word) ;; C-left

(global-set-key [f12] 'match-paren)
(global-set-key "\e[1;5H" 'backward-open-curly) ;; C-home
(global-set-key "\e[5;5~" 'backward-closed-curly) ;; C-pageup
(global-set-key "\e[1;5F" 'forward-open-curly) ;; C-pageup
(global-set-key "\e[6;5~" 'forward-closed-curly) ;; C-pageup

(global-set-key [f11] 'indent-relative)

;; Some spacing rules
(c-set-offset 'innamespace nil)



;;(global-hl-line-mode 1)
;;(set-face-background 'hl-line "Green")

(setq column-number-mode 1)

(add-hook 'text-mode-hook 'turn-on-auto-fill)

(defun c-lineup-arglist-tabs-only (ignored)
  "Line up argument lists by tabs, not spaces"
  (let* ((anchor (c-langelem-pos c-syntactic-element))
         (column (c-langelem-2nd-pos c-syntactic-element))
         (offset (- (1+ column) anchor))
         (steps (floor offset c-basic-offset)))
    (* (max steps 1)
       c-basic-offset)))

(add-hook 'c-mode-common-hook
          (lambda ()
            ;; Add kernel style
            (c-add-style
             "linux-tabs-only"
             '("linux" (c-offsets-alist
                        (arglist-cont-nonempty
                         c-lineup-gcc-asm-reg
                         c-lineup-arglist))))))
;                         c-lineup-arglist-tabs-only))))))

(add-hook 'c-mode-hook
          (lambda ()
            (let ((filename (buffer-file-name)))
              ;; Enable kernel mode for the appropriate files
              (when (and filename
                         (string-match (expand-file-name "~/linux")
                                       filename))
                (setq indent-tabs-mode t)
                (setq c-basic-offset 8)
                (setq show-trailing-whitespace t)
                (c-set-style "linux-tabs-only")))))

(defun linux-c-mode ()
  "C mode with adjusted defaults for use with the Linux kernel."
  (interactive)
  (c-mode)
  (setq indent-tabs-mode t)
  (setq c-basic-offset 8)
  (setq show-trailing-whitespace t)
  (c-set-style "linux-tabs-only"))

(defun xv6-c-mode ()
  "C mode with adjusted defaults for use with xv6."
  (interactive)
  (c-mode)
  (c-set-style "K&R")
  (setq c-basic-offset 2))

(defun sbw-c++-mode ()
  "Linux-like C++ mode."
  (interactive)
  (c++-mode)
  (setq c-basic-offset 4))

(defun xv6-c++-mode ()
  "C++ mode with adjusted defaults for use with xv6."
  (interactive)
  (c++-mode)
  (c-set-style "K&R")
  (setq c-basic-offset 2))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(auto-compression-mode t nil (jka-compr))
 '(case-fold-search t)
 '(current-language-environment "UTF-8")
 '(default-input-method "rfc1345")
 '(global-font-lock-mode t nil (font-lock))
 '(inhibit-startup-screen t)
 '(package-selected-packages
   (quote
    (yaml-mode company-tern tern js2-mode go-mode groovy-mode)))
 '(show-paren-mode t nil (paren))
 '(transient-mark-mode t))

(setq show-trailing-whitespace t)

(add-to-list 'auto-mode-alist '("\\.y\\'" . text-mode))

(add-hook 'python-mode-hook '(lambda ()
                               (setq python-indent 4)))

(setq js-indent-level 2)
(setq typescript-indent-level 4)
(setq groovy-indent-offset 2)

(add-to-list 'auto-mode-alist '("\\.jsx\\'" . jsx-mode))
(autoload 'jsx-mode "jsx-mode" "JSX mode" t)

;; go mode
;; (add-to-list 'load-path "~/.emacs.d" t)
;; (require 'go-mode-load)

(require 'package)
(add-to-list 'package-archives
             '("melpa-stable" . "https://stable.melpa.org/packages/") t)
(package-initialize)
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(require 'js2-mode)
(add-to-list 'auto-mode-alist '("\\.js\\'" . js2-mode))
(add-hook 'js2-mode-hook #'js2-imenu-extras-mode)
(require 'company)
(require 'company-tern)
(add-to-list 'company-backends 'company-tern)
(add-hook 'js2-mode-hook (lambda ()
                           (tern-mode)
                           (company-mode)))
(setq js2-strict-missing-semi-warning nil)

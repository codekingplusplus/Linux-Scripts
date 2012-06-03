;;-------------------------------------------------;;
;; This is my current emacs file, feel free to use ;;
;;    and edit for your own use.                   ;;
;;                                                 ;;
;; David Medina                                    ;;
;;-------------------------------------------------;;

;;---------------------;;
;;     REQUIREMENTS    ;;
;;---------------------;;

;; Add directory for libararies
(add-to-list 'load-path "~/.emacs.d/libraries")
(add-to-list 'load-path "~/.latex/")

;;---------------------;;
;;    CUSTOMIZATION    ;;
;;---------------------;;

;; Send me straight to *scratch* when loading emacs
(setq inhibit-startup-message t)

;; Color-code stuff
(global-font-lock-mode t)

;; Get rid of menu bar
(menu-bar-mode 0)

;; Stop making backup files
(setq make-backup-files nil)

;; Stop selected region highlight
(transient-mark-mode 0)

;; Change C-x b look
(iswitchb-mode 1)

;; Change yes-or-no --> y-or-n
(fset 'yes-or-no-p 'y-or-n-p)

;; Set Linum-Mode on
(global-linum-mode t)

;; Linum-Mode and add space after #
(setq linum-format "%d ")

;; Suppress symbolic link warning
(setq find-file-visit-truename t)

;;---------------------;;
;;        LATEX        ;;
;;---------------------;;

(require 'tex-site)

(defcustom TeX-macro-global '("~/.latex/") 
"Directories for style files"
:group 'TeX-file
:type '(repeat (directory :format "%v")))

;;---------------------;;
;;    WINDOW-SYSTEM    ;;
;;---------------------;;

(if window-system
    (progn
      (tool-bar-mode 0)
      (scroll-bar-mode 0)

  ;;-----------------;;
  ;;   Color-Theme   ;;
  ;;-----------------;;

      (defun current-theme ()
	(interactive)
	(color-theme-install
	 '(current-theme
	   ((background-color . "#21374f")
	    (background-mode . dark)
	    (border-color . "#3b566d")
	    (cursor-color . "#c9c8c0")
	    (foreground-color . "#ffffff")
	    (mouse-color . "black"))
	   (fringe ((t (:background "#3b566d"))))
	   (mode-line ((t (:foreground "#2c4654" :background "#cccccc"))))
	   (region ((t (:background "#255283"))))
	   (font-lock-builtin-face ((t (:foreground "#67bbd0"))))
	   (font-lock-comment-face ((t (:foreground "#8ddd83"))))
	   (font-lock-function-name-face ((t (:foreground "#5ccde0"))))
	   (font-lock-keyword-face ((t (:foreground "#8bb9ea"))))
	   (font-lock-string-face ((t (:foreground "#c76b74"))))
	   (font-lock-type-face ((t (:foreground"#6cd5af"))))
	   (font-lock-variable-name-face ((t (:foreground "#dfde72"))))
	   (minibuffer-prompt ((t (:foreground "#77bdc5" :bold t))))
	   (font-lock-warning-face ((t (:foreground "Blue" :bold t))))
	   )))
      (provide 'current-theme)
      (require 'color-theme)
      (color-theme-initialize)
      (current-theme)))

;;---------------------;;
;;      MODE-LINE      ;;
;;---------------------;;

;; Get rid of the old mode-line and replace with a more informative and organized mode-line
(setq-default mode-line-format 
   (list      
      " -- "    

      ;; Modified shows *      
      "[" 
      '(:eval 
	(if (buffer-modified-p) 
	    "*"
	    (if buffer-read-only
		"!"
		" "
	    )))
      "] "
  
      ;; Buffer (tooltip - file name)
      '(:eval (propertize "%b" 'face 'bold 'help-echo (buffer-file-name)))
  

      " "
  
      ;; Spaces 20 - "buffer"
      '(:eval
        (make-string
         (- 20
  	  (min
  	     20
  	     (length (buffer-name))))
        ?-))
  
    " "
      ;; Current (row,column)
    "("(propertize "%01l") "," (propertize "%01c") ") "
  
      ;; Spaces 7 - "(r,c)"
      '(:eval
        (make-string
         (- 7
  	  (min
  	     4
  	     (length (number-to-string (current-column)))
  	  )
  	  (min
  	     3
  	     (length (number-to-string (1+ (count-lines 1 (point)))))))
        ?-))
  
      ;; Percentage of file traversed (current line/total lines)
      " [" 
      '(:eval (number-to-string (/ (* (1+ (count-lines 1 (point))) 100) (count-lines 1 (point-max)))) )
      "%%] "
  
      ;; Spaces 4 - %
      '(:eval 
        (make-string
         (- 4 (length (number-to-string (/ (* (count-lines 1 (point)) 100) (count-lines 1 (point-max))))))
        ?-))
  
      ;; Major Mode
      " [" '(:eval mode-name) "] "      
  
      ;; Spaces 18 - %
      '(:eval
        (make-string
         (- 18
  	  (min
  	     18
  	     (length mode-name)))
        ?-))
      
      " ("

      ;; Time
      '(:eval (propertize (format-time-string "%H:%M")
  			'help-echo
  			(concat (format-time-string "%c; ")
  				(emacs-uptime "Uptime:%hh"))))
  
      ;; Fill with '-'
      ")"

      ;; Spaces 13 - Battery info
      (if (string= (user-full-name) "root") " --- [SUDO]")
      " %-" 
      ))

;;---------------------;;
;;        MODES        ;;
;;---------------------;;

;; Matlab Mode
(autoload 'matlab-mode "matlab" "Matlab Editing Mode" 1)
(add-to-list
 'auto-mode-alist
 '("\\.m$" . matlab-mode))
(setq matlab-indent-function nil)
(setq matlab-shell-command "matlab")

;; Bash Mode
(add-to-list
 'auto-mode-alist
 '(".bashrc" . shell-script-mode))
(add-to-list
 'auto-mode-alist
 '(".muttrc" . shell-script-mode))

;; Lisp Mode
(add-to-list
 'auto-mode-alist
 '(".emacs" . lisp-mode))

;; Python Mode
(add-to-list
 'auto-mode-alist
 '(".py" . python-mode))

;; C Mode
(add-to-list
 'auto-mode-alist
 '(".gmsh" . c-mode))
(add-to-list
 'auto-mode-alist
 '(".cu" . c-mode))
(add-to-list
 'auto-mode-alist
 '(".cl" . c-mode))
;;---------------------;;
;;       ORG-MODE      ;;
;;---------------------;;

(if (string= (system-name) "Yuuta")
    (progn
      (setq org-agenda-files (file-expand-wildcards "~/.emacs.d/libraries/orgAgendaFiles/*.org"))
      (require 'edit-server)
      (edit-server-start)
    )
)

;;---------------------;;
;;      SHORTCUTS      ;;
;;---------------------;;

;; Indent Region
(global-set-key (kbd "C-c i") 'indent-region)

;; Goto-line
(global-set-key (kbd "C-c g") 'goto-line)

;; Query-replace
(global-set-key (kbd "C-q") 'query-replace)
(global-set-key (kbd "C-c q") 'query-replace-regexp)

;; Search Regexp
(global-set-key (kbd "C-s") 'isearch-forward)
(global-set-key (kbd "C-r") 'isearch-backward)
(global-set-key (kbd "C-c s") 'isearch-forward-regexp)
(global-set-key (kbd "C-c r") 'isearch-backward-regexp)

;; Comment/Uncomment region
(global-set-key (kbd "C-c n") 'comment-region)
(global-set-key (kbd "C-c m") 'uncomment-region)

;; Macro
(global-set-key (kbd "C-c o") 'start-kbd-macro)
(global-set-key (kbd "C-c p") 'end-kbd-macro)
(global-set-key (kbd "C-z") 'call-last-kbd-macro)
;; Disable Create-Macro
(global-set-key (kbd "C-x C-k") 'kill-buffer)

;; Load-file
(global-set-key (kbd "C-c f") 'load-file)
(global-set-key (kbd "C-c C-f") 'load-file)

;; Linum-mode
(global-set-key (kbd "C-c l") 'linum-mode)

;; Run shell
(global-set-key (kbd "C-c C-v") 'shell)

(custom-set-faces
  ;; custom-set-faces was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(linum ((t (:inherit (shadow default) :foreground "orange")))))

;; Set iBuffer
(global-set-key (kbd "C-c b") 'ibuffer)
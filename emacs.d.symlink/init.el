(require 'package)
(push '("marmalade" . "http://marmalade-repo.org/packages/")
    package-archives )
(push '("melpa" . "http://melpa.milkbox.net/packages/")
    package-archives)

(setq package-list '(evil-org
                     evil-surround
                     powerline
                     powerline-evil
                     color-theme-sanityinc-solarized
                     org-ref
                     sbt-mode
                     scala-mode))

(package-initialize)

(unless package-archive-contents
  (package-refresh-contents))

(dolist (package package-list)
  (unless (package-installed-p package)
    (package-install package)))

(evil-mode 1)
(require 'evil-leader)
(setq evil-leader/in-all-states t)
(evil-leader/set-leader ",")
(evil-mode nil)
(global-evil-leader-mode 1)
(evil-mode 1)
(require 'evil-surround)
(global-evil-surround-mode 1)

(require 'powerline)
(powerline-default-theme)
(require 'powerline-evil)

(require 'color-theme-sanityinc-solarized)
(color-theme-sanityinc-solarized--define-theme dark)

(menu-bar-mode -1)
(toggle-scroll-bar -1)
(tool-bar-mode -1)
;(setq org-latex-pdf-process 
;   "latexmk -pdflatex='lualatex -shell-escape -interaction nonstopmode' -pdf -f  %f")
 (setq org-latex-pdf-process
       '("pdflatex -interaction nonstopmode -output-directory %o %f" 
 	"bibtex %b"
 	"pdflatex -interaction nonstopmode -output-directory %o %f" 
 	"pdflatex -interaction nonstopmode -output-directory %o %f"))

(require 'org-ref)
(require 'org-ref-latex)
(require 'org-ref-pdf)
(require 'org-ref-url-utils)
(require 'ox-latex)

(add-to-list 'org-latex-classes
             '("ieee"
               "\\documentclass[11pt,conference]{IEEEtran}"
               ("\\section{%s}" . "\\section*{%s}")
               ("\\subsection{%s}" . "\\subsection*{%s}")
               ("\\subsubsection{%s}" . "\\subsubsection*{%s}")))

(setq org-latex-listings 'listings)
(setq org-latex-listings-options
    '(("frame" "lines")
      ("basicstyle" "\\footnotesize\\ttfamily")
      ("numbers" "left")
      ("numberstyle" "\\tiny")))
(setq org-export-allow-bind-keywords "t")

(setq 
  inhibit-startup-message t
  create-lockfiles nil
  make-backup-files nil
  truncate-lines nil
  line-number-mode t
  column-number-mode t
  scroll-error-top-bottom t
  show-paren-delay 0.5
  use-package-always-ensure t
  sentence-end-double-space nil)
(setq-default
  indent-tabs-mode nil
  tab-with 4
  c-base-offset 4)
(fset 'yes-or-no-p 'y-or-n-p)
(when (fboundp 'toggle-scroll-bar)
  (toggle-scroll-bar -1))

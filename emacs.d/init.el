(load-theme 'tango-dark t)
(setq make-backup-files nil) ; no backup~ files
(setq auto-save-default nil) ; no #autosave# files
(menu-bar-mode -1) ; no menu bar
(toggle-scroll-bar -1) ; no scroll bar
(tool-bar-mode -1) ; no tool bar
(set-face-attribute 'default nil :font "DejaVu Sans Mono 10")
(electric-indent-mode +1)
(electric-pair-mode +1)
(global-linum-mode 1) ; line numbers
(column-number-mode 1) ; cursor position in footer
(global-visual-line-mode 1)
(show-paren-mode +1)
(setq show-paren-style 'expression)
(cua-mode) ; standard copy and paste
(delete-selection-mode 1) ; overwrite selection
(custom-set-variables
 '(inhibit-startup-screen t)) ; turn off startup screen

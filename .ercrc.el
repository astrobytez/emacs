;; This buffer is for text that is not saved, and for Lisp evaluation.
;; To create a file, visit it with C-x C-f and enter text in its buffer.

(require 'erc)
(require 'tls)
(require 'erc-spelling)
(require 'erc-goodies)

(erc-spelling-enable)
(erc-scrolltobottom-enable)

(setq erc-netsplit-show-server-mode-changes-flag t
	  erc-keywords '()
	  erc-current-nick-highlight-type 'nick
	  erc-pal-highlight-type 'nick
	  erc-pals '()
	  erc-fool-highlight-type 'all
	  erc-fools '("fsbot" "rudybot" "birny")
	  erc-dangerous-hosts '())

(erc-lurker-initialize)

(setq-default erc-ignore-list '())

(remove-hook 'erc-text-matched-hook #'erc-hide-fools)

(defmacro custom-erc-propertize (prompt)
  `(erc-propertize (format "%s>" ,prompt) 'read-only t 'rear-nonsticky t 'front-nonsticky t))

(defun custom-erc-prompt ()
  (if (and (boundp 'erc-default-recipients) (erc-default-target))
	  (custom-erc-propertize (erc-default-target))
	(custom-erc-propertize "ERC")))

(setq erc-nick "gingerbeer" ;;(getenv "USER")
	  erc-nick-uniquifier "_"
	  erc-server "irc.freenode.net"
	  erc-port 7000 ;; NOTE: `erc-tls' port (for ssl)
	  erc-user-full-name user-full-name
	  erc-email-userid user-mail-address
	  erc-format-nick-function 'erc-format-@nick
	  erc-current-nick-highlight-type 'all
	  erc-button-google-url "http://www.google.com/search?q=%s"
	  erc-timestamp-format "[%H:%M] "
	  erc-timestamp-right-column 61
	  erc-timestamp-only-if-changed-flag nil
	  erc-insert-timestamp-function 'erc-insert-timestamp-left
	  erc-track-showcount t
	  erc-track-exclude-server-buffer t
	  erc-track-exclude-types '("JOIN" "NICK" "PART" "QUIT" "MODE" "324" "329" "332" "333" "353" "477")
	  erc-kill-buffer-on-part t
	  erc-kill-queries-on-quit t
	  erc-kill-server-buffer-on-quit t
	  erc-interpret-mirc-color t
	  erc-hide-list '("JOIN" "NICK" "PART" "QUIT")
	  erc-lurker-hide-list '("JOIN" "NICK" "PART" "QUIT")
	  erc-mode-line-format "%t %a"
	  erc-header-line-format nil
	  erc-input-line-position -1
	  erc-max-buffer-size 20000
	  erc-truncate-buffer-on-save t
	  erc-remove-parsed-property nil
	  erc-prompt #'custom-erc-prompt
	  erc-join-buffer 'bury
	  erc-autojoin-channels-alist '((".*\\.freenode.net" "#emacs" "#clojure")))

(setq erc-modules (delq 'fill erc-modules))

(add-hook 'erc-insert-post-hook #'erc-truncate-buffer)
(add-hook 'erc-mode-hook #'turn-on-visual-line-mode)

(defun erc-tls-connect-server (server &rest junk)
  "Ask for a password before connecting to SERVER"
  (let ((password (read-passwd "Enter IRC Password: ")))
    (erc-tls :server server :port erc-port :nick erc-nick
             :password password)))

(defun erc-start-or-switch (&rest junk)
  "Connect to ERC, or switch to last active buffer"
  (interactive)
  (save-excursion
    (if (get-buffer "irc.freenode.net:7000")
		(erc-track-switch-buffer 1)
      (erc-tls-connect-server "irc.freenode.net"))))

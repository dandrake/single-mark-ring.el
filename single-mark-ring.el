;;; Emacs has two mark rings: a buffer-local one, and a global one. I
;;; always get confused with them; my mental model is that there ought to
;;; be just one mark ring. I want to implement that without trampling over
;;; the existing mark ring stuff. Here's a first draft at doing so: I just
;;; add a hook so that anytime the mark is set, we append to my own
;;; personal mark ring, and then I have a function that is basically a
;;; copy-and-paste of pop-to-mark-command.
;;;
;;; This is, right now, a prototype / proof of concept / rough draft
;;; that...seems to work? I am (1) stunned that it was so easy, and (2)
;;; suspcious that this ought to be unnecessary if I really understand the
;;; mark rings and used them correctly.
;;;
;;; Thanks to https://mathstodon.xyz/@vernon@emacs.ch for pushing me to
;;; try this; see
;;; https://mathstodon.xyz/@vernon@emacs.ch/109913166908490838 and my
;;; replies.
;;;
;;; sources, etc:
;;; https://www.math.utah.edu/docs/info/elisp_29.html
;;; https://www.discovering-emacs.com/2134279/12309075

(setq my-mark-ring ())

(defun my-activate-mark-hook ()
  "Hook function that pushes the current mark onto our mark ring."
  (let ((new-mark (point-marker)))
    (setq my-mark-ring (cons new-mark my-mark-ring))
    ))

(setq activate-mark-hook #'my-activate-mark-hook)

(defun my-pop-to-mark-command ()
  "Jump to mark, and pop a new position for mark off the ring."
  (interactive)
  (let ((the-mark (car my-mark-ring)))
    (if (null the-mark)
        (user-error "No mark set in my mark ring.")
      (if (= (point) the-mark)
          (message "Mark popped"))
      (switch-to-buffer (marker-buffer the-mark))
      (goto-char the-mark)
      (setq my-mark-ring (cdr my-mark-ring)))))

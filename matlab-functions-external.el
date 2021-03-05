(defun run-line-in-matlab-external ()
  (interactive)
  (save-window-excursion

  (async-shell-command
   (concat "mateval $'"
        (s-replace "'" "\\'" (buffer-substring-no-properties (line-beginning-position) (line-end-position)))
           "' &"))
  )
)

(defun run-region-in-matlab-external (b e)
  (interactive "r")
  (save-window-excursion
    (async-shell-command
      (concat "mateval $'" (s-replace  "'" "\\'" (buffer-substring-no-properties b e)) "' &"))

        ;(concat "mateval \'"
        ;        (replace-regexp-in-string (buffer-substring-no-properties b e) "'" "'\''")
        ;        "\' &"))
  )
)

(defun run-command-in-matlab-external (cmd)
  (interactive)
  (save-window-excursion

    (async-shell-command
     ;(concat "mateval \'" cmd "\' &"))
     (concat "mateval $'" (s-replace  "'" "\\'" cmd  "' &"))
    )
  )
)

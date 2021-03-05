;;; matlab-debug-external --- hacking the matlab debugger
;;; Commentary:

; TODO
;; faces
;; first in stack different face
;; test status (setting breakpoints
;; do stack
;; test stack
;; maybe send commands through tcp?

(require 'basic-functions)
(require 'bm) ;;; boomark+?

(defvar mat-status-file)
(defvar mat-stack-file)

(defvar mat-status-marks nil)
(defvar mat-status-hl)
(defvar mat-status-face)

(defvar mat-stack-marks nil)
(defvar mat-stack-hl)
(defvar mat-stack-face)

(setq mat-status-hl 'bm-highlght-line)
(setq mat-status-face) ; TODO
(setq mat-stack-hl 'bm-highlght-line)
(setq mat-stack-face) ; TODO

;;;;;;;
; for private use
(defvar mat-status-bm-current nil)
(defvar o-bm-current nil)
(defvar o-bm-face nil)
(defvar o-bm-hl nil)


;----------------------------------
; IPC

(defun db-create ()
  "Create TCP server for connection with matlab."
  (interactive)
  (make-network-process
              :name "dbMatlab"
              :buffer "*dbMatlab*"
              :server t
              :family 'ipv4
              :service 26097
              :local [127 0 0 1 26097]
              :sentinel 'db-listen-sentinel
              :filter 'db-listen-filter
  )
)
(defun db-kill ()
  "Kill TCP server."
  (interactive)
  (delete-process "dbMatlab")
 )

(defun db-listen-filter (proc string)
"Filter matlab callback STRING through server process PROC."
  (cond ((string= (substring string 0 1) "0") (db-update-status (substring string 2) 't))
        ((string= (substring string 0 1) "1") (db-update-stack  (substring string 2) 't))
  )

)

(defun db-listen-sentinel (proc msg)
  "Sentinal for using messages MSG from tcp connection PROC with matlab."
  (when (string= msg "connection broken by remote peer\n")
    (message (format "client %s has quit" proc)))
   ;TODO CLEAR ALL
 )

;----------------------------------

(defun db-step-line ()
"Run 'dbstep' in gui matlab and update in mark in Emacs."
  (interactive)
   (run-command-in-matlab-external "mydb.step(1);")
)
(defun db-step (nlines)
"Run 'dbstep NLINES' in gui matlab and update in mark in Emacs."
  (interactive)
   (run-command-in-matlab-external (concat "mydb.step(" nlines ");"))
)
(defun db-step-in ()
"Run 'dbstep in' in gui matlab and update in mark in Emacs."
  (interactive)
   (run-command-in-matlab-external "mydb.step_in(1);")
)
(defun db-step-out ()
"Run 'dbstep out' in gui matlab and update in mark in Emacs."
   (interactive)
   (run-command-in-matlab-external "mydb.step_out(1);")
)

(message (substring "abcd" 2))
;; CONT - STACK ONLY
(defun db-cont ()
"Run 'dbcont' in gui matlab and update in mark in Emacs."
  (interactive)
   (run-command-in-matlab-external "mydb.cont")
)

;; QUIT
(defun db-quit ()
"Run 'dquit' in gui matlab and update in mark in Emacs."
  (interactive)
   (run-command-in-matlab-external "mydb.quit();")
)
(defun db-quit-all ()
"Run 'dbquit all' in gui matlab and update in mark in Emacs."
  (interactive)
   (run-command-in-matlab-external "mydb.quit_all();")
)

;;STOP - STATUS ONLY
(defun db-stop-line(FILE LINE)
"Run 'dbstop in FILE at LINE' in gui matlab and update in mark in Emacs."
 (interactive)
  (run-command-in-matlab-external (concat "mydb.stop(" FILE "," LINE ");"))
)
(defun db-stop-cur-line()
"Run 'dbstop' for current line in gui matlab and update in mark in Emacs."
  (interactive)
  (dbstop-line (buffer-name) (line-number-at-pos))
)
(defun db-stop-if-warn()
"Run 'dbstop if warn' in gui matlab and update in mark in Emacs."
  (interactive)
  (run-command-in-matlab-external "mydb.stop_if_warn();")
)
(defun db-stop-if-warn-ID(ID)
"Run 'dbstop if warn ID' in gui matlab and update in mark in Emacs."
 (interactive)
 (run-command-in-matlab-external (concat "mydb.stop_if_warn(" ID ");"))
)
(defun db-stop-if-error()
"Run 'dbstop if error' in gui matlab and update in mark in Emacs."
 (interactive)
  (run-command-in-matlab-external "mydb.stop_if_error();")
)
(defun db-stop-if-error-ID(ID)
"Run 'dbstop if error ID' in gui matlab and update in mark in Emacs."
 (interactive)
  (run-command-in-matlab-external (concat "mydb.stop_if_error(" ID ");"))
)

;;CLEAR - STATUS ONLY
(defun db-clear-line(file line)
"Run 'dbclear in FILE at LINE' in gui matlab and update in mark in Emacs."
  (interactive)
  (run-command-in-matlab-external (concat "mydb.clear(" file "," line ");"))
)
(defun db-clear-line-if(file line expr)
"Run 'dbclear in FILE at LINE if EXPR' in gui matlab and update in mark in Emacs."
 (interactive)
  (run-command-in-matlab-external (concat "mydb.clear(" file "," line ", " expr ");"))
)
(defun db-clear-cur-line()
"Run 'dbclear' for current line in gui matlab and update in mark in Emacs."
  (interactive)
  (dbclear-line (buffer-name) (line-number-at-pos))
)
(defun db-clear-cur-line-if(expr)
"Run 'dbclear if EXPR' for current line in gui matlab and update in mark in Emacs."
  (interactive)
  (dbclear-line-if (buffer-name) (line-number-at-pos) expr)
)
(defun db-clear-if-warn()
"Run 'dbclear if warn' in gui matlab and update in mark in Emacs."
 (interactive)
 (run-command-in-matlab-external "mydb.clear_if_warn();")
 )
(defun db-clear-if-warn-ID(ID)
"Run 'dbclear if warn ID' in gui matlab and update in mark in Emacs."
  (interactive)
  (run-command-in-matlab-external (concat "mydb.clear_if_warn(" ID ");"))
)
(defun db-clear-if-error()
"Run 'dbclear if error' in gui matlab and update in mark in Emacs."
 (interactive)
 (run-command-in-matlab-external "mydb.clear_if_error();")
)
(defun db-clear-if-error-ID(ID)
"Run 'dbclear if error ID' in gui matlab and update in mark in Emacs."
  (interactive)
  (run-command-in-matlab-external (concat "mydb.clear_if_error(" ID ");"))
)
(defun db-clear-all()
"Run 'dbclear all' in gui matlab and update in mark in Emacs."
 (interactive)
 (run-command-in-matlab-external "mydb.clear_all()")
)

;; XXX UPDATE
;; OTHER
(defun db-up ()
"Run 'dbup' in gui matlab and update in mark in Emacs."
 (interactive)
 (run-command-in-matlab-external "mydb.up")
)
(defun db-down ()
"Run 'dbdown' in gui matlab and update in mark in Emacs."
  (interactive)
   (run-command-in-matlab-external "mydb.down")
)

;;---------------------------------------------------------
(defun db-go-top-stack ()
  ;; TODO
)
(defun db-go-bottom-stack ()
  ;; TODO
)
(defun db-go-up-stack ()
  ;; TODO
)
(defun db-go-down-stack ()
  ;; TODO
)
;;---------------------------------------------------------
;; STATUS
(defun db-update-status (msg)
"Read status output from matlab through tcp, encoded as MSG. Mark status in each open buffer."
   (setq buffs (buffer-list-string))
   (setq seen nil)
   (setq el)
   (db-bm-status-on)
   (save-current-buffer
     (do-list (el (split-string msg))
     ;(do-list (el (read-lines mat-status-file))
       (progn
         (setq elsplit (split-stirng el ","))
         (setq elitem (mapconcat 'identity (sublist elitem 1 3) ","))
         (add-to-list 'seen 'elitem)
         (if (and (member (nth elsplit 2) buffs) (not (member elitem mat-status-marks)))
             (progn
               (db-mark-status elitem)
               (add-to-list 'mat-status-marks 'elitem)))))
     (do-list (el mat-status-marks)
       (if (not (member el seen))
           (progn
             (db-unmark-status el)
             (delete el seen)))))
     (db-bm-status-off)
)
(defun db-mark-status (linelist)
"Mark status of line in file."
  ; 1 name
  ; 2 file
  ; 3 line
  (set-buffer (get-file-buffer (nth linelist 2))) ;;
  (bm-bookmark-line (nth linelist 3))
)
(defun db-bm-status-on ()
"Save current bm highlght, style, face and current. Change to status."
    (setq o-bm-hl 'bm-highlght-style)
    (setq o-bm-current 'bm-current)
    (setq o-bm-face 'bm-face)
    (setq bm-current 'mat-status-bm-current)
    (setq bm-highlight-style 'mat-status-hl)
    (setq bm-face 'mat-status-bm-face)
 )
(defun db-bm-status-off ()
"Restore bm sytel and current."
    (setq bm-current 'o-bm-current)
    (setq bm-highlight-style 'o-bm-hl)
    (setq bm-face 'o-bm-face)
    (setq o-bm-current nil)
    (setq o-bm-hl nil)
    (setq o-bm-face nil)
)
(defun db-unmark-status (linelist)
  (set-buffer (get-file-buffer (nth linelist 2)))
  (bm-bookmark-remove-line (bm-bookmark-at (nth lineliset 3)))
)


;------------------------------------------
;; STACK
; TODO



;; ------------------------
(defun bm-remove-bookmark-line (line)
  "Remove bookmark on the specified LINE."
  (interactive "nSet a bookmark on line: ")
  (let* ((here (point))
         (remaining (progn
                      (goto-char (point-min))
                      (forward-line (1- line)))))
    (if (zerop remaining)
        (bm-bookmark-remove)
      (message "Unable to set bookmark at line %d. Only %d lines in the buffer." line (- line remaining 1))
      (goto-char here))))

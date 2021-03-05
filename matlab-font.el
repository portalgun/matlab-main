;; TODO
;        builtin functions
;        transpose  -> disable background
;                   (font-lock-keywords-only t)?
;        Static,Hidden,Access=private

        ;diff, prod, sum, min, max, cumsum
        ;repmate,repelem
        ;unique, sort
        ;struct
        ;properties
        ;methods
        ; numbers in if statements
        ;
        ;
        ;vertcat horzcat cat
        ;all any
        ;copy
        ;varargin varargout nargout nargin nargchk nargoutchk
        ;logical int16 int32 int64 int8 uint... single, double, char
        ; is....
        ; b...
        ; round, fix, floor, ceil
        ; trig
        ; mod,abs, log, log10,log1p,log, exp
        ; pi, exp(1)
        ; reshape
        ; set get
        ; randi rand
        ; fieldnames, flds, fld[0-9]* (fld)
        ; ismember isequal strcmp
        ; transpose
        ; plot,imagesc,scatter
        ; L R B
        ; xor
        ; newline filesep
        ; @
        ; cellfun, arrayfun
;
;Gkkj

; font-lock-string-face
;(setq font-lock-string-face nil)
;; font lock
(defface font-lock-error-face `((t (:foreground "firebrick")))  "Red highlight")
(defvar font-lock-error-face 'font-lock-error-face
  "Variable for face font-lock-error-face.")

(defface font-lock-dg-face `((t (:foreground "dark slate gray")))  "dark green highlight")
(defvar font-lock-dg-face 'font-lock-dg-face
  "Variable for face font-lock-rg-face.")

(defface font-lock-db-face `((t (:foreground "dark slate blue")))  "dark blue highlight")
(defvar font-lock-db-face 'font-lock-db-face
  "Variable for face font-lock-rg-face.")

(defface font-lock-white-face `((t (:foreground "white")))  "white highlight")
(defvar font-lock-white-face 'font-lock-white-face
  "Variable for face font-lock-white-face.")

(defface font-lock-grey-face `((t (:foreground "grey")))  "gry highlight")
(defvar font-lock-grey-face 'font-lock-grey-face
  "Variable for face font-lock-grey-face.")


(defface font-lock-fg-face `((t (:foreground "#5B6268")))  "fg highlight")
(defvar font-lock-fg-face 'font-lock-fg-face
  "Variable for face font-lock-fg-face.")

(defface font-lock-comment-face `((t (:foreground "#414141")))  "comment highlight")
(defvar font-lock-comment-face 'font-lock-comment-face
  "Variable for face font-lock-comment-face.")

;

; font lock
(font-lock-remove-keywords 'octave-mode
        `(
        ("\\_<\\(?:break\\|c\\(?:a\\(?:se\\|tch\\)\\|lassdef\\|ontinue\\)\\|do\\|e\\(?:lse\\(?:if\\)?\\|n\\(?:d\\(?:_\\(?:try_catch\\|unwind_protect\\)\\|classdef\\|e\\(?:numeration\\|vents\\)\\|f\\(?:or\\|unction\\)\\|if\\|methods\\|p\\(?:arfor\\|roperties\\)\\|s\\(?:pmd\\|witch\\)\\|while\\)?\\|umeration\\)\\|vents\\)\\|f\\(?:or\\|unction\\)\\|global\\|if\\|methods\\|otherwise\\|p\\(?:arfor\\|ersistent\\|roperties\\)\\|return\\|s\\(?:pmd\\|witch\\)\\|try\\|un\\(?:til\\|wind_protect\\(?:_cleanup\\)?\\)\\|while\\)\\_>")
        ("\\(?:!=\\|&&\\|\\*[*=]\\|\\+[+=]\\|-[=-]\\|\\.\\(?:\\*\\*\\|\\.\\.\\|['*/\\^]\\)\\|/=\\|<=\\|==\\|>=\\|||\\|~=\\|[!&'*+,/:->\\|~^-]\\)")
)
)
(font-lock-add-keywords 'octave-mode
        `(

                ; n _ ; ???
                ; try_catch
                ; unwind_protect
                ; s    ;; ?
                ; spmd ;; ?
                ; _cleanup ;; ?

                ;; 1 'function'; 2 output; 3 '='; 4 function-name; 5 input
                ("^\\(?:[ \t]*\\)\\(\\<\\function\\>\\) +\\([A-Za-z][A-Za-z0-9_]*\\|\\[[A-Za-z0-9, ]*\\]\\) *\\([=]\\) *\\(\\<[A-Za-z][A-Za-z0-9_]*\\>\\(([A-Za-z0-9_, ]*)\\)\\)" (1 'font-lock-keyword-face prepend) (2 'font-lock-constant-face prepend)(3 'font-lock-keyword-face prepend) (4 'font-lock-function-name-face prepend) (5 'font-lock-constant-face prepend))
                ;; 1 'function'; 2 function-name; 3 input
                ("^\\(?:[ \t]*\\)\\(\\<\\function\\>\\) +\\(\\<[A-Za-z][A-Za-z0-9_]*\\>\\(([A-Za-z0-9_, ]*)\\)\\)" (1 'font-lock-keyword-face prepend) (2 'font-lock-function-name-face prepend) (3 'font-lock-constant-face prepend))

                ;; symbols that dont require semicolon
                ("\\(\\(?:^ *\\|; *\\)\\(\\<\\(enumeration\\|do\\|profile\\|hold\\|subplot\\|figure\\|end\\|continue\\|return\\|break\\|catch\\|classdef\\|else\\|if\\|elseif\\|for\\|functions\\|events\\|parfor\\|properties\\|switch\\|case\\|while\\|otherwise\\|global\\|persistent\\|try\\|until\\|methods\\)\\>\\)\\([^;\n]*\\)\\)+?"  (2 'font-lock-keyword-face prepend) (4 'font-lock-fg-face prepend))
                ;; TRIPLE DOTS
                ("\\(.*?\\)\\(\\.\\{3\\}\\)" (1 'font-lock-fg-face prepend))
                ;; HIGHLIGHT LINES NOT TERMINATED WITH ';' IF THEY DO NOT MATCH ABOVE
                ("^\\([^%\n]*?\\([^;% \t\n]\\)\\([ \t]\\)*\\(%.*\\)*$\\)" (1 'font-lock-error-face keep))
                ;; NORMAL FACE
                ("\\('\\(.*?\\)'\\)"  (0 font-lock-string-face prepend))

                ; TRANSPOSE IF I CAN DISABLE FONT-LOCK STRING HIGHLIGHTING
                ;("\\('[^']*?'\\)" (1 'font-lock-warning-face t) prepend)
                ;("\\(\\(?:^\\|[^'A-Za-z0-9_]\\)\\('[^']*?'\\)\\(?:$\\|[^'a-z0-9_]\\)\\)"  (2 'font-lock-error-face prepend) )

                ; STRINGS
                ("\\(?:^[^']*?\\)\\([(A-Za-z09_]+\\)\\('\\)\\(?: \\|;\\|\$\\)"  (1 'font-lock-warning-face prepend) (2 'font-lock-error-face prepend))

                ;; empty data types
                ("\\<\\(struct\\|cell\\|inf\\|nan\\|zeros\\|ones\\|true\\|false\\)\\>" (1 'font-lock-db-face t))
                ;; []
                ("\\(\\[\]\\)"        (1 'font-lock-db-face t)) ;; XXX NEED TO GET AROUND SMART PARENS


                ;; KEYWORDS
                ("\\<\\(size\\|length\\|numel\\|ndims\\)\\>" (1 'font-lock-warning-face t))
                ("\\<\\(clear\\|clc\\|input\\|tic\\|toc\\|pause\\|display\\|disp\\|cputime\\|clock\\|drawnow\\)\\>" (1 'font-lock-warning-face t))
                ("\\<\\(assignin\\|eval\\|evalin\\)\\>" (1 'font-lock-warning-face t))

                ("\\<\\(lastwarn\\|lasterr\\|lasterror\\|warning\\|error\\|assert\\|ME\\)\\>" 1 'font-lock-warning-face )
                ("\\<\\(i\\|j\\|k\\|n\\|m\\)\\>" (1 'font-lock-dg-face t))
                ("\\<\\(J\\|J\\|K\\|N\\|M\\)\\>" (1 'font-lock-dg-face t))
                ("\\<\\(ii\\|jj\\|kk\\\)\\>" (1 'font-lock-dg-face t))
                ("\\<\\(exist\\|isempty\\)\\>"   (1 'font-lock-dg-face t))
                ("\\<\\(obj\\|gca\\|gcf\\)\\>" (1 'font-lock-constant-face t))
                ("\\<\\(end\\|pi\\|exp(1)\\)\\>" (1 'font-lock-constant-face keep))
                ("\\<\\(dbclear\\|dbcont\\|dbquit\\|dbstackf\\|dbstatus\\|dbsetp\\|dbtype\\|dbup\\)\\>" (1 'font-lock-constant-face keep))

                ; STRUCTS and FLDS
                ;("\\([A-Za-z]+[A-Za-z0-9_]*\\)\\(\\.\\)\\([A-Za-z_][A-Za-z0-9_]*\\)" (1 'font-lock-grey-face)(2 'font-lock-error-face)(3 'font-lock-grey-face))

                ; RANGE
                ;("\\(\\([A-Za-z][A-Za-z0-9_]*\\)\\|\\([0-9]\\)*\\)\\(:\\)\\(\\([A-Za-z][A-Za-z0-9_]*\\)\\|\\([0-9]*\\)\\)" (2 'font-lock-db-face t)(3 'font-lock-warning-face t)(4 'font-lock-error-face t)(5 'font-lock-db-face t)(6 'font-lock-warning-face t))
                ;("\\(\\(:\\)*\\([A-Za-z][A-Za-z0-9_]*\\)+\\(:\\)\\)+" (1 'font-lock-grey-face t))

                ; SYMBOLS
                ("\\(:\\)" (1 'font-lock-error-face t))
                ("\\(=\\)" (1 'font-lock-keyword-face t))
                ("\\(;\\)" (1 'font-lock-function-name-face t))
                ("\\(,\\)" (1 'font-lock-function-name-face t))
                ("\\(\\.\\)" (1 'font-lock-constant-face t))
                ("\\(~\\|&\\||\\{1\\}\\)" (1 'font-lock-warning-face t))
                ("\\(+\\|-\\|/\\|\\*\\)" (1 'font-lock-keyword-face t))
                ("\\(&&\\|||\\)" (1 'font-lock-keyword-face t))
                ("\\(>\\|<\\)" (1 'font-lock-keyword-face t))

                ; COMMENTS
                ("\\(%[^\n]*\\)" (1 'font-lock-comment-face t))
                ("% *\\<\\(TODO[:;]?\\)\\>" (1 'org-todo t))
                ("% *\\<\\(XX[X]+[:;]?\\)\\>" (1 'font-lock-error-face t))
                ("% *\\<\\(NOTE[:;]?\\)\\>" (1 'org-level-6 t))
                ("% *\\<\\(TEST[:;]?\\)\\>" (1 'all-the-icons-lred t))
                ("% *\\<\\(CITE[:;]?\\)\\>" (1 'org-level-1 t))
                ("% *\\<\\(DONE[:;]?\\)\\>" (1 'org-done t))

                ; SEPARATORS
                ("\\(^%% +.*\\)" 1 'font-lock-white-face t)
                ("\\(%%%.*\\)" 1 'font-lock-error-face t)
                ("\\(%%*-.*\\)" 1 'font-lock-error-face t)


)
;'end
)


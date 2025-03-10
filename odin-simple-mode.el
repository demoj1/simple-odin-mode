;;; odin-simple-mode.el --- sample major mode for editing Odin. -*- coding: utf-8; lexical-binding: t; -*-
;;; Code:

(require 'compile)
(require 'cl-lib)

(defgroup odin-simple-mode nil
  "Odin simple mode."
  :group 'tools)

(defcustom odin/compile-command nil
  "Command use in compile mode (if not set, use Odin path)."
  :type '(choice
          string
          (const :tag "Use odin path" nil))
  :group 'odin-simple-mode)

;;;###autoload
(defcustom odin/path "odin"
  "Path to executable odin."
  :type 'file
  :group 'odin-simple-mode)

(defcustom odin/constants '("nil" "true" "false")
  "Syntax specific word."
  :type '(repeat string)
  :group 'odin-simple-mode)

(defcustom odin/keywords '("import" "foreign" "package" "typeid" "when" "where" "if" "else" "for" "switch" "in" "not_in" "do" "case" "break" "continue" "fallthrough" "defer" "return" "proc" "struct" "union" "enum" "bit_set" "bit_field" "map" "dynamic" "auto_cast" "cast" "transmute" "distinct" "using" "context" "or_else" "or_return" "or_break" "or_continue" "asm" "matrix")
  "Syntax specific word."
  :type '(repeat string)
  :group 'odin-simple-mode)

(defcustom odin/types '("byte" "bool" "b8" "b16" "b32" "b64" "i8" "u8" "i16" "u16" "i32" "u32" "i64" "u64" "i128" "u128" "rune" "f16" "f32" "f64" "complex32" "complex64" "complex128" "quaternion64" "quaternion128" "quaternion256" "int" "uint" "uintptr" "rawptr" "string" "cstring" "typeid" "any" "i16le" "u16le" "i32le" "u32le" "i64le" "u64le" "i128le" "u128le" "i16be" "u16be" "i32be" "u32be" "i64be" "u64be" "i128be" "u128be" "f16le" "f32le" "f64le" "f16be" "f32be" "f64be")
  "Syntax specific word."
  :type '(repeat string)
  :group 'odin-simple-mode)

(defvar odin-simple-mode-syntax-table
  (let ((table (make-syntax-table)))
    (modify-syntax-entry ?/ ". 124b" table)
    (modify-syntax-entry ?* ". 23" table)
    (modify-syntax-entry ?\n "> b" table)
    table))

(defvar odin/fontlock
  (list (cons (regexp-opt odin/keywords 'symbols) 'font-lock-keyword-face)
        (cons (regexp-opt odin/types 'symbols) 'font-lock-type-face)
        (cons (regexp-opt odin/constants 'symbols) 'font-lock-constant-face)
        (cons (rx (group "#" (? "+") letter (minimal-match (0+ graph))) (or "(" "{" "[" whitespace)) '(1 font-lock-builtin-face))
        (cons (rx bol (0+ whitespace) "package" whitespace (group letter (0+ graph))) '(1 font-lock-builtin-face))
        (cons (rx bol (0+ whitespace) "import" whitespace (group letter (0+ graph))) '(1 font-lock-builtin-face))
        (cons (rx bol (0+ whitespace) (group (or letter (1+ "_")) (0+ graph)) whitespace "::" whitespace "proc") '(1 font-lock-function-name-face))
        (cons (rx bol (0+ whitespace) (group letter (0+ graph)) (1+ whitespace) "::" whitespace (1+ any)) '(1 font-lock-constant-face)))
  "List font locks.")

;;;###autoload
(define-derived-mode odin-simple-mode prog-mode "Odin mode"
  :syntax-table odin-simple-mode-syntax-table
  (setq-local
   odin-path (or odin/path "odin")
   comment-start "// "
   font-lock-defaults '((odin/fontlock))
   compile-command (format "%s " (or odin/compile-command odin/path)))

  (cl-pushnew 'odin compilation-error-regexp-alist)
  (cl-pushnew '(odin "^\\([^[:space:]]+?\\)(\\([[:digit:]]+\\):\\([[:digit:]]+\\)) .*$" 1 2 3 nil) compilation-error-regexp-alist-alist)

  (indent-tabs-mode t)

  (flycheck-define-command-checker 'odin
    "A Odin syntax checker."
    :command (list odin/path "check" 'source "-file")
    :standard-input t
    :error-patterns
    '((error line-start (file-name) "(" line ":" column ")" " Syntax Error: " (message) line-end))
    :modes '(odin-simple-mode))

  (cl-pushnew 'odin flycheck-checkers))

;;;###autoload
(add-to-list 'auto-mode-alist '("\\.odin\\'" . odin-simple-mode))

(provide 'odin-simple-mode)

;;; odin-simple-mode.el ends here

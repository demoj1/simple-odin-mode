;;; odin-simple-mode.el --- sample major mode for editing Odin. -*- coding: utf-8; lexical-binding: t; -*-

(defun odin/keywords ()
  '("import" "foreign" "package" "typeid" "when" "where" "if" "else" "for" "switch" "in" "not_in" "do" "case" "break" "continue" "fallthrough" "defer" "return" "proc" "struct" "union" "enum" "bit_set" "bit_field" "map" "dynamic" "auto_cast" "cast" "transmute" "distinct" "using" "context" "or_else" "or_return" "or_break" "or_continue" "asm" "matrix"))

(defun odin/types ()
  '("byte" "bool" "b8" "b16" "b32" "b64" "i8" "u8" "i16" "u16" "i32" "u32" "i64" "u64" "i128" "u128" "rune" "f16" "f32" "f64" "complex32" "complex64" "complex128" "quaternion64" "quaternion128" "quaternion256" "int" "uint" "uintptr" "rawptr" "string" "cstring" "typeid" "any" "i16le" "u16le" "i32le" "u32le" "i64le" "u64le" "i128le" "u128le" "i16be" "u16be" "i32be" "u32be" "i64be" "u64be" "i128be" "u128be" "f16le" "f32le" "f64le" "f16be" "f32be" "f64be"))

(defvar odin/fontlock
  (list (cons (regexp-opt (odin/keywords) 'symbols) 'font-lock-keyword-face)
        (cons (regexp-opt (odin/types) 'symbols) 'font-lock-type-face)
        (cons (rx bol (0+ whitespace) (group (1+ word)) whitespace "::" whitespace "proc") '(1 font-lock-function-name-face)))
  "list font locks")

(define-derived-mode odin-simple-mode prog-mode "Odin mode"
  (setq-local
   comment-start "// "
   font-lock-defaults '((odin/fontlock)))
  (indent-tabs-mode t))

(add-to-list 'auto-mode-alist '("\\.odin\\'" . odin-simple-mode))

(provide 'odin-simple-mode)

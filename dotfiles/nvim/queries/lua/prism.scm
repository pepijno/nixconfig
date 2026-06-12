(arguments (_) @container)
(parameters (_) @container)
(for_generic_clause (_) @container)
(table_constructor (_) @container)

(bracket_index_expression
  field: (_) @container)

(if_statement
  condition: (_) @container)
(elseif_statement
  condition: (_) @container)
(while_statement
  condition: (_) @container)

(block) @container

(string) @string

(comment) @comment

(chunk) @main

[
  "return"
  "goto"
  "in"
  "local"
  (break_statement)
  "and"
  "not"
  "or"
  (hash_bang_line)
] @keyword

((identifier) @keyword
  (#eq? @keyword "coroutine"))

(do_statement
  [
    "do"
    "end"
  ] @keyword)

(while_statement
  [
    "while"
    "do"
    "end"
  ] @keyword)

(repeat_statement
  [
    "repeat"
    "until"
  ] @keyword)

(if_statement
  [
    "if"
    "elseif"
    "else"
    "then"
    "end"
  ] @keyword)

(elseif_statement
  [
    "elseif"
    "then"
    "end"
  ] @keyword)

(else_statement
  [
    "else"
    "end"
  ] @keyword)

(for_statement
  [
    "for"
    "do"
    "end"
  ] @keyword)

(function_declaration
  [
    "function"
    "end"
  ] @keyword)

(function_definition
  [
    "function"
    "end"
  ] @keyword)


; (function_declaration
;   "function" @delimiter
;   "end" @delimiter) @container
;
; (function_definition
;   "function" @delimiter
;   "end" @delimiter) @container
;
; (if_statement
;   "if" @delimiter
;   "then" @delimiter
;   (elseif_statement
;     "elseif" @delimiter
;     "then" @delimiter)*
;   (else_statement
;     "else" @delimiter)?
;   "end" @delimiter) @container
;
; (while_statement
;   "while" @delimiter
;   "do" @delimiter
;   "end" @delimiter) @container
;
; (repeat_statement
;   "repeat" @delimiter
;   "until" @delimiter) @container
;
; (for_statement
;   "for" @delimiter
;   (for_generic_clause
;     "in" @delimiter)?
;   "do" @delimiter
;   "end" @delimiter) @container
;
; (do_statement
;   "do" @delimiter
;   "end" @delimiter) @container
;
;
; ;;; Copied over from rainbow-parens
;
; (arguments
;   "(" @delimiter
;   ")" @delimiter) @container
;
; (parameters
;   "(" @delimiter
;   ")" @delimiter) @container
;
; (parenthesized_expression
;   "(" @delimiter
;   ")" @delimiter) @container
;
; (table_constructor
;   "{" @delimiter
;   "}" @delimiter) @container
;
; (bracket_index_expression
;   "[" @delimiter
;   "]" @delimiter) @container
;
; (field
;   "[" @delimiter
;   "]" @delimiter) @container
; (arguments
;   "(" @delimiter
;   ")" @delimiter) @container
;
; (parameters
;   "(" @delimiter
;   ")" @delimiter) @container
;
; (parenthesized_expression
;   "(" @delimiter
;   ")" @delimiter) @container
;
; (table_constructor
;   "{" @delimiter
;   "}" @delimiter) @container
;
; (bracket_index_expression
;   "[" @delimiter
;   "]" @delimiter) @container
;
; (field
;   "[" @delimiter
;   "]" @delimiter) @container

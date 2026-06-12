; ─────────────────────────────────────────────────────────────────────────────
; Containers / inner contents
; ─────────────────────────────────────────────────────────────────────────────

(parameter_list (_) @container)
(argument_list (_) @container)
(parenthesized_expression (_) @container)

(compound_statement (_) @container)

(field_declaration_list (_) @container)
(initializer_list (_) @container)
(enumerator_list (_) @container)

(array_declarator
  size: (_) @container)

(cast_expression
  type: (_) @container)

(sizeof_expression
  type: (_) @container)

(compound_literal_expression
  type: (_) @container)

(macro_type_specifier
  type: (_) @container)

(parenthesized_declarator (_) @container)

(subscript_expression
  index: (_) @container)

; ─────────────────────────────────────────────────────────────────────────────
; Control-flow bodies
; ─────────────────────────────────────────────────────────────────────────────

; Match an unbraced if-body.
(if_statement
  consequence: (_) @container
  (#not-match? @container "^[{]"))

; Match an unbraced else-body, but exclude `else if (...)`.
(if_statement
  alternative: (else_clause
    (_) @container)
  (#not-match? @container "^[{]")
  (#not-match? @container "^if\\b"))

; Match an unbraced while-body.
(while_statement
  body: (_) @container
  (#not-match? @container "^[{]"))

; Capture the three optional for-loop clauses.
(for_statement
  initializer: (_) @container)

(for_statement
  condition: (_) @container)

(for_statement
  update: (_) @container)

; Match an unbraced for-body.
(for_statement
  body: (_) @container
  (#not-match? @container "^[{]"))

; ─────────────────────────────────────────────────────────────────────────────
; Preprocessor
; ─────────────────────────────────────────────────────────────────────────────

(preproc_if (_) @container)
(preproc_params (_) @container)
(preproc_arg) @container

; ─────────────────────────────────────────────────────────────────────────────
; Strings and comments
; ─────────────────────────────────────────────────────────────────────────────

[
  (string_literal)
  (system_lib_string)
] @string

(comment) @comment

; ─────────────────────────────────────────────────────────────────────────────
; Keywords
; ─────────────────────────────────────────────────────────────────────────────

[
  "default"
  "goto"
  "asm"
  "__asm__"
  "__extension__"
  "enum"
  "struct"
  "union"
  "typedef"
  "sizeof"
  "offsetof"
  "return"
  "while"
  "for"
  "do"
  "continue"
  "break"
  "if"
  "else"
  "case"
  "switch"

  "#define"
  "#include"
  "#if"
  "#ifdef"
  "#ifndef"
  "#else"
  "#elif"
  "#endif"
  "#elifdef"
  "#elifndef"

  (type_qualifier)
  (gnu_asm_qualifier)
  (storage_class_specifier)
  (preproc_directive)
] @keyword

(conditional_expression
  [
    "?"
    ":"
  ] @keyword)

(linkage_specification
  "extern" @keyword)

(alignof_expression
  .
  _ @keyword)

; ─────────────────────────────────────────────────────────────────────────────
; Root node
; ─────────────────────────────────────────────────────────────────────────────

(translation_unit) @main


(string) @leaf

; (string) @single_quote

[
  (export_statement)
  (function_declaration)
  (return_statement)
  (expression_statement)
  (lexical_declaration)
  (switch_statement)
  (comment)
] @allow_blank_line_before

(comment) @prepend_input_softline

(
  (comment) @append_input_softline
  .
  [ "," ";" ]* @do_nothing
)

[
  "import"
  "export"
  "function"
  "interface"
  "if"
  "return"
  "const"
  "let"
  "switch"
  "case"
] @append_space

(interface_declaration name: (type_identifier) @append_space)
[
  "else"
  "from"
  "=>"
  "??"
  "="
  "as"
] @prepend_space @append_space

; ((_) . (import_statement) @append_spaced_softline)

[
  ":"
] @append_space

(interface_body
  .
  "{" @prepend_space @append_spaced_softline @append_indent_start
  (_)+
  "}" @prepend_spaced_softline @prepend_indent_end @append_hardline
  .
)

(named_imports
  .
  "{" @prepend_space @append_spaced_softline @append_indent_start
  (_)+
  "}" @prepend_spaced_softline @prepend_indent_end
  .
)

(function_declaration name: (identifier) @append_antispace)

(statement_block
  .
  "{" @prepend_space @append_spaced_softline @append_indent_start
  (_)+
  "}" @prepend_spaced_softline @prepend_indent_end
  .
)

(object
  .
  "{" @prepend_space @append_spaced_softline @append_indent_start
  (_)+
  "}" @prepend_spaced_softline @prepend_indent_end
  .
)

(
  [
    ","
  ] @append_spaced_softline
  .
  (comment)* @do_nothing
)

(
  [
    ";"
  ] @append_hardline
  .
  (comment)* @do_nothing
)

(arguments
  .
  "(" @append_empty_softline @append_indent_start
  _
  .
  (_)+
  ")" @prepend_empty_softline @prepend_indent_end
  .
)

(switch_statement value: (_) @append_space)

(switch_body
  .
  "{" @prepend_space @append_hardline @append_indent_start
  (_)+
  "}" @prepend_spaced_softline @prepend_indent_end
  .
)

(switch_case
  value: (_) @append_delimiter
  .
  ":"* @do_nothing
  (#delimiter! ":")
)

(switch_case
  value: (_)
  .
  ":" @append_hardline @append_indent_start
)

(switch_case
  body: (_) @append_indent_end
)

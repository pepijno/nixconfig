(named_imports (_) @container)
(arguments (_) @container)
(object (_) @container)
(object_type (_) @container)
(array (_) @container)
(class_body (_) @container)
(type_parameters (_) @container)
(type_arguments (_) @container)
(statement_block (_) @container)
(parenthesized_expression (_) @container)
(formal_parameters (_) @container)
(interface_body (_) @container)
(enum_body (_) @container)
(subscript_expression
  index: (_) @container)
(index_signature
  name: (_) @container
  index_type: (_) @container
  )
(array_type (_) @container)
(tuple_type (_) @container)
(lookup_type (_) @container)

(comment) @comment

(lookup_type
  "[" @delimiter
  "]" @delimiter) @container

(tuple_type
  "[" @delimiter
  "]" @delimiter) @container

[
  (string_fragment)
  (string)
] @string

[
  "declare"
  "implements"
  "type"
  "override"
  "module"
  "asserts"
  "infer"
  "is"
  "using"
] @keyword

(program) @main

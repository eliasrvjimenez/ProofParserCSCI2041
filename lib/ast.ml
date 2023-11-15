type expression =
  | Identifier of string
  | Application of expression * expression
  | Tuple of (expression list)

type equality  = 
  Equality of expression * expression

type comment = 
  Comment of string

type hint =
  Hint of string option



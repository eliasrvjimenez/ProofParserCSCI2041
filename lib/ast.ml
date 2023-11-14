type expression =
  | Identifier of string
  | Application of expression * expression

type pattern = 
  | Constructor
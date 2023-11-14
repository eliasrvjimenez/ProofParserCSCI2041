type expression =
  | Identifier of string
  | Application of expression * expression
  | Comment of expression
  | Equation of expression * expression

type equality = 
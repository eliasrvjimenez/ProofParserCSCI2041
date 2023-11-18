type expression =
  | Identifier of string
  | Application of expression * expression

type equality =
  | Equality of expression * expression
  | Is of equality

type declArgs = (string * string) list 

type declaration = 
  | Prove of (string option * expression * declArgs * equality * string option)




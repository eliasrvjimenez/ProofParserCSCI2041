type expression =
  | Identifier of string
  | Application of expression * expression

type equality =
  | Equality of expression * expression

type declArgs = (string * string) list 

type declaration = 
  | Prove of (string * declArgs * equality)



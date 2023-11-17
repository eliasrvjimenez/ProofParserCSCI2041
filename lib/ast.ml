type expression =
  | Identifier of string
  | Application of expression * expression
  | Proof of string option
  | Axiom of string option 

type equality =
  | Equality of expression * expression
  | Is of equality

type declArgs = (string * string) list 

type declaration = 
  | Prove of (expression * string * declArgs * equality)




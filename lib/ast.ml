type expression =
  | Identifier of string
  | Application of expression * expression

type equality =
  | Equality of expression * expression
  | Is of equality

type declArgs =
  (* In Declarations *)
  | Variables of (string * string) list 
  (* In Types *)
  | Variants of string list (* list that contains these. *)
  | VariantsOf of (string * string) list 

type hint = string option

type declaration = 
  | Prove of (string option * string option * string * declArgs * equality * hint) (* let rec ... = *)
  | Type of (string * declArgs) (* type ... = *)




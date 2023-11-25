type expression =
  | Identifier of string
  | Application of expression * expression

type equality =
  | Equality of expression * expression
  | Is of equality

type declArgs =
  (* In Declarations *)
  | Variable of string * string
  (* In Types *)
  | Variant of string(* list that contains these. *)
  | VariantOf of string * string 

type hint = string option

type declaration = 
  | Prove of (string option * string option * string * declArgs list * equality * hint) (* let rec ... = *)
  | Type of (string * declArgs list) (* type ... = *)




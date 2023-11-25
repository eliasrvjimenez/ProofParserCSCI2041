type expression =
  | Identifier of string
  | Application of expression * expression
  | Tuple of expression * expression

type equality =
  | Equality of expression * expression
  | Is of equality

type declArgs =
  (* In Declarations *)
  | Variable of string * string
  (* In Types *)
  | Variant of expression (* list that contains these. *)
  | VariantOf of expression * expression

type hint = string option

type declaration = 
  | Prove of (string option * string option * string * declArgs list * equality * hint) (* let rec ... = *)
  | Type of (string * declArgs list) (* type ... = *)




(* A sample file for your ocaml prover.

   The syntax here is chosen so that these files can be parsed by the ocaml compiler.
   This allows you to, when you write files for your prover,
     check the types of your definitions and lemmas, and even test them.

   Your tool is not expected to parse all of ocaml: only the subset of ocaml used in this file.
   In addition to ocaml syntax, this file uses annotations that ocaml does not have:
   They all use ocaml-comments without spaces like, and they are:
     (*prove*)  (immediately following the 'let' keyword)
     (*hint: ..*) (at the end of a 'let (*prove*)' statement)
   Because the are comments, they are ignored by ocaml.
   However, your tool should parse them and use them as explained below.
   Inside the hint annotations, you'll see the following keywords:
     axiom
     induction <var>

   Note that comments are nestable in ocaml, and should be in your language too,
     so the use of '(*' followed by '*)' in this sentence and the lines above is all fine,
     since all opening "(*"s are matched by "*)"s.
   Regular comments, the ones that are not prove or hint, always have a space following the * symbol.
*)

(* A type declaration for lists of integers.
   You need to know about these for induction proofs, to know the cases. *)
type list = (* To simplify parsing, each variant starts with | *)
  | Nil
  | Cons of (int * list)

(* Definitions always start with let rec,
   variables in patterns always have type annotations: *)
let rec append (l1 : list) (l2 : list) : list =
  match l1 with
  | Nil -> l2
  | Cons ((h : int), (t : list)) -> Cons (h, append t l2)

(* We can now prove simple properties about append, like this somewhat silly one: *)
let (*prove*) append_nilnil
 = (append Nil (Nil) = (Nil))
(* Your tool should output the following:
   Proof of append_nilnil:
    append Nil Nil
   = {definition of append}
    match Nil with | Nil -> Nil | Cons ((h : int), (t : list)) -> Cons (h, append t Nil)
   = {matching Nil with Nil}
    Nil
*)

(* A note on syntax: the function 'append' has a type annotation,
   but the property/lemma 'append_nilnil' does not:
   The keyword 'prove' is enough for us to know this is a bool,
   and the '=' symbol must occur as the definition at top level as well. *)

(* If there are variables in a lemma,
   they should be given as arguments: *)
let (*prove*) append_cons (h : int) (t : list) (l : list)
 = (append (Cons (h, t)) l = Cons (h, append t l))

(* A 'let-prove' statement can be followed by a hint,
   which tells your system what to do as the first step.
   Given a hint to do so, your system should do proofs by induction: *)
let (*prove*) append_nil (x : list)
  = (append x Nil = x)
(*hint: induction x *)
(* Output of your tool should be along these lines (your proof steps may vary):
   Proof of append_nil by induction on x:
   Case x = Nil:
    append x Nil
   = {case x = Nil}
    append Nil Nil
   = {lemma append_nilnil}
    Nil
   = {case x = Nil}
    x
   Case x = Cons (h, t):
   Induction hypothesis: append t Nil = t
    append x Nil
   = {case x = Cons (h, t)}
    append (Cons (h, t)) Nil
   = {lemma append_cons}
    Cons (h, append t Nil)
   = {inductive hypothesis}
    Cons (h, t)
   = {case x = Cons (h, t)}
    x
*)

(* Another definition: *)
let rec reverse (l : list) : list =
  match l with
  | Nil -> Nil
  | Cons ((h : int), (t : list)) -> append (reverse t) (Cons (h, Nil))

(* Your system should allow lemmas to be added without proving them first.
   The axiom hint does this. *)
let (*prove*) rev_rev (x : list) = (reverse (reverse x) = x)
(*hint: axiom *)
(* Output of your tool should be:
   rev_rev is assumed as an axiom:
    reverse (reverse x)
   = {axiom}
    x
*)

(* The proof of rev4 is now a straightforward application of rev_rev: *)
let (*prove*) rev4 (x : list) = (reverse (reverse (reverse (reverse x))) = x)

(* Aside: Can your system prove the rev_rev axiom without using 'axiom'?
   If you can find the right helper lemmas, you should be able to guide it to do so. *)

(* Here are some other proofs to try your system on: *)
let (*prove*) append_assoc (l1 : list) (l2 : list) (l3 : list)
    = (append (append l1 l2) l3 = append l1 (append l2 l3))
  (*hint: induction l1 *)

(* A lemma about reverse of append: *)
let (*prove*) rev_append (l1 : list) (l2 : list)
    = (reverse (append l1 l2) = append (reverse l2) (reverse l1))
  (*hint: induction l1 *)

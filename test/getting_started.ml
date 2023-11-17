(* A minimal sample file for your ocaml prover.
   This file does not contain everything your prover needs to do, just a small selection:
   - all functions and lemmas have only a single argument
   - the only statement is a let-prove statement
   - the only hint is 'axiom' (no 'induction')
*)

let (*prove*) cf_idempotent (h : int)
 = (cf (cf h) = cf h)
(*hint: axiom *)

let (*prove*) inv_involution (h : int)
 = (inv (inv h) = h)
(*hint: axiom *)

let (*prove*) cf_inv_commute (h : int)
 = (cf (inv h) = inv (cf h))
(*hint: axiom *)

(* This should now be provable from the axioms: *)
let (*prove*) cf_inv_property (h : int)
 = (cf (inv (cf (inv h))) = cf h)
(* no hints! *)

(* Output should read something like this:
  Proof of cf_inv_property:
   cf (inv (cf (inv h)))
  = {lemma cf_inv_commute}
   inv (cf (cf (inv h)))
  = {lemma cf_idempotent}
   inv (cf (inv h))
  = {lemma cf_inv_commute}
   inv (inv (cf h))
  = {lemma inv_involution}
   cf h
*)
(* Here's a file with two more proofs to test your implementation on: *)

(* a proof that does not go through (this tests the ???): *)
let (*prove*) fooxy (x:int) (y:int) = (foo x y = x)

(* some axioms that define append:
   we're writing 'cons' as if it was a function,
   this way we avoid the , in Cons (x,xs).
   It's just to keep things simple. *)

let (*prove*) append_nil (xs:int) = (append Nil xs = xs) 
(*hint: axiom *)

let (*prove*) append_cons (x:int) (xs:int) (ys:int) =
  (append (cons x xs) ys = cons x (append xs ys))
(*hint: axiom *)

(* a proof of associativity of append requires induction,
   but we can ask for the base case manually: *)
let (*prove*) append_assoc_base (xs:int) (ys:int) =
  (append (append Nil xs) ys = append Nil (append xs ys))

(* We can add the inductive hypothesis manually too.
   Note that 'tl' is never a variable,
   and the above statement actually proves it for tl = Nil.
   Here is the inductive hypothesis: *)

let (*prove*) ih_append_assoc (xs : list) (ys : list)
 = (append (append tl xs) ys = append tl (append xs ys)) 
(*hint: axiom *)

let (*prove*) append_assoc_inductive_step (h:int) (xs:int) (ys:int) =
  (append (append (cons h tl) xs) ys = append (cons h tl) (append xs ys))

(* There is more inspiration to be had from the homework and midterms.
   Encoding induction theorems is a bit of a pain still,
     but I hope the above illustrates how you can get to see your tool to give proofs! *)

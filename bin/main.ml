
(* These are the functions and modules I get from the module in the lib directory.
   I've called it procaml.ml there, some will probably have called it halloween.ml.
   Names may vary, but these are the things this executable needs.
   In any case, these four definitions should be the only things you need to change. *)
let string_of_declaration = Final_project.string_of_declaration
let string_of_simple_proof = Final_project.string_of_simple_proof
let mainParser = Final_project.Parser.main
let mainLexer = Final_project.Lexer.token
module Parser : (sig exception Error end) = Final_project.Parser
(* Here are the types these things have for me,
   but I'm not stating them for ocaml because there's a good chance things are different for you:
   Parser.main : (Lexing.lexbuf -> token) -> Lexing.lexbuf -> Final_project.expression list
   Lexer.token : Lexing.lexbuf -> Final_project.Parser.token
   string_of_declaration : Final_project.expression -> string
*)

(* the function that prints everything. *)
(* has a side-effect (namely: it prints) so it belongs here *)
let print_all = Stdlib.List.map (fun decl -> print_endline (string_of_declaration decl))
let simple_proof = Stdlib.List.map (fun simple -> print_endline (string_of_simple_proof simple))

(* An improved function to parse everything from a 'channel'.
 * It has a side-effect (namely: reads from an input-channel)
 * The filename is passed for error-reporting purposes only
 * 
 * To make developing a parser easier, this function reports
 * a location of the parse error.
 * We're using the lexer to determine the location, and the
 * location of the error will be the last lexed token.
 * This means that the error is an approximate indication,
 * but it's better than nothing, and it doesn't require anything
 * with respect to the grammar.
 * However, it does require some discipline from the lexer:
 * Make sure to add 'Lexing.new_line lexbuf;' for every newline
 * that is, my 'token' lexer reads:
 *   | newline { Lexing.new_line lexbuf;token lexbuf }
 * and my 'comment' lexer reads:
 *   | newline { Lexing.new_line lexbuf;comment level lexbuf }
 * (this is placed just before the parsing of _)
 * If you don't call newline, you'll still get a location,
 * but it count newlines as characters all of a sudden.
 * This means things behave as if the entire file is a single line.
 * If that's how you've written your lexer, and you can't be bothered
 * to change your lexer,the work-around is to remove all newlines
 * from the input file t o get an error location.
 *)
let printback_file (filename : string) (chan : in_channel)
 = let buf = Lexing.from_channel ~with_positions:true chan in
 (* Lexing.set_filename buf filename; If your ocaml is new enough, this line may help improve error messages. *)
 match mainParser mainLexer buf with
 | ast -> let _ = print_all ast in ()
 | exception Parser.Error ->
    let pos = buf.lex_start_p in
    (* location is formatted such that it becomes clickable in vscode,
       use ctrl-click or cmd-click *)
    print_endline ("File \""^filename^"\", line "^
                    string_of_int pos.pos_lnum^", character "^
                    string_of_int (pos.pos_cnum - pos.pos_bol)^
                    ":\n  Syntax error")

let simple_file (filename : string) (chan : in_channel)
   = let buf = Lexing.from_channel ~with_positions:true chan in
   (* Lexing.set_filename buf filename; If your ocaml is new enough, this line may help improve error messages. *)
   match mainParser mainLexer buf with
   | ast -> let _ = simple_proof ast in ()
   | exception Parser.Error ->
      let pos = buf.lex_start_p in
      (* location is formatted such that it becomes clickable in vscode,
         use ctrl-click or cmd-click *)
      print_endline ("File \""^filename^"\", line "^
                        string_of_int pos.pos_lnum^", character "^
                        string_of_int (pos.pos_cnum - pos.pos_bol)^
                        ":\n  Syntax error")
(* This function is borrowed largely from Janestreet's core library *)
(* It is used to ensure that files get closed after they are opened *)
let protectx f x (finally : _ -> unit) =
  match f x with
  | res ->
    finally x;
    res
  | exception exn ->
    let bt = Stdlib.Printexc.get_raw_backtrace () in
    (match finally x with
     | () -> Printexc.raise_with_backtrace exn bt
     | exception _final_exn ->
       (* Unfortunately, the backtrace of the [final_exn] is discarded here. *)
       Printexc.raise_with_backtrace exn bt)

(* parse and print a file indicated by its filename
   (borrowed from Janestreet's stdio library) *)
let printfile (filename : string) : unit
 = protectx (printback_file filename)
            (Stdlib.open_in_gen [ Open_rdonly ] 0o000 filename)
            Stdlib.close_in
let simple (filename: string) : unit
 = protectx (simple_file filename)
            (Stdlib.open_in_gen [ Open_rdonly ] 0o000 filename)
            Stdlib.close_in

(***********************************************************)
(* here's the code for dealing with command line arguments *)
(***********************************************************)

(* the usage message is based of the name of the executable *)
let usage_msg = Sys.executable_name ^ " [--printback <filename>]"

(* Here is a list of arguments that the executable can take.
   It's simply given by a list of triples:
     the first and last elements end up in the documentation (use -help),
     the middle element is code for what the argument 'does'.
   Note that "Arg.String" takes a function of type: string -> unit.
   This is where we plug in the 'printfile' function we wrote above. *)
let speclist =
  [("--printback", Arg.String printfile, "Print the parsed file back out");
  ("--simple", Arg.String simple, "Generates simple proof for file")]

let _ = Arg.parse
           speclist
           (* the next argument is for parsing strings not in the speclist.
              Eventually, this may be a list of files for which we should generate proofs.
              For now, we'll just put a dummy function here. *)
           (fun x -> print_endline ("Unexpected argument: "^x))
           usage_msg;
        (* printing an extra newline at the end of it all:
           this way, no matter what was printed so far,
           we don't mess up the terminal output too badly. *)
        print_newline ()

(* I run this by calling:
   
dune build
./_build/default/bin/main.exe --printback test/gettingstarted.ml

(of course, I should make 'dune test' call this instead,
 but I haven't gotten around to that yet.)

*)
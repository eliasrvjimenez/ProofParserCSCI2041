{ 
    open Parser
    exception SyntaxError of string
}

let newline = '\r' | '\n' | "\r\n"

rule token = parse
| [' ' '\t']  { token lexbuf } 
| newline { Lexing.new_line lexbuf; token lexbuf } 
| ['a'-'z' 'A'-'Z' '0'-'9' '_' '\'' '.' ]+ as word 
    { match word with
    | "let" -> LET(word)
    | _ ->  IDENT(word) }  
| "(*prove*)" as proof{PROVE(proof)} 
| "(*hint: axiom *)" as axiom {AXIOM(axiom)}
| "(*" { comment lexbuf }
| ':' {COLON}
| '(' {LPAREN}
| ')' {RPAREN}
| '=' {EQUALS}
| _ { raise (SyntaxError ("Unexpected char: " ^ Lexing.lexeme lexbuf))}
| eof { EOF }

and comment = parse
| "*)" {token lexbuf}
| eof {raise (SyntaxError ("Unterminated Comment, please add a *)")) }
| _ {comment lexbuf}



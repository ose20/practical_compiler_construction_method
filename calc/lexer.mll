{
  open Parser
  exception Lexing of string
}

let space = [' ' '\t' '\r' '\n']
let digit = ['0'-'9']+

rule token = parse
  | digit 
      { NUM (int_of_string @@ Lexing.lexeme lexbuf) }
  | '+'
      { PLUS }
  | '-'
      { MINUS }
  | '*'
      { TIMES }
  | '/'
      { DIV }
  | '('
      { LP }
  | ')'
      { RP }
  | space
      { token lexbuf }
  | ";;"
      { EOI }
  | "#quit"
      { QUIT }
  | _
      { raise (Lexing (Lexing.lexeme lexbuf)) }
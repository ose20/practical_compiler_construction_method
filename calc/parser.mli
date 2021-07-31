type token =
  | NUM of (int)
  | PLUS
  | MINUS
  | TIMES
  | DIV
  | LP
  | RP
  | QUIT
  | EOI

val prog :
  (Lexing.lexbuf  -> token) -> Lexing.lexbuf -> Toplevel.t

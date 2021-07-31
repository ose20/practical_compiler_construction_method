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

open Parsing;;
let _ = parse_error;;
let yytransl_const = [|
  258 (* PLUS *);
  259 (* MINUS *);
  260 (* TIMES *);
  261 (* DIV *);
  262 (* LP *);
  263 (* RP *);
  264 (* QUIT *);
  265 (* EOI *);
    0|]

let yytransl_block = [|
  257 (* NUM *);
    0|]

let yylhs = "\255\255\
\001\000\001\000\002\000\002\000\002\000\002\000\002\000\002\000\
\002\000\000\000"

let yylen = "\002\000\
\002\000\002\000\001\000\003\000\003\000\003\000\003\000\003\000\
\002\000\002\000"

let yydefred = "\000\000\
\000\000\000\000\003\000\000\000\000\000\000\000\010\000\000\000\
\000\000\000\000\002\000\000\000\000\000\000\000\000\000\001\000\
\004\000\000\000\000\000\007\000\008\000"

let yydgoto = "\002\000\
\007\000\008\000"

let yysindex = "\005\000\
\015\255\000\000\000\000\038\255\038\255\008\255\000\000\010\255\
\041\255\000\255\000\000\038\255\038\255\038\255\038\255\000\000\
\000\000\041\255\041\255\000\000\000\000"

let yyrindex = "\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\022\255\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\025\255\033\255\000\000\000\000"

let yygindex = "\000\000\
\000\000\252\255"

let yytablesize = 46
let yytable = "\009\000\
\010\000\012\000\013\000\014\000\015\000\001\000\017\000\018\000\
\019\000\020\000\021\000\012\000\013\000\014\000\015\000\003\000\
\011\000\004\000\016\000\000\000\005\000\000\000\006\000\009\000\
\009\000\000\000\005\000\005\000\009\000\000\000\009\000\005\000\
\000\000\005\000\006\000\006\000\000\000\000\000\003\000\006\000\
\004\000\006\000\000\000\005\000\014\000\015\000"

let yycheck = "\004\000\
\005\000\002\001\003\001\004\001\005\001\001\000\007\001\012\000\
\013\000\014\000\015\000\002\001\003\001\004\001\005\001\001\001\
\009\001\003\001\009\001\255\255\006\001\255\255\008\001\002\001\
\003\001\255\255\002\001\003\001\007\001\255\255\009\001\007\001\
\255\255\009\001\002\001\003\001\255\255\255\255\001\001\007\001\
\003\001\009\001\255\255\006\001\004\001\005\001"

let yynames_const = "\
  PLUS\000\
  MINUS\000\
  TIMES\000\
  DIV\000\
  LP\000\
  RP\000\
  QUIT\000\
  EOI\000\
  "

let yynames_block = "\
  NUM\000\
  "

let yyact = [|
  (fun _ -> failwith "parser")
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 1 : 'expr) in
    Obj.repr(
# 15 "parser.mly"
      ( Toplevel.Exp (_1) )
# 98 "parser.ml"
               : Toplevel.t))
; (fun __caml_parser_env ->
    Obj.repr(
# 17 "parser.mly"
      ( Toplevel.Quit )
# 104 "parser.ml"
               : Toplevel.t))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : int) in
    Obj.repr(
# 21 "parser.mly"
      ( _1 )
# 111 "parser.ml"
               : 'expr))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 1 : 'expr) in
    Obj.repr(
# 23 "parser.mly"
      ( _2 )
# 118 "parser.ml"
               : 'expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'expr) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'expr) in
    Obj.repr(
# 25 "parser.mly"
      ( _1 + _3 )
# 126 "parser.ml"
               : 'expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'expr) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'expr) in
    Obj.repr(
# 27 "parser.mly"
      ( _1 - _3 )
# 134 "parser.ml"
               : 'expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'expr) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'expr) in
    Obj.repr(
# 29 "parser.mly"
      ( _1 * _3 )
# 142 "parser.ml"
               : 'expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'expr) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'expr) in
    Obj.repr(
# 31 "parser.mly"
      ( _1 / _3 )
# 150 "parser.ml"
               : 'expr))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 0 : 'expr) in
    Obj.repr(
# 33 "parser.mly"
      ( - _2 )
# 157 "parser.ml"
               : 'expr))
(* Entry prog *)
; (fun __caml_parser_env -> raise (Parsing.YYexit (Parsing.peek_val __caml_parser_env 0)))
|]
let yytables =
  { Parsing.actions=yyact;
    Parsing.transl_const=yytransl_const;
    Parsing.transl_block=yytransl_block;
    Parsing.lhs=yylhs;
    Parsing.len=yylen;
    Parsing.defred=yydefred;
    Parsing.dgoto=yydgoto;
    Parsing.sindex=yysindex;
    Parsing.rindex=yyrindex;
    Parsing.gindex=yygindex;
    Parsing.tablesize=yytablesize;
    Parsing.table=yytable;
    Parsing.check=yycheck;
    Parsing.error_function=parse_error;
    Parsing.names_const=yynames_const;
    Parsing.names_block=yynames_block }
let prog (lexfun : Lexing.lexbuf -> token) (lexbuf : Lexing.lexbuf) =
   (Parsing.yyparse yytables 1 lexfun lexbuf : Toplevel.t)

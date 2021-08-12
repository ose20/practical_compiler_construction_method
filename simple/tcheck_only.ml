open Ast
open Typecheck

exception Err of string

let main () =
    if Array.length Sys.argv != 2
    then raise (Err "just one input file is needed")
    else ();
    let cin = open_in Sys.argv.(1) in
    let lexbuf = Lexing.from_channel cin in
    check (Parser.prog Lexer.lexer lexbuf)

let _ = 
    main ();
    Printf.printf "yay!! type checked!\n"
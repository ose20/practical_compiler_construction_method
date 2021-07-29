
let rec repl () =
  print_string "# ";
  flush stdout;
  try
    match Parser0.prog Lexer0.token (Lexing.from_channel stdin) with
    | Toplevel.Exp num -> Printf.printf "%d\n" num; repl ()
    | Toplevel.Quit -> ()
  with
  | Parsing.Parse_error | Lexer0.Lexing _ ->
      print_endline "Error: Syntax error";
      repl ()

let _ = repl ()      
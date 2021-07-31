
let rec repl () =
  print_string "# ";
  flush stdout;
  try
    match Parser.prog Lexer.token (Lexing.from_channel stdin) with
    | Toplevel.Exp num -> Printf.printf "%d\n" num; repl ()
    | Toplevel.Quit -> ()
  with
  | Parsing.Parse_error | Lexer.Lexing _ ->
      print_endline "Error: Syntax error";
      repl ()

let _ = repl ()      
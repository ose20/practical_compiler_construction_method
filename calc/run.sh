ocamllex lexer0.mll
ocamlyacc parser0.mly
ocamlc -c toplevel.ml
ocamlc -c parser0.mli
ocamlc -c lexer0.ml
ocamlc -c parser0.ml
ocamlc -c main.ml
ocamlc -o main toplevel.cmo lexer0.cmo parser0.cmo main.cmo
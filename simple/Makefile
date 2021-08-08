APP 		= print_ast
OCAMLC 		= ocamlc
OCAMLDEP 	= ocamldep

OBJS = lexer.cmo parser.cmo types.cmo ast.cmo print_ast.cmo
DEPEND = lexer.ml parser.ml

all: .depend $(APP)

$(APP): $(OBJS)
	$(OCAMLC) -o $@ $(OBJS)

# Common rules
.SUFFIXES: .ml .mli .cmo .cmi .cmx

.mli.cmi:
	$(OCAMLC) -c $<

.ml.cmo:
	$(OCAMLC) -c $<

parser.ml: parser.mly
	ocamlyacc -v $<

lexer.ml: lexer.mll
	ocamllex $<

# Clean up
.PHONY: clean
clean:
	rm -f print_ast
	rm -f *.cm[io]
	rm -f lexer.ml
	rm -f parser.ml
	rm -f parser.mli
	rm -f parser.output

# Dependencies
.depend: $(DEPEND)
	$(OCAMLDEP) *.mli *.ml > .depend

include .depend
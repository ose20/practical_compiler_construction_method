APP 		= print_ast
OCAMLC 		= ocamlc
OCAMLDEP 	= ocamldep

OBJS1 = lexer.cmo parser.cmo types.cmo ast.cmo print_ast.cmo
OBJS2 = lexer.cmo parser.cmo types.cmo ast.cmo table.cmo typecheck.cmo\
            tcheck_only.cmo
DEPEND = lexer.ml parser.ml

all: .depend $(APP)

$(APP): $(OBJS1)
	$(OCAMLC) -o $@ $(OBJS1)

tcheck_only : $(OBJS2)
	$(OCAMLC) -o $@ $(OBJS2)

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
APP       = main
OCAMLC    = ocamlc
OCAMLDEP  = ocamldep

INCLUDES     =             # all relevant -I options here
OCAMLFLAGS   = $(INCLUDES) # add other options for ocamlc here
OCAMLOPTFLAGS= $(INCLUDES) # add other options for ocamlopt here

OBJS   = lexer.cmo parser.cmo toplevel.cmo main.cmo
DEPEND  = lexer.ml parser.ml

all: .depend $(APP)


$(APP): $(OBJS)
	@echo Linking $@
	$(OCAMLC) -o $@ $(OCAMLFLAGS) $(OBJS)

# Common rules
.SUFFIXES: .ml .mli .cmo .cmi .cmx

.mli.cmi:
	$(OCAMLC) $(OCAMLFLAGS) -c $<

.ml.cmo:
	$(OCAMLC) $(OCAMLFLAGS) -c $<

parser.ml parser.mli: parser.mly
	ocamlyacc -v $<

lexer.ml: lexer.mll
	ocamllex $<

# Clean up
.PHONY: clean
clean:
	rm -f main
	rm -f *.cm[iox]
	rm -f lexer.ml
	rm -f parser.mli
	rm -f parser.ml


# Dependencies
.depend: $(DEPEND)
	$(OCAMLDEP) $(INCLUDES) *.mli *.ml > .depend

include .depend


all: compile

COMPILE = dict.cmo lexer.cmo tree.cmo parser.cmo check.cmo jvm.cmo jvmgen.cmo main.cmo 
compile: $(COMPILE)
	ocamlc lib/common.cma $(COMPILE) -o $@
	./compile

parser.mli parser.ml: parser.mly
	ocamlyacc parser.mly

lexer.ml: lexer.mll
	ocamllex lexer.mll

clean:
	rm -f compile parser.mli parser.ml lexer.ml *.cma *.cmo *.cmi 

ML =  lexer.mli lexer.ml dict.mli main.ml check.mli check.ml dict.mli dict.ml\
	 jvm.mli jvm.ml jvmgen.mli jvmgen.ml parser.mli parser.ml tree.mli

depend : $(ML) force
	(sed '/^###/q' Makefile; echo; ocamldep $(ML)) >new
	mv new Makefile

%.cmi : %.mli
	ocamlc $(MLFLAGS) -c $<

%.cmo : %.ml
	ocamlc $(MLFLAGS) -c $<

force:

MLFLAGS = -I lib

###

check.cmo : \
    tree.cmi \
    jvm.cmi \
    dict.cmi \
    check.cmi
check.cmx : \
    tree.cmx \
    jvm.cmx \
    dict.cmx \
    check.cmi
check.cmi : \
    tree.cmi
dict.cmo : \
    dict.cmi
dict.cmx : \
    dict.cmi
dict.cmi :
dict.cmi :
jvm.cmo : \
    jvm.cmi
jvm.cmx : \
    jvm.cmi
jvm.cmi :
jvmgen.cmo : \
    tree.cmi \
    jvm.cmi \
    dict.cmi \
    jvmgen.cmi
jvmgen.cmx : \
    tree.cmx \
    jvm.cmx \
    dict.cmx \
    jvmgen.cmi
jvmgen.cmi : \
    tree.cmi
lexer.cmo : \
    parser.cmi \
    lexer.cmi
lexer.cmx : \
    parser.cmx \
    lexer.cmi
lexer.cmi : \
    parser.cmi
main.cmo : \
    tree.cmi \
    parser.cmi \
    lexer.cmi \
    jvmgen.cmi \
    check.cmi
main.cmx : \
    tree.cmx \
    parser.cmx \
    lexer.cmx \
    jvmgen.cmx \
    check.cmx
parser.cmo : \
    tree.cmi \
    lexer.cmi \
    dict.cmi \
    parser.cmi
parser.cmx : \
    tree.cmx \
    lexer.cmx \
    dict.cmx \
    parser.cmi
parser.cmi : \
    tree.cmi \
    dict.cmi
tree.cmi : \
    dict.cmi

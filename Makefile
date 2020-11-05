###
# This Makefile can be used to make a parser for the egg language
# (parser.class) and to make a program (P4.class) that tests the parser, unparse and
# name analysis methods in ast.java.
#
# make clean removes all generated files.
#
###

JC = javac
FLAGS = -g  
CP = ./deps:.

P4.class: P4.java parser.class Yylex.class ASTnode.class
	$(JC) $(FLAGS) -cp $(CP) P4.java

parser.class: parser.java ASTnode.class Yylex.class ErrMsg.class
	$(JC) $(FLAGS) -cp $(CP) parser.java

parser.java: egg.cup
	java -cp $(CP) java_cup.Main < egg.cup

Yylex.class: egg.jlex.java sym.class ErrMsg.class
	$(JC) $(FLAGS) -cp $(CP) egg.jlex.java

ASTnode.class: ast.java SymTable.class
	$(JC) $(FLAGS) -cp $(CP) ast.java

egg.jlex.java: egg.jlex sym.class
	java -cp $(CP) JLex.Main egg.jlex

sym.class: sym.java
	$(JC) $(FLAGS) -cp $(CP) sym.java

sym.java: egg.cup
	java -cp $(CP) java_cup.Main < egg.cup

ErrMsg.class: ErrMsg.java
	$(JC) $(FLAGS) -cp $(CP) ErrMsg.java

Sym.class: Sym.java
	$(JC) $(FLAGS) -cp $(CP) ast.java
	$(JC) $(FLAGS) -cp $(CP) Sym.java

SymTable.class: SymTable.java Sym.class DuplicateSymException.class WrongArgumentException.class EmptySymTableException.class
	$(JC) $(FLAGS) -cp $(CP) SymTable.java

DuplicateSymException.class: DuplicateSymException.java
	$(JC) $(FLAGS) -cp $(CP) DuplicateSymException.java

WrongArgumentException.class: WrongArgumentException.java
	$(JC) $(FLAGS) -cp $(CP) WrongArgumentException.java

EmptySymTableException.class: EmptySymTableException.java
	$(JC) $(FLAGS) -cp $(CP) EmptySymTableException.java

##test
test:
	java -cp $(CP) P4 nameErrors.egg nameErrors.out
	java -cp $(CP) P4 test.egg test.out

###
# clean
###
clean:
	rm -f *~ *.class parser.java egg.jlex.java sym.java

## cleantest (delete test artifacts)
cleantest:
	rm -f *.out

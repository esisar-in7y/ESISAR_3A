SRC=.
HERE=$(PWD)
MAINCLASS=table
SRCJAVA=$(wildcard $(SRC)/*.java)
CLASSFILES = $(SRCJAVA:.java=.class)

all: run

# Compilation
%.class: %.java
	# javac -d $(SRC) $^
	javac noeud.java
	javac -d $(SRC) table.java

# Exécution
run: $(MAINCLASS).class
	java $(MAINCLASS)

clean:
	rm -f $(SRC)/*.class $(SRC)/*~ *~

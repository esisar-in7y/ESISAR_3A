SRC=.
HERE=$(PWD)
MAINCLASS=Table
SRCJAVA=$(wildcard $(SRC)/*.java)
CLASSFILES = $(SRCJAVA:.java=.class)

all: run

# Compilation
%.class: %.java
	javac -d $(SRC) $^

# Exécution
run: $(MAINCLASS).class
	java $(MAINCLASS)

clean:
	rm -f $(SRC)/*.class $(SRC)/*~ *~

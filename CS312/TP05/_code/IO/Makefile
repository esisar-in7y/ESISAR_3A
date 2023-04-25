## Change your name here:
MYNAME=MoncorgeLeprat

## DO NOT change below
MAINCLASS=FindArray
OUTDIR=./build
SRC=./src
HERE=$(PWD)
CLASS_PATH=$(OUTDIR)
SRCJAVA=$(wildcard $(SRC)/*.java)
CLASSFILES = $($(SRCJAVA:.java=.class):$(SRC)=$(OUTDIR))

all: run

# Compile
%.class: %.java
	javac -cp $(CLASS_PATH) -d $(OUTDIR) $^

all: run
# Run
run: $(SRC)/$(MAINCLASS).class
	java -cp build/ IO.Files

tar: clean
	dir=$$(basename $$PWD/$$SRC) && cd .. && \
	tar cvfz "TP05-$(MYNAME).tgz" --exclude=".git" "$$dir"

clean:
	rm -f $(OUTDIR)/*.class $(SRC)/*~ *~

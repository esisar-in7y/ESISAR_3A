## Change your name here:
MYNAME=MoncorgeLeprat

## DO NOT change below
OUTDIR=../build
HERE=$(PWD)
CLASS_PATH=../../../V2/:$(OUTDIR)

all: run

# Compile
%.class: %.java
	javac -cp $(CLASS_PATH) $^ -d $(OUTDIR)

all: run
# Run
run: FindArray.class
	java -cp $(CLASS_PATH) $(OUTDIR)FindArray 

tar: clean
	dir=$$(basename $$PWD/$$SRC) && cd .. && \
	tar cvfz "TP05-$(MYNAME).tgz" --exclude=".git" "$$dir"

clean:
	rm -f *.class *~

## Change your name here:
MYNAME=MoncorgeLeprat

## DO NOT change below
HERE=$(PWD)
CLASS_PATH=../../../V2/:.

all: run

# Compile
%.class: %.java
	javac -cp $(CLASS_PATH) $^

all: run
# Run
run: FindArray.class
	java -cp $(CLASS_PATH) FindArray 

tar: clean
	dir=$$(basename $$PWD/$$SRC) && cd .. && \
	tar cvfz "TP05-$(MYNAME).tgz" --exclude=".git" "$$dir"

clean:
	rm -f *.class *~

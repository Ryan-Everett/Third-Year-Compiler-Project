DEPENDANCIES = "dependancies/*"
RUNFLAGS = -cp classes:$(DEPENDANCIES)

all: downloadKrak build compile runMain

downloadKrak:
		git clone https://github.com/Storyyeller/Krakatau

build:
		
		$(MAKE) -C compiler/lib all
		$(MAKE) -C compiler all

compile:
		mkdir -p krakIn
		compiler/compile examples/* > krakIn/generatedClasses.j
		python Krakatau/assemble.py -out classes -r krakIn > /dev/null 2>&1
		javac -cp classes rt/* -d classes

runMain:
		java $(RUNFLAGS):. rt.examples.ExampleTester

clean:
		$(MAKE) -C compiler/lib clean
		$(MAKE) -C compiler clean
		rm -rf classes/*
		rm -rf krakIn
		rm -rf Krakatau

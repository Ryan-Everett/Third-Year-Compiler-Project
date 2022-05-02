dependencies = "dependencies/*"
RUNFLAGS = -cp classes:$(dependencies)
CLASSDIR = ./classes/rt/examples
all: downloadKrak btest

btest: build compile buildtester runMain
ctest: 	
		$(MAKE) -C compiler/lib clean
		$(MAKE) -C compiler clean
		rm -rf classes
		rm utilities/*.class
downloadKrak:
		git clone https://github.com/Storyyeller/Krakatau utilities/Krakatau
		mkdir krakIn

build:
		
		$(MAKE) -C compiler/lib all
		$(MAKE) -C compiler all
		javac -cp "utilities/asm-9.2.jar":. utilities/GenStackMaps.java

compile:
		compiler/compile examples/* > krakIn/generatedClasses.j
		python utilities/Krakatau/assemble.py -out classes -r krakIn > /dev/null 2>&1
		java -cp "dependencies/rt.jar":"utilities/asm-9.2.jar":. utilities/GenStackMaps classes/rt/examples

buildtester:
		javac -cp classes:"dependencies/*":. testClasses/*.java -d classes
runMain:
	java $(RUNFLAGS):. rt.examples.ExampleTester

runDNE:
	java $(RUNFLAGS):. rt.examples.DNETester
clean:
		$(MAKE) -C compiler/lib clean
		$(MAKE) -C compiler clean
		rm -rf classes
		rm -rf utilities/Krakatau
		rm -rf krakIn
		rm utilities/*.class

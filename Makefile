DEPENDANCIES = "dependancies/*"
RUNFLAGS = -cp classes:$(DEPENDANCIES)
CLASSDIR = ./classes/rt/examples
all: downloadKrak build compile genStackMaps runMain

btest: build compile genStackMaps runMain
ctest: 	
		$(MAKE) -C compiler/lib clean
		$(MAKE) -C compiler clean
		rm -rf classes
		rm -rf krakIn
		rm utilities/*.class
downloadKrak:
		git clone https://github.com/Storyyeller/Krakatau

build:
		
		$(MAKE) -C compiler/lib all
		$(MAKE) -C compiler all
		javac -cp classes:"dependancies/*":. utilities/GenStackMaps.java

compile:
		mkdir -p krakIn
		compiler/compile examples/* > krakIn/generatedClasses.j
		python Krakatau/assemble.py -out classes -r krakIn > /dev/null 2>&1
		javac -cp classes:dependancies/dynalink-0.7.jar rt/* -d classes
		javac -cp classes:"dependancies/*":. dependancies/*.java -d classes

genStackMaps: 
	$(foreach file, $(wildcard $(CLASSDIR)/*), java $(RUNFLAGS):. utilities/GenStackMaps $(file);)

runMain:
	java $(RUNFLAGS):. rt.examples.ExampleTester

runDNE:
	java $(RUNFLAGS):. rt.examples.DNETester
clean:
		$(MAKE) -C compiler/lib clean
		$(MAKE) -C compiler clean
		rm -rf classes
		rm -rf krakIn
		rm -rf Krakatau
		rm utilities/*.class

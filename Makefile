dependencies = "dependencies/*"
RUNFLAGS = -cp classes:$(dependencies)
CLASSDIR = ./classes/rt/examples
all: downloadKrak btest

btest: build compile buildtester runMain
ctest: 	
		$(MAKE) -C compiler/lib clean
		$(MAKE) -C compiler clean
		rm -rf classes
		rm -rf midwayClasses
		rm utilities/*.class
downloadKrak:
		git clone https://github.com/Storyyeller/Krakatau utilities/Krakatau

build:
		
		$(MAKE) -C compiler/lib all
		$(MAKE) -C compiler all
		javac -cp classes:"dependencies/*":. utilities/GenStackMaps.java
		javac -cp classes:dependencies/dynalink-0.7.jar rt/*.java -d classes
		javac -cp classes:"dependencies/*":. dependencies/*.java -d classes

compile:
		compiler/compile examples/* > krakIn/generatedClasses.j
		python utilities/Krakatau/assemble.py -out classes -r krakIn > /dev/null 2>&1
		java $(RUNFLAGS):. utilities/GenStackMaps classes/rt/examples

buildtester:
		javac -cp classes rt/examples/*.java -d classes
runMain:
	java $(RUNFLAGS):. rt.examples.ExampleTester

runDNE:
	java $(RUNFLAGS):. rt.examples.DNETester
clean:
		$(MAKE) -C compiler/lib clean
		$(MAKE) -C compiler clean
		rm -rf classes
		rm -rf midwayClasses
		rm -rf utilities/Krakatau
		rm utilities/*.class

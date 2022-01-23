DEPENDANCIES = "dependancies/*"
RUNFLAGS = -cp classes:$(DEPENDANCIES)

all: build compile runMain

build:
		$(MAKE) -C compiler/lib all
		$(MAKE) -C compiler all

compile:
		compiler/compile examples/* > krakIn/generatedClasses.j
		python Krakatau/assemble.py -out classes -r krakIn > /dev/null 2>&1

runMain:
		java $(RUNFLAGS):. rt.examples.ExampleTester

clean:
		$(MAKE) -C compiler/lib clean
		$(MAKE) -C compiler clean
		rm -rf classes/*
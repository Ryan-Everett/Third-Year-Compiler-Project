# ThirdYearProject
Third year compiler project (Still in progress)

Compiler for a smalltalk style language to the JVM. Based on the Oxford Oberon-2 compiler


To compile everything run $make.

This will first download Krakatau from https://github.com/Storyyeller/Krakatau (Used to translate the textual jvm outputted by my compiler into bytecode)
Then it will compile all of the classes in examples to jvm class files in "classes" 
and finally it will run a java class that creates an instance of examples/Main.

/compiler/compile dir/* to compile all files in dir to jvm class files

Yet to be added:
    Control statements
    Higher order functions
    Class variables
    Strings, Booleans, Arrays, Floats

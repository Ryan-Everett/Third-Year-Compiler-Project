.version 55 0
.class public super rt/examples/ExampleTester
.super rt/Object

.const [defbootcls] = Class org/dynalang/dynalink/DefaultBootstrapper
.const [dynmeth] = Method [defbootcls] publicBootstrap (Ljava/lang/invoke/MethodHandles$Lookup;Ljava/lang/String;Ljava/lang/invoke/MethodType;)Ljava/lang/invoke/CallSite;

.const [dynset] = InvokeDynamic invokeStatic [dynmeth] : 'dyn:setProp' (Ljava/lang/Object;Ljava/lang/Object;Ljava/lang/Object;)V
.const [dynmake] = InvokeDynamic invokeStatic [dynmeth] : 'dyn:new' (Ljava/lang/Object;)Ljava/lang/Object;
.const [dyngetmethod] = InvokeDynamic invokeStatic [dynmeth] : 'dyn:getMethod' (Ljava/lang/Object;Ljava/lang/String;)Ljava/lang/Object;
.const [dyncall] = InvokeDynamic invokeStatic [dynmeth] : 'dyn:call' (Ljava/lang/Object;Ljava/lang/Object;)Lrt/Object;
.const [dyncall1] = InvokeDynamic invokeStatic [dynmeth] : 'dyn:call' (Ljava/lang/Object;Ljava/lang/Object;Ljava/lang/Object;)Lrt/Object;
.const [dynnewone] = InvokeDynamic invokeStatic [dynmeth] : 'dyn:new' (Ljava/lang/Object;I)Lrt/Object;
.const [statcls] = Class org/dynalang/dynalink/beans/StaticClass
.const [getstatclass] = Method [statcls] forClass (Ljava/lang/Class;)Lorg/dynalang/dynalink/beans/StaticClass;


.method public static main : ([Ljava/lang/String;)V
	.limit stack 10
	.limit locals 10

    ldc Class rt/examples/Main
    invokestatic [getstatclass]
    invokedynamic [dynmake]
    astore_1

    return
.end method
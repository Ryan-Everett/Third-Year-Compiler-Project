.version 55 0
.class public super "rt/examples/IntTests"
.super "rt/Object"
.const [getstatcls] = Method org/dynalang/dynalink/beans/StaticClass forClass (Ljava/lang/Class;)Lorg/dynalang/dynalink/beans/StaticClass;
.const [dynmeth] = Method org/dynalang/dynalink/DefaultBootstrapper publicBootstrap (Ljava/lang/invoke/MethodHandles$Lookup;Ljava/lang/String;Ljava/lang/invoke/MethodType;)Ljava/lang/invoke/CallSite;
.field private "v" Lrt/Object;
.method public <init> : ()V
.limit stack 10
.limit locals 11
aload 0
invokespecial Method rt/Object <init> ()V
aload 0
getstatic Field rt/Integer smallInts [Lrt/Integer;
bipush 7
aaload
putfield Field "rt/examples/IntTests" "v" Lrt/Object;
aload 0
invokedynamic InvokeDynamic invokeStatic [dynmeth] : 'dyn:callMethod:println' (Ljava/lang/Object;)Lrt/Object;
pop
aload 0
aload 0
getfield Field "rt/examples/IntTests" "v" Lrt/Object;
getstatic Field rt/Integer smallInts [Lrt/Integer;
bipush 3
aaload
invokedynamic InvokeDynamic invokeStatic [dynmeth] : 'dyn:callMethod:mult$' (Ljava/lang/Object;Lrt/Object;)Lrt/Object;
getstatic Field rt/Integer smallInts [Lrt/Integer;
bipush 7
aaload
invokedynamic InvokeDynamic invokeStatic [dynmeth] : 'dyn:callMethod:minus' (Ljava/lang/Object;)Lrt/Object;
getstatic Field rt/Integer smallInts [Lrt/Integer;
bipush 2
aaload
invokedynamic InvokeDynamic invokeStatic [dynmeth] : 'dyn:callMethod:mult$' (Ljava/lang/Object;Lrt/Object;)Lrt/Object;
invokedynamic InvokeDynamic invokeStatic [dynmeth] : 'dyn:callMethod:minus$' (Ljava/lang/Object;Lrt/Object;)Lrt/Object;
putfield Field "rt/examples/IntTests" "v" Lrt/Object;
aload 0
getfield Field "rt/examples/IntTests" "v" Lrt/Object;
invokedynamic InvokeDynamic invokeStatic [dynmeth] : 'dyn:callMethod:println' (Ljava/lang/Object;)Lrt/Object;
pop
aload 0
getstatic Field rt/Integer smallInts [Lrt/Integer;
bipush 2
aaload
invokedynamic InvokeDynamic invokeStatic [dynmeth] : 'dyn:callMethod:add1$' (Ljava/lang/Object;Lrt/Object;)Lrt/Object;
invokedynamic InvokeDynamic invokeStatic [dynmeth] : 'dyn:callMethod:println' (Ljava/lang/Object;)Lrt/Object;
pop
return
.end method
.method public "println" : ()Lrt/Object;
.limit stack 10
.limit locals 10
aload 0
getfield Field "rt/examples/IntTests" "v" Lrt/Object;
invokedynamic InvokeDynamic invokeStatic [dynmeth] : 'dyn:callMethod:println' (Ljava/lang/Object;)Lrt/Object;
pop
aload 0
areturn
.end method
.method public "add1$" : (Lrt/Object;)Lrt/Object;
.limit stack 10
.limit locals 10
aload 1
getstatic Field rt/Integer smallInts [Lrt/Integer;
bipush 1
aaload
invokedynamic InvokeDynamic invokeStatic [dynmeth] : 'dyn:callMethod:add$' (Ljava/lang/Object;Lrt/Object;)Lrt/Object;
astore 1
aload 1
areturn
.stack same
aload 0
areturn
.end method
.end class
.version 55 0
.class public super "rt/examples/Main"
.super "rt/Object"
.const [getstatcls] = Method org/dynalang/dynalink/beans/StaticClass forClass (Ljava/lang/Class;)Lorg/dynalang/dynalink/beans/StaticClass;
.const [dynmeth] = Method org/dynalang/dynalink/DefaultBootstrapper publicBootstrap (Ljava/lang/invoke/MethodHandles$Lookup;Ljava/lang/String;Ljava/lang/invoke/MethodType;)Ljava/lang/invoke/CallSite;
.field private "x" Lrt/Object;
.field private "y" Lrt/Object;
.method public <init> : ()V
.limit stack 10
.limit locals 11
aload 0
invokespecial Method rt/Object <init> ()V
aload 0
ldc Class "rt/examples/IntTests"
invokestatic [getstatcls]
invokedynamic InvokeDynamic invokeStatic [dynmeth] : 'dyn:new' (Ljava/lang/Object;)Lrt/Object;
putfield Field "rt/examples/Main" "y" Lrt/Object;
aload 0
ldc Class "rt/examples/SavingsAccount"
invokestatic [getstatcls]
invokedynamic InvokeDynamic invokeStatic [dynmeth] : 'dyn:new' (Ljava/lang/Object;)Lrt/Object;
putfield Field "rt/examples/Main" "x" Lrt/Object;
aload 0
getstatic Field rt/Integer smallInts [Lrt/Integer;
bipush 20
aaload
putfield Field "rt/examples/Main" "y" Lrt/Object;
aload 0
getfield Field "rt/examples/Main" "x" Lrt/Object;
aload 0
getfield Field "rt/examples/Main" "y" Lrt/Object;
invokedynamic InvokeDynamic invokeStatic [dynmeth] : 'dyn:callMethod:deposit$' (Ljava/lang/Object;Lrt/Object;)Lrt/Object;
pop
aload 0
getfield Field "rt/examples/Main" "x" Lrt/Object;
invokedynamic InvokeDynamic invokeStatic [dynmeth] : 'dyn:callMethod:printbal' (Ljava/lang/Object;)Lrt/Object;
pop
aload 0
getfield Field "rt/examples/Main" "x" Lrt/Object;
invokedynamic InvokeDynamic invokeStatic [dynmeth] : 'dyn:callMethod:applyInterest' (Ljava/lang/Object;)Lrt/Object;
pop
aload 0
getfield Field "rt/examples/Main" "x" Lrt/Object;
invokedynamic InvokeDynamic invokeStatic [dynmeth] : 'dyn:callMethod:printbal' (Ljava/lang/Object;)Lrt/Object;
pop
aload 0
getfield Field "rt/examples/Main" "x" Lrt/Object;
getstatic Field rt/Integer smallInts [Lrt/Integer;
bipush 20
aaload
invokedynamic InvokeDynamic invokeStatic [dynmeth] : 'dyn:callMethod:withdrawal$' (Ljava/lang/Object;Lrt/Object;)Lrt/Object;
pop
aload 0
getfield Field "rt/examples/Main" "x" Lrt/Object;
invokedynamic InvokeDynamic invokeStatic [dynmeth] : 'dyn:callMethod:printbal' (Ljava/lang/Object;)Lrt/Object;
pop

return
.end method
.end class
.version 55 0
.class public super "rt/examples/RtAccount"
.super "rt/Object"
.const [getstatcls] = Method org/dynalang/dynalink/beans/StaticClass forClass (Ljava/lang/Class;)Lorg/dynalang/dynalink/beans/StaticClass;
.const [dynmeth] = Method org/dynalang/dynalink/DefaultBootstrapper publicBootstrap (Ljava/lang/invoke/MethodHandles$Lookup;Ljava/lang/String;Ljava/lang/invoke/MethodType;)Ljava/lang/invoke/CallSite;
.field private "id" Lrt/Object;
.field private "balance" Lrt/Object;
.method public <init> : ()V
.limit stack 10
.limit locals 11
aload 0
invokespecial Method rt/Object <init> ()V
aload 0
getstatic Field rt/Integer smallInts [Lrt/Integer;
bipush 0
aaload
putfield Field "rt/examples/RtAccount" "balance" Lrt/Object;

return
.end method
.method public "id$" : (Lrt/Object;)Lrt/Object;
.limit stack 10
.limit locals 10
aload 0
aload 1
putfield Field "rt/examples/RtAccount" "id" Lrt/Object;

aload 0
areturn
.end method
.method public "deposit$" : (Lrt/Object;)Lrt/Object;
.limit stack 10
.limit locals 10
aload 0
aload 0
getfield Field "rt/examples/RtAccount" "balance" Lrt/Object;
aload 1
invokedynamic InvokeDynamic invokeStatic [dynmeth] : 'dyn:callMethod:add$' (Ljava/lang/Object;Lrt/Object;)Lrt/Object;
putfield Field "rt/examples/RtAccount" "balance" Lrt/Object;

aload 0
areturn
.end method
.method public "withdrawal$" : (Lrt/Object;)Lrt/Object;
.limit stack 10
.limit locals 10
aload 0
aload 0
getfield Field "rt/examples/RtAccount" "balance" Lrt/Object;
aload 1
invokedynamic InvokeDynamic invokeStatic [dynmeth] : 'dyn:callMethod:minus$' (Ljava/lang/Object;Lrt/Object;)Lrt/Object;
putfield Field "rt/examples/RtAccount" "balance" Lrt/Object;

aload 0
areturn
.end method
.method public "printbal" : ()Lrt/Object;
.limit stack 10
.limit locals 10
aload 0
getfield Field "rt/examples/RtAccount" "balance" Lrt/Object;
invokedynamic InvokeDynamic invokeStatic [dynmeth] : 'dyn:callMethod:println' (Ljava/lang/Object;)Lrt/Object;
pop

aload 0
areturn
.end method
.method public "balance" : ()Lrt/Object;
.limit stack 10
.limit locals 10
aload 0
getfield Field "rt/examples/RtAccount" "balance" Lrt/Object;
areturn
.stack same
aload 0
areturn
.end method
.end class
.version 55 0
.class public super "rt/examples/SavingsAccount"
.super "rt/examples/RtAccount"
.const [getstatcls] = Method org/dynalang/dynalink/beans/StaticClass forClass (Ljava/lang/Class;)Lorg/dynalang/dynalink/beans/StaticClass;
.const [dynmeth] = Method org/dynalang/dynalink/DefaultBootstrapper publicBootstrap (Ljava/lang/invoke/MethodHandles$Lookup;Ljava/lang/String;Ljava/lang/invoke/MethodType;)Ljava/lang/invoke/CallSite;
.field private "interestRate" Lrt/Object;
.method public <init> : ()V
.limit stack 10
.limit locals 11
aload 0
invokespecial Method rt/examples/RtAccount <init> ()V
aload 0
getstatic Field rt/Integer smallInts [Lrt/Integer;
bipush 1
aaload
putfield Field "rt/examples/SavingsAccount" "interestRate" Lrt/Object;

return
.end method
.method public "interestRate$" : (Lrt/Object;)Lrt/Object;
.limit stack 10
.limit locals 10
aload 0
aload 1
putfield Field "rt/examples/SavingsAccount" "interestRate" Lrt/Object;

aload 0
areturn
.end method
.method public "applyInterest" : ()Lrt/Object;
.limit stack 10
.limit locals 10
aload 0
aload 0
invokedynamic InvokeDynamic invokeStatic [dynmeth] : 'dyn:callMethod:balance' (Ljava/lang/Object;)Lrt/Object;
aload 0
getfield Field "rt/examples/SavingsAccount" "interestRate" Lrt/Object;
invokedynamic InvokeDynamic invokeStatic [dynmeth] : 'dyn:callMethod:mult$' (Ljava/lang/Object;Lrt/Object;)Lrt/Object;
invokedynamic InvokeDynamic invokeStatic [dynmeth] : 'dyn:callMethod:deposit$' (Ljava/lang/Object;Lrt/Object;)Lrt/Object;
pop
aload 0
areturn
.end method
.end class

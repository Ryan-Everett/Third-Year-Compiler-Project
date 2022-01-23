.version 55 0 
.class public super rt/Integer 
.super rt/Object 
.field public static final smallInts [Lrt/Integer; 
.field private final value I 

.method public <init> : (I)V 
    .code stack 2 locals 2 
L0:     aload_0 
L1:     invokespecial Method rt/Object <init> ()V 
L4:     aload_0 
L5:     iload_1 
L6:     putfield Field rt/Integer value I 
L9:     return 
L10:    
        .linenumbertable 
            L0 12 
            L4 13 
            L9 14 
        .end linenumbertable 
    .end code 
.end method 

.method public 'print' : ()V 
    .code stack 2 locals 1 
L0:     getstatic Field java/lang/System out Ljava/io/PrintStream; 
L3:     aload_0 
L4:     getfield Field rt/Integer value I 
L7:     invokevirtual Method java/io/PrintStream print (I)V 
L10:    return 
L11:    
        .linenumbertable 
            L0 17 
            L10 18 
        .end linenumbertable 
    .end code 
.end method 

.method public 'println' : ()V 
    .code stack 2 locals 1 
L0:     getstatic Field java/lang/System out Ljava/io/PrintStream; 
L3:     aload_0 
L4:     getfield Field rt/Integer value I 
L7:     invokevirtual Method java/io/PrintStream println (I)V 
L10:    return 
L11:    
        .linenumbertable 
            L0 21 
            L10 22 
        .end linenumbertable 
    .end code 
.end method 

.method public 'add:' : (Lrt/Integer;)Lrt/Integer; 
    .code stack 4 locals 2 
L0:     new rt/Integer 
L3:     dup 
L4:     aload_0 
L5:     getfield Field rt/Integer value I 
L8:     aload_1 
L9:     getfield Field rt/Integer value I 
L12:    iadd 
L13:    invokespecial Method rt/Integer <init> (I)V 
L16:    areturn 
L17:    
        .linenumbertable 
            L0 24 
        .end linenumbertable 
    .end code 
.end method 

.method public "minus" : ()Lrt/Integer; 
    .code stack 3 locals 1 
L0:     new rt/Integer 
L3:     dup 
L4:     aload_0 
L5:     getfield Field rt/Integer value I 
L8:     ineg 
L9:     invokespecial Method rt/Integer <init> (I)V 
L12:    areturn 
L13:    
        .linenumbertable 
            L0 17 
        .end linenumbertable 
    .end code 
.end method 

.method public 'minus:' : (Lrt/Integer;)Lrt/Integer; 
    .code stack 4 locals 2 
L0:     new rt/Integer 
L3:     dup 
L4:     aload_0 
L5:     getfield Field rt/Integer value I 
L8:     aload_1 
L9:     getfield Field rt/Integer value I 
L12:    isub 
L13:    invokespecial Method rt/Integer <init> (I)V 
L16:    areturn 
L17:    
        .linenumbertable 
            L0 27 
        .end linenumbertable 
    .end code 
.end method 

.method public 'mult:' : (Lrt/Integer;)Lrt/Integer; 
    .code stack 4 locals 2 
L0:     new rt/Integer 
L3:     dup 
L4:     aload_0 
L5:     getfield Field rt/Integer value I 
L8:     aload_1 
L9:     getfield Field rt/Integer value I 
L12:    imul 
L13:    invokespecial Method rt/Integer <init> (I)V 
L16:    areturn 
L17:    
        .linenumbertable 
            L0 30 
        .end linenumbertable 
    .end code 
.end method 

.method public 'div:' : (Lrt/Integer;)Lrt/Integer; 
    .code stack 4 locals 2 
L0:     new rt/Integer 
L3:     dup 
L4:     aload_0 
L5:     getfield Field rt/Integer value I 
L8:     aload_1 
L9:     getfield Field rt/Integer value I 
L12:    idiv 
L13:    invokespecial Method rt/Integer <init> (I)V 
L16:    areturn 
L17:    
        .linenumbertable 
            L0 33 
        .end linenumbertable 
    .end code 
.end method 

.method public 'mod:' : (Lrt/Integer;)Lrt/Integer; 
    .code stack 4 locals 2 
L0:     new rt/Integer 
L3:     dup 
L4:     aload_0 
L5:     getfield Field rt/Integer value I 
L8:     aload_1 
L9:     getfield Field rt/Integer value I 
L12:    irem 
L13:    invokespecial Method rt/Integer <init> (I)V 
L16:    areturn 
L17:    
        .linenumbertable 
            L0 36 
        .end linenumbertable 
    .end code 
.end method 

.method static <clinit> : ()V 
    .code stack 5 locals 1 
L0:     sipush 128 
L3:     anewarray rt/Integer 
L6:     putstatic Field rt/Integer smallInts [Lrt/Integer; 
L9:     iconst_0 
L10:    istore_0 

        .stack append Integer 
L11:    iload_0 
L12:    sipush 128 
L15:    if_icmpge L37 
L18:    getstatic Field rt/Integer smallInts [Lrt/Integer; 
L21:    iload_0 
L22:    new rt/Integer 
L25:    dup 
L26:    iload_0 
L27:    invokespecial Method rt/Integer <init> (I)V 
L30:    aastore 
L31:    iinc 0 1 
L34:    goto L11 

        .stack chop 1 
L37:    return 
L38:    
        .linenumbertable 
            L0 4 
            L9 6 
            L18 7 
            L31 6 
            L37 9 
        .end linenumbertable 
    .end code 
.end method 
.sourcefile 'Integer.java' 
.end class 

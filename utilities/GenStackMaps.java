package utilities;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import org.objectweb.asm.ClassWriter;
import org.objectweb.asm.ClassReader;
public class GenStackMaps {
    public static void main(String[] args) throws IOException{
        genStackMapsInClass(args[0]);
    }

    //Takes a class, generates stack maps where necessary and then re-writes to the same name
    static void genStackMapsInClass(String pathName) throws IOException {
        byte[] bytecode = Files.readAllBytes(Paths.get(pathName));
        ClassReader cr = new ClassReader(bytecode);
        ClassWriter cw = new ClassWriter(ClassWriter.COMPUTE_FRAMES);
        cr.accept(cw, ClassReader.SKIP_FRAMES);
        bytecode = cw.toByteArray(); // Rewrite class with StackMaps
        Files.write(Paths.get(pathName), bytecode);
    }
}
package utilities;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.nio.file.Path;
import org.objectweb.asm.ClassWriter;
import org.objectweb.asm.ClassReader;
public class GenStackMaps {
    public static void main(String[] args) throws IOException{
        Files.walk(Paths.get(args[0])).forEach (path ->{
            try {
                if (!Files.isDirectory(path)){
                    genStackMapsInClass(path);
                }
            } catch (IOException e) {
                throw new RuntimeException(e);
            }
        });
    }

    //Takes a class, generates stack maps where necessary and then re-write to the same name
    static void genStackMapsInClass(Path pathName) throws IOException {
        byte[] bytecode = Files.readAllBytes(pathName);
        ClassReader cr = new ClassReader(bytecode);
        ClassWriter cw = new ClassWriter(ClassWriter.COMPUTE_FRAMES);
        cr.accept(cw, ClassReader.SKIP_FRAMES);
        bytecode = cw.toByteArray(); // Rewrite class with StackMaps
        Files.write(pathName, bytecode);
    }
}
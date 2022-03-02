package rt.examples;
//import rt.examples.Main;
public class ExampleTester {
    public static void main(String[] args) {
        try {
            Main m = new Main();
            System.out.println("Done");
        } catch (org.dynalang.dynalink.NoSuchDynamicMethodException e) {
            System.out.println("ERROR: " + e);
        }
    }
}

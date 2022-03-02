package rt;

public class Boolean extends rt.Object{
    private final boolean value;
    public Boolean(boolean b) {
        value = b;
    }
    @Override
    public void print() {
        System.out.print(value);
    }
    @Override
    public void println() {
        System.out.println(value);
    }

    public void if$then$(rt.Block b){
    }
}
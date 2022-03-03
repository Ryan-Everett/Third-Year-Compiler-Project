package rt;

public class Boolean extends rt.Object{
    final boolean value;
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

    public rt.Boolean and$(rt.Boolean b2){
        return new rt.Boolean(value && b2.value);
    }

    public rt.Boolean or$(rt.Boolean b2){
        return new rt.Boolean(value || b2.value);
    }

    public rt.Boolean not() {
        return new rt.Boolean(!value);
    }
    //public void if$then$(rt.Block b){
    //}
}
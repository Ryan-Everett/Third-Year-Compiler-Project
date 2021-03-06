package rt;


public class Char extends rt.Object{
    final char value;
    public Char(char c){
        value = c;
    }

    @Override
    public void print() {
        System.out.print(value);
    }
    @Override
    public void println() {
        System.out.println(value);
    }

    @Override
    public String makeString() {
        return new rt.String("" + value);
    }

    public rt.Char add$ (rt.Char x){
        return new rt.Char((char) (value + x.value));
    }
    public rt.Char add$ (rt.Integer x){
        return new rt.Char((char) (value + x.value));
    }
    public rt.Char minus$ (rt.Char x){
        return new rt.Char((char) (value - x.value));
    }
    public rt.Char minus$ (rt.Integer x){
        return new rt.Char((char) (value - x.value));
    }
    public rt.Boolean eq$ (rt.Char x){
        return new rt.Boolean(value == x.value);
    }
    public rt.Boolean neq$ (rt.Char x){
        return new rt.Boolean(value != x.value);
    }
    public rt.Boolean lt$ (rt.Char x){
        return new rt.Boolean(value < x.value);
    }
    public rt.Boolean leq$ (rt.Char x){
        return new rt.Boolean(value <= x.value);
    }
    public rt.Boolean gt$ (rt.Char x){
        return new rt.Boolean(value > x.value);
    }
    public rt.Boolean geq$ (rt.Char x){
        return new rt.Boolean(value >= x.value);
    }
}

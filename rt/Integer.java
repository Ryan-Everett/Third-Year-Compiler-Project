package rt;

public class Integer extends rt.Object{
    public static final rt.Integer [] smallInts = new rt.Integer [128];
    static {
        for (int i = 0; i < 128; i++){
            smallInts[i] = new rt.Integer(i);
        }
    }

    final int value;
    public Integer(int x) {
        value = x;
    }

    @Override
    public void print() {
        System.out.print(value);
    }
    @Override
    public void println() {
        System.out.println(value);
    }
    
    public rt.Integer minus () {
        return new rt.Integer(-value);
    }
    public rt.Integer add$ (rt.Integer x){
        return new rt.Integer(value + x.value);
    }
    public rt.Integer minus$ (rt.Integer x){
        return new rt.Integer(value - x.value);
    }
    public rt.Integer mult$ (rt.Integer x){
        return new rt.Integer(value * x.value);
    }
    public rt.Integer div$ (rt.Integer x){
        return new rt.Integer(value / x.value);
    }
    public rt.Integer mod$ (rt.Integer x){
        return new rt.Integer(value % x.value);
    }
}

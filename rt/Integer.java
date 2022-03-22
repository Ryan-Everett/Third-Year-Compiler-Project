package rt;

public class Integer extends rt.Object{
    private static final rt.Integer [] smallInts = new rt.Integer [128];
    static {
        for (int i = 0; i < 128; i++){
            smallInts[i] = new rt.Integer(i);
        }
    }
    public static rt.Integer createInt(int x){
        if (x >= 0 && x < 128) {
            return smallInts[x];
        }
        else {
            return new rt.Integer(x);
        }
    }

    //Ask about how to handle big ints
    public static rt.Integer createInt(long x){
        return new rt.Integer(1);
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
    
    @Override
    public String makeString() {
        return new rt.String("" + value);
    }

    public int $get$(){
        return this.value;
    }

    public rt.Integer minus () {
        return createInt(-value);
    }
    public rt.Integer add$ (rt.Integer x){
        return createInt(value + x.value);
    }
    public rt.Integer minus$ (rt.Integer x){
        return createInt(value - x.value);
    }
    public rt.Integer mult$ (rt.Integer x){
        return createInt(value * x.value);
    }
    public rt.Integer div$ (rt.Integer x){
        return createInt(value / x.value);
    }
    public rt.Integer mod$ (rt.Integer x){
        return createInt(value % x.value);
    }
    public rt.Boolean eq$ (rt.Integer x){
        return new rt.Boolean(value == x.value);
    }
    public rt.Boolean neq$ (rt.Integer x){
        return new rt.Boolean(value != x.value);
    }
    public rt.Boolean lt$ (rt.Integer x){
        return new rt.Boolean(value < x.value);
    }
    public rt.Boolean leq$ (rt.Integer x){
        return new rt.Boolean(value <= x.value);
    }
    public rt.Boolean gt$ (rt.Integer x){
        return new rt.Boolean(value > x.value);
    }
    public rt.Boolean geq$ (rt.Integer x){
        return new rt.Boolean(value >= x.value);
    }
}

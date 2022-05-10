package rt;

public class Boolean extends rt.Object{
    static final rt.Boolean falseBool = new rt.Boolean(false);
    static final rt.Boolean trueBool = new rt.Boolean(true);
    static Boolean createBool(boolean b){
        if (b){
            return trueBool;
        }
        else{
            return falseBool;
        }
    }
    boolean value;
    public Boolean(boolean b) {
        value = b;  //REMOVE THIS
    }
    @Override
    public void print() {
        System.out.print(value);
    }
    @Override
    public void println() {
        System.out.println(value);
    }

    public boolean $get$(){
        return this.value;
    }

    public rt.Boolean and$(rt.Boolean b2){
        return createBool(value && b2.value);
    }

    public rt.Boolean or$(rt.Boolean b2){
        return createBool(value || b2.value);
    }

    public rt.Boolean not() {
        return createBool(!value);
    }
    //public void if$then$(rt.Block b){
    //}
}
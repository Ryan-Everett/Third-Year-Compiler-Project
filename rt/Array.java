package rt;

public class Array extends rt.Object{
    final rt.Object [] value;
    final rt.Integer length;
    public Array (rt.Object [] os) {
        value = os;
        length = new rt.Integer(os.length);
    }

    @Override
    public void print() {
        System.out.print(value);
    }
    @Override
    public void println() {
        System.out.println(value);
    }

    public rt.Integer length(){
        return length;
    }

    public rt.Object at$ (rt.Integer x){
        return value[x.value];
    }
}


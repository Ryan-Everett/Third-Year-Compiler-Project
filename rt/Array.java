package rt;

public class Array extends rt.Object{
    final rt.Object [] value;
    final rt.Integer length;

    public Array (rt.Integer x) {
        value = new Object[x.value] ;
        length = rt.Integer.createInt(x.value);
    }
    public Array (rt.Object [] os) {
        value = os;
        length = rt.Integer.createInt(os.length);
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
    public rt.Array at$put$ (rt.Integer i, rt.Object x){    //Note that this edits the current array instead of making a new one
        value[i.value] = x;
        return this;
    }
}


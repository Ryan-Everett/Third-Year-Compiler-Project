package rt;
//The common super class for ryantalk
public class Object {

    public Object(){
    }
    //Add a does not understand here
    public void print () {
        System.out.print(this);
    }
    public void println() {
        System.out.println(this);
    }

    //Create a String of the object
    public rt.String makeString() {
        return new rt.String(this.toString());
    }

    public rt.String concat$(rt.Object o) {
        return this.makeString().concat$(o.makeString());
    }

    public rt.Boolean eq$(rt.Object o) {
        return new rt.Boolean(this.equals(o));
    }
    public rt.Boolean neq$(rt.Object o) {
        return new rt.Boolean(!this.equals(o));
    }
}
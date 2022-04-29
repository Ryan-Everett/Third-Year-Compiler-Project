package rt;
//The common super class for ryantalk
public class Object {

    public Object(){
    }

    public rt.Object doesNotUnderstand$(rt.Object s){
        throw(new MessageNotUnderstood("MESSAGE \"" + ((rt.String) s).value + "\" NOT UNDERSTOOD"));
    }

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

    //Uncallable in my language due to prepended $, used only for perform
    public java.lang.String $getStringForPerform$() {
        return (this.makeString()).$getStringForPerform$();
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
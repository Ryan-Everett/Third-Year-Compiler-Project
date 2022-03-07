package rt;

public class String extends rt.Object {
    final java.lang.String value;

    public String(java.lang.String s) {
        value = s;
    }

    public String(rt.Integer x) {
        value = "" + x.value;
    }

    public String(rt.Char c) {
        value = "" + c.value;
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
        return this;
    }

    public rt.Char charAt$(rt.Integer x) {
        return new rt.Char(value.charAt(x.value));
    }

    public String concat$(rt.String s) {
        return new String(value.concat(s.value));
    }
}

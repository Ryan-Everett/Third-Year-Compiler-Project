package rt;

public class String extends rt.Object {
    final java.lang.String value;

    public String(java.lang.String s) {
        value = s;
    }

    @Override
    public void print() {
        System.out.print(value);
    }
    @Override
    public void println() {
        System.out.println(value);
    }

    public rt.Char charAt$(rt.Integer x) {
        return new rt.Char(value.charAt(x.value));
    }

    public String concat$(rt.String s) {
        return new String(value.concat(s.value));
    }

    public String concat$(rt.Integer x) {
        return new String(value + x.value);
    }
}

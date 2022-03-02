package rt;

public class Block extends rt.Object{
    public rt.Object value () {
        return this;
    }
    public rt.Object value$(rt.Object o1) {
        throw new BlockException("Incorrect number of args");
        //return this;
    }
    public rt.Object value$value$(rt.Object o1, rt.Object o2) {
        throw new BlockException("Incorrect number of args");
        //return this;
    }
    public rt.Object value$value$value$(rt.Object o1, rt.Object o2, rt.Object o3) {
        throw new BlockException("Incorrect number of args");
        //return this;
    }
    public rt.Object value$value$value$value$(rt.Object o1, rt.Object o2, rt.Object o3, rt.Object o4) {
        throw new BlockException("Incorrect number of args");
        //return this;
    }
    public rt.Object valueWithArguments$(rt.Object [] os) {
        return this;
    }
}

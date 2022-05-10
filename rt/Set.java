package rt;
import java.util.Arrays;
import java.util.HashSet;
public class Set extends rt.Object{
    final HashSet<rt.Object> value;
    Set(){
        value = new HashSet<>();
    }
    rt.Boolean addAll$(rt.Array arr) {
        return new rt.Boolean(value.addAll(Arrays.asList(arr.value)));
    }
    rt.Boolean add$(rt.Object o) {
        return new rt.Boolean(value.add(o));
    }
    rt.Boolean remove$(rt.Object o){
        return new rt.Boolean(value.remove(o));
    }
    rt.Boolean contains$(rt.Object o){
        return new rt.Boolean(value.contains(o));
    }
    rt.Integer length(){
        return new rt.Integer(value.size());
    }
}

package rt;
import java.util.Arrays;
import java.util.LinkedList;
public class Queue extends rt.Object{
    final LinkedList<rt.Object> value;
    Queue(){
        value = new LinkedList<>();
    }
    rt.Boolean push$(rt.Object o){
        return new rt.Boolean(value.add(o));
    } 
    rt.Boolean pushAll$(rt.Set s){
        return new rt.Boolean(value.addAll(s.value));
    }
    rt.Boolean pushAll$(rt.Array arr){
        return new rt.Boolean(value.addAll(Arrays.asList(arr.value)));
    }
    rt.Boolean remove$(rt.Object o){
        return new rt.Boolean(value.remove(o));
    }
    rt.Boolean contains$(rt.Object o){
        return new rt.Boolean(value.contains(o));
    }
    rt.Object pop(){
        return value.pop(); 
    }
    rt.Object peek(){
        return value.peek(); 
    }
    rt.Integer length(){
        return Integer.createInt(value.size());
    }
}

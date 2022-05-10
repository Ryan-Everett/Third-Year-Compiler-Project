package rt.speedtest;
import rt.speedtest.SpeedTest;
public class SpeedTester {

    public static void main(String[] args) {
        compare();
    }

    private static void compare(){
        long start2 = System.currentTimeMillis();
        SpeedTestJava s2 = new SpeedTestJava();
        long finish2 = System.currentTimeMillis();
        System.out.println("Java Took: " + (finish2 - start2) + " milliseconds");
    
        long start1 = System.currentTimeMillis();
        SpeedTest s = new SpeedTest();
        long finish1 = System.currentTimeMillis();
        System.out.println("rt Took: " + (finish1 - start1) + " milliseconds");

    }
}

class SpeedTestJava{
    SpeedTestJava(){
        System.out.println(loopCeption(4));
        //int n = 10000019;
        //while(k < n) {
          //  this.busyLoop(k);
         //   k = k + 1;
        //}
        //System.out.println("Factor of " + n + " is " + slowFactorise(n));

    }
    int loopCeption(int n) {
        int i = 1;
        int k = 0;
        if (n > 0){
            while(k < 127){
                i = i + this.loopCeption(n-1);
                k = k +1;
            }
        }
        return i;
    }
    int busyLoop(int n) {
        int k = 0;
        while (k < n){
            k = k + 1;
        }
        return n;
    }
    int slowFactorise (int n){
        int k = 1;
        while (k % n != 0) {
            k = k + 1;
        }
        return k;
    }
}

class ObjJava{
    ObjJava(){

    }
    Object doesNotUnderstand(String x) {
        return 0;
    }
}

class ObjFooJava extends ObjJava{
    ObjFooJava(){
        super();
    }
}

class ObjNoFooJava extends ObjJava{
    ObjNoFooJava(){
        super();
    }
    int foo() {
        return 1;
    }
}
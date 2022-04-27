package dependencies;
import org.dynalang.dynalink.*;
import java.lang.invoke.CallSite;
import java.lang.invoke.MethodHandle;
import java.lang.invoke.MethodHandles;
import java.lang.invoke.MethodType;
import java.util.Arrays;
import rt.Object;
import java.lang.Exception;
import org.dynalang.dynalink.CallSiteDescriptor;
import org.dynalang.dynalink.linker.GuardedInvocation;
import org.dynalang.dynalink.linker.GuardingDynamicLinker;
import org.dynalang.dynalink.linker.LinkRequest;
import org.dynalang.dynalink.linker.LinkerServices;

public class DoesNotUnderstandLinker implements GuardingDynamicLinker{
    private final MethodType dneType;
    private final MethodHandle dneHandle;

    DoesNotUnderstandLinker() throws NoSuchMethodException, IllegalAccessException{
        super();
        dneType = MethodType.methodType(rt.Object.class, rt.Object.class);
        dneHandle = MethodHandles.publicLookup().findVirtual(rt.Object.class, "doesNotUnderstand$", dneType);
    }


    /*
        Creates the invocation (method handle) used by the bootstrap when the BeansLinker fails to link.
        The BeansLinker will fail to link when the receiver doesn't understand the instruction.
        Upon a dyn:callMethod request: getGuardedInvocation will return a non-conditional invocation
        containing a method handle which when invoked will:
            Drop all parameters which it is invoked with
            Insert an rt.String with the value being the message name
            Call the message "doesNotUnderstand:" on the receiver with the String parameter

        Returns null when a request is not valid
    */
    @Override
    public GuardedInvocation getGuardedInvocation(final LinkRequest request, final LinkerServices linkerServices)
            throws Exception {
        final CallSiteDescriptor callSiteDescriptor = request.getCallSiteDescriptor();
        final int l = callSiteDescriptor.getNameTokenCount();
        //The DNE Linker can only deal with dyn:callMethod requests
        if(l < 2 || "dyn" != callSiteDescriptor.getNameToken(CallSiteDescriptor.SCHEME)
                 || "callMethod" != callSiteDescriptor.getNameToken(CallSiteDescriptor.OPERATOR)) {
            System.out.println(callSiteDescriptor.getMethodType().toString());
            final java.lang.Object receiver = request.getArguments()[1];
            System.out.println("RECIEVER + " + receiver.getClass());
            final java.lang.Object callName = request.getCallSiteDescriptor();
            //System.out.println("CallName + " + callName);
            return null;
        }
        final java.lang.Object receiver = request.getReceiver();
        System.out.println(receiver.toString());
        //We cannot operate with no receiver
        if(receiver == null) {
            return null;
        }

        final java.lang.String callName = callSiteDescriptor.getNameToken(CallSiteDescriptor.NAME_OPERAND);
        System.out.println(callSiteDescriptor.getMethodType().parameterCount() );
        final java.lang.Class[] clazzs = new java.lang.Class [callSiteDescriptor.getMethodType().parameterCount() - 1];
        final java.lang.Class clazz = (new java.lang.Object()).getClass(); //Used in the dropArgs
        Arrays.fill(clazzs, clazz);
        //Create the Invocation holding a method handle for this particular doesNotUnderstand call
        //The method handle representing this call is the dneHandle adapted to the run-time type of this particular invocation
        return (new GuardedInvocation( linkerServices.asType(
            MethodHandles.dropArguments(  //Drop all arguments except from the receiver
                MethodHandles.insertArguments(dneHandle,1,new rt.String(callName.replace("$", ":")))  //Add in the callName as a string argument
                ,1, clazzs) //Drop args starting at pos 1
            , request.getCallSiteDescriptor().getMethodType())
            , null));    //This invocation is unconditional, so we pass null as guard
    }
}

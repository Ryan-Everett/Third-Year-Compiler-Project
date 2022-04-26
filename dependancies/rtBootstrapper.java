package dependancies;
import java.lang.invoke.CallSite;
import java.lang.invoke.MethodHandles;
import java.lang.invoke.MethodType;

import org.dynalang.dynalink.support.CallSiteDescriptorFactory;
import org.dynalang.dynalink.*;
import org.dynalang.dynalink.beans.*;
import org.dynalang.dynalink.linker.*;
public class rtBootstrapper {
    private static final GuardingDynamicLinker dneLinker;
    private static final DynamicLinker dynamicLinker;
    static {
        try{
            dneLinker = new DoesNotUnderstandLinker();
        }
        //Error would only throw if rt.Object does not have a public doesNotUnderstand method
        catch (NoSuchMethodException | IllegalAccessException e){
            throw new ExceptionInInitializerError(e);
        }
        dynamicLinker = createDynamicLinker();
    }

    //Create the dynamic linker for my language run-time
    //This linker will first consult the BeansLinker, which can link any valid message calls in my objects
    //If the BeansLinker cannot link the call, the receiver cannot respond to that message, so the DoesNotUnderstand linker is consulted
    //If the DoesNotUnderstand linker cannot link the call, an error is thrown. 
    private static DynamicLinker createDynamicLinker() {
        final DynamicLinkerFactory factory = new DynamicLinkerFactory();
        factory.setPrioritizedLinker(new BeansLinker());
        factory.setFallbackLinkers(dneLinker);
        return factory.createLinker();
    }

    //The bootstrap method for all invokedynamic instructions in my language
    public static CallSite publicBootstrap(MethodHandles.Lookup caller, String name, MethodType type) {
        return dynamicLinker.link(new MonomorphicCallSite(CallSiteDescriptorFactory.create(MethodHandles.publicLookup(), name, type)));
    }
}
package dependencies;
import java.lang.invoke.CallSite;
import java.lang.invoke.MethodHandles;
import java.lang.invoke.MethodType;

import org.dynalang.dynalink.support.CallSiteDescriptorFactory;
import org.dynalang.dynalink.*;
import org.dynalang.dynalink.beans.*;
import org.dynalang.dynalink.linker.*;
public class rtBootstrapper {
    private static final DynamicLinker dynamicLinker = createDynamicLinker();

    //Create the dynamic linker for my language run-time
    //This linker will first consult the BeansLinker, which can link any valid message calls in my objects
    //If the BeansLinker cannot link the call, the receiver cannot respond to that message, so the DoesNotUnderstand linker is consulted
    //The try catch will only go off if the rt.Object didn't have a doesNotUnderstand$ method.
    //If the DoesNotUnderstand linker cannot link the call, an error is thrown. 
    private static DynamicLinker createDynamicLinker() {
        final DynamicLinkerFactory factory = new DynamicLinkerFactory();
        factory.setPrioritizedLinker(new BeansLinker());
        try{
            factory.setFallbackLinkers(new DoesNotUnderstandLinker());
        }
        catch (NoSuchMethodException | IllegalAccessException e){
            throw new ExceptionInInitializerError(e);
        }
        return factory.createLinker();
    }

    //The bootstrap method for all invokedynamic instructions in my language
    public static CallSite publicBootstrap(MethodHandles.Lookup caller, String name, MethodType type) {
        //System.out.println("Sig: " + caller.toString() + ", " + name + ", " + type.toString());
        return dynamicLinker.link(new MonomorphicCallSite(CallSiteDescriptorFactory.create(MethodHandles.publicLookup(), name, type)));
    }
}
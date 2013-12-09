package org.spicefactory.parsley.core.dynamiccontext {
import org.spicefactory.parsley.core.decorator.injection.InjectedDependency;
import org.spicefactory.parsley.util.MessageReceiverBase;

/**
 * @author Jens Halm
 */
public class DynamicTestObject extends MessageReceiverBase {
	
	public var dependency:InjectedDependency;
	
	public function handleMessage (message:Object) : void {
		addMessage(message);
	}
	
}
}

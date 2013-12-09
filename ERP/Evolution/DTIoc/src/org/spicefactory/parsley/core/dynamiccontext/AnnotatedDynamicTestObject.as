package org.spicefactory.parsley.core.dynamiccontext {
import org.spicefactory.parsley.core.decorator.injection.InjectedDependency;
import org.spicefactory.parsley.util.MessageReceiverBase;

/**
 * @author Jens Halm
 */
public class AnnotatedDynamicTestObject extends MessageReceiverBase {
	
	
	private var _dependency:InjectedDependency;
	
	public function get dependency () : InjectedDependency {
		return _dependency;
	}
	
	[Inject]
	public function set dependency (dependency:InjectedDependency) : void {
		_dependency = dependency;
	}
	
	[MessageHandler]
	public function handleMessage (message:Object) : void {
		addMessage(message);
	}
	
	
}
}

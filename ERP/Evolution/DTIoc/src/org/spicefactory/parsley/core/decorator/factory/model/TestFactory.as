package org.spicefactory.parsley.core.decorator.factory.model {
import org.spicefactory.lib.errors.IllegalStateError;
import org.spicefactory.parsley.core.decorator.injection.InjectedDependency;
import org.spicefactory.parsley.core.decorator.injection.RequiredMethodInjection;

/**
 * @author Jens Halm
 */
public class TestFactory {
	
	
	[Inject]
	public var dependency:InjectedDependency;
	
	
	public function createInstance () : RequiredMethodInjection {
		if (dependency == null) {
			throw new IllegalStateError("Dependency not injected");
		}
		return new RequiredMethodInjection();
	}
	
	
}
}

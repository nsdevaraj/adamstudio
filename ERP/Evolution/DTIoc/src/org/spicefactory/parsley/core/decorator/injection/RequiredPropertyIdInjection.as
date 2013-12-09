package org.spicefactory.parsley.core.decorator.injection {
import org.spicefactory.parsley.core.decorator.injection.InjectedDependency;

/**
 * @author Jens Halm
 */
public class RequiredPropertyIdInjection {
	
	
	[Inject(id="injectedDependency")]
	public var dependency:InjectedDependency;
	
	
}
}

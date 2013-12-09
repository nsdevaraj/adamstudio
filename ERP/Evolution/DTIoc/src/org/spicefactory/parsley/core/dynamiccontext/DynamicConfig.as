package org.spicefactory.parsley.core.dynamiccontext {
import org.spicefactory.parsley.core.decorator.injection.InjectedDependency;

/**
 * @author Jens Halm
 */
public class DynamicConfig {
	
	
	public function get dependency () : InjectedDependency {
		return new InjectedDependency();
	}
	
	
}
}

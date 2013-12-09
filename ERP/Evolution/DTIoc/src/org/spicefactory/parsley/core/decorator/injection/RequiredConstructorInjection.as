package org.spicefactory.parsley.core.decorator.injection {
import org.spicefactory.parsley.core.decorator.injection.InjectedDependency;

[InjectConstructor]
/**
 * @author Jens Halm
 */
public class RequiredConstructorInjection {
	
	
	private var _dependency:InjectedDependency;
	
	
	function RequiredConstructorInjection (dep:InjectedDependency) {
		_dependency = dep;
	}


	public function get dependency () : InjectedDependency {
		return _dependency;
	}
	
	
}
}

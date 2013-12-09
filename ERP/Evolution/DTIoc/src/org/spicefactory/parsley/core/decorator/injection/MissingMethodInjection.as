package org.spicefactory.parsley.core.decorator.injection {
import org.spicefactory.parsley.core.decorator.injection.MissingDependency;

/**
 * @author Jens Halm
 */
public class MissingMethodInjection {
	
	
	private var _dependency:MissingDependency;
	
	
	[Inject]
	public function missingMethodInjection (dep:MissingDependency) : void {
		_dependency = dep;
	}


	public function get dependency () : MissingDependency {
		return _dependency;
	}
	
	
}
}

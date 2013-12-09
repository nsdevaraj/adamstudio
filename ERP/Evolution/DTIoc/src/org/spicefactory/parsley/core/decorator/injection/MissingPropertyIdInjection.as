package org.spicefactory.parsley.core.decorator.injection {
import org.spicefactory.parsley.core.decorator.injection.MissingDependency;

/**
 * @author Jens Halm
 */
public class MissingPropertyIdInjection {
	
	
	[Inject(id="missingId")]
	public var dependency:MissingDependency;
	
	
}
}

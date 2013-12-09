package org.spicefactory.parsley.core.decorator.injection {
import org.spicefactory.parsley.core.decorator.injection.MissingDependency;

/**
 * @author Jens Halm
 */
public class OptionalPropertyInjection {
	
	
	[Inject(required="false")]
	public var dependency:MissingDependency;
	
	
}
}

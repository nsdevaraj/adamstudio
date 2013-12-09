package org.spicefactory.parsley.core.decorator.injection {
import org.spicefactory.parsley.core.decorator.injection.MissingDependency;

/**
 * @author Jens Halm
 */
public class OptionalPropertyIdInjection {
	
	
	[Inject(id="missingId", required="false")]
	public var dependency:MissingDependency;
	
	
}
}

package org.spicefactory.parsley.core.decorator.factory.model {
import org.spicefactory.parsley.core.decorator.injection.RequiredMethodInjection;

/**
 * @author Jens Halm
 */
public class TestFactoryMetadata extends TestFactory {
	
	
	[Factory]
	public override function createInstance () : RequiredMethodInjection {
		return super.createInstance();
	}
	
	
}
}

package org.spicefactory.parsley.core.decorator.factory {
import org.spicefactory.lib.errors.AbstractMethodError;
import org.spicefactory.parsley.core.ContextTestBase;
import org.spicefactory.parsley.core.context.Context;
import org.spicefactory.parsley.core.decorator.factory.model.TestFactory;
import org.spicefactory.parsley.core.decorator.injection.RequiredMethodInjection;

/**
 * @author Jens Halm
 */
public class FactoryDecoratorTestBase extends ContextTestBase {

	
	public function testFactoryWithDependency () : void {
		var context:Context = context;
		checkState(context);
		checkObjectIds(context, ["factoryWithDependency"], RequiredMethodInjection);	
		assertTrue("Expected Factory to be accessible in Context", 1, context.getObjectIds(TestFactory).length);
		var obj:RequiredMethodInjection 
				= getAndCheckObject(context, "factoryWithDependency", RequiredMethodInjection) as RequiredMethodInjection;
		assertNotNull("Missing dependency", obj.dependency);
	}
	
	public function get context () : Context {
		throw new AbstractMethodError();
	}
	
	
}
}

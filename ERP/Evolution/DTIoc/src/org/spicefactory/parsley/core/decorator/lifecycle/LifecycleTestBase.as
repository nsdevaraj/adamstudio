package org.spicefactory.parsley.core.decorator.lifecycle {
import org.spicefactory.lib.errors.AbstractMethodError;
import org.spicefactory.parsley.core.ContextTestBase;
import org.spicefactory.parsley.core.context.Context;
import org.spicefactory.parsley.core.decorator.lifecycle.model.PostConstructModel;
import org.spicefactory.parsley.core.decorator.lifecycle.model.PreDestroyModel;

/**
 * @author Jens Halm
 */
public class LifecycleTestBase extends ContextTestBase {

	
	public function testPostConstruct () : void {
		var context:Context = lifecycleContext;
		checkState(context);
		checkObjectIds(context, ["postConstructModel"], PostConstructModel);	
		var obj:PostConstructModel = context.getObject("postConstructModel") as PostConstructModel; 
		assertTrue("PostConstruct method not called", obj.methodCalled);	
	}
	
	public function testPreDestroy () : void {
		var context:Context = lifecycleContext;
		checkState(context);
		checkObjectIds(context, ["preDestroyModel"], PreDestroyModel);	
		var obj:PreDestroyModel = context.getObject("preDestroyModel") as PreDestroyModel;
		context.destroy();
		assertTrue("PreDestroy method not called", obj.methodCalled);			
	}
	
	public function get lifecycleContext () : Context {
		throw new AbstractMethodError();
	}
	
	
}
}

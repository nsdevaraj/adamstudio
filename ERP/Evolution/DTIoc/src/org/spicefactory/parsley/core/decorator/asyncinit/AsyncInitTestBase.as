package org.spicefactory.parsley.core.decorator.asyncinit {
import org.spicefactory.lib.errors.AbstractMethodError;
import org.spicefactory.parsley.core.ContextTestBase;
import org.spicefactory.parsley.core.context.Context;
import org.spicefactory.parsley.core.decorator.asyncinit.model.AsyncInitModel;

import flash.events.Event;

/**
 * @author Jens Halm
 */
public class AsyncInitTestBase extends ContextTestBase {
	
	
	
	public function testDefaultAsyncInit () : void {
		var context:Context = defaultContext;
		checkState(context, true, false);
		checkObjectIds(context, ["asyncInitModel"], AsyncInitModel);
		var model:AsyncInitModel = context.getObject("asyncInitModel") as AsyncInitModel;
		model.dispatchEvent(new Event(Event.COMPLETE));
		checkState(context, true, true);
	}
	
	
	public function testOrderedAsyncInit () : void {
		AsyncInitModel.instances = 0;
		var context:Context = orderedContext;
		checkState(context, true, false);
		checkObjectIds(context, ["asyncInitModel1", "asyncInitModel2"], AsyncInitModel);
		assertEquals("First model should be initialized", 1, AsyncInitModel.instances);
		
		var model1:AsyncInitModel = context.getObject("asyncInitModel1") as AsyncInitModel;	
		model1.dispatchEvent(new Event(Event.COMPLETE));
		checkState(context, true, false);
		assertEquals("Second model should now be initialized", 2, AsyncInitModel.instances);
		
		var model2:AsyncInitModel = context.getObject("asyncInitModel2") as AsyncInitModel;
		model2.dispatchEvent(new Event("customComplete"));
		checkState(context, true, true);
	}
	
	
	protected function get defaultContext () : Context {
		throw new AbstractMethodError();
	}
	
	protected function get orderedContext () : Context {
		throw new AbstractMethodError();
	}
	
	
}
}

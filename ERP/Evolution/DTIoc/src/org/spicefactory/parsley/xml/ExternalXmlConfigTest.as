package org.spicefactory.parsley.xml {
import org.spicefactory.parsley.core.ContextTestBase;
import org.spicefactory.parsley.core.context.Context;
import org.spicefactory.parsley.core.decorator.injection.InjectedDependency;
import org.spicefactory.parsley.core.events.ContextEvent;
import org.spicefactory.parsley.flex.mxmlconfig.core.CoreModel;

/**
 * @author Jens Halm
 */
public class ExternalXmlConfigTest extends ContextTestBase {
	
	
	public function testExternalConfig () : void {
		var context:Context = XmlContextBuilder.build("test.xml");
		checkState(context, false, false);
		var func:Function = addAsync(onContextComplete, 5000);
		context.addEventListener(ContextEvent.INITIALIZED, func);
	}	
	
	private function onContextComplete (event:ContextEvent) : void {
		var context:Context = event.target as Context;
		checkState(context);
		checkObjectIds(context, ["dependency"], InjectedDependency);	
		checkObjectIds(context, ["object"], CoreModel);	
		var obj:CoreModel 
				= getAndCheckObject(context, "object", CoreModel) as CoreModel;
		assertEquals("Unexpected string property", "foo", obj.stringProp);
		assertEquals("Unexpected int property", 7, obj.intProp);
		assertNotNull("Dependency not resolved", obj.refProp);
	}
		
		
}
}

package org.spicefactory.parsley.core.decorator.lifecycle {
import org.spicefactory.lib.errors.AbstractMethodError;
import org.spicefactory.lib.reflect.ClassInfo;
import org.spicefactory.parsley.core.ContextTestBase;
import org.spicefactory.parsley.core.context.Context;
import org.spicefactory.parsley.core.context.DynamicContext;
import org.spicefactory.parsley.core.decorator.lifecycle.model.LifecycleEventCounter;
import org.spicefactory.parsley.core.registry.impl.DefaultObjectDefinition;

import mx.containers.Box;
import mx.containers.HBox;
import mx.containers.VBox;
import mx.controls.Text;

/**
 * @author Jens Halm
 */
public class ObserveTestBase extends ContextTestBase {

	
	public function testObserveTags () : void {
		var context:Context = observeContext;
		var counter:LifecycleEventCounter = context.getObjectByType(LifecycleEventCounter) as LifecycleEventCounter;
		context.getAllObjectsByType(Box); // just trigger instantiation of lazy objects
		context.getAllObjectsByType(Text); // just trigger instantiation of lazy objects
  		assertEquals("Unexpected total count of listener invocations", 33, counter.getCount());
  		assertEquals("Unexpected total count of listeners for Text", 3, counter.getCount(Text));
  		assertEquals("Unexpected total count of listeners for Box", 6, counter.getCount(Box));
  		assertEquals("Unexpected total count of listeners for HBox", 12, counter.getCount(HBox));
  		assertEquals("Unexpected total count of listeners for VBox", 12, counter.getCount(VBox));
  		assertEquals("Unexpected total count of listeners for HBox-local", 2, counter.getCount(HBox, "local"));
  		assertEquals("Unexpected total count of listeners for HBox-custom", 4, counter.getCount(HBox, "custom"));
  		assertEquals("Unexpected total count of listeners for HBox-global", 6, counter.getCount(HBox, "global"));
  		assertEquals("Unexpected total count of listeners for Box-local", 1, counter.getCount(Box, "local"));
  		assertEquals("Unexpected total count of listeners for Box-custom", 2, counter.getCount(Box, "custom"));
  		assertEquals("Unexpected total count of listeners for Box-global", 3, counter.getCount(Box, "global"));

  		
  		assertEquals("Unexpected count of destroy listeners", 0, counter.getCount(Text, "globalDestroy"));  		var dynContext:DynamicContext = context.createDynamicContext();
  		dynContext.addDefinition(new DefaultObjectDefinition(ClassInfo.forClass(Text)));
  		dynContext.destroy();
  		assertEquals("Unexpected count of destroy listeners", 1, counter.getCount(Text, "globalDestroy"));
	}

	
	public function get observeContext () : Context {
		throw new AbstractMethodError();
	}
	
	
}
}

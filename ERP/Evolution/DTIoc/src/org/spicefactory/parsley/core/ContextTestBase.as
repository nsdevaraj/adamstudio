package org.spicefactory.parsley.core {
import flexunit.framework.TestCase;

import org.spicefactory.parsley.core.builder.CompositeContextBuilder;
import org.spicefactory.parsley.core.builder.ObjectDefinitionBuilder;
import org.spicefactory.parsley.core.builder.impl.DefaultCompositeContextBuilder;
import org.spicefactory.parsley.core.context.Context;

/**
 * @author Jens Halm
 */
public class ContextTestBase extends TestCase {
	
	
	protected function getContext (builder:ObjectDefinitionBuilder, parent:Context = null, 
			customScope:String = null, inherited:Boolean = true) : Context {
		var contextBuilder:CompositeContextBuilder = new DefaultCompositeContextBuilder(null, parent);
		contextBuilder.addBuilder(builder);
		if (customScope) {
			contextBuilder.addScope(customScope, inherited);
		}
		return contextBuilder.build();
	}
	
	
	protected function checkState (context:Context, configured:Boolean = true, initialized:Boolean = true, destroyed:Boolean = false) : void {
		assertEquals("Unexpected configured state", configured, context.configured);
		assertEquals("Unexpected initialized state", initialized, context.initialized);
		assertEquals("Unexpected destroyed state", destroyed, context.destroyed);		
	}
	
	
	protected function checkObjectIds (context:Context, expectedIds:Array, type:Class = null) : void {
		assertEquals("Unexpected number of objects", expectedIds.length, context.getObjectCount(type));
		var actualIds:Array = context.getObjectIds(type);
		actualIds.sort();
		expectedIds.sort();
		assertEquals("Unexpected number of ids", expectedIds.length, actualIds.length);
		for (var i:int = 0; i < expectedIds.length; i++) {
			assertTrue("Expected containsObject to return true", context.containsObject(expectedIds[i]));
			assertEquals("Unexpected object id", expectedIds[i], actualIds[i]);
		}
	}
	
	protected function getAndCheckObject (context:Context, id:String, expectedType:Class, 
			singleton:Boolean = true, typeUnique:Boolean = true) : Object {
		var actualType:Class = context.getType(id);
		assertEquals("Unexpected type returned by getType", expectedType, actualType);
		var obj1:Object = context.getObject(id);
		assertTrue("Unexpected type returned by getObject", (obj1 is expectedType));
		var obj2:Object;
		if (typeUnique) {
			obj2 = context.getObjectByType(expectedType);
			assertTrue("Unexpected type returned by getObjectByType", (obj2 is expectedType));
		}
		else {
			obj2 = context.getObject(id);
		}
		if (singleton) {
			assertTrue("Expected singleton instance", obj1 === obj2);
		}
		else {
			assertFalse("Expected prototype instance", obj1 === obj2);
		}
		return obj1;
	}
	
	
}
}

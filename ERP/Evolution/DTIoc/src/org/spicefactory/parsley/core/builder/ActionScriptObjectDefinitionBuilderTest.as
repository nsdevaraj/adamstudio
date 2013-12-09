package org.spicefactory.parsley.core.builder {
import org.spicefactory.parsley.asconfig.ActionScriptContextBuilder;
import org.spicefactory.parsley.core.ContextTestBase;
import org.spicefactory.parsley.core.builder.Container1;
import org.spicefactory.parsley.core.builder.Container2;
import org.spicefactory.parsley.core.context.Context;
import org.spicefactory.parsley.testmodel.ClassWithSimpleProperties;
import org.spicefactory.parsley.testmodel.LazyTestClass;

/**
 * @author Jens Halm
 */
public class ActionScriptObjectDefinitionBuilderTest extends ContextTestBase {

	
	
	public function testEmptyContext () : void {
		var context:Context = ActionScriptContextBuilder.build(EmptyContainer);
		checkState(context);
		checkObjectIds(context, []);
	}
	
	
	public function testObjectWithSimpleProperties () : void {
		var context:Context = ActionScriptContextBuilder.build(Container1);
		checkState(context);
		checkObjectIds(context, ["simpleObject"]);	
		checkObjectIds(context, ["simpleObject"], ClassWithSimpleProperties);	
		checkObjectIds(context, [], Container1);	
		var obj:ClassWithSimpleProperties = getAndCheckObject(context, "simpleObject", ClassWithSimpleProperties) as ClassWithSimpleProperties;
		assertEquals("Unexpected boolean property", true, obj.booleanProp);	
		assertEquals("Unexpected int property", 7, obj.intProp);	
		assertEquals("Unexpected String property", "foo", obj.stringProp);	
	}


	public function testOverwrittenId () : void {
		var context:Context = ActionScriptContextBuilder.build(Container2);
		checkState(context);
		checkObjectIds(context, ["foo", "prototypeInstance", "lazyInstance", "eagerInstance"]);	
		checkObjectIds(context, ["foo", "prototypeInstance"], ClassWithSimpleProperties);	
		getAndCheckObject(context, "foo", ClassWithSimpleProperties, true, false);		
	}
	
	public function testPrototypeInstance () : void {
		var context:Context = ActionScriptContextBuilder.build(Container2);
		checkState(context);
		checkObjectIds(context, ["foo", "prototypeInstance", "lazyInstance", "eagerInstance"]);	
		checkObjectIds(context, ["foo", "prototypeInstance"], ClassWithSimpleProperties);	
		getAndCheckObject(context, "prototypeInstance", ClassWithSimpleProperties, false, false);		
	}
	
	public function testLazyness () : void {
		LazyTestClass.instanceCount = 0;
		var context:Context = ActionScriptContextBuilder.build(Container2);
		checkState(context);
		checkObjectIds(context, ["foo", "prototypeInstance", "lazyInstance", "eagerInstance"]);	
		checkObjectIds(context, ["lazyInstance", "eagerInstance"], LazyTestClass);
		assertEquals("Unexpected object count", 1, LazyTestClass.instanceCount);	
		getAndCheckObject(context, "lazyInstance", LazyTestClass, true, false);		
		assertEquals("Unexpected object count", 2, LazyTestClass.instanceCount);	
		getAndCheckObject(context, "eagerInstance", LazyTestClass, true, false);		
		assertEquals("Unexpected object count", 2, LazyTestClass.instanceCount);	
	}
	
	public function testMergeTwoContainers () : void {
		var context:Context = ActionScriptContextBuilder.buildAll([Container1, Container2]);
		checkState(context);
		checkObjectIds(context, ["simpleObject", "foo", "prototypeInstance", "lazyInstance", "eagerInstance"]);	
		checkObjectIds(context, ["simpleObject", "foo", "prototypeInstance"], ClassWithSimpleProperties);	
	}
	
	public function testGetAllObjectsByType () : void {
		var context:Context = ActionScriptContextBuilder.buildAll([Container1, Container2]);
		checkState(context);
		checkObjectIds(context, ["simpleObject", "foo", "prototypeInstance", "lazyInstance", "eagerInstance"]);	
		checkObjectIds(context, ["simpleObject", "foo", "prototypeInstance"], ClassWithSimpleProperties);
		var cnt:int = context.getObjectCount(ClassWithSimpleProperties);	
		assertEquals("Unexpected object count", 3, cnt);	
		var objects:Array = context.getAllObjectsByType(ClassWithSimpleProperties);
		assertEquals("Unexpected object count", 3, objects.length);	
		for each (var obj:Object in objects) {
			assertTrue("Unexpected object type", obj is ClassWithSimpleProperties);	
		}
	}
	
	
}
}

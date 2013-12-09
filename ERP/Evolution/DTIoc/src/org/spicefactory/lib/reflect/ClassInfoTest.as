package org.spicefactory.lib.reflect {
import org.spicefactory.lib.errors.IllegalStateError;
import org.spicefactory.lib.reflect.model.ClassB;
import org.spicefactory.lib.reflect.model.InterfaceA;
import org.spicefactory.lib.reflect.model.InternalSubclass;
import org.spicefactory.lib.reflect.model.TestProxy;
import org.spicefactory.lib.reflect.types.Any;
import org.spicefactory.lib.reflect.types.Private;
import org.spicefactory.lib.reflect.types.Void;

import mx.collections.ArrayCollection;

import flash.display.Loader;
import flash.display.LoaderInfo;
import flash.display.Sprite;
import flash.events.Event;
import flash.net.URLRequest;
import flash.system.ApplicationDomain;
import flash.utils.getQualifiedClassName;

public class ClassInfoTest extends ReflectionTestBase {
	
	
	public function testModel () : void {
		var ci:ClassInfo = ClassInfo.forClass(ClassB);
		// TODO - check inconsistencies with ::
		assertEquals("Unexpected class name", "org.spicefactory.lib.reflect.model::ClassB", ci.name);
		assertEquals("Unexpected class", ClassB, ci.getClass());
		assertFalse("Test Class is not an interface", ci.isInterface());
		assertEquals("Unexpected number of properties", 8, ci.getProperties().length);
		assertEquals("Unexpected number of static properties", 2, ci.getStaticProperties().length);
		assertEquals("Unexpected number of methods", 3, ci.getMethods().length);
		assertEquals("Unexpected number of static methods", 2, ci.getStaticMethods().length);
		checkProperty(ci, "stringVar", String, false, true, true);
		checkProperty(ci, "booleanVar", Boolean, false, true, true);
		checkProperty(ci, "uintVar", uint, false, true, false );
		checkProperty(ci, "untyped", Any, false, true, true);
		checkProperty(ci, "anything", Any, false, true, true);
		checkProperty(ci, "readOnlyProperty", String, false, true, false);
		checkProperty(ci, "readWriteProperty", String, false, true, true);
		checkProperty(ci, "booleanProperty", Boolean, false, true, true);
		//checkProperty(ci, "classVar", Class, true, true, false);
		checkProperty(ci, "staticReadOnlyProperty", XML, true, true, false);
		checkMethod(ci, "methodNoParams", Void, [], false);
		checkMethod(ci, "methodWithOptionalParam", Boolean, 
				[new Parameter(ClassInfo.forClass(String), true), 
				new Parameter(ClassInfo.forClass(uint), false)], false);
		checkMethod(ci, "methodWithPrivateClassReturnValue", Private, [], false);
		checkMethod(ci, "staticMethod", Void, [new Parameter(ClassInfo.forClass(Boolean), true)], true);
	}
	
	public function testInterface () : void {
		var ci:ClassInfo = ClassInfo.forClass(InterfaceA);
		assertTrue("Expected Interface", ci.isInterface());
	}
	
	public function testInternalSuperclass () : void {
		var ci:ClassInfo = ClassInfo.forClass(InternalSubclass);
		var type:Class = ci.getSuperClass();
		assertEquals("Expected private superclass", Private, type);
		assertEquals("Expected Object base class", Object, ci.getSuperClasses()[1]);
	}
	
	
	private function checkProperty (ci:ClassInfo, name:String, type:Class,
			isStatic:Boolean, readable:Boolean, writable:Boolean) : void {
		var p:Property = (!isStatic) ? ci.getProperty(name) : ci.getStaticProperty(name);
		assertNotNull("Expected Property instance with name " + name, p);			
		assertEquals("Unexpected name", name, p.name);
		assertEquals("Unexpected type", type, p.type.getClass());
		assertEquals("Unexpected static flag", isStatic, p.isStatic);
		assertEquals("Unexpected readable flag", readable, p.readable);
		assertEquals("Unexpected writable flag", writable, p.writable);
	}
	
	private function checkMethod (ci:ClassInfo, name:String,
			returnType:Class, params:Array, isStatic:Boolean) : void {
		var m:Method = (!isStatic) ? ci.getMethod(name) : ci.getStaticMethod(name);			
		assertNotNull("Expected Method instance with name " + name, m);			
		assertEquals("Unexpected name", name, m.name);
		assertEquals("Unexpected static flag", isStatic, m.isStatic);
		assertEquals("Unexpected return type", returnType, m.returnType.getClass());
		var actualParams:Array = m.parameters;
		assertEquals("Unexpected parameter count", params.length, actualParams.length);
		var i:uint = 0;
		for each (var expectedParam:Parameter in params) {
			var actualParam:Parameter = actualParams[i++] as Parameter;
			assertEquals("Unexpected parameter type at index " + i, expectedParam.type, actualParam.type); 
			assertEquals("Unexpected required flag at index " + i, expectedParam.required, actualParam.required); 
		}				
	}
	
	
	public function testCache () : void {
		var ci1:ClassInfo = ClassInfo.forClass(ClassB);
		var ci2:ClassInfo = ClassInfo.forClass(ClassB);
		assertEquals("Expected cached ClassInfo instance", ci1, ci2);
	}
	
	public function testCacheWithName () : void {
		var name:String = getQualifiedClassName(ClassB);
		var ci1:ClassInfo = ClassInfo.forName(name);
		var ci2:ClassInfo = ClassInfo.forName(name);
		assertEquals("Expected cached ClassInfo instance", ci1, ci2);
	}
	
	public function testNewInstance () : void {
		var ci:ClassInfo = ClassInfo.forClass(ClassB);
		var classB:ClassB = ci.newInstance(["test"]) as ClassB;
		assertEquals("Unexpected property value", "test", classB.readOnlyProperty);
	}
	
	public function testNewInstanceForInterface () : void {
		var ci:ClassInfo = ClassInfo.forClass(InterfaceA);
		try {
			ci.newInstance([]);
		} catch (e:IllegalStateError) {
			return;
		}
		fail("Expected IllegalStateError");
	}
	
	public function testApplicationDomain () : void {
		assertFalse("Unexpected definition in current domain",
				ApplicationDomain.currentDomain.hasDefinition("org.spicefactory.lib.reflect.domain.ClassInChildDomain"));
		var loader:Loader = new Loader();
		loader.load(new URLRequest("domain.swf"));
		loader.contentLoaderInfo.addEventListener(Event.COMPLETE, addAsync(onTestApplicationDomain, 3000));
	}
	
	private function onTestApplicationDomain (event:Event) : void {
		var loaderInfo:LoaderInfo = LoaderInfo(event.target);
		var className:String = "org.spicefactory.lib.reflect.domain.ClassInChildDomain";
		try {
			ClassInfo.forName(className);
		}
		catch (e:Error) {
			assertTrue("Expected ReferenceError", (e is ReferenceError));
			// Now try with the child domain
			var ci:ClassInfo = ClassInfo.forName(className, loaderInfo.applicationDomain);
			assertEquals("Unexpected superclass", Sprite, ci.getSuperClass());
			return;
		}
		fail("Expected error in attempt to load class from parent domain");
	}
	
	public function testProxy () : void {
		var o:Object = new TestProxy();
		var ci:ClassInfo = ClassInfo.forInstance(o);
		assertEquals("Unexpected simple name", "TestProxy", ci.simpleName);
		assertEquals("Unexpected superclass", "flash.utils::Proxy", getQualifiedClassName(ci.getSuperClass()));
	}
	
	public function testArrayCollection () : void {
		var o:Object = new ArrayCollection();
		var ci:ClassInfo = ClassInfo.forInstance(o);
		assertEquals("Unexpected simple name", "ArrayCollection", ci.simpleName);
	}
	
	public function testNumbers () : void {
		var n1:Number = 3.45;
		var n2:int = -4;
		var n3:uint = 4;
		
		assertEquals("Unexpected class name", "Number", ClassInfo.forInstance(n1).name);		
		assertEquals("Unexpected class name", "int", ClassInfo.forInstance(n2).name);		
		assertEquals("Unexpected class name", "int", ClassInfo.forInstance(n3).name);
	}
	
	
}

}
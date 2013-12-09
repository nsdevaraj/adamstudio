package org.spicefactory.lib.reflect {

import flexunit.framework.TestCase;

import org.spicefactory.lib.reflect.errors.ConversionError;
import org.spicefactory.lib.reflect.errors.PropertyError;
import org.spicefactory.lib.reflect.model.ClassB;
	
	
public class PropertyTest extends TestCase {


	private var classBInfo:ClassInfo;
	private var classBInstance:ClassB;
	
	
	public override function setUp () : void {
		super.setUp();
		classBInfo = ClassInfo.forClass(ClassB);
		classBInstance = new ClassB("foo");
	}

	
	public function testReadBooleanProperty () : void {
		var p:Property = classBInfo.getProperty("booleanVar");
		var value:Boolean = p.getValue(classBInstance);
		assertEquals("Unexpected property value", false, value);
	}
	
	public function testReadStringProperty () : void {
		var p:Property = classBInfo.getProperty("readOnlyProperty");
		var value:String = p.getValue(classBInstance);
		assertEquals("Unexpected property value", "foo", value);
	}
	
	public function testWriteReadOnlyProperty () : void {
		try {
			var p:Property = classBInfo.getProperty("readOnlyProperty");
			p.setValue(classBInstance, "someValue");
		} catch (e:PropertyError) {
			return;
		}
		fail("Expected PropertyError");
	}
	
	public function testWriteIllegalPropertyType () : void {
		try {
			var p:Property = classBInfo.getProperty("booleanProperty");
			p.setValue(classBInstance, new Date());
		} catch (e:ConversionError) {
			return;
		}
		fail("Expected ConversionError");
	}
	

}

}
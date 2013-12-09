package org.spicefactory.lib.reflect {
import org.spicefactory.lib.reflect.mapping.ValidationError;

import flexunit.framework.TestCase;

import org.spicefactory.lib.reflect.metadata.EventInfo;
import org.spicefactory.lib.reflect.model.ClassC;
import org.spicefactory.lib.reflect.model.ClassE;
import org.spicefactory.lib.reflect.model.InterfaceB;
import org.spicefactory.lib.reflect.model.TestMetadata1;
import org.spicefactory.lib.reflect.model.TestMetadata2;
import org.spicefactory.lib.reflect.model.TestMetadata3;

import flash.display.Sprite;

public class MetadataTest extends TestCase {
	
	
	private var classCInfo:ClassInfo;
	
	
	public override function setUp () : void {
		super.setUp();
		new ClassC(""); // needed to avoid Flash Player bug that does report '*' as type for
		                // all constructor parameters if the class was not instantiated at least once.
		Metadata.registerMetadataClass(TestMetadata1);
		Metadata.registerMetadataClass(TestMetadata2);
		Metadata.registerMetadataClass(TestMetadata3);
		classCInfo = ClassInfo.forClass(ClassC);
	}
	
	
	public function testClassMetadata () : void {
		var meta:Array = classCInfo.getMetadata(EventInfo);
		assertEquals("Unexpected number of metadata tags", 3, meta.length);
		meta.sortOn("name");
		checkEventInfo(meta[0], "start", "TaskEvent");
		checkEventInfo(meta[1], "start2", "");
		checkEventInfo(meta[2], "start3", "");
	}
	
	private function checkEventInfo (meta:*, expectedName:String, expectedType:String) : void {
		assertTrue("Unexpected type for metadata", meta is EventInfo);
		var ei:EventInfo = EventInfo(meta);
		assertEquals("Unexpected value for name property", expectedName, ei.name);
		assertEquals("Unexpected value for type property", expectedType, ei.type);
	}
	
	public function testVarMetadata () : void {
		var p:Property = classCInfo.getProperty("optionalProperty");
		var meta:Array = p.getMetadata("TestMetadata");
		assertEquals("Unexpected number of metadata tags", 1, meta.length);
		assertTrue("Unexpected type for metadata", meta[0] is Metadata);
	}
	
	public function testConstMetadata () : void {
		var p:Property = classCInfo.getProperty("aConst");
		var meta:Array = p.getMetadata("TestMetadata");
		assertEquals("Unexpected number of metadata tags", 1, meta.length);
		assertTrue("Unexpected type for metadata", meta[0] is Metadata);
	}
	
	public function testMappedPropertyMetadata () : void {
		var p:Property = classCInfo.getProperty("requiredProperty");
		var meta:Array = p.getMetadata(TestMetadata1);
		assertEquals("Unexpected number of metadata tags", 1, meta.length);
		assertTrue("Unexpected type for metadata", meta[0] is TestMetadata1);
		var mapped:TestMetadata1 = TestMetadata1(meta[0]);
		assertEquals("Unexpected value for metadata property", "A", mapped.stringProp);
		assertEquals("Unexpected value for metadata property", 5, mapped.intProp);		
	}
	
	public function testMappedInterfaceMethodMetadata () : void {
		var interfaceInfo:ClassInfo = ClassInfo.forClass(InterfaceB);
		var m:Method = interfaceInfo.getMethod("method");
		var meta:Array = m.getMetadata(TestMetadata1);
		assertEquals("Unexpected number of metadata tags", 1, meta.length);
		assertTrue("Unexpected type for metadata", meta[0] is TestMetadata1);
		var mapped:TestMetadata1 = TestMetadata1(meta[0]);
		assertEquals("Unexpected value for metadata property", "A", mapped.stringProp);
		assertEquals("Unexpected value for metadata property", 1, mapped.intProp);	
	}
	
	public function testMappedInterfaceTypeMetadata () : void {
		var interfaceInfo:ClassInfo = ClassInfo.forClass(InterfaceB);
		var meta:Array = interfaceInfo.getMetadata(TestMetadata1);
		assertEquals("Unexpected number of metadata tags", 1, meta.length);
		assertTrue("Unexpected type for metadata", meta[0] is TestMetadata1);
		var mapped:TestMetadata1 = TestMetadata1(meta[0]);
		assertEquals("Unexpected value for metadata property", "A", mapped.stringProp);
		assertEquals("Unexpected value for metadata property", 1, mapped.intProp);	
	}

	public function testMappedDefaultProperty () : void {
		var p:Property = classCInfo.getProperty("testDefaultValue");
		var meta:Array = p.getMetadata(TestMetadata1);
		assertEquals("Unexpected number of metadata tags", 1, meta.length);
		assertTrue("Unexpected type for metadata", meta[0] is TestMetadata1);
		var mapped:TestMetadata1 = TestMetadata1(meta[0]);
		assertEquals("Unexpected value for metadata property", "defaultValue", mapped.stringProp);
		assertEquals("Unexpected value for metadata property", 0, mapped.intProp);		
	}

	public function testMethodMetadata () : void {
		var method:Method = classCInfo.getMethod("methodWithMetadata");
		var meta:Array = method.getMetadata("TestMetadata");
		assertEquals("Unexpected number of metadata tags", 2, meta.length);
		assertTrue("Unexpected type for metadata", meta[0] is Metadata);
		assertTrue("Unexpected type for metadata", meta[1] is Metadata);
		meta.sort(function (item1:Metadata, item2:Metadata) : int { 
			return (item1.getDefaultArgument() > item2.getDefaultArgument()) ? -1 : 1;
		});
		var m:Metadata = Metadata(meta[0]);
		assertEquals("Unexpected value for metadata property", "someValue", m.getArgument(""));
		assertEquals("Unexpected value for default property", "someValue", m.getDefaultArgument());
		m = Metadata(meta[1]);
		assertEquals("Unexpected value for metadata property", "someOtherValue", m.getArgument(""));
		assertEquals("Unexpected value for default property", "someOtherValue", m.getDefaultArgument());
	}
	
	public function testDuplicateMappedMetadata () : void {
		var method:Method = classCInfo.getMethod("methodWithMappedMetadata");
		var meta:Array = method.getMetadata(TestMetadata1);
		assertEquals("Unexpected number of metadata tags", 2, meta.length);
		assertTrue("Unexpected type for metadata", meta[0] is TestMetadata1);
		assertTrue("Unexpected type for metadata", meta[1] is TestMetadata1);
		meta.sortOn("stringProp");
		var mapped:TestMetadata1 = TestMetadata1(meta[0]);
		assertEquals("Unexpected value for metadata property", "A", mapped.stringProp);
		assertEquals("Unexpected value for metadata property", 1, mapped.intProp);	
		mapped = TestMetadata1(meta[1]);
		assertEquals("Unexpected value for metadata property", "B", mapped.stringProp);
		assertEquals("Unexpected value for metadata property", 2, mapped.intProp);		
	}
	
	public function testMetadataWithRestrictedMetadata () : void {
		// Metadata only mapped for properties and methods
		var method:Method = classCInfo.getMethod("methodWithRestrictedMetadata");
		var meta:Array = method.getMetadata(TestMetadata2);
		assertEquals("Unexpected number of metadata tags", 1, meta.length);
		assertTrue("Unexpected type for metadata", meta[0] is TestMetadata2);
		var mapped:TestMetadata2 = TestMetadata2(meta[0]);
		assertTrue("Expected Array as default property value", (mapped.arrayProp is Array));
		var a:Array = mapped.arrayProp as Array;
		assertEquals("Unexpected Array length", 2, a.length);
		assertEquals("Unexpected Array element", "a", a[0]);
		assertEquals("Unexpected Array element", "b", a[1]);
		
		meta = classCInfo.getMetadata(TestMetadata2);
		assertEquals("Expected no mapped metadata tags", 0, meta.length);
		meta = classCInfo.getMetadata("TestMetadata2");
		assertEquals("Unexpected number of metadata tags", 1, meta.length);
		assertTrue("Unexpected type for metadata", meta[0] is Metadata);
		var metadata:Metadata = Metadata(meta[0]);
		// Without mapping no Array conversion should occur
		assertEquals("Unexpected default property value", "a,b", metadata.getDefaultArgument());
	}
	
	public function testAssignableToAndRequired () : void {
		var meta:TestMetadata3 = getMetadata3Tag("valid");
		assertEquals("Unexpected type property", Sprite, meta.type);
		assertEquals("Unexpected count property", 5, meta.count);
	}

	public function testMissingRequiredValue () : void {
		expectError("invalid1");
	}
		
	public function testIllegalClassValue () : void {
		expectError("invalid2");
	}
	
	public function testIllegalMultipleOccurrences () : void {
		expectError("invalid3");
	}
	
	public function testValidationTurnedOff () : void {
		var meta:TestMetadata3 = getMetadata3Tag("invalid1", false);
		assertEquals("Unexpected type property", Sprite, meta.type);
		assertEquals("Unexpected count property", 0, meta.count);
	}

	
	private function getMetadata3Tag (propName:String, validate:Boolean = true) : TestMetadata3 {
		var meta:Array = ClassInfo.forClass(ClassE).getProperty(propName).getMetadata(TestMetadata3, validate);
		assertEquals("Unexpected number of metadata tags", 1, meta.length);
		return meta[0] as TestMetadata3;
	}
	
	private function expectError (propName:String) : void {
		try {
			getMetadata3Tag(propName);
		} 
		catch (e:ValidationError) {
			return;
		}
		fail("Expected Error");
	}
	
	
}

}
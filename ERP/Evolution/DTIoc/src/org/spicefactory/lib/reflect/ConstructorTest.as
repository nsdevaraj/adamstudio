package org.spicefactory.lib.reflect {
import org.spicefactory.lib.reflect.errors.ConversionError;
import org.spicefactory.lib.reflect.errors.MethodInvocationError;
import org.spicefactory.lib.reflect.model.ClassC;
import org.spicefactory.lib.reflect.model.TestMetadata1;
import org.spicefactory.lib.reflect.model.TestMetadata2;

import flexunit.framework.TestCase;

public class ConstructorTest extends TestCase {
	
	
	private var classCInfo:ClassInfo;
	
	
	public override function setUp () : void {
		super.setUp();
		new ClassC(""); // needed to avoid Flash Player bug that does report '*' as type for
		                // all constructor parameters if the class was not instantiated at least once.
		Metadata.registerMetadataClass(TestMetadata1);
		Metadata.registerMetadataClass(TestMetadata2);
		classCInfo = ClassInfo.forClass(ClassC);
	}
	
	
	public function testConstructorWithOptionalParam () : void {
		var c:Constructor = classCInfo.getConstructor();
		var i:ClassC = ClassC(c.newInstance(["bar", 27]));
		assertNotNull("Expected instance of ClassC", i);
		assertEquals("Unexpected value for required parameter", "bar", i.requiredProperty);
		assertEquals("Unexpected value for optional parameter", 27, i.optionalProperty);
	}
	
	public function testConstructorWithoutOptionalParam () : void {
		var c:Constructor = classCInfo.getConstructor();
		var i:ClassC = ClassC(c.newInstance(["bar"]));
		assertNotNull("Expected instance of ClassC", i);
		assertEquals("Unexpected value for required parameter", "bar", i.requiredProperty);
		assertEquals("Unexpected value for optional parameter", 0, i.optionalProperty);
	}
	
	public function testIllegalParameterCount () : void {
		try {
			classCInfo.getConstructor().newInstance(["bar", 15, 15]);
		} catch (e:MethodInvocationError) {
			return;
		}
		fail("Expected MethodInvocationError");
	}
	
	public function testIllegalParameterType () : void {
		try {
			classCInfo.getConstructor().newInstance(["bar", "foo"]);
		} catch (e:ConversionError) {
			return;
		}
		fail("Expected ConversionError");
	}
	
	
}

}
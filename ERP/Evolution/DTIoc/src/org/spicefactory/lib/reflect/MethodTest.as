package org.spicefactory.lib.reflect {
import flexunit.framework.TestCase;

import org.spicefactory.lib.reflect.errors.ConversionError;
import org.spicefactory.lib.reflect.errors.MethodInvocationError;
import org.spicefactory.lib.reflect.model.ClassB;
import org.spicefactory.lib.reflect.model.ClassD;

public class MethodTest extends TestCase {
	
	
	private var classBInfo:ClassInfo;
	
	
	public override function setUp () : void {
		super.setUp();
		classBInfo = ClassInfo.forClass(ClassB);
	}
	
	
	public function testMethodWithOptionalParam () : void {
		var m:Method = classBInfo.getMethod("methodWithOptionalParam");
		var target:ClassB = new ClassB("foo");
		var returnValue:* = m.invoke(target, ["bar", 27]);
		assertEquals("Unexpected return value", true, returnValue);
	}
	
	public function testMethodWithoutOptionalParam () : void {
		var m:Method = classBInfo.getMethod("methodWithOptionalParam");
		var target:ClassB = new ClassB("foo");
		var returnValue:* = m.invoke(target, ["bar"]);
		assertEquals("Unexpected return value", false, returnValue);
	}
	
	public function testMethodWithVarArgs () : void {
		var ci:ClassInfo = ClassInfo.forClass(ClassD);
		var m:Method = ci.getMethod("withVarArgs");
		assertEquals("Unexpected parameter count", 1, m.parameters.length);
		var result:int = m.invoke(new ClassD(), ["foo", 0, 0, 0]);
		assertEquals("Unexpected return value", 3, result);
	}
	
	public function testMethodWithUntypedParam () : void {
		var ci:ClassInfo = ClassInfo.forClass(ClassD);
		var m:Method = ci.getMethod("withUntypedParam");
		var result:* = m.invoke(new ClassD(), ["foo"]);
		assertEquals("Unexpected return value", "foo", result);		
	}
	
	public function testStaticMethodInvocation () : void {
		var m:Method = classBInfo.getStaticMethod("staticMethod");
		m.invoke(null, [false]);
		assertEquals("Unexpected invocationCount", 1, ClassB.getStaticMethodCounter());
	}
	
	public function testIllegalParameterCount () : void {
		try {
			var m:Method = classBInfo.getMethod("methodWithOptionalParam");
			var target:ClassB = new ClassB("foo");
			m.invoke(target, ["bar", 15, 15]);
		} catch (e:MethodInvocationError) {
			return;
		}
		fail("Expected MethodInvocationError");
	}
	
	public function testIllegalParameterType () : void {
		try {
			var m:Method = classBInfo.getMethod("methodWithOptionalParam");
			var target:ClassB = new ClassB("foo");
			m.invoke(target, ["bar", "illegal"]);
		} catch (e:ConversionError) {
			return;
		}
		fail("Expected ConversionError");
	}
	
}

}
package org.spicefactory.lib.reflect {

import org.spicefactory.lib.reflect.converter.BooleanConverter;
import org.spicefactory.lib.reflect.converter.ClassConverter;
import org.spicefactory.lib.reflect.converter.ClassInfoConverter;
import org.spicefactory.lib.reflect.converter.DateConverter;
import org.spicefactory.lib.reflect.converter.IntConverter;
import org.spicefactory.lib.reflect.converter.NumberConverter;
import org.spicefactory.lib.reflect.converter.StringConverter;
import org.spicefactory.lib.reflect.converter.UintConverter;
import org.spicefactory.lib.reflect.errors.ConversionError;
	
	
public class ConverterTest extends ReflectionTestBase {
	

	public function testInt () : void {
		assertEquals("Unexcpected result", 345, IntConverter.INSTANCE.convert("345"));
	}
	
	public function testIllegalInt () : void {
		try {
			IntConverter.INSTANCE.convert("5a");
		} catch (e:ConversionError) {
			return;
		}
		fail("Expected ConversionError");
	}
	
	public function testUint () : void {
		assertEquals("Unexcpected result", 345, UintConverter.INSTANCE.convert("345"));
	}
	
	public function testFloatToUint () : void {
		assertEquals("Unexcpected result", 7, UintConverter.INSTANCE.convert("7.8"));
	}
	
	public function testNegativeToUint () : void {
		assertEquals("Unexcpected result", 4294967273, UintConverter.INSTANCE.convert("-23"));
	}
	
	public function testIllegalUint () : void {
		try {
			UintConverter.INSTANCE.convert("5 5");
		} catch (e:ConversionError) {
			return;
		}
		fail("Expected ConversionError");
	}
	
	public function testNumber () : void {
		assertEquals("Unexcpected result", 345, NumberConverter.INSTANCE.convert("345"));
	}	
	
	public function testFloatNumber () : void {
		var result:Number = NumberConverter.INSTANCE.convert("7.8");
		if (Math.abs(result - 7.8) > 0.01) {
			fail("Unexpected result, expected <7.8> - got <" + result + ">");
		}
	}
	
	public function testIllegalNumber () : void {
		try {
			NumberConverter.INSTANCE.convert("a5");
		} catch (e:ConversionError) {
			return;
		}
		fail("Expected ConversionError");
	}	
	
	public function testBooleanTrue () : void {
		assertEquals("Unexcpected result", true, BooleanConverter.INSTANCE.convert("true"));
	}
	
	public function testBooleanFalse () : void {
		assertEquals("Unexcpected result", false, BooleanConverter.INSTANCE.convert("false"));
	}
	
	public function testIllegalBoolean () : void {
		try {
			BooleanConverter.INSTANCE.convert("hallo");
		} catch (e:ConversionError) {
			return;
		}
		fail("Expected ConversionError");
	}
	
	public function testString () : void {
		var d:Date = new Date();
		var ds:String = d.toString();
		assertEquals("Unexcpected result", ds, StringConverter.INSTANCE.convert(d));
	}
	
	public function testDate () : void {
		var s:String = "2002-12-11";
		var d:Date = DateConverter.INSTANCE.convert(s);
		assertEquals("Unexpected year", 2002, d.fullYear);
		assertEquals("Unexpected month", 11, d.month);
		assertEquals("Unexpected day", 11, d.date);
		assertEquals("Unexpected hour", 0, d.hours);
		assertEquals("Unexpected minute", 0, d.minutes);
		assertEquals("Unexpected second", 0, d.seconds);
	}
	
	public function testDateTime () : void {
		var s:String = "2002-12-11 13:17:24";
		var d:Date = DateConverter.INSTANCE.convert(s);
		assertEquals("Unexpected year", 2002, d.fullYear);
		assertEquals("Unexpected month", 11, d.month);
		assertEquals("Unexpected day", 11, d.date);
		assertEquals("Unexpected hour", 13, d.hours);
		assertEquals("Unexpected minute", 17, d.minutes);
		assertEquals("Unexpected second", 24, d.seconds);
	}
	
	public function testTime () : void {
		var time:Number = new Date(2002, 11, 11, 13, 17, 24).time;
		var d:Date = DateConverter.INSTANCE.convert(time);
		assertEquals("Unexpected year", 2002, d.fullYear);
		assertEquals("Unexpected month", 11, d.month);
		assertEquals("Unexpected day", 11, d.date);
		assertEquals("Unexpected hour", 13, d.hours);
		assertEquals("Unexpected minute", 17, d.minutes);
		assertEquals("Unexpected second", 24, d.seconds);
	}
	
	public function testIllegalDate () : void {
		try {
			DateConverter.INSTANCE.convert("2009-12-12-15 23,12");
		} catch (e:ConversionError) {
			return;
		}
		fail("Expected ConversionError");
	}
	
	public function testClass () : void {
		assertEquals("Unexcpected result", Property, ClassConverter.INSTANCE.convert("org.spicefactory.lib.reflect.Property"));
	}
	
	public function testIllegalClass () : void {
		try {
			ClassConverter.INSTANCE.convert("org.spicefactory.lib.reflect.Broperty");
		} catch (e:ConversionError) {
			return;
		}
		fail("Expected ConversionError");
	}
	
	public function testClassInfo () : void {
		var ci:ClassInfo = new ClassInfoConverter().convert("org.spicefactory.lib.reflect.Property");
		assertEquals("Unexcpected result", Property, ci.getClass());
	}
	
	public function testClassInfoWithRequiredType () : void {
		var requiredType:ClassInfo = ClassInfo.forClass(Property);
		var ci:ClassInfo = new ClassInfoConverter(requiredType).convert("org.spicefactory.lib.reflect.Property");
		assertEquals("Unexcpected result", Property, ci.getClass());
	}
	
	public function testClassInfoNotOfRequiredType () : void {
		try {
			var requiredType:ClassInfo = ClassInfo.forClass(Property);
			new ClassInfoConverter(requiredType).convert("org.spicefactory.lib.reflect.Converter");
		} catch (e:ConversionError) {
			return;
		}
		fail("Expected ConversionError");
	}
	
	
}

}
package org.spicefactory.lib.xml {
import flexunit.framework.TestCase;

import org.spicefactory.lib.xml.mapper.Choice;
import org.spicefactory.lib.xml.mapper.PropertyMapperBuilder;
import org.spicefactory.lib.xml.model.ChildA;
import org.spicefactory.lib.xml.model.ChildB;
import org.spicefactory.lib.xml.model.ClassWithChild;
import org.spicefactory.lib.xml.model.ClassWithChildren;
import org.spicefactory.lib.xml.model.SimpleClass;

import flash.events.Event;
import flash.utils.Dictionary;

/**
 * @author Jens Halm
 */
public class PropertyMapperTest extends TestCase {
	
	
	public function testAttributeMapper () : void {
		var xml:XML = <tag boolean-prop="true" string-prop="foo" int-prop="7" class-prop="flash.events.Event"/>;
		var builder:PropertyMapperBuilder = new PropertyMapperBuilder(SimpleClass, new QName("tag"));
		builder.mapAllToAttributes();
		var mapper:XmlObjectMapper = builder.build();
		var obj:Object = mapper.mapToObject(xml, new XmlProcessorContext());
		assertTrue("Expected instance of SimpleClass", obj is SimpleClass);
		var sc:SimpleClass = SimpleClass(obj);
		assertEquals("Unexpected String Property", "foo", sc.stringProp);
		assertEquals("Unexpected int Property", 7, sc.intProp);
		assertEquals("Unexpected Boolean Property", true, sc.booleanProp);
		assertEquals("Unexpected Class Property", Event, sc.classProp);
	}
	
	public function testAttributeMapperWithMissingOptionalAttr () : void {
		var xml:XML = <tag boolean-prop="true" string-prop="foo" int-prop="7"/>;
		var builder:PropertyMapperBuilder = new PropertyMapperBuilder(SimpleClass, new QName("tag"));
		builder.mapAllToAttributes();
		var mapper:XmlObjectMapper = builder.build();
		var obj:Object = mapper.mapToObject(xml, new XmlProcessorContext());
		assertTrue("Expected instance of SimpleClass", obj is SimpleClass);
		var sc:SimpleClass = SimpleClass(obj);
		assertEquals("Unexpected String Property", "foo", sc.stringProp);
		assertEquals("Unexpected int Property", 7, sc.intProp);
		assertEquals("Unexpected Boolean Property", true, sc.booleanProp);
		assertEquals("Unexpected Class Property", null, sc.classProp);
	}
	
	public function testAttributeMapperWithMissingRequiredAttr () : void {
		var xml:XML = <tag boolean-prop="true" int-prop="7"/>;
		var builder:PropertyMapperBuilder = new PropertyMapperBuilder(SimpleClass, new QName("tag"));
		builder.mapAllToAttributes();
		var mapper:XmlObjectMapper = builder.build();
		var context:XmlProcessorContext = new XmlProcessorContext();
		try {
			mapper.mapToObject(xml, context);
		} catch (e:MappingError) {
			assertTrue("Expected context with errors", context.hasErrors());
			assertEquals("Unexpected number of errors", 1, context.errors.length);
			return;
		}
		fail("Expected mapping error");
	}
	
	public function testTextNodeMapper () : void {
		var xml:XML = <tag>
			<string-prop>foo</string-prop>
			<int-prop>7</int-prop>
			<boolean-prop>true</boolean-prop>
			<class-prop>flash.events.Event</class-prop>
		</tag>;
		var builder:PropertyMapperBuilder = new PropertyMapperBuilder(SimpleClass, new QName("tag"));
		builder.mapAllToChildTextNodes();
		var mapper:XmlObjectMapper = builder.build();
		var obj:Object = mapper.mapToObject(xml, new XmlProcessorContext());
		assertTrue("Expected instance of SimpleClass", obj is SimpleClass);
		var sc:SimpleClass = SimpleClass(obj);
		assertEquals("Unexpected String Property", "foo", sc.stringProp);
		assertEquals("Unexpected int Property", 7, sc.intProp);
		assertEquals("Unexpected Boolean Property", true, sc.booleanProp);
		assertEquals("Unexpected Class Property", Event, sc.classProp);
	}
	
	public function testTextNodeMapperWithMissingOptionalNode () : void {
		var xml:XML = <tag>
			<string-prop>foo</string-prop>
			<int-prop>7</int-prop>
			<boolean-prop>true</boolean-prop>
		</tag>;
		var builder:PropertyMapperBuilder = new PropertyMapperBuilder(SimpleClass, new QName("tag"));
		builder.mapAllToChildTextNodes();
		var mapper:XmlObjectMapper = builder.build();
		var obj:Object = mapper.mapToObject(xml, new XmlProcessorContext());
		assertTrue("Expected instance of SimpleClass", obj is SimpleClass);
		var sc:SimpleClass = SimpleClass(obj);
		assertEquals("Unexpected String Property", "foo", sc.stringProp);
		assertEquals("Unexpected int Property", 7, sc.intProp);
		assertEquals("Unexpected Boolean Property", true, sc.booleanProp);
		assertEquals("Unexpected Class Property", null, sc.classProp);
	}
	
	public function testTextNodeMapperWithMissingRequiredNode () : void {
		var xml:XML = <tag>
			<int-prop>7</int-prop>
			<boolean-prop>true</boolean-prop>
		</tag>;
		var builder:PropertyMapperBuilder = new PropertyMapperBuilder(SimpleClass, new QName("tag"));
		builder.mapAllToChildTextNodes();
		var mapper:XmlObjectMapper = builder.build();
		var context:XmlProcessorContext = new XmlProcessorContext();
		try {
			mapper.mapToObject(xml, context);
		} catch (e:MappingError) {
			assertTrue("Expected context with errors", context.hasErrors());
			assertEquals("Unexpected number of errors", 1, context.errors.length);
			return;
		}
		fail("Expected mapping error");
	}
	
	public function testMapSingleAttribute () : void {
		var xml:XML = <tag string-prop="foo"/>;
		var builder:PropertyMapperBuilder = new PropertyMapperBuilder(SimpleClass, new QName("tag"));
		builder.mapToAttribute("stringProp");
		var mapper:XmlObjectMapper = builder.build();
		var obj:Object = mapper.mapToObject(xml, new XmlProcessorContext());
		assertTrue("Expected instance of SimpleClass", obj is SimpleClass);
		var sc:SimpleClass = SimpleClass(obj);
		assertEquals("Unexpected String Property", "foo", sc.stringProp);
		assertEquals("Unexpected int Property", 0, sc.intProp);
		assertEquals("Unexpected Boolean Property", false, sc.booleanProp);
		assertEquals("Unexpected Class Property", null, sc.classProp);
	}
	
	public function testMapSingleChildTextNode () : void {
		var xml:XML = <tag>
			<string-prop>foo</string-prop>
		</tag>;
		var builder:PropertyMapperBuilder = new PropertyMapperBuilder(SimpleClass, new QName("tag"));
		builder.mapToChildTextNode("stringProp");
		var mapper:XmlObjectMapper = builder.build();
		var obj:Object = mapper.mapToObject(xml, new XmlProcessorContext());
		assertTrue("Expected instance of SimpleClass", obj is SimpleClass);
		var sc:SimpleClass = SimpleClass(obj);
		assertEquals("Unexpected String Property", "foo", sc.stringProp);
		assertEquals("Unexpected int Property", 0, sc.intProp);
		assertEquals("Unexpected Boolean Property", false, sc.booleanProp);
		assertEquals("Unexpected Class Property", null, sc.classProp);
	}
	
	public function testMapSingleTextNode () : void {
		var xml:XML = <tag>foo</tag>;
		var builder:PropertyMapperBuilder = new PropertyMapperBuilder(SimpleClass, new QName("tag"));
		builder.mapToTextNode("stringProp");
		var mapper:XmlObjectMapper = builder.build();
		var obj:Object = mapper.mapToObject(xml, new XmlProcessorContext());
		assertTrue("Expected instance of SimpleClass", obj is SimpleClass);
		var sc:SimpleClass = SimpleClass(obj);
		assertEquals("Unexpected String Property", "foo", sc.stringProp);
		assertEquals("Unexpected int Property", 0, sc.intProp);
		assertEquals("Unexpected Boolean Property", false, sc.booleanProp);
		assertEquals("Unexpected Class Property", null, sc.classProp);
	}
	
	public function testMapTextNodeAndAttribute () : void {
		var xml:XML = <tag int-prop="7">foo</tag>;
		var builder:PropertyMapperBuilder = new PropertyMapperBuilder(SimpleClass, new QName("tag"));
		builder.mapToTextNode("stringProp");
		builder.mapToAttribute("intProp");
		var mapper:XmlObjectMapper = builder.build();
		var obj:Object = mapper.mapToObject(xml, new XmlProcessorContext());
		assertTrue("Expected instance of SimpleClass", obj is SimpleClass);
		var sc:SimpleClass = SimpleClass(obj);
		assertEquals("Unexpected String Property", "foo", sc.stringProp);
		assertEquals("Unexpected int Property", 7, sc.intProp);
		assertEquals("Unexpected Boolean Property", false, sc.booleanProp);
		assertEquals("Unexpected Class Property", null, sc.classProp);
	}
	
	public function testMapSingleChildElement () : void {
		var xml:XML = <tag int-prop="7">
			<child name="foo"/>
		</tag>;
		var builder:PropertyMapperBuilder = new PropertyMapperBuilder(ClassWithChild, new QName("tag"));
		builder.createChildElementMapperBuilder("child").mapAllToAttributes();
		builder.mapAllToAttributes();
		var mapper:XmlObjectMapper = builder.build();
		var obj:Object = mapper.mapToObject(xml, new XmlProcessorContext());
		assertTrue("Expected instance of ClassWithChild", obj is ClassWithChild);
		var cwc:ClassWithChild = ClassWithChild(obj);
		assertEquals("Unexpected int Property", 7, cwc.intProp);
		assertTrue("Expected ChildA as child property", cwc.child != null);
		assertEquals("Unexpected name Property", "foo", cwc.child.name);
	}
	
	public function testMapSingleChildElementExplicit () : void {
		var xml:XML = <tag int-prop="7">
			<child name="foo"/>
		</tag>;
		var builder:PropertyMapperBuilder = new PropertyMapperBuilder(ClassWithChild, new QName("tag"));
		var childBuilder:PropertyMapperBuilder = new PropertyMapperBuilder(ChildA, new QName("child"));
		childBuilder.mapAllToAttributes();
		builder.mapToChildElement("child", childBuilder.build());
		builder.mapAllToAttributes();
		var mapper:XmlObjectMapper = builder.build();
		var obj:Object = mapper.mapToObject(xml, new XmlProcessorContext());
		assertTrue("Expected instance of ClassWithChild", obj is ClassWithChild);
		var cwc:ClassWithChild = ClassWithChild(obj);
		assertEquals("Unexpected int Property", 7, cwc.intProp);
		assertTrue("Expected ChildA as child property", cwc.child != null);
		assertEquals("Unexpected name Property", "foo", cwc.child.name);
	}
	
	public function testMapChildElementArray () : void {
		var xml:XML = <tag int-prop="7">
			<child name="A"/>
			<child name="B"/>
		</tag>;
		var builder:PropertyMapperBuilder = new PropertyMapperBuilder(ClassWithChildren, new QName("tag"));
		builder.createChildElementMapperBuilder("children", ChildA, new QName("child")).mapAllToAttributes();
		builder.mapAllToAttributes();
		var mapper:XmlObjectMapper = builder.build();
		var obj:Object = mapper.mapToObject(xml, new XmlProcessorContext());
		assertTrue("Expected instance of ClassWithChildren", obj is ClassWithChildren);
		var cwc:ClassWithChildren = ClassWithChildren(obj);
		assertEquals("Unexpected int Property", 7, cwc.intProp);
		assertTrue("Expected Array as children property", cwc.children != null);
		assertEquals("Unexpected name Property", "A", cwc.children[0].name);
		assertEquals("Unexpected name Property", "B", cwc.children[1].name);
	}
	
	public function testMapChildElementChoice () : void {
		var xml:XML = <tag int-prop="7">
			<child-a name="A"/>
			<child-b name="B"/>
		</tag>;
		var builder:PropertyMapperBuilder = new PropertyMapperBuilder(ClassWithChildren, new QName( "tag"));
		var choice:Choice = new Choice();
		var childABuilder:PropertyMapperBuilder = new PropertyMapperBuilder(ChildA, new QName("child-a"));
		childABuilder.mapAllToAttributes();
		var childBBuilder:PropertyMapperBuilder = new PropertyMapperBuilder(ChildB, new QName("child-b"));
		childBBuilder.mapAllToAttributes();
		choice.addMapper(childABuilder.build());
		choice.addMapper(childBBuilder.build());
		builder.mapToChildElementChoice("children", choice);
		builder.mapAllToAttributes();
		var mapper:XmlObjectMapper = builder.build();
		var obj:Object = mapper.mapToObject(xml, new XmlProcessorContext());
		assertTrue("Expected instance of ClassWithChildren", obj is ClassWithChildren);
		var cwc:ClassWithChildren = ClassWithChildren(obj);
		assertEquals("Unexpected int Property", 7, cwc.intProp);
		assertTrue("Expected Array as children property", cwc.children != null);
		assertEquals("Unxpected length of children Array", 2, cwc.children.length);
		assertTrue("Unexpected child type", cwc.children[0] is ChildA);
		assertTrue("Unexpected child type", cwc.children[1] is ChildB);
		assertEquals("Unexpected name Property", "A", cwc.children[0].name);
		assertEquals("Unexpected name Property", "B", cwc.children[1].name);
	}
	
	public function testMissingRequiredChildren () : void {
		var xml:XML = <tag int-prop="7"/>;
		var builder:PropertyMapperBuilder = new PropertyMapperBuilder(ClassWithChildren, new QName("tag"));
		builder.createChildElementMapperBuilder("children", ChildA, new QName("child")).mapAllToAttributes();
		builder.mapAllToAttributes();
		var mapper:XmlObjectMapper = builder.build();
		var context:XmlProcessorContext = new XmlProcessorContext();
		try {
			mapper.mapToObject(xml, context);
		} catch (e:MappingError) {
			assertTrue("Expected context with errors", context.hasErrors());
			assertEquals("Unexpected number of errors", 1, context.errors.length);
			return;
		}
		fail("Expected mapping error");
	}
	
	public function testMissingRequiredChild () : void {
		var xml:XML = <tag int-prop="7"/>;
		var builder:PropertyMapperBuilder = new PropertyMapperBuilder(ClassWithChild, new QName("tag"));
		builder.createChildElementMapperBuilder("child").mapAllToAttributes();
		builder.mapAllToAttributes();
		var mapper:XmlObjectMapper = builder.build();
		var context:XmlProcessorContext = new XmlProcessorContext();
		try {
			mapper.mapToObject(xml, context);
		} catch (e:MappingError) {
			assertTrue("Expected context with errors", context.hasErrors());
			assertEquals("Unexpected number of errors", 1, context.errors.length);
			return;
		}
		fail("Expected mapping error");
	}
	
	public function testTwoErrors () : void {
		var xml:XML = <tag><child/></tag>;
		var builder:PropertyMapperBuilder = new PropertyMapperBuilder(ClassWithChild, new QName("tag"));
		builder.createChildElementMapperBuilder("child").mapAllToAttributes();
		builder.mapAllToAttributes();
		var mapper:XmlObjectMapper = builder.build();
		var context:XmlProcessorContext = new XmlProcessorContext();
		try {
			mapper.mapToObject(xml, context);
		} catch (e:MappingError) {
			assertTrue("Expected context with errors", context.hasErrors());
			assertEquals("Unexpected number of errors", 2, e.causes.length);
			assertEquals("Unexpected number of errors", 2, context.errors.length);
			return;
		}
		fail("Expected mapping error");
	}
	
	public function testNamespace () : void {
		var xml:XML = <tag int-prop="7" xmlns:ns="testuri">
			<ns:child name="foo"/>
		</tag>;
		var builder:PropertyMapperBuilder = new PropertyMapperBuilder(ClassWithChild, new QName("tag"));
		builder.createChildElementMapperBuilder("child", null, new QName("testuri", "child")).mapAllToAttributes();
		builder.mapAllToAttributes();
		var mapper:XmlObjectMapper = builder.build();
		var obj:Object = mapper.mapToObject(xml, new XmlProcessorContext());
		assertTrue("Expected instance of ClassWithChild", obj is ClassWithChild);
		var cwc:ClassWithChild = ClassWithChild(obj);
		assertEquals("Unexpected int Property", 7, cwc.intProp);
		assertTrue("Expected ChildA as child property", cwc.child != null);
		assertEquals("Unexpected name Property", "foo", cwc.child.name);
	}


	
	public function testDictionary () : void {
		var d:Dictionary = new Dictionary();
		var b:Boolean = (d["foo"] != undefined);
		var o:Object = new Object();
		b = (d[o] != undefined);
		var n:QName = new QName("", "foo");
		b = (d[n] != undefined);
	}
}
}

package org.spicefactory.parsley.xml {
import org.spicefactory.parsley.core.context.Context;
import org.spicefactory.parsley.core.decorator.injection.InjectedDependency;
import org.spicefactory.parsley.flex.mxmlconfig.core.CoreModel;
import org.spicefactory.parsley.xml.XmlContextTestBase;

import flash.events.Event;

/**
 * @author Jens Halm
 */
public class CoreXmlTagTest extends XmlContextTestBase {
	
	
	public static const config:XML = <objects 
		xmlns="http://www.spicefactory.org/parsley">
		
		<object id="dependency" type="org.spicefactory.parsley.core.decorator.injection.InjectedDependency"/>
		
		<object id="object" type="org.spicefactory.parsley.flex.mxmlconfig.core.CoreModel">
			<constructor-args>
				<string>foo</string>
				<int>7</int>
			</constructor-args>
			<property name="booleanProp" value="true"/>
			<property name="refProp" id-ref="dependency"/>
			<property name="arrayProp">
				<array>
					<string>AA</string>
					<int>7</int>
					<boolean>true</boolean>
					<class>flash.events.Event</class>
					<object type="org.spicefactory.parsley.xml.XmlModel">
						<property name="prop" value="nested"/>
					</object>
					<static-property type="org.spicefactory.parsley.xml.XmlModel" property="STATIC_PROP"/>
					<object-ref id-ref="dependency"/>
					<object-ref type-ref="org.spicefactory.parsley.core.decorator.injection.InjectedDependency"/>
				</array>
			</property>
		</object> 
	</objects>; 
	
	
	
	public function testCoreTags () : void {
		var context:Context = getXmlContext(config);
		checkState(context);
		checkObjectIds(context, ["dependency"], InjectedDependency);	
		checkObjectIds(context, ["object"], CoreModel);	
		var obj:CoreModel 
				= getAndCheckObject(context, "object", CoreModel) as CoreModel;
		assertEquals("Unexpected string property", "foo", obj.stringProp);
		assertEquals("Unexpected int property", 7, obj.intProp);
		assertEquals("Unexpected boolean property", true, obj.booleanProp);
		assertNotNull("Dependency not resolved", obj.refProp);
		var arr:Array = obj.arrayProp;
		assertNotNull("Expected Array instance", arr);
		assertEquals("Unexpected Array length", 8, arr.length);
		assertEquals("Unexpected Array element 0", "AA", arr[0]);
		assertEquals("Unexpected Array element 1", 7, arr[1]);
		assertEquals("Unexpected Array element 2", true, arr[2]);
		assertEquals("Unexpected Array element 3", Event, arr[3]);
		assertTrue("Expected Array element 4 to be of type XmlModel", (arr[4] is XmlModel));
		var model:XmlModel = arr[4] as XmlModel;
		assertEquals("Unexpected string property for XmlModel", "nested", model.prop);
		assertEquals("Unexpected Array element 5", "static-foo", arr[5]);
		assertEquals("Unexpected Array element 6", obj.refProp, arr[6]);
		assertEquals("Unexpected Array element 7", obj.refProp, arr[7]);
	}
	
	
}
}

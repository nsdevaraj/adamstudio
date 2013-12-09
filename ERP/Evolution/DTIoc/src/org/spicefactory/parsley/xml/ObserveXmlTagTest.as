package org.spicefactory.parsley.xml {
import org.spicefactory.lib.reflect.ClassInfo;
import org.spicefactory.parsley.core.context.Context;
import org.spicefactory.parsley.core.context.DynamicContext;
import org.spicefactory.parsley.core.decorator.lifecycle.ObserveTestBase;
import org.spicefactory.parsley.core.decorator.lifecycle.model.LifecycleEventCounter;
import org.spicefactory.parsley.core.registry.impl.DefaultObjectDefinition;

import mx.containers.Box;
import mx.containers.HBox;
import mx.containers.VBox;
import mx.controls.Text;

/**
 * @author Jens Halm
 */
public class ObserveXmlTagTest extends ObserveTestBase {

	
	
	public override function get observeContext () : Context {
		var contextA:Context = XmlContextTestBase.getXmlContext(boxConfig);
  		var contextB:Context = XmlContextTestBase.getXmlContext(boxConfig, contextA, "custom");
  		return XmlContextTestBase.getXmlContext(listenerConfig, contextB);
	}
	
	public static const boxConfig:XML = <objects xmlns="http://www.spicefactory.org/parsley">
		<object type="mx.containers.HBox" lazy="true"/>
		<object type="mx.containers.VBox" lazy="true"/>
		<object type="mx.containers.Box" lazy="true"/>
		<object type="mx.controls.Text" lazy="true" id="text"/>
		<object type="mx.controls.Text" lazy="true" id="text2"/>
	</objects>;
	
	public static const listenerConfig:XML = <objects xmlns="http://www.spicefactory.org/parsley">
		<object type="mx.containers.HBox" lazy="true"/>
		<object type="mx.containers.VBox" lazy="true"/>
		<object type="mx.containers.Box" lazy="true"/>
		<object type="mx.controls.Text" lazy="true" id="text"/>
		<object type="mx.controls.Text" lazy="true" id="text2"/>
		<object type="org.spicefactory.parsley.core.decorator.lifecycle.model.LifecycleEventCounter">
			<observe method="globalListener"/>
			<observe method="globalVListener"/>
			<observe method="globalHListener"/>
			<observe method="localListener" scope="local"/>
			<observe method="localVListener" scope="local"/>
			<observe method="localHListener" scope="local"/>
			<observe method="customListener" scope="custom"/>
			<observe method="customVListener" scope="custom"/>
			<observe method="customHListener" scope="custom"/>
			<observe method="globalIdListener" object-id="text"/>
			<observe method="globalDestroyListener" phase="postDestroy"/>
		</object>
	</objects>;
	
	
	public function testObserverProxy () : void {
		var config:XML = <objects xmlns="http://www.spicefactory.org/parsley">
			<object type="mx.containers.Box" order="1"/>
			<object type="org.spicefactory.parsley.core.decorator.lifecycle.model.LifecycleEventCounter" order="2">
				<observe method="globalListener"/>
			</object>
		</objects>;
		var context:Context = XmlContextTestBase.getXmlContext(config); 
		var counter:LifecycleEventCounter = context.getObjectByType(LifecycleEventCounter) as LifecycleEventCounter;
  		assertEquals("Unexpected total count of listener invocations", 1, counter.getCount());
  		assertEquals("Unexpected total count of listeners for Box", 1, counter.getCount(Box));
	}
	
	
}
}

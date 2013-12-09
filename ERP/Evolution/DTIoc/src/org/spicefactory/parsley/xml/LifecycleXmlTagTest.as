package org.spicefactory.parsley.xml {
import org.spicefactory.parsley.core.context.Context;
import org.spicefactory.parsley.core.decorator.lifecycle.LifecycleTestBase;

/**
 * @author Jens Halm
 */
public class LifecycleXmlTagTest extends LifecycleTestBase {

	
	
	public override function get lifecycleContext () : Context {
		return XmlContextTestBase.getXmlContext(config);
	}
	
	public static const config:XML = <objects 
		xmlns="http://www.spicefactory.org/parsley">
		
		<object id="postConstructModel" type="org.spicefactory.parsley.core.decorator.lifecycle.model.PostConstructModel">
			<init method="init"/>		
		</object>
		
		<object id="preDestroyModel" type="org.spicefactory.parsley.core.decorator.lifecycle.model.PreDestroyModel">
			<destroy method="dispose"/>		
		</object>
	</objects>; 
	
	
}
}

package org.spicefactory.parsley.xml {
import org.spicefactory.parsley.core.context.Context;
import org.spicefactory.parsley.core.decorator.factory.FactoryDecoratorTestBase;

/**
 * @author Jens Halm
 */
public class FactoryXmlTagTest extends FactoryDecoratorTestBase {

	
	public static const config:XML = <objects 
		xmlns="http://www.spicefactory.org/parsley">
		
		<object id="dependency" type="org.spicefactory.parsley.core.decorator.injection.InjectedDependency"/>
		
		<object id="factoryWithDependency" type="org.spicefactory.parsley.core.decorator.factory.model.TestFactory">
			<factory method="createInstance"/>
		</object> 
	</objects>; 

	public override function get context () : Context {
		return XmlContextTestBase.getXmlContext(config);
	}
	
	
}
}

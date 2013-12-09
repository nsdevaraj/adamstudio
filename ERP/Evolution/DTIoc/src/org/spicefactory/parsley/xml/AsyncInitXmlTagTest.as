package org.spicefactory.parsley.xml {
import org.spicefactory.parsley.core.context.Context;
import org.spicefactory.parsley.core.decorator.asyncinit.AsyncInitTestBase;

/**
 * @author Jens Halm
 */
public class AsyncInitXmlTagTest extends AsyncInitTestBase {
	
	
	public static const config:XML = <objects 
		xmlns="http://www.spicefactory.org/parsley">
		
		<object id="asyncInitModel" type="org.spicefactory.parsley.core.decorator.asyncinit.model.AsyncInitModel">
			<async-init/>
		</object> 
	</objects>;
	
	public static const orderedConfig:XML = <objects 
		xmlns="http://www.spicefactory.org/parsley">
		
		<object id="asyncInitModel1" type="org.spicefactory.parsley.core.decorator.asyncinit.model.AsyncInitModel" order="1">
			<async-init/>
		</object> 
		<object id="asyncInitModel2" type="org.spicefactory.parsley.core.decorator.asyncinit.model.AsyncInitModel" order="2">
			<async-init complete-event="customComplete" error-event="customError"/>
		</object> 
	</objects>;

	protected override function get defaultContext () : Context {
		return XmlContextTestBase.getXmlContext(config);
	}
	
	protected override function get orderedContext () : Context {
		return XmlContextTestBase.getXmlContext(orderedConfig);
	}
	
	
}
}

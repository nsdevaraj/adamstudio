package org.spicefactory.parsley.pimento {
import org.spicefactory.parsley.cinnamon.CinnamonXmlSupport;
import org.spicefactory.parsley.core.context.Context;
import org.spicefactory.parsley.xml.XmlContextTestBase;

public class PimentoXmlTagTest extends PimentoTestBase {

	
	CinnamonXmlSupport.initialize();
	PimentoXmlSupport.initialize();
	
	
	public override function get pimentoContext () : Context {
		return XmlContextTestBase.getXmlContext(pimentoXml);
	}
	
	public override function get cinnamonContext () : Context {
		return XmlContextTestBase.getXmlContext(cinnamonXml);
	}
	
	public var cinnamonXml:XML = <objects 
		xmlns="http://www.spicefactory.org/parsley"
		xmlns:cinnamon="http://www.spicefactory.org/parsley/cinnamon"
		xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
		xsi:schemaLocation="http://www.spicefactory.org/parsley http://www.spicefactory.org/parsley/schema/2.0/parsley-core.xsd http://www.spicefactory.org/parsley/cinnamon http://www.spicefactory.org/parsley/schema/2.0/parsley-cinnamon.xsd"
		>
		<cinnamon:channel 
		    id="mainChannel"
		    url="http://localhost/test/service/"
		    timeout="3000"
		/>
		<cinnamon:service
		    name="echoService"
		    type="org.spicefactory.parsley.pimento.EchoServiceImpl"
		/>
	</objects>;
		
	public var pimentoXml:XML = <objects 
		xmlns="http://www.spicefactory.org/parsley"
		xmlns:pimento="http://www.spicefactory.org/parsley/pimento"
		xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
		xsi:schemaLocation="http://www.spicefactory.org/parsley http://www.spicefactory.org/parsley/schema/2.0/parsley-core.xsd http://www.spicefactory.org/parsley/pimento http://www.spicefactory.org/parsley/schema/2.0/parsley-pimento.xsd"
		>
		<pimento:config 
		    url="http://localhost/test/service/"
		    timeout="3000"
		/>
		<pimento:service
		    name="echoService"
		    type="org.spicefactory.parsley.pimento.EchoServiceImpl"
		/>
	</objects>;
	
}

}
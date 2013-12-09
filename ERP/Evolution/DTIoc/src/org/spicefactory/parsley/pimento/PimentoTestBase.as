package org.spicefactory.parsley.pimento {
import org.spicefactory.cinnamon.service.ServiceProxy;
import org.spicefactory.lib.errors.AbstractMethodError;
import org.spicefactory.parsley.core.context.Context;
import org.spicefactory.parsley.xml.XmlContextTestBase;
import org.spicefactory.pimento.config.PimentoConfig;
import org.spicefactory.pimento.service.EntityManager;

public class PimentoTestBase extends XmlContextTestBase {

	
	public function testCinnamonServiceConfig () : void {
		var c:Class = EchoServiceImpl;
		var context:Context = cinnamonContext;
		checkState(context);
		var service:EchoService = context.getObjectByType(EchoService) as EchoService;
		var proxy:ServiceProxy = ServiceProxy.forService(service);
		assertNotNull("Expected proxy instance", proxy);
		assertEquals("Unexpected service URL", "http://localhost/test/service/", proxy.channel.serviceUrl);
	}
	
	public function testPimentoServiceConfig () : void {
		var c:Class = EchoServiceImpl;
		var context:Context = pimentoContext;
		checkState(context);
		
		var service:EchoService = context.getObjectByType(EchoService) as EchoService;
		var proxy:ServiceProxy = ServiceProxy.forService(service);
		assertNotNull("Expected proxy instance", proxy);
		assertEquals("Unexpected service URL", "http://localhost/test/service/", proxy.channel.serviceUrl);
		
		var config:PimentoConfig = context.getObjectByType(PimentoConfig) as PimentoConfig;
		assertEquals("Unexpected config URL", "http://localhost/test/service/", config.serviceUrl);
		assertEquals("Unexpected timeout", 3000, config.defaultTimeout);
		
		var entityManager:EntityManager = context.getObjectByType(EntityManager) as EntityManager;
		var emProxy:ServiceProxy = ServiceProxy.forService(entityManager);
		assertNotNull("Expected proxy instance", emProxy);
	}
	
	public function get pimentoContext () : Context {
		throw new AbstractMethodError();
	}
	
	public function get cinnamonContext () : Context {
		throw new AbstractMethodError();
	}
	
	
}

}
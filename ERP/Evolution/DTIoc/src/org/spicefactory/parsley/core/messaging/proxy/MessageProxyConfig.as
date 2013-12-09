package org.spicefactory.parsley.core.messaging.proxy {

/**
 * @author Jens Halm
 */
public class MessageProxyConfig {
	
	
	[ObjectDefinition(order="1")]
	public function get sender () : Sender {
		return new Sender();
	}
	
	[ObjectDefinition(order="2")]
	public function get receiver () : Receiver {
		return new Receiver();
	}
	
	
}
}

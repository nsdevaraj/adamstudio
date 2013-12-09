package org.spicefactory.parsley.core.messaging.proxy {
import flexunit.framework.TestCase;

import org.spicefactory.parsley.asconfig.ActionScriptContextBuilder;
import org.spicefactory.parsley.core.context.Context;

/**
 * @author Jens Halm
 */
public class MessageProxyTest extends TestCase {
	
	
	public function testReceiverProxy () : void {
		Receiver.instanceCount = 0;
		var context:Context = ActionScriptContextBuilder.build(MessageProxyConfig);
		var receiver:Receiver = context.getObjectByType(Receiver) as Receiver;
		assertEquals("Unexpected number of messages", 1, receiver.getCount());
	}
	
	
}
}

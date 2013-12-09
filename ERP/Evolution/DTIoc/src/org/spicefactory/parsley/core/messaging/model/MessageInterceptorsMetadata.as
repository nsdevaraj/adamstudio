package org.spicefactory.parsley.core.messaging.model {
import org.spicefactory.parsley.core.messaging.MessageProcessor;

/**
 * @author Jens Halm
 */
public class MessageInterceptorsMetadata extends MessageInterceptors {

	
	[MessageInterceptor(type="org.spicefactory.parsley.core.messaging.TestEvent")]
	public override function interceptAllMessages (processor:MessageProcessor) : void {
		super.interceptAllMessages(processor);
	}
	
	[MessageInterceptor]
	public override function allEvents (processor:MessageProcessor) : void {
		super.allEvents(processor);
	}
	
	[MessageInterceptor(type="org.spicefactory.parsley.core.messaging.TestEvent", selector="test1")]
	public override function event1 (processor:MessageProcessor) : void {
		super.event1(processor);
	}
	
	[MessageInterceptor(type="org.spicefactory.parsley.core.messaging.TestEvent", selector="test2")]
	public override function event2 (processor:MessageProcessor) : void {
		super.event2(processor);
	}
	
	
}
}

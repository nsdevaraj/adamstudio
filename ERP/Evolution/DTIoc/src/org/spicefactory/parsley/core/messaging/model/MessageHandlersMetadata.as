package org.spicefactory.parsley.core.messaging.model {
import org.spicefactory.parsley.core.messaging.TestEvent;

import flash.events.Event;

/**
 * @author Jens Halm
 */
public class MessageHandlersMetadata extends MessageHandlers {
	
	
	[MessageHandler]
	public override function allTestEvents (event:TestEvent) : void {
		super.allTestEvents(event);
	}
	
	[MessageHandler]
	public override function allEvents (event:Event) : void {
		super.allEvents(event);
	}
	
	[MessageHandler(selector="test1")]
	public override function event1 (event:TestEvent) : void {
		super.event1(event);
	}
	
	[MessageHandler(selector="test2")]
	public override function event2 (event:TestEvent) : void {
		super.event2(event);
	}
	
	[MessageHandler(messageProperties="stringProp,intProp",type="org.spicefactory.parsley.core.messaging.TestEvent")]
	public override function mappedProperties (stringProp:String, intProp:int) : void {
		super.mappedProperties(stringProp, intProp);
	}

	
}
}

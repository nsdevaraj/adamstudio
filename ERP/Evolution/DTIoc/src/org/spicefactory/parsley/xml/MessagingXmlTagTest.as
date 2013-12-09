package org.spicefactory.parsley.xml {
import org.spicefactory.parsley.core.context.Context;
import org.spicefactory.parsley.core.messaging.MessagingTestBase;

/**
 * @author Jens Halm
 */
public class MessagingXmlTagTest extends MessagingTestBase {
	
	
	function MessagingXmlTagTest () {
		super(true);
	}
	
	public override function get messagingContext () : Context {
		return XmlContextTestBase.getXmlContext(config);
	}
	
	public static const config:XML = <objects 
		xmlns="http://www.spicefactory.org/parsley">
		
		<object id="eventSource" type="org.spicefactory.parsley.core.messaging.model.EventSource" lazy="true">
			<managed-events names="test1, test2, foo"/>
		</object> 
		
		<object id="testDispatcher" type="org.spicefactory.parsley.core.messaging.model.TestMessageDispatcher" lazy="true">
			<message-dispatcher property="dispatcher"/>
		</object> 
	
		<object id="testMessageHandlers" type="org.spicefactory.parsley.core.messaging.model.TestMessageHandlers" lazy="true">
			<message-handler method="allTestMessages" type="org.spicefactory.parsley.core.messaging.TestMessage"/>
			<message-handler method="event1" selector="test1" type="org.spicefactory.parsley.core.messaging.TestMessage"/>
			<message-handler method="event2" selector="test2" type="org.spicefactory.parsley.core.messaging.TestMessage"/>
		</object> 
		
		<object id="messageHandlers" type="org.spicefactory.parsley.core.messaging.model.MessageHandlers" lazy="true">
			<message-handler method="allTestEvents" type="org.spicefactory.parsley.core.messaging.TestEvent"/>
			<message-handler method="allEvents" type="flash.events.Event"/>
			<message-handler method="event1" selector="test1" type="org.spicefactory.parsley.core.messaging.TestEvent"/>
			<message-handler method="event2" selector="test2" type="org.spicefactory.parsley.core.messaging.TestEvent"/>
			<message-handler method="mappedProperties" message-properties="stringProp,intProp" type="org.spicefactory.parsley.core.messaging.TestEvent"/>
		</object>
		
		<object id="faultyHandlers" type="org.spicefactory.parsley.core.messaging.model.FaultyMessageHandlers" lazy="true">
			<message-handler method="allTestEvents" type="org.spicefactory.parsley.core.messaging.TestEvent"/>
			<message-handler method="allEvents" type="flash.events.Event"/>
			<message-handler method="event1" selector="test1" type="org.spicefactory.parsley.core.messaging.TestEvent"/>
			<message-handler method="event2" selector="test2" type="org.spicefactory.parsley.core.messaging.TestEvent"/>
		</object>
		
		<object id="errorHandlers" type="org.spicefactory.parsley.core.messaging.model.ErrorHandlers">
			<message-error method="allTestEvents" type="org.spicefactory.parsley.core.messaging.TestEvent"/>
			<message-error method="allEvents" type="flash.events.Event"/>
			<message-error method="event1" selector="test1" type="org.spicefactory.parsley.core.messaging.TestEvent"/>
			<message-error method="event2" selector="test2" type="org.spicefactory.parsley.core.messaging.TestEvent"/>
		</object>
	
		<object id="messageBindings" type="org.spicefactory.parsley.core.messaging.model.MessageBindingsBlank" lazy="true">
			<message-binding target-property="stringProp" message-property="stringProp" type="org.spicefactory.parsley.core.messaging.TestEvent"/>
			<message-binding target-property="intProp1" message-property="intProp" selector="test1" type="org.spicefactory.parsley.core.messaging.TestEvent"/>
			<message-binding target-property="intProp2" message-property="intProp" selector="test2" type="org.spicefactory.parsley.core.messaging.TestEvent"/>
		</object> 
	
		<object id="messageInterceptors" type="org.spicefactory.parsley.core.messaging.model.MessageInterceptors" lazy="true">
			<message-interceptor method="interceptAllMessages" type="org.spicefactory.parsley.core.messaging.TestEvent"/>
			<message-interceptor method="allEvents"/>
			<message-interceptor method="event1" selector="test1" type="org.spicefactory.parsley.core.messaging.TestEvent"/>
			<message-interceptor method="event2" selector="test2" type="org.spicefactory.parsley.core.messaging.TestEvent"/>
		</object> 	
	</objects>;

	
}
}

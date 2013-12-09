package org.spicefactory.parsley.core.messaging {
import org.spicefactory.lib.errors.AbstractMethodError;
import org.spicefactory.parsley.core.ContextTestBase;
import org.spicefactory.parsley.core.context.Context;
import org.spicefactory.parsley.core.messaging.model.ErrorHandlers;
import org.spicefactory.parsley.core.messaging.model.EventSource;
import org.spicefactory.parsley.core.messaging.model.FaultyMessageHandlers;
import org.spicefactory.parsley.core.messaging.model.MessageBindings;
import org.spicefactory.parsley.core.messaging.model.MessageHandlers;
import org.spicefactory.parsley.core.messaging.model.MessageInterceptors;
import org.spicefactory.parsley.core.messaging.model.TestMessageDispatcher;
import org.spicefactory.parsley.core.messaging.model.TestMessageHandlers;

import flash.events.Event;

/**
 * @author Jens Halm
 */
public class MessagingTestBase extends ContextTestBase {
	
	
	private var lazy:Boolean;
	
	
	function MessagingTestBase (lazy:Boolean) {
		this.lazy = lazy;
	}

	
	public function testMessageHandlers () : void {
		var context:Context = messagingContext;
		checkState(context);
		checkObjectIds(context, ["eventSource"], EventSource);	
		checkObjectIds(context, ["messageHandlers"], MessageHandlers);	
		var source:EventSource = context.getObject("eventSource") as EventSource;
		var handlers:MessageHandlers;
		if (lazy) handlers = context.getObject("messageHandlers") as MessageHandlers;
		source.dispatchEvent(new TestEvent(TestEvent.TEST1, "foo1", 7));
		source.dispatchEvent(new TestEvent(TestEvent.TEST2, "foo2", 9));
		source.dispatchEvent(new Event("foo"));
		if (!lazy) handlers = context.getObject("messageHandlers") as MessageHandlers;
		assertEquals("Unexpected count for event test1", 2, handlers.test1Count);
		assertEquals("Unexpected count for event test2", 2, handlers.test2Count);
		assertEquals("Unexpected count for generic event handler", 3, handlers.genericEventCount);
		assertEquals("Unexpected string property", "foo2", handlers.stringProp);
		assertEquals("Unexpected int property", 9, handlers.intProp);
	}
	
	public function testMessageBindings () : void {
		var context:Context = messagingContext;
		checkState(context);
		checkObjectIds(context, ["eventSource"], EventSource);	
		checkObjectIds(context, ["messageBindings"], MessageBindings);	
		var source:EventSource = context.getObject("eventSource") as EventSource;
		var bindings:MessageBindings;
		if (lazy) bindings = context.getObject("messageBindings") as MessageBindings;
		source.dispatchEvent(new TestEvent(TestEvent.TEST1, "foo1", 7));
		source.dispatchEvent(new TestEvent(TestEvent.TEST2, "foo2", 9));
		if (!lazy) bindings = context.getObject("messageBindings") as MessageBindings;
		assertEquals("Unexpected value for string property", "foo1foo2", bindings.stringProp);
		assertEquals("Unexpected value for int1 property", 7, bindings["intProp1"]);
		assertEquals("Unexpected value for int2 property", 9, bindings["intProp2"]);
	}
	
	public function testMessageInterceptors () : void {
		var context:Context = messagingContext;
		checkState(context);
		checkObjectIds(context, ["eventSource"], EventSource);	
		checkObjectIds(context, ["messageHandlers"], MessageHandlers);	
		checkObjectIds(context, ["messageInterceptors"], MessageInterceptors);	
		var source:EventSource = context.getObject("eventSource") as EventSource;
		var handlers:MessageHandlers = context.getObject("messageHandlers") as MessageHandlers;
		var interceptors:MessageInterceptors = context.getObject("messageInterceptors") as MessageInterceptors;
				
		source.dispatchEvent(new TestEvent(TestEvent.TEST1, "foo1", 7));
		source.dispatchEvent(new TestEvent(TestEvent.TEST2, "foo2", 9));
		source.dispatchEvent(new Event("foo"));
		
		assertEquals("Unexpected count for event test1", 2, handlers.test1Count);
		assertEquals("Unexpected count for event test2", 0, handlers.test2Count);
		assertEquals("Unexpected count for generic event handler", 2, handlers.genericEventCount);
		assertEquals("Unexpected string property", "foo1", handlers.stringProp);
		assertEquals("Unexpected int property", 7, handlers.intProp);
		
		assertEquals("Unexpected count for event test1", 2, interceptors.test1Count);
		assertEquals("Unexpected count for event test2", 1, interceptors.test2Count);
		
		interceptors.proceedEvent2();
		
		assertEquals("Unexpected count for event test1", 2, handlers.test1Count);
		assertEquals("Unexpected count for event test2", 2, handlers.test2Count);
		assertEquals("Unexpected count for generic event handler", 3, handlers.genericEventCount);
		assertEquals("Unexpected string property", "foo2", handlers.stringProp);
		assertEquals("Unexpected int property", 9, handlers.intProp);
		
		assertEquals("Unexpected count for event test1", 2, interceptors.test1Count);
		assertEquals("Unexpected count for event test2", 2, interceptors.test2Count);
	}
	
	public function testErrorHandlers () : void {
		var context:Context = messagingContext;
		checkState(context);
		checkObjectIds(context, ["eventSource"], EventSource);	
		checkObjectIds(context, ["faultyHandlers"], FaultyMessageHandlers);	
		checkObjectIds(context, ["errorHandlers"], ErrorHandlers);	
		var source:EventSource = context.getObject("eventSource") as EventSource;
		context.getObjectByType(FaultyMessageHandlers); // must fetch explicitly - it's lazy
		var handlers:ErrorHandlers = context.getObjectByType(ErrorHandlers) as ErrorHandlers;
		source.dispatchEvent(new TestEvent(TestEvent.TEST1, "foo1", 7));
		source.dispatchEvent(new TestEvent(TestEvent.TEST2, "foo2", 9));
		source.dispatchEvent(new Event("foo"));
		assertEquals("Unexpected count for all events", 15, handlers.getCount());
		assertEquals("Unexpected count for TestEvents", 14, handlers.getCount(TestEvent));
		assertEquals("Unexpected count for selector test1", 1, handlers.getCount(TestEvent, TestEvent.TEST1));
		assertEquals("Unexpected count for selector test2", 1, handlers.getCount(TestEvent, TestEvent.TEST2));
	}
	
	public function testMessageDispatcher () : void {
		var context:Context = messagingContext;
		checkState(context);
		checkObjectIds(context, ["testDispatcher"], TestMessageDispatcher);	
		checkObjectIds(context, ["testMessageHandlers"], TestMessageHandlers);	
		var dispatcher:TestMessageDispatcher = context.getObject("testDispatcher") as TestMessageDispatcher;
		var handlers:TestMessageHandlers;
		if (lazy) handlers = context.getObject("testMessageHandlers") as TestMessageHandlers; 
		var m1:TestMessage = new TestMessage();
		m1.name = TestEvent.TEST1;
		m1.value = 3;
		dispatcher.dispatchMessage(m1);
		var m2:TestMessage = new TestMessage();
		m2.name = TestEvent.TEST2;
		m2.value = 5;
		dispatcher.dispatchMessage(m2);
		if (!lazy) handlers = context.getObject("testMessageHandlers") as TestMessageHandlers; 
		assertEquals("Unexpected count for event test1", 2, handlers.test1Count);
		assertEquals("Unexpected count for event test2", 2, handlers.test2Count);
		assertEquals("Unexpected sum value", 16, handlers.sum);
	}
	
	public function get messagingContext () : Context {
		throw new AbstractMethodError();
	}
	
	
}
}

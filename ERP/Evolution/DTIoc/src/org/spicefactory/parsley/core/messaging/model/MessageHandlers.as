package org.spicefactory.parsley.core.messaging.model {
import org.spicefactory.lib.errors.IllegalArgumentError;
import org.spicefactory.parsley.core.messaging.TestEvent;

import flash.events.Event;

/**
 * @author Jens Halm
 */
public class MessageHandlers {
	
	
	private var _genericEventCount:int = 0;
	private var _test1Count:int = 0;
	private var _test2Count:int = 0;
	
	private var _stringProp:String;
	private var _intProp:int;
	
	
	public function get test1Count () : int {
		return _test1Count;
	}
	
	public function get test2Count () : int {
		return _test2Count;
	}
	
	public function get genericEventCount ():int {
		return _genericEventCount;
	}
	

	public function get stringProp ():String {
		return _stringProp;
	}
	
	public function get intProp ():int {
		return _intProp;
	}
		
	
	public function allTestEvents (event:TestEvent) : void {
		if (event.type == TestEvent.TEST1) {
			_test1Count++;
		}
		else if (event.type == TestEvent.TEST2) {
			_test2Count++;
		}
		else {
			throw new IllegalArgumentError("Unexpected event type: " + event.type);
		}
	}
	
	public function allEvents (event:Event) : void {
		_genericEventCount++;
	}
	
	public function event1 (event:TestEvent) : void {
		if (event.type == TestEvent.TEST1) {
			_test1Count++;
		}
		else {
			throw new IllegalArgumentError("Unexpected event type: " + event.type);
		}
	}
	
	public function event2 (event:TestEvent) : void {
		if (event.type == TestEvent.TEST2) {
			_test2Count++;
		}
		else {
			throw new IllegalArgumentError("Unexpected event type: " + event.type);
		}
	}
	
	public function mappedProperties (stringProp:String, intProp:int) : void {
		_stringProp = stringProp;
		_intProp = intProp;
	}

	
}
}

package org.spicefactory.parsley.core.decorator.asyncinit.model {
import flash.events.EventDispatcher;

/**
 * @author Jens Halm
 */
public class AsyncInitModel extends EventDispatcher {
	
	
	public static var instances:uint = 0;
	
	
	function AsyncInitModel () {
		instances++;
	}
	
	
}
}

package org.spicefactory.parsley.core.messaging.model {

/**
 * @author Jens Halm
 */
public class TestMessageDispatcher {
	
	
	private var _dispatcher:Function;
	
	
	public function set dispatcher (disp:Function) : void {
		_dispatcher = disp;
	}
	
	
	public function dispatchMessage (message:Object) : void {
		_dispatcher(message);
	}
	
	
}
}

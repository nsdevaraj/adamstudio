package org.spicefactory.parsley.core.messaging.model {

/**
 * @author Jens Halm
 */
public class TestMessageDispatcherMetadata extends TestMessageDispatcher {
	
	
	[MessageDispatcher]
	public override function set dispatcher (disp:Function) : void {
		super.dispatcher = disp;
	}
	
	
}
}

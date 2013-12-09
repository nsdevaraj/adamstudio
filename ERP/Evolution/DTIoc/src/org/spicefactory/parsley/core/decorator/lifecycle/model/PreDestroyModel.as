package org.spicefactory.parsley.core.decorator.lifecycle.model {

/**
 * @author Jens Halm
 */
public class PreDestroyModel {
	
	
	private var _methodCalled:Boolean = false;
	
	
	public function dispose () : void {
		_methodCalled = true;
	}
	
	public function get methodCalled () : Boolean {
		return _methodCalled;
	}
	
	
}
}

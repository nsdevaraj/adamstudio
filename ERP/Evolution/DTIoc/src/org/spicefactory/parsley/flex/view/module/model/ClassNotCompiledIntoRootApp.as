package org.spicefactory.parsley.flex.view.module.model {
import mx.controls.Alert;

import flash.events.Event;

/**
 * @author Jens Halm
 */
public class ClassNotCompiledIntoRootApp {
	
	
	public var dependency:ModuleDependency;
	
	
	function ClassNotCompiledIntoRootApp () {
		trace("ClassNotCompiledIntoRootApp constr");
	}
	
	
    public function onAnything( event : Event ) : void {
         Alert.show( "Hello world!" );
    }
	
	
	
}
}

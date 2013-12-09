package org.spicefactory.parsley.core.decorator.lifecycle.model {

/**
 * @author Jens Halm
 */
public class PreDestroyMetadata extends PreDestroyModel {
	
	
	[Destroy]
	public override function dispose () : void {
		super.dispose();
	}
	
	
}
}

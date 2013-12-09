package org.spicefactory.parsley.testmodel {

/**
 * @author Jens Halm
 */
public class AnnotatedResourceBinding {
	
	
	[Bindable]
	[ResourceBinding(bundle="test", key="bind")]
	public var boundValue:String;
	
	
}
}

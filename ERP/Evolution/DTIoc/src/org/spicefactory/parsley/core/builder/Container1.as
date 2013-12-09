package org.spicefactory.parsley.core.builder {
import org.spicefactory.parsley.testmodel.ClassWithSimpleProperties;

/**
 * @author Jens Halm
 */
public class Container1 {
	
	
	public function get simpleObject () : ClassWithSimpleProperties {
		var obj:ClassWithSimpleProperties = new ClassWithSimpleProperties();
		obj.booleanProp = true;
		obj.intProp = 7;
		obj.stringProp = "foo";
		return obj;
	}
	
	
}
}

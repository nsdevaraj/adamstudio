package org.spicefactory.parsley.flex.mxmlconfig.lifecycle {
import org.spicefactory.parsley.core.context.Context;
import org.spicefactory.parsley.core.decorator.lifecycle.LifecycleTestBase;
import org.spicefactory.parsley.flex.FlexContextBuilder;

/**
 * @author Jens Halm
 */
public class LifecycleMxmlTagTest extends LifecycleTestBase {

	
	public override function get lifecycleContext () : Context {
		return FlexContextBuilder.build(LifecycleMxmlTagContainer);
	}
	
	
}
}

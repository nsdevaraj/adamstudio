package org.spicefactory.parsley.core.decorator.lifecycle {
import org.spicefactory.parsley.asconfig.ActionScriptContextBuilder;
import org.spicefactory.parsley.core.context.Context;
import org.spicefactory.parsley.core.decorator.lifecycle.LifecycleTestContainer;

/**
 * @author Jens Halm
 */
public class LifecycleMetadataTagTest extends LifecycleTestBase {

	
	public override function get lifecycleContext () : Context {
		return ActionScriptContextBuilder.build(LifecycleTestContainer);
	}
	
	
}
}

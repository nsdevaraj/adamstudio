package org.spicefactory.parsley.core.decorator.asyncinit {
import org.spicefactory.parsley.asconfig.ActionScriptContextBuilder;
import org.spicefactory.parsley.core.context.Context;

/**
 * @author Jens Halm
 */
public class AsyncInitMetadataTagTest extends AsyncInitTestBase {
	
	
	protected override function get defaultContext () : Context {
		return ActionScriptContextBuilder.build(AsyncInitContainer);
	}
	
	protected override function get orderedContext () : Context {
		return ActionScriptContextBuilder.build(AsyncInitOrderedContainer);
	}
	
	
}
}

package org.spicefactory.parsley.flex.mxmlconfig.asyncinit {
import org.spicefactory.parsley.asconfig.ActionScriptContextBuilder;
import org.spicefactory.parsley.core.context.Context;
import org.spicefactory.parsley.core.decorator.asyncinit.AsyncInitTestBase;

/**
 * @author Jens Halm
 */
public class AsyncInitMxmlTagTest extends AsyncInitTestBase {
	
	
	protected override function get defaultContext () : Context {
		return ActionScriptContextBuilder.build(AsyncInitMxmlTagContainer);
	}
	
	protected override function get orderedContext () : Context {
		return ActionScriptContextBuilder.build(AsyncInitOrderedMxmlTagContainer);
	}
	
	
}
}

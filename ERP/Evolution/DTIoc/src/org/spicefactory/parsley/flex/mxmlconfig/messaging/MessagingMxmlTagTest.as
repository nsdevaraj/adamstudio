package org.spicefactory.parsley.flex.mxmlconfig.messaging {
import org.spicefactory.parsley.asconfig.ActionScriptContextBuilder;
import org.spicefactory.parsley.core.context.Context;
import org.spicefactory.parsley.core.messaging.MessagingTestBase;

/**
 * @author Jens Halm
 */
public class MessagingMxmlTagTest extends MessagingTestBase {
	
	
	function MessagingMxmlTagTest () {
		super(true);
	}
	
	public override function get messagingContext () : Context {
		return ActionScriptContextBuilder.build(MessagingMxmlTagContainer);
	}
		
	
}
}

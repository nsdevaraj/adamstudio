package org.spicefactory.parsley.core.messaging {
import org.spicefactory.parsley.asconfig.ActionScriptContextBuilder;
import org.spicefactory.parsley.core.context.Context;

/**
 * @author Jens Halm
 */
public class MessagingMetadataTagTest extends MessagingTestBase {
	

	function MessagingMetadataTagTest () {
		super(false);
	}
		
	public override function get messagingContext () : Context {
		return ActionScriptContextBuilder.build(MessagingTestConfig);
	}
	
	
}
}

package org.spicefactory.parsley.core.decorator.lifecycle {
import org.spicefactory.parsley.asconfig.ActionScriptContextBuilder;
import org.spicefactory.parsley.asconfig.builder.ActionScriptObjectDefinitionBuilder;
import org.spicefactory.parsley.core.context.Context;

/**
 * @author Jens Halm
 */
public class ObserveMetadataTagTest extends ObserveTestBase {

	
	public override function get observeContext () : Context {
		var contextA:Context = ActionScriptContextBuilder.build(ObserveTestConfig);
  		var contextB:Context = getContext(new ActionScriptObjectDefinitionBuilder([ObserveTestConfig]), contextA, "custom");
  		return ActionScriptContextBuilder.buildAll([ObserveTestConfig, ObserveCounterConfig], null, contextB);
	}
	
	
}
}

package org.spicefactory.parsley.flex.mxmlconfig.observer {
import org.spicefactory.parsley.asconfig.builder.ActionScriptObjectDefinitionBuilder;
import org.spicefactory.parsley.core.context.Context;
import org.spicefactory.parsley.core.decorator.lifecycle.ObserveTestBase;
import org.spicefactory.parsley.flex.FlexContextBuilder;

/**
 * @author Jens Halm
 */
public class ObserveMxmlTagTest extends ObserveTestBase {

	
	public override function get observeContext () : Context {
		var contextA:Context = FlexContextBuilder.build(ObserveMxmlTagConfig);
  		var contextB:Context = getContext(new ActionScriptObjectDefinitionBuilder([ObserveMxmlTagConfig]), contextA, "custom");
  		return FlexContextBuilder.buildAll([ObserveMxmlTagConfig, ObserveCounterMxmlConfig], null, contextB);
	}
	
	
}
}

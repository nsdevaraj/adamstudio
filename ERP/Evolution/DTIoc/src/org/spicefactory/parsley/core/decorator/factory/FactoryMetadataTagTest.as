package org.spicefactory.parsley.core.decorator.factory {
import org.spicefactory.parsley.asconfig.ActionScriptContextBuilder;
import org.spicefactory.parsley.core.context.Context;
import org.spicefactory.parsley.core.decorator.factory.FactoryDecoratorTestContainer;

/**
 * @author Jens Halm
 */
public class FactoryMetadataTagTest extends FactoryDecoratorTestBase {

	
	public override function get context () : Context {
		return ActionScriptContextBuilder.build(FactoryDecoratorTestContainer);
	}
	
	
}
}

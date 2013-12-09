package org.spicefactory.parsley.flex.mxmlconfig.factory {
import org.spicefactory.parsley.core.context.Context;
import org.spicefactory.parsley.core.decorator.factory.FactoryDecoratorTestBase;
import org.spicefactory.parsley.flex.FlexContextBuilder;

/**
 * @author Jens Halm
 */
public class FactoryMxmlTagTest extends FactoryDecoratorTestBase {


	public override function get context () : Context {
		return FlexContextBuilder.build(FactoryMxmlTagContainer);
	}
		
	
}
}

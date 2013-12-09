package org.spicefactory.parsley.core.decorator.factory {
import org.spicefactory.parsley.core.decorator.factory.model.TestFactoryMetadata;
import org.spicefactory.parsley.core.decorator.injection.InjectedDependency;
import org.spicefactory.parsley.core.registry.ObjectDefinitionFactory;
import org.spicefactory.parsley.core.registry.impl.DefaultObjectDefinitionFactory;

/**
 * @author Jens Halm
 */
public class FactoryDecoratorTestContainer {
	

	public function get injectedDependency () : InjectedDependency {
		return new InjectedDependency();
	}
	
	public function get factoryWithDependency () : ObjectDefinitionFactory {
		return new DefaultObjectDefinitionFactory(TestFactoryMetadata, "factoryWithDependency", true);
	}

	
}
}

package org.spicefactory.parsley.core.decorator.injection {
import org.spicefactory.parsley.core.decorator.injection.InjectedDependency;
import org.spicefactory.parsley.core.decorator.injection.MissingConstructorInjection;
import org.spicefactory.parsley.core.decorator.injection.MissingMethodInjection;
import org.spicefactory.parsley.core.decorator.injection.MissingPropertyIdInjection;
import org.spicefactory.parsley.core.decorator.injection.MissingPropertyInjection;
import org.spicefactory.parsley.core.decorator.injection.OptionalConstructorInjection;
import org.spicefactory.parsley.core.decorator.injection.OptionalMethodInjection;
import org.spicefactory.parsley.core.decorator.injection.OptionalPropertyIdInjection;
import org.spicefactory.parsley.core.decorator.injection.OptionalPropertyInjection;
import org.spicefactory.parsley.core.decorator.injection.RequiredConstructorInjection;
import org.spicefactory.parsley.core.decorator.injection.RequiredMethodInjection;
import org.spicefactory.parsley.core.decorator.injection.RequiredPropertyIdInjection;
import org.spicefactory.parsley.core.decorator.injection.RequiredPropertyInjection;
import org.spicefactory.parsley.core.registry.ObjectDefinitionFactory;
import org.spicefactory.parsley.core.registry.impl.DefaultObjectDefinitionFactory;

/**
 * @author Jens Halm
 */
public class InjectTestContainer {
	
	
	public function get injectedDependency () : InjectedDependency {
		return new InjectedDependency();
	}
	

	public function get requiredConstructorInjection () : ObjectDefinitionFactory {
		return new DefaultObjectDefinitionFactory(RequiredConstructorInjection, "requiredConstructorInjection", true);
	}
	
	public function get missingConstructorInjection () : ObjectDefinitionFactory {
		return new DefaultObjectDefinitionFactory(MissingConstructorInjection, "missingConstructorInjection", true);
	}
	
	public function get optionalConstructorInjection () : ObjectDefinitionFactory {
		return new DefaultObjectDefinitionFactory(OptionalConstructorInjection, "optionalConstructorInjection", true);
	}
	

	[ObjectDefinition(lazy="true")]
	public function get requiredMethodInjection () : RequiredMethodInjection {
		return new RequiredMethodInjection();
	}

	[ObjectDefinition(lazy="true")]
	public function get missingMethodInjection () : MissingMethodInjection {
		return new MissingMethodInjection();
	}
	
	[ObjectDefinition(lazy="true")]
	public function get optionalMethodInjection () : OptionalMethodInjection {
		return new OptionalMethodInjection();
	}
	
		
	
	[ObjectDefinition(lazy="true")]
	public function get requiredPropertyInjection () : RequiredPropertyInjection {
		return new RequiredPropertyInjection();
	}
	
	[ObjectDefinition(lazy="true")]
	public function get missingPropertyInjection () : MissingPropertyInjection {
		return new MissingPropertyInjection();
	}
	
	[ObjectDefinition(lazy="true")]
	public function get optionalPropertyInjection () : OptionalPropertyInjection {
		return new OptionalPropertyInjection();
	}
	
	
	
	[ObjectDefinition(lazy="true")]
	public function get requiredPropertyIdInjection () : RequiredPropertyIdInjection {
		return new RequiredPropertyIdInjection();
	}
	
	[ObjectDefinition(lazy="true")]
	public function get missingPropertyIdInjection () : MissingPropertyIdInjection {
		return new MissingPropertyIdInjection();
	}
	
	[ObjectDefinition(lazy="true")]
	public function get optionalPropertyIdInjection () : OptionalPropertyIdInjection {
		return new OptionalPropertyIdInjection();
	}
	
	
	
}
}

package org.spicefactory.parsley.samples {
import org.spicefactory.lib.reflect.Method;
import org.spicefactory.lib.reflect.Property;
import org.spicefactory.parsley.core.errors.ContextError;
import org.spicefactory.parsley.core.registry.ObjectDefinitionRegistry;
import org.spicefactory.parsley.core.registry.ObjectDefinition;
import org.spicefactory.parsley.core.registry.ObjectDefinitionDecorator;

/**
 * @author Jens Halm
 */
[Metadata(types="class")]
public class Singleton implements ObjectDefinitionDecorator {
	
	
	public var property:String;
	
	public var method:String;



	public function decorate (definition:ObjectDefinition, registry:ObjectDefinitionRegistry) 
			: ObjectDefinition {
		if (property != null && method != null) {
			throw new ContextError("Only one of 'method' or 'property' may be specified for " 
					+ definition);
		}
		if (property != null) {
			var p:Property = definition.type.getProperty(property);
			if (p == null) {
				throw new ContextError("Class " + definition.type.name 
						+ " does not contain a property with name " + property);
			}
			if (!p.readable) {
				throw new ContextError(p.toString() + " is not readable");
			}
			definition.instantiator = new SingletonPropertyInstantiator(p);
		}
		else {
			if (method == null) method = "getInstance";
			var m:Method = definition.type.getMethod(method);
			if (m == null) {
				throw new ContextError("Class " + definition.type.name 
						+ " does not contain a method with name " + method);
			}
			if (m.parameters.length > 0) {
				throw new ContextError(m.toString() + " requires method parameters");
			}			
			definition.instantiator = new SingletonMethodInstantiator(m);
		}
	}
}
}

import org.spicefactory.lib.reflect.Method;
import org.spicefactory.lib.reflect.Property;
import org.spicefactory.parsley.core.context.Context;
import org.spicefactory.parsley.core.registry.definition.ObjectInstantiator;

class SingletonPropertyInstantiator implements ObjectInstantiator {
	
	private var property:Property;
	
	function SingletonPropertyInstantiator (p:Property) {
		this.property = p;
	}
	
	public function instantiate (context:Context) : Object {
		return property.getValue(null);
	}
	
}

class SingletonMethodInstantiator implements ObjectInstantiator {
	
	private var method:Method;
	
	function SingletonMethodInstantiator (m:Method) {
		this.method = m;
	}
	
	public function instantiate (context:Context) : Object {
		return method.invoke(null, []);
	}
	
}


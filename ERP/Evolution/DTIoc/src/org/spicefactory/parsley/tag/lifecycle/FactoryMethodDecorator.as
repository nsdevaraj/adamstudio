/*
 * Copyright 2008-2009 the original author or authors.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package org.spicefactory.parsley.tag.lifecycle {
import org.spicefactory.lib.reflect.Method;
import org.spicefactory.parsley.core.registry.ObjectDefinition;
import org.spicefactory.parsley.core.registry.ObjectDefinitionDecorator;
import org.spicefactory.parsley.core.registry.ObjectDefinitionFactory;
import org.spicefactory.parsley.core.registry.ObjectDefinitionRegistry;
import org.spicefactory.parsley.core.registry.RootObjectDefinition;
import org.spicefactory.parsley.core.registry.impl.DefaultObjectDefinitionFactory;
import org.spicefactory.parsley.core.registry.impl.ObjectDefinitionWrapper;
import org.spicefactory.parsley.tag.core.NestedTag;
import org.spicefactory.parsley.tag.util.DecoratorUtil;

[Metadata(name="Factory", types="method")]
/**
 * Represents a Metadata, MXML or XML tag that can be used to mark a method as a factory method.
 * 
 * @author Jens Halm
 */
public class FactoryMethodDecorator implements ObjectDefinitionDecorator, NestedTag {

	
	[Target]
	/**
	 * The name of the factory method.
	 */
	public var method:String;
	
	
	/**
	 * @inheritDoc
	 */
	public function decorate (definition:ObjectDefinition, registry:ObjectDefinitionRegistry) : ObjectDefinition {
		
		// Specified definition is for the factory, must be registered as a root factory, 
		// even if the original definition is for a nested object
		var factoryDefinition:RootObjectDefinition = new ObjectDefinitionWrapper(definition);
		registry.registerDefinition(factoryDefinition);
		
		// Must create a new definition for the target type
		var method:Method = DecoratorUtil.getMethod(this.method, definition);
		var targetType:Class = method.returnType.getClass();
		var targetFactory:ObjectDefinitionFactory;
		var targetDefinition:ObjectDefinition;
		if (definition is RootObjectDefinition) {
			var rootDefinition:RootObjectDefinition = RootObjectDefinition(definition);
			targetFactory = new DefaultObjectDefinitionFactory(targetType, rootDefinition.id, rootDefinition.lazy, rootDefinition.singleton);
			targetDefinition = targetFactory.createRootDefinition(registry);
		}
		else {
			targetFactory = new DefaultObjectDefinitionFactory(targetType);
			targetDefinition = targetFactory.createNestedDefinition(registry);
		}
		targetDefinition.instantiator = new FactoryMethodInstantiator(factoryDefinition, method);
		return targetDefinition;		
	}
}
}

import org.spicefactory.lib.reflect.Method;
import org.spicefactory.parsley.core.context.Context;
import org.spicefactory.parsley.core.errors.ContextError;
import org.spicefactory.parsley.core.registry.RootObjectDefinition;
import org.spicefactory.parsley.core.registry.definition.ObjectInstantiator;

class FactoryMethodInstantiator implements ObjectInstantiator {

	
	private var definition:RootObjectDefinition;
	private var method:Method;


	function FactoryMethodInstantiator (definition:RootObjectDefinition, method:Method) {
		this.definition = definition;
		this.method = method;
	}

	
	public function instantiate (context:Context) : Object {
		var factory:Object = context.getObject(definition.id);
		if (factory == null) {
			throw new ContextError("Unable to obtain factory of type " + definition.type.name);
		}
		return method.invoke(factory, []);
	}
	
	
}

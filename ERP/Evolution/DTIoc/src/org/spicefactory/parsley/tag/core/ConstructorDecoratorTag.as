/*
 * Copyright 2009 the original author or authors.
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

package org.spicefactory.parsley.tag.core {
import org.spicefactory.parsley.core.registry.ObjectDefinitionDecorator;
import org.spicefactory.parsley.core.registry.ObjectDefinition;
import org.spicefactory.parsley.core.registry.ObjectDefinitionRegistry;
import org.spicefactory.parsley.core.registry.impl.RegistryValueResolver;
import org.spicefactory.parsley.core.registry.model.ObjectTypeReference;
import org.spicefactory.parsley.core.registry.model.ObjectIdReference;

/**
 * Represent the constructor arguments for an object definition. Can be used in MXML and XML configuration.
 * 
 * @author Jens Halm
 */
public class ConstructorDecoratorTag extends ArrayTag implements ObjectDefinitionDecorator {


	private static const valueResolver:RegistryValueResolver = new RegistryValueResolver(); 


	/**
	 * @inheritDoc
	 */
	public function decorate (definition:ObjectDefinition, registry:ObjectDefinitionRegistry) : ObjectDefinition {
		valueResolver.resolveValues(values, registry);
		for each (var arg:* in values) {
			if (arg is ObjectIdReference) {
				// ignoring required value from config - will be detected with reflection
				definition.constructorArgs.addIdReference(ObjectIdReference(arg).id);
			}
			else if (arg is ObjectTypeReference) {
				definition.constructorArgs.addTypeReference(ObjectTypeReference(arg).type);
			}
			else {
				definition.constructorArgs.addValue(arg);
			}
		}
		return definition;
	}
	
	
}
}

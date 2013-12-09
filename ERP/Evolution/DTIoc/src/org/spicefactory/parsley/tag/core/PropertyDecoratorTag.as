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
import org.spicefactory.lib.reflect.ClassInfo;
import org.spicefactory.parsley.core.errors.ObjectDefinitionBuilderError;
import org.spicefactory.parsley.core.registry.ObjectDefinition;
import org.spicefactory.parsley.core.registry.ObjectDefinitionDecorator;
import org.spicefactory.parsley.core.registry.ObjectDefinitionRegistry;
import org.spicefactory.parsley.core.registry.impl.RegistryValueResolver;

[DefaultProperty("value")]
/**
 * Represent the property value for an object definition. Can be used in MXML and XML configuration.
 * 
 * @author Jens Halm
 */
public class PropertyDecoratorTag extends ObjectReferenceTag implements ObjectDefinitionDecorator {


	private static const valueResolver:RegistryValueResolver = new RegistryValueResolver(); 

	/**
	 * The value of the property mapped as a child element.
	 */
	public var childValue:*;

	/**
	 * The value of the property mapped as an attribute.
	 */
	public var value:*;

	[Required]
	/**
	 * The name of the property. 
	 */
	public var name:String;


	/**
	 * @inheritDoc
	 */
	public function decorate (definition:ObjectDefinition, registry:ObjectDefinitionRegistry) : ObjectDefinition {
		var valueCount:int = 0;
		if (childValue !== undefined) valueCount++;
		if (value !== undefined) valueCount++;
		if (idRef != null) valueCount++;
		if (typeRef != null) valueCount++;
		if (valueCount != 1) {
			throw new ObjectDefinitionBuilderError("Exactly one attribute of value, id-ref or type-ref or a child node without" +
				" attributes must be specified");
		}
		if (idRef != null) {
			definition.properties.addIdReference(name, idRef, required);
		}
		else if (typeRef != null) {
			var ci:ClassInfo = ClassInfo.forClass(typeRef, registry.domain);
			definition.properties.addTypeReference(name, required, ci);
		}
		else if (childValue != null) {
			definition.properties.addValue(name, valueResolver.resolveValue(childValue, registry));
		}
		else if (value != null) {
			definition.properties.addValue(name, valueResolver.resolveValue(value, registry));
		}
		else {
			definition.properties.addTypeReference(name, required);
		}
		return definition;
	}
	
	
}
}

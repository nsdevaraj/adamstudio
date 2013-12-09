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
import org.spicefactory.parsley.core.registry.ObjectDefinition;
import org.spicefactory.parsley.core.registry.ObjectDefinitionDecorator;
import org.spicefactory.parsley.core.registry.ObjectDefinitionRegistry;
import org.spicefactory.parsley.tag.core.NestedTag;

[Metadata(name="Destroy", types="method")]
/**
 * Represents a Metadata, MXML or XML tag that can be used on methods that should be invoked when the Context
 * that the object belongs to gets destroyed or when the object is removed from the Context.
 *
 * @author Jens Halm
 */
public class DestroyMethodDecorator implements ObjectDefinitionDecorator, NestedTag {

	
	[Target]
	/**
	 * The name of the method.
	 */
	public var method:String;
	
	
	/**
	 * @inheritDoc
	 */
	public function decorate (definition:ObjectDefinition, registry:ObjectDefinitionRegistry) : ObjectDefinition {
		definition.destroyMethod = method;
		return definition;
	}
	
	
}
}

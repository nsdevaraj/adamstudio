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

package org.spicefactory.parsley.core.registry {

/**
 * A factory that produces object definitions.
 * 
 * @author Jens Halm
 */
public interface ObjectDefinitionFactory {
	
	
	/**
	 * Creates a root object definition that can be accessed directly by id.
	 * The method must not register the new definition with the registry, that step will be performed
	 * by the container. The specified registry may be used to look up or register additional collaborators/dependencies.
	 * 
	 * @param registry the registry the new definition will be added to
	 * @return a new root object definition
	 */
	function createRootDefinition (registry:ObjectDefinitionRegistry) : RootObjectDefinition;	

	/**
	 * Creates a nested (inline) object definition that cannot be accessed directly.
	 * 
	 * @param registry the registry that the new definition will belong to
	 * @return a new object definition
	 */
	function createNestedDefinition (registry:ObjectDefinitionRegistry) : ObjectDefinition;	

	
}
}

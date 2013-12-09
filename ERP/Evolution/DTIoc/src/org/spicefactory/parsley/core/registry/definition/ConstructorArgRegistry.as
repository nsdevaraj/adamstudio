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

package org.spicefactory.parsley.core.registry.definition {
import org.spicefactory.lib.reflect.ClassInfo;

/**
 * Registry for the constructor arguments for a single object.
 * 
 * @author Jens Halm
 */
public interface ConstructorArgRegistry {
	
	/**
	 * Adds a value to the list of constructor arguments.
	 * 
	 * @param value the value to add
	 * @return this registry instance for method chaining
	 */
	function addValue (value:*) : ConstructorArgRegistry;

	/**
	 * Adds a reference to another object in the registry by id to the list of constructor arguments.
	 * 
	 * @param id the id of the referenced object
	 * @return this registry instance for method chaining
	 */	
	function addIdReference (id:String) : ConstructorArgRegistry;

	/**
	 * Adds a reference to another object in the registry by type to the list of constructor arguments.
	 * If the type parameter is omitted the registry will reflect on the type of the next constructor 
	 * parameter the reference will be associated with.
	 * 
	 * @param type the type of the referenced object or null for auto-resolving
	 * @return this registry instance for method chaining
	 */	
	function addTypeReference (type:ClassInfo = null) : ConstructorArgRegistry;
	
	/**
	 * Returns the constructor argument value for the specified argument index.
	 * 
	 * @param index the index to return the value for
	 * @return the constructor argument value for the specified argument index
	 */
	function getAt (index:uint) : *;
	
	/**
	 * Returns all constructor argument values added to this registry.
	 * 
	 * @return all constructor argument values added to this registry
	 */
	function getAll () : Array;
	
}
}

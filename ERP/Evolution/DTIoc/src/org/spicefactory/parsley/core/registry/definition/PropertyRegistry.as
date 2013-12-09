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
 * Registry for the property values for a single instance.
 * 
 * @author Jens Halm
 */
public interface PropertyRegistry {
	
	/**
	 * Adds a property value.
	 * 
	 * @param name the name of the property
	 * @param value the value of the property
	 * @return this registry instance for method chaining
	 */
	function addValue (name:String, value:*) : PropertyRegistry;
	
	/**
	 * Adds a reference to another object in the registry by id as a property value.
	 * 
	 * @param name the name of the property
	 * @param id the id of the referenced object
	 * @param required whether the referenced object is a required dependency.
	 * @return this registry instance for method chaining
	 */	
	function addIdReference (name:String, id:String, required:Boolean = true) : PropertyRegistry;

	/**
	 * Adds a reference to another object in the registry by type as a property value.
	 * If the type parameter is omitted the registry will reflect on the type of the specified property.
	 * 
	 * @param name the name of the property
	 * @param required whether the referenced object is a required dependency.
	 * @param type the type of the referenced object or null for auto-resolving
	 * @return this registry instance for method chaining
	 */	
	function addTypeReference (name:String, required:Boolean = true, type:ClassInfo = null) : PropertyRegistry;
	
	/**
	 * Removes the value for the specified property.
	 * 
	 * @param name the name of the property to remove the value for
	 */
	function removeValue (name:String) : void;
	
	/**
	 * Returns the value of the property with the specified name.
	 * 
	 * @param name the name of the property.
	 * @return the value of the property with the specified name
	 */
	function getValue (name:String) : *;

	/**
	 * Returns all property values added to this registry as an Array of PropertyValue instances.
	 * 
	 * @return all property values added to this registry as an Array of PropertyValue instances
	 */
	function getAll () : Array;
		
}
}

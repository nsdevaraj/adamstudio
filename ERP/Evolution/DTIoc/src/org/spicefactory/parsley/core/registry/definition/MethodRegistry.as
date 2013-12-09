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

/**
 * Registry for the parameters for all configured methods for a single instance.
 * 
 * @author Jens Halm
 */
public interface MethodRegistry {
	
	/**
	 * Creates a new parameter registry for the specified method and adds it to this registry.
	 * 
	 * @param methodName the name of the method
	 * @return a new registry for the parameters of the specified method
	 */
	function addMethod (methodName:String) : MethodParameterRegistry;
	
	/**
	 * Adds the configuration for dependency injection by type for the parameters of the specified method.
	 * 
	 * @param methodName the name of the method
	 */
	function addTypeReferences (methodName:String) : void;
	
	/**
	 * Removes the configuration of parameters for the specified method.
	 * 
	 * @param methodName the name of the method
	 */
	function removeMethod (methodName:String) : void;
	
	/**
	 * Returns the parameter registry for the specified method.
	 * 
	 * @return the parameter registry for the specified method
	 */
	function getMethod (methodName:String) : MethodParameterRegistry;
	
	/**
	 * Returns all parameter registries that were added to this registry.
	 * 
	 * @return all parameter registries that were added to this registry
	 */
	function getAll () : Array;
	
}

}

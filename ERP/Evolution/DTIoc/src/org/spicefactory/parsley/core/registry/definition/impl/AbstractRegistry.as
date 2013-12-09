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

package org.spicefactory.parsley.core.registry.definition.impl {
import org.spicefactory.lib.errors.IllegalStateError;
import org.spicefactory.parsley.core.registry.ObjectDefinition;

/**
 * Abstract registry base class.
 * 
 * @author Jens Halm
 */
public class AbstractRegistry {
	
	
	/**
	 * The definition of the object this registry is associated with.
	 */
	protected var definition:ObjectDefinition;
	
	
	/**
	 * Creates a new instance.
	 * 
	 * @param def the definition of the object this registry is associated with
	 */
	function AbstractRegistry (def:ObjectDefinition) {
		this.definition = def;
	}
	
	
	/**
	 * Checks if the associated definition has already been frozen and throws an error in that case.
	 */
	protected function checkState () : void {
		if (definition.frozen) {
			throw new IllegalStateError("" + definition + " is frozen");
		}
	}
	
	
}
}

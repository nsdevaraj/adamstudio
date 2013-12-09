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

package org.spicefactory.parsley.core.registry.model {
import org.spicefactory.lib.reflect.Property;

/**
 * Represents a single property value.
 * 
 * @author Jens Halm
 */
public class PropertyValue {
	
	
	private var _property:Property;
	private var _value:*;
	
	
	/**
	 * Creates a new instance.
	 * 
	 * @param property the Property instance
	 * @param value the value for the property
	 */
	function PropertyValue (property:Property, value:*) {
		_property = property;
		_value = value;
	}
	
	/**
	 * The Property instance.
	 */
	public function get property () : Property {
		return _property;
	}
	
	/**
	 * The value for the property.
	 */
	public function get value () : * {
		return _value;
	}
	
	
}

}

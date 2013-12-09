/*
 * Copyright 2007 the original author or authors.
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
 
package org.spicefactory.lib.reflect.converter {
import org.spicefactory.lib.reflect.Converter;
import org.spicefactory.lib.reflect.errors.ConversionError;

/**
 * Converts boolean values.
 * 
 * @author Jens Halm
 */
public class BooleanConverter implements Converter {
	
	
	public static var INSTANCE:BooleanConverter = new BooleanConverter();
	
	
	/**
	 * Creates a new Converter instance
	 */
	function BooleanConverter () {
		
	}
	
	/**
	 * @inheritDoc
	 */
	public function convert (value:*) : * {
		if (value is Boolean) {
			return value;
		}
		if (value == null) {
			throw new ConversionError("Cannot convert null value to Boolean"); 
		}
		var str:String = value.toString();
		if (str != "true" && str != "false") {
			throw new ConversionError("Illegal value for boolean type: " + str);
		}
		return (str == "true");
	}
	
	
}

}
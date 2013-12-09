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
 
package org.spicefactory.lib.flash.logging {

/**
 * Static utility methods for formatting log output.
 * 
 * @author Jens Halm
 */	
public class FlashLogUtil {

	/**
	 * Creates formatted log output for the given Object, starting with the specified indentation level.
	 * Each property name and value for the specified object will be added to the formatted output.
	 * 
	 * @param obj the Object to create formatted output for
	 * @param indent the indentation level to start from
	 * @return the formatted log output
	 */	
	public static function formatObject (obj:Object, indent:uint) : String {
		var cnt:uint = 0;
		var prop:String;
		for (prop in obj) cnt++;
		var s:String = "Object(" + cnt + "):";
		indent++;
		for (prop in obj) {
			s += "\n";
			for (var idx:Number = 0; idx < indent; idx++) s += "  ";
			s += prop + " = " + format(obj[prop], indent);
		}
		return s;
	}
	
	/**
	 * Creates formatted log output for the given Array, starting with the specified indentation level.
	 * 
	 * @param arr the Array to create formatted output for
	 * @param indent the indentation level to start from
	 * @return the formatted log output
	 */
	public static function formatArray (arr:Array, indent:uint) : String {
		var s:String = "Array(" + arr.length + "):";
		var len:uint = arr.length;
		indent++;
		for (var i:uint = 0; i < len; i++) {
			s += "\n";
			for (var idx:uint = 0; idx < indent; idx++) s += "  ";
			s += "[" + i + "] = " + format(arr[i], indent);
		}
		return s;
	}

	/**
	 * Creates formatted log output for the given value, starting with the specified indentation level.
	 * 
	 * @param value the value to create formatted output for
	 * @param indent the indentation level to start from
	 * @return the formatted log output
	 */		
	public static function format (value:*, indent:uint = 0) : String {
		if (value is Array) return formatArray(value, indent);
		if (value is Object) return formatObject(value, indent);
		return value.toString();
	}
	
}
	
}
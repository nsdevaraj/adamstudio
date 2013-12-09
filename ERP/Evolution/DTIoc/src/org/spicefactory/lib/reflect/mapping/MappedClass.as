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

package org.spicefactory.lib.reflect.mapping {
import org.spicefactory.lib.reflect.ClassInfo;
import org.spicefactory.lib.reflect.Property;
import org.spicefactory.lib.reflect.metadata.AssignableTo;
import org.spicefactory.lib.reflect.metadata.Required;

/**
 * Represents a class that can be mapped to a metadata tag or an XML tag.
 * 
 * @author Jens Halm
 */
public class MappedClass {

	
	private var _type:ClassInfo;
	private var _properties:Array;
	
	
	/**
	 * Creates a new instance.
	 * 
	 * @param type the mapped class
	 * @param type the properties to map values to (will be determined reflectively if omitted)
	 */
	function MappedClass (type:ClassInfo, properties:Array = null) {
		this._type = type;
		if (properties != null) {
			_properties = properties;
		}
		else {
			init();
		}
	}
	
	private function init () : void {
		_properties = new Array();
		for each (var p:Property in _type.getProperties()) {
			if (!p.writable) continue;
			var reqMeta:Array = p.getMetadata(Required);
			var required:Boolean = (reqMeta.length == 1);
			var assignableMeta:Array = p.getMetadata(AssignableTo);
			var assignableTo:ClassInfo = (assignableMeta.length == 1) 
					? ClassInfo.forClass(AssignableTo(assignableMeta[0]).type) : null;
			if (assignableTo != null && p.type.getClass() != Class && p.type.getClass() != ClassInfo) {
				throw new Error("Illegal placement of AssignableTo tag on " + p 
						+ " - tag is only allowed on properties of type Class or ClassInfo");
			}	
			_properties.push(new MappedProperty(p, required, assignableTo));
		}
	}
	
	/**
	 * The mapped class.
	 */
	public function get type () : ClassInfo {
		return _type;	
	}
	
	/**
	 * Creates a new instance mapping the values of the specified Object to the mapped class.
	 * 
	 * @param values a map of values with keys corresponding to property names of the mapped class
	 * @param validate whether the mapping should be validated
	 * @return a new instance reflecting the mapped values
	 */
	public function newInstance (values:Object, validate:Boolean) : Object {
		var instance:Object = _type.newInstance([]);
		for each (var prop:MappedProperty in _properties) {
			prop.mapValue(instance, values, validate);
		}
		if (validate) {
			var unmapped:Array = new Array();
			for (var key:String in values) {
				unmapped.push(key);
			}
			if (unmapped.length > 0) {
				throw new ValidationError("Unmappable attributes for mapped class " 
						+ _type.name + ": " + unmapped.join(","));
			}
		}
		return instance;		
	}

	
}

}

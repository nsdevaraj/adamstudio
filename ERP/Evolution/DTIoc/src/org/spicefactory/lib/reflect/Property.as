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
 
package org.spicefactory.lib.reflect {
import org.spicefactory.lib.reflect.errors.PropertyError;
import org.spicefactory.lib.reflect.metadata.Types;

/**
 * Represents a single property. 
 * The property may have been declared with var, const or implicit getter/setter functions
 * 
 * @author Jens Halm
 */
public class Property extends Member {


	private var _type:ClassInfo;
	
	private var _isStatic:Boolean;
	private var _readable:Boolean;
	private var _writable:Boolean;
	
	
	/**
	 * @private
	 */
	function Property (name:String, type:ClassInfo, readable:Boolean, writable:Boolean, s:Boolean, 
			metadata:MetadataCollection, owner:ClassInfo) {
		super(name, owner, metadata);
		this._type = type;
		this._readable = readable;
		this._writable = writable;
		this._isStatic = s;
	}

	/**
	 * @private
	 */
	internal static function fromAccessorXML (x:XML, isStatic:Boolean, owner:ClassInfo) : Property {
		var access:String = x.@access;
		var readable:Boolean = (access != "writeonly");
		var writable:Boolean = (access != "readonly");
		return fromXML(x, readable, writable, isStatic, owner);
	}
	
	/**
	 * @private
	 */
	internal static function fromVariableXML (x:XML, isStatic:Boolean, owner:ClassInfo) : Property {
		return fromXML(x, true, true, isStatic, owner);
	}
	
	/**
	 * @private
	 */
	internal static function fromConstantXML (x:XML, isStatic:Boolean, owner:ClassInfo) : Property {
		return fromXML(x, true, false, isStatic, owner);
	}
	
	private static function fromXML 
			(x:XML, readable:Boolean, writable:Boolean, isStatic:Boolean, owner:ClassInfo) : Property {
		var type:ClassInfo = ClassInfo.forName(x.@type, owner.applicationDomain);
		var metadata:MetadataCollection = MetadataAware.metadataFromXml(x, Types.PROPERTY);
		return new Property(x.@name, type, readable, writable, isStatic, metadata, owner); 		
	}
	
	
	/**
	 * Returns the type of this Property.
	 * 
	 * @return the type of this Property
	 */
	public function get type () : ClassInfo {
		return _type;
	}
	
	/**
	 * Determines if this instance represents a static property.
	 * 
	 * @return true if this instance represents a static property
	 */
	public function get isStatic () : Boolean {
		return _isStatic;
	}
	
	/**
	 * Determines if this instance represents a readable property.
	 * 
	 * @return true if this instance represents a readable property
	 */
	public function get readable () : Boolean {
		return _readable;
	}
	
	/**
	 * Determines if this instance represents a writable property.
	 * Properties declared with var or an implicit setter method are writable.
	 * Properties declared with const or with an implicit getter without matching setter method
	 * are not writable.
	 * 
	 * @return true if this instance represents a writable property
	 */
	public function get writable () : Boolean {
		return _writable;
	}
	
	/**
	 * Returns the value of the property represented by this instance in the specified target instance.
	 * 
	 * @param instance the instance whose property value should be retrieved or null if the property
	 * is static
	 * @return the value of the property represented by this instance in the specified target instance
	 * @throws org.spicefactory.lib.reflect.errors.PropertyError if the property is not readable or
	 * if the specified target instance is not of the required type
	 */
	public function getValue (instance:Object) : * {
		if (!_readable) {
			throw new PropertyError("" + this + " is write-only");
		}
		checkInstanceParameter(instance);
		return (_isStatic) ? owner.getClass()[name] : instance[name];
	}
	
	/**
	 * Sets the value of the property represented by this instance in the specified target instance.
	 * 
	 * @param instance the instance whose property value should be set or null if the property
	 * is static
	 * @param value the new value for the property
	 * @return the (probably converted) value that was set for the property in the target instance
	 * @throws org.spicefactory.lib.reflect.errors.ConversionError if the specified value is not
	 * of the required type and cannot be converted
	 * @throws org.spicefactory.lib.reflect.errors.PropertyError if the property is not writable or
	 * if the specified target instance is not of the required type
	 */
	public function setValue (instance:Object, value:*) : * {
		if (!_writable) {
			throw new PropertyError("" + this + " is read-only");
		}
		checkInstanceParameter(instance);
		value = Converters.convert(value, type.getClass());
		if (_isStatic) {
			owner.getClass()[name] = value;
		} else {
			instance[name] = value;
		}
		return value;
	}
	
	private function checkInstanceParameter (instance:Object) : void {
		if (_isStatic) {
			if (instance != null && instance != owner.getClass()) {
				throw new PropertyError("Instance parameter must be of type Class or null for static properties");
			}
		} else {
			if (instance == null) {
				throw new PropertyError("Instance parameter must not be null for non-static properties");
			} else if (!(instance is owner.getClass())) {
				throw new PropertyError("Instances must be of type " + owner.name);
			}
		}		
	}
	
	/**
	 * @private
	 */
	public function toString () : String {
		return "[Property " + name + " in class " + owner.name + "]";
	}


}

}
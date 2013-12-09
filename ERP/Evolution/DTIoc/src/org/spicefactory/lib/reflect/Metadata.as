/*
 * Copyright 2008 the original author or authors.
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
import org.spicefactory.lib.reflect.mapping.MappedClass;
import org.spicefactory.lib.reflect.mapping.MappedProperty;
import org.spicefactory.lib.reflect.mapping.ValidationError;
import org.spicefactory.lib.reflect.metadata.AssignableTo;
import org.spicefactory.lib.reflect.metadata.DefaultProperty;
import org.spicefactory.lib.reflect.metadata.EventInfo;
import org.spicefactory.lib.reflect.metadata.MappedMetadata;
import org.spicefactory.lib.reflect.metadata.Required;
import org.spicefactory.lib.reflect.metadata.Types;

import flash.system.ApplicationDomain;

/**
 * Represents a single metadata tag associated with a class, property or method declaration.
 * 
 * @author Jens Halm
 */
public class Metadata {
	
	
	private static var metadataClasses:Object = new Object();
	private static var initialized:Boolean = false;
	
	private var _name:String;
	private var _type:String;
	private var _arguments:Object;
	private var registration:MetadataClassRegistration;
	
	
	/**
	 * @private
	 */
	function Metadata (name:String, args:Object, type:String) {
		_name = name;
		_arguments = args;
		_type = type;
	}
	
	/**
	 * @private
	 */
	internal static function fromXml (xml:XML, type:String) : Metadata {
		if (!initialized) initialize();
		var name:String = xml.@name;
		var args:Object = new Object();
		for each (var argTag:XML in xml.arg) {
			args[argTag.@key] = argTag.@value;
		} 
		return new Metadata(name, args, type);
	}
	
	
	/**
	 * Registers a custom Class for representing metadata tags.
	 * If no custom Class is registered for a particular tag an instance of this generic <code>Metadata</code>
	 * class will be used to represent the tag and its arguments. For type-safe access to such
	 * tags a custom Class can be registered. In this case the arguments of the metadata tag
	 * will be mapped to the corresponding properties with the same name. Type conversion occurs 
	 * automatically if necessary. If the builtin basic Converters are not sufficient for a particular
	 * type you can register custom <code>Converter</code> instances with the <code>Converters</code>
	 * class. Arguments on the metadata tag without a matching property will be silently ignored. 
	 * 
	 * <p>The specified metadata class should be annotated itself with a <code>[Metadata]</code> tag.
	 * See the documentation for the <code>MappedMetadata</code> class for details.</p>
	 * 
	 * @param metadataClass the custom Class to use for representing that tag
	 * @param appDomain the ApplicationDomain to use for loading classes when reflecting on the specified 
	 * Metadata class
	 */
	public static function registerMetadataClass (metadataClass:Class, 
			appDomain:ApplicationDomain = null) : void {
		if (!initialized) initialize();
		//ClassInfo.clearCache();
		var reg:MetadataClassRegistration = 
				new MetadataClassRegistration(ClassInfo.forClass(metadataClass, appDomain));
		for each (var key:String in reg.registrationKeys) {
			metadataClasses[key] = reg;
		} 
	}
	
	private static function initialize () : void {
		initialized = true;
		for each (var reg:MetadataClassRegistration in createInternalRegistrations()) {
			for each (var key:String in reg.registrationKeys) {
				metadataClasses[key] = reg;
			} 
		}
		registerMetadataClass(EventInfo);
	}
	
	/**
	 * The name of the metadata tag.
	 */
	public function get name () : String {
		return _name;
	}
	
	/**
	 * Returns the argument for the specified key as a String or null if no such argument exists.
	 * 
	 * @return the argument for the specified key as a String or null if no such argument exists
	 */
	public function getArgument (key:String) : String {
		return _arguments[key];
	} 
	

	/**
	 * Returns the default argument as a String or null if no such argument exists.
	 * The default argument is the value that was specified without an excplicit key (e.g.
	 * <code>[Meta("someValue")]</code> compared to <code>[Meta(key="someValue")]</code>).
	 * 
	 * @return the default argument as a String or null if no such argument exists
	 */
	public function getDefaultArgument () : String {
		return _arguments[""];
	} 
	
	/**
	 * @private
	 */
	internal function resolve () : Boolean {
		registration = MetadataClassRegistration(metadataClasses[name + " " + _type]);
		if (registration == null) {
			return false;
		}
		if (registration.defaultProperty != null && _arguments[""] != undefined) {
			_arguments[registration.defaultProperty] = _arguments[""];
			delete _arguments[""];
		}
		return true;
	}
	
	/**
	 * @private
	 */
	internal function getExternalValue (validate:Boolean, first:Boolean) : Object {
		if (registration == null) {
			return this;
		}
		if (validate && !first && !registration.allowMultiple) {
			throw new ValidationError("Multiple occurrences of the tag mapped to " 
					+ registration.mappedClass.type.name + " on the same element are not allowed");
		}
		// Create a new instance on each access so that modifications of property values
		// have no effect.
		var values:Object = new Object();
		for (var key:String in _arguments) {
			values[key] = _arguments[key];
		}
		return registration.mappedClass.newInstance(values, validate);
	}
	
	public static function createInternalRegistrations () : Array {
		/* Internal tags like [Metadata] cannot be created through Reflection
		   as this would lead to a chicken-and-egg problem. */
	    var internalRegs:Array = new Array();
	    var ci:ClassInfo = ClassInfo.forClass(MappedMetadata);
	    var props:Array = [new MappedProperty(ci.getProperty("name")), 
	    		new MappedProperty(ci.getProperty("types")), 
	    		new MappedProperty(ci.getProperty("multiple"))];
	    internalRegs.push(createRegistration("Metadata", 
	   			ci, [Types.CLASS], null, props));
	    internalRegs.push(createRegistration("DefaultProperty", 
	    		ClassInfo.forClass(DefaultProperty), [Types.PROPERTY]));
	    internalRegs.push(createRegistration("Required", 
	    		ClassInfo.forClass(Required), [Types.PROPERTY]));
	    ci = ClassInfo.forClass(AssignableTo);
	    internalRegs.push(createRegistration("AssignableTo", 
	    		ci, [Types.PROPERTY], "type", [new MappedProperty(ci.getProperty("type"), true)]));
	    		
	    return internalRegs;
	}
	
	private static function createRegistration (name:String, metadataType:ClassInfo, annotatedTypes:Array, 
			defaultProperty:String = null, properties:Array = null)
			: MetadataClassRegistration {
		if (properties == null) properties = [];
		var reg:MetadataClassRegistration = new MetadataClassRegistration();
		reg.name = name;
		reg.mappedClass = new MappedClass(metadataType, properties);
		reg.annotatedTypes = annotatedTypes;
		reg.defaultProperty = defaultProperty;
		
		for each (var key:String in reg.registrationKeys) {
			metadataClasses[key] = reg;
		} 
		
		return reg;
	}
	
	/**
	 * @private
	 */
	internal function getKey () : Object {
		if (registration == null) {
			return _name;
		}
		else {
			return registration.mappedClass.type.getClass();
		}
	}
	
	/**
	 * @private
	 */
	public function toString () : String {
		return "[Metadata name=" + name + "]";
	}
	
	
}
}

import org.spicefactory.lib.errors.IllegalArgumentError;
import org.spicefactory.lib.reflect.ClassInfo;
import org.spicefactory.lib.reflect.Property;
import org.spicefactory.lib.reflect.mapping.MappedClass;
import org.spicefactory.lib.reflect.metadata.DefaultProperty;
import org.spicefactory.lib.reflect.metadata.MappedMetadata;
import org.spicefactory.lib.reflect.metadata.Types;

class MetadataClassRegistration {
	
	
	public var name:String;
	public var mappedClass:MappedClass;
	public var defaultProperty:String;
	public var annotatedTypes:Array;
	public var allowMultiple:Boolean;
	
	
	function MetadataClassRegistration (type:ClassInfo = null) {
		if (type != null) {
			var metadata:Array = type.getMetadata(MappedMetadata);
			if (metadata.length != 1) {
				throw new IllegalArgumentError("Expected exactly one [Metadata] tag on Class " + type.name);
			}
			var mappedMetadata:MappedMetadata = MappedMetadata(metadata[0]);
			this.name = (mappedMetadata.name == null) ? type.simpleName : mappedMetadata.name;
			this.allowMultiple = mappedMetadata.multiple;
			
			this.annotatedTypes = (mappedMetadata.types == null || mappedMetadata.types.length == 0)
					? [Types.CLASS, Types.CONSTRUCTOR, Types.PROPERTY, Types.METHOD] : mappedMetadata.types;
			for each (var p:Property in type.getProperties()) {
				metadata = p.getMetadata(DefaultProperty);
				if (metadata.length == 1) {
					if (this.defaultProperty != null) {
						throw new IllegalArgumentError("Expected no more than one property annotated " +
								"with [DefaultProperty] on Class " + type.name);
					}
					this.defaultProperty = p.name;
				}
			}
			this.mappedClass = new MappedClass(type);
		}
	}
	
	public function get registrationKeys () : Array {
		var keys:Array = new Array();
		for each (var type:String in annotatedTypes) {
			keys.push(name + " " + type);
		}
		return keys;
	}
	
	
}


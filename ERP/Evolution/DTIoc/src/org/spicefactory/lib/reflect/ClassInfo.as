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
import org.spicefactory.lib.errors.IllegalStateError;
import org.spicefactory.lib.reflect.metadata.Types;
import org.spicefactory.lib.reflect.types.Any;
import org.spicefactory.lib.reflect.types.Private;
import org.spicefactory.lib.reflect.types.Void;
import org.spicefactory.lib.util.collection.SimpleMap;

import flash.system.ApplicationDomain;
import flash.utils.Dictionary;
import flash.utils.Proxy;
import flash.utils.describeType;
import flash.utils.getQualifiedClassName;

/**
 * Represents a class or interface and allows reflection on its name, properties and methods.
 * Instances of this class can be obtained with one of the three static methods (<code>forName</code>,
 * <code>forClass</code> or <code>forInstance</code>). ClassInfo instances are cached and rely on
 * the XML returned by <code>flash.utils.describeType</code> internally.
 * 
 * @author Jens Halm
 */
public class ClassInfo extends MetadataAware {


	private static var cache:Dictionary = new Dictionary();
	
	/**
	 * The ApplicationDomain to be used when no domain was explicitly specified.
	 * Points to ApplicationDomain.currentDomain but makes sure that always the
	 * same instance will be used. Since ApplicationDomain.currentDomain always
	 * returns a different instance it would be difficult to use domains as keys 
	 * in Dictionaries otherwise.
	 */
	public static const currentDomain:ApplicationDomain = ApplicationDomain.currentDomain;
	
	
	/**
	 * Returns an instance representing the class or interface with the specified name.
	 * If the optional <code>domain</code> parameter is omitted <code>ApplicationDomain.currentDomain</code>
	 * will be used.
	 * 
	 * @param name the fully qualified name of the class or interface
	 * @param domain the ApplicationDomain to load the class from
	 * @return an instance representing the class or interface with the specified name
	 * @throws ReferenceError if the class with the specified name does not exist
	 */
	public static function forName (name:String, domain:ApplicationDomain = null) : ClassInfo {
		domain = getDomain(domain);
		var C:Class = getClassDefinitionByName(name, domain);
		return getClassInfo(C, domain, name);
	}

	/**
	 * Returns an instance representing the specified class or interface.
	 * If the optional <code>domain</code> parameter is omitted <code>ApplicationDomain.currentDomain</code>
	 * will be used.
	 * 
	 * @param clazz the class or interface to reflect on
	 * @param domain the ApplicationDomain the specified class was loaded from
	 * @return an instance representing the specified class or interface
	 */	
	public static function forClass (clazz:Class, domain:ApplicationDomain = null) : ClassInfo {
		return getClassInfo(clazz, getDomain(domain));
	}

	/**
	 * Returns an instance representing the class of the specified instance.
	 * If the optional <code>domain</code> parameter is omitted <code>ApplicationDomain.currentDomain</code>
	 * will be used.
	 * 
	 * @param instance the instance to return the ClassInfo for
	 * @return an instance representing the class of the specified instance
	 */		
	public static function forInstance (instance:Object, domain:ApplicationDomain = null) : ClassInfo {
		if (instance is Proxy || instance is Number) {
			// Cannot rely on Proxy subclasses to support the constructor property
			// For Number instance constructor property always returns Number (never int)
			return forName(getQualifiedClassName(instance), domain);
		}
		var C:Class = instance.constructor as Class;
		return getClassInfo(C, getDomain(domain));
	}
	
	private static function getDomain (domain:ApplicationDomain) : ApplicationDomain {
		return (domain == null) ? currentDomain : domain;
	}
	
	private static function getClassDefinitionByName (name:String, domain:ApplicationDomain) : Class {
		if (name == "*") {
			return Any;
		} else if (name == "void") {
			return Void;
		} else if (name.indexOf(".as$") != -1) {
			return Private;
		} else {
			return domain.getDefinition(name) as Class;
		}
	}
	
	private static function getClassInfo (clazz:Class, domain:ApplicationDomain, name:String = null) : ClassInfo {
		if (name == null) {
			name = getQualifiedClassName(clazz);
		}
		var cacheEntry:ClassInfo = getFromCache(clazz, domain);
		if (cacheEntry != null) {
			return cacheEntry;
		}
		var ci:ClassInfo = new ClassInfo(name, clazz, domain);
		putIntoCache(ci, domain);
		return ci;		
	}
	
	private static function getFromCache (type:Class, domain:ApplicationDomain) : ClassInfo {
		var domainCache:Dictionary = cache[domain];
		return (domainCache == null) ? null : domainCache[type] as ClassInfo;
	}
	
	private static function putIntoCache (info:ClassInfo, domain:ApplicationDomain) : void {
		var domainCache:Dictionary = cache[domain];
		if (domainCache == null) {
			domainCache = new Dictionary();
			cache[domain] = domainCache;
		}
		domainCache[info.getClass()] = info;
	}
	
	/**
	 * Purges all cached ClassInfo instance from the specified domain.
	 * If the ApplicationDomain parameter is omitted the cache will be cleared for all ApplicationDomains.
	 * 
	 * @param domain the ApplicationDomain to purge all cached ClassInfo instances from
	 */
	public static function purgeCache (domain:ApplicationDomain = null) : void {
		if (domain != null) {
			delete cache[domain];
		}
		else {
			clearCache();			
		}
	} 
	
	/**
	 * @private
	 */
	internal static function clearCache () : void {
		cache = new Dictionary();
	}

	
	private var _name:String;
	private var _simpleName:String;
	
	private var initialized:Boolean;
	private var type:Class;
	private var _applicationDomain:ApplicationDomain;
	
	private var _constructor:Constructor;
	private var properties:SimpleMap;
	private var staticProperties:SimpleMap;
	private var methods:SimpleMap;
	private var staticMethods:SimpleMap;
	private var superClasses:Array;
	private var interfaces:Array;
	private var _interface:Boolean;
	
	/**
	 * @private
	 */
	function ClassInfo (name:String, type:Class, domain:ApplicationDomain) {
		super(null); // Defer creation of metadata until init gets executed
		this._name = name;
		this.type = type;
		this._applicationDomain = domain;
	}

	private function initCollections () : void {
		properties = new SimpleMap();
		staticProperties = new SimpleMap();
		methods = new SimpleMap();
		staticMethods = new SimpleMap();
		superClasses = new Array();
		interfaces = new Array();
	}
	
	private function init () : void {
		if (initialized) return;
		initCollections();
		var xml:XML = describeType(type);
		var staticChildren:XMLList = xml.children();
		for each (var staticChild:XML in staticChildren) {
			var name:String = staticChild.localName() as String;
			if (name == "accessor") {
				var staticAccessor:Property = Property.fromAccessorXML(staticChild, true, this);
				staticProperties.put(staticAccessor.name, staticAccessor);
			} else if (name == "constant") {
				var staticConstant:Property = Property.fromConstantXML(staticChild, true, this);
				staticProperties.put(staticConstant.name, staticConstant);
			} else if (name == "variable") {
				var staticVariable:Property = Property.fromVariableXML(staticChild, true, this);
				staticProperties.put(staticVariable.name, staticVariable);
			} else if (name == "method") {
				var sm:Method = Method.fromXML(staticChild, true, this);
				staticMethods.put(sm.name, sm);
			} else if (name == "factory") {
				setMetadata(metadataFromXml(staticChild, Types.CLASS));
				_interface = (staticChild.elements("extendsClass").length() == 0 && type != Object);
				var instanceChildren:XMLList = staticChild.children();
				for each (var instanceChild:XML in instanceChildren) {
					var childName:String = instanceChild.localName() as String;
					if (childName == "constructor") {
						_constructor = Constructor.fromXML(instanceChild, this);
					} else if (childName == "accessor") {
						if (representsPublicMember(instanceChild)) {
							var accessor:Property = Property.fromAccessorXML(instanceChild, false, this);
							properties.put(accessor.name, accessor);
						}
					} else if (childName == "constant") {
						if (representsPublicMember(instanceChild)) {
							var constant:Property = Property.fromConstantXML(instanceChild, false, this);
							properties.put(constant.name, constant);
						}
					} else if (childName == "variable") {
						if (representsPublicMember(instanceChild)) {
							var variable:Property = Property.fromVariableXML(instanceChild, false, this);
							properties.put(variable.name, variable);
						}
					} else if (childName == "method") {
						if (representsPublicMember(instanceChild)) {
							var m:Method = Method.fromXML(instanceChild, false, this);
							methods.put(m.name, m);
						}
					} else if (childName == "extendsClass") {
						superClasses.push(getDefinition(instanceChild.@type));
					} else if (childName == "implementsInterface") {
						interfaces.push(getDefinition(instanceChild.@type));
					}
				}
			}
		}
		if (!_interface && _constructor == null) {
			// empty default constructor
			_constructor = new Constructor([], new MetadataCollection([]), this);
		}
		initialized = true;
	}
	
	private function getDefinition (name:String) : Class {
		try {
			return _applicationDomain.getDefinition(name) as Class;
		}
		catch (e:ReferenceError) {
			/* fall through */
		}
		return Private;
	}
	
	/**
	 * Since there is no way to reflectively invoke namespace scoped methods we will
	 * not add them. But there is the edge case that interface methods have an uri
	 * that equals the fully qualified name of the interface. That is the only case where
	 * we accept an uri attribute.
	 * 
	 * @return whether we accept the type as a public member
	 */
	private function representsPublicMember (xml:XML) : Boolean {
		return (xml.@uri.length() == 0 || _interface);
	}
	
	/**
	 * The fully qualified class name for this instance.
	 */
	public function get name () : String {
		return _name;
	}
	
	/**
	 * The non qualified class name for this instance.
	 */
	public function get simpleName () : String {
		if (_simpleName == null) {
			var name:String = _name.replace("::", ".");
			_simpleName = name.substring(name.lastIndexOf(".") + 1);
		}
		return _simpleName;
	}
	
	
	/**
	 * Creates a new instance of the class represented by this ClassInfo instance.
	 * This is just a shortcut for <code>ClassInfo.getConstructor().newInstance()</code>.
	 * 
	 * @param constructorArgs the argumenst to pass to the constructor
	 * @return a new instance of the class represented by this ClassInfo instance
	 */
	public function newInstance (constructorArgs:Array) : Object {
		init();
		if (_interface) {
			throw new IllegalStateError("Cannot instantiate an interface: " + name);
		}
		return _constructor.newInstance(constructorArgs);
	}
	
	/**
	 * Returns the class this instance represents.
	 * 
	 * @return the class this instance represents
	 */
	public function getClass () : Class {
		return type;
	}
	
	/**
	 * The ApplicationDomain this class belongs to. It will be used to load
	 * all dependent classes referenced by properties or methods of this class.
	 */
	public function get applicationDomain () : ApplicationDomain {
		return _applicationDomain;
	}

	/**
	 * Indicates whether this type is an interface.
	 * 
	 * @return true if this type is an interface
	 */
	public function isInterface () : Boolean {
		init();
		return _interface;
	}
	
	/**
	 * Returns the constructor for this class.
	 * This method will return null for interfaces.
	 * 
	 * @return the constructor for this class
	 */
	public function getConstructor () : Constructor {
		init();
		return _constructor;
	}

	/**
	 * Returns the Property instance for the specified property name.
	 * The property may be declared in this class or in one of its superclasses or superinterfaces.
	 * The property must be public and non-static 
	 * and may have been declared with var, const or implicit getter/setter functions.
	 * 
	 * @param name the name of the property
	 * @return the Property instance for the specified property name or null if no such property exists
	 */
	public function getProperty (name:String) : Property {
		init();
		return properties.get(name) as Property;
	}
	
	/**
	 * Returns Property instances for all public, non-static properties of this class.
	 * Included are all properties declared in this class 
	 * or in one of its superclasses or superinterfaces with var, const or implicit getter/setter
	 * functions.
	 * 
	 * @return Property instances for all public, non-static properties of this class
	 */
	public function getProperties () : Array {
		init();
		return properties.values;
	}

	/**
	 * Returns the Property instance for the specified property name.
	 * The property must be public and static and may have been declared 
	 * with var, const or implicit getter/setter functions.
	 * Static properties of superclasses or superinterfaces are not included.
	 * 
	 * @param name the name of the static property
	 * @return the Property instance for the specified property name or null if no such property exists
	 */	
	public function getStaticProperty (name:String) : Property {
		init();
		return staticProperties.get(name) as Property;
	}

	/**
	 * Returns Property instances for all public, static properties of this class.
	 * Included are all static properties declared in this class
	 * with var, const or implicit getter/setter
	 * functions.
	 * 
	 * @return Property instances for all public, static properties of this class
	 */	
	public function getStaticProperties () : Array {
		init();
		return staticProperties.values;
	}
	
	/**
	 * Returns the Method instance for the specified method name.
	 * The method must be public, non-static and
	 * may be declared in this class or in one of its superclasses or superinterfaces.
	 * 
	 * @param name the name of the method
	 * @return the Method instance for the specified method name or null if no such method exists
	 */
	public function getMethod (name:String) : Method {
		init();
		return methods.get(name) as Method;
	}
	
	/**
	 * Returns Method instances for all public, non-static methods of this class.
	 * Included are all methods declared in this class 
	 * or in one of its superclasses or superinterfaces.
	 * 
	 * @return Method instances for all public, non-static methods of this class
	 */
	public function getMethods () : Array {
		init();
		return methods.values;
	}
	
	/**
	 * Returns the Method instance for the specified method name.
	 * The method must be public, static and
	 * must be declared in this class.
	 * 
	 * @param name the name of the static method
	 * @return the Method instance for the specified method name or null if no such method exists
	 */
	public function getStaticMethod (name:String) : Method {
		init();
		return staticMethods.get(name) as Method;
	}

	/**
	 * Returns Method instances for all public, static methods of this class.
	 * Included are all static methods declared in this class.
	 * 
	 * Method instances for all public, static methods of this class
	 */	
	public function getStaticMethods () : Array {
		init();
		return staticMethods.values;
	}
	
	/**
	 * Returns the superclass of the class represented by this ClassInfo instance.
	 * 
	 * @return the superclass of the class represented by this ClassInfo instance
	 */
	public function getSuperClass () : Class {
		init();
		return superClasses[0] as Class;
	}
	
	/**
	 * Returns all superclasses or superinterfaces of the class or interface
	 * represented by this ClassInfo instance. The first element in the Array
	 * is always the immediate superclass.
	 * 
	 * @return all superclasses or superinterfaces of the class or interface
	 * represented by this ClassInfo instance
	 */
	public function getSuperClasses () : Array {
		init();
		return superClasses.concat();
	}

	/**
	 * Returns all interfaces implemented by the class
	 * represented by this ClassInfo instance.
	 * 
	 * @return all interfaces implemented by the class
	 * represented by this ClassInfo instance
	 */	
	public function getInterfaces () : Array {
		init();
		return interfaces.concat();
	}
	
	/**
	 * Checks whether the class or interface represented by this ClassInfo instance
	 * is a subclass or subinterface of the specified class.
	 * 
	 * @return true if the class or interface represented by this ClassInfo instance
	 * is a subclass or subinterface of the specified class
	 */
	public function isType (c:Class) : Boolean {
		init();
		if (type == c) return true;
		for each (var sc:Class in superClasses) {
			if (sc == c) return true;
		}
		for each (var inf:Class in interfaces) {
			if  (inf == c) return true;
		}
		return false;
	}
	
	
	/**
	 * @private
	 */
	public override function getMetadata (type:Object, validate:Boolean = true) : Array {
		init();
		return super.getMetadata(type);
	}
	
	/**
	 * @private
	 */
	public override function getAllMetadata (validate:Boolean = true) : Array {
		init();
		return super.getAllMetadata();
	}
	
	
	/**
	 * @private
	 */
	public function toString () : String {
		return "[ClassInfo for class " + name + "]";
	} 
	

}

}
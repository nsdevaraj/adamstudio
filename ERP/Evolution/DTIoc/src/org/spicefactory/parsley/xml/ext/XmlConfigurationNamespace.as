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

package org.spicefactory.parsley.xml.ext {
	import org.spicefactory.parsley.xml.mapper.XmlObjectDefinitionMapperFactory;
import org.spicefactory.lib.errors.IllegalArgumentError;
import org.spicefactory.lib.reflect.ClassInfo;
import org.spicefactory.lib.xml.NamingStrategy;
import org.spicefactory.lib.xml.XmlObjectMapper;
import org.spicefactory.lib.xml.mapper.PropertyMapperBuilder;
import org.spicefactory.parsley.core.registry.ObjectDefinitionDecorator;
import org.spicefactory.parsley.core.registry.ObjectDefinitionFactory;
import org.spicefactory.parsley.core.registry.impl.DefaultObjectDefinitionFactory;

import flash.system.ApplicationDomain;
import flash.utils.Dictionary;

/**
 * Represent a single custom XML configuration namespace.
 * 
 * Allows to register XML-to-Object mappers for objects, definition factories and decorators.
 * You should not create instance of this class yourself, but use the static 
 * <code>XmlConfigurationNamespaceRegistry.registerNamespace()</code> method for creating such an instance.
 * 
 * @author Jens Halm
 */
public class XmlConfigurationNamespace {
	
	
	private var _uri:String;
	
	private var _domain:ApplicationDomain;
	private var _namingStrategy:NamingStrategy;
	
	private var factories:Dictionary = new Dictionary();
	
	private var decorators:Dictionary = new Dictionary();
	
	
	/**
	 * @private
	 */
	function XmlConfigurationNamespace (uri:String, namingStrategy:NamingStrategy = null, domain:ApplicationDomain = null) {
		_uri = uri;
		_namingStrategy = namingStrategy;
		_domain = domain;
	}

	
	/**
	 * The namespace URI of this custom XML configuration namespace.
	 */
	public function get uri ():String {
		return _uri;
	}
	
	/**
	 * Adds a custom mapper for an XML tag mapping directly to an object that should be added to the IOC Container.
	 * 
	 * @param mapper the mapper to add
	 */
	public function addCustomObjectMapper (mapper:XmlObjectMapper) : void {
		validateFactory(mapper.objectType, mapper.elementName.localName);
		checkNamespace(mapper);
		factories[mapper.elementName.localName] = mapper;
	}
	
	/**
	 * Adds a custom mapper for an XML tag mapping to an ObjectDefinitionFactory instance that produces definitions
	 * to be added to the IOC Container. 
	 * 
	 * @param mapper the mapper to add
	 */
	public function addCustomDefinitionFactoryMapper (mapper:XmlObjectMapper) : void {
		validateFactory(mapper.objectType, mapper.elementName.localName, true);
		checkNamespace(mapper);
		factories[mapper.elementName.localName] = mapper;
	}
	
	/**
	 * Adds a custom mapper for an XML tag mapping to an ObjectDefinitionDecorator instance that modifies definitions
	 * created by the parent tag. 
	 * 
	 * @param mapper the mapper to add
	 */
	public function addCustomDecoratorMapper (mapper:XmlObjectMapper) : void {
		validateDecorator(mapper.objectType, mapper.elementName.localName);
		checkNamespace(mapper);
		decorators[mapper.elementName.localName] = mapper;
	}

	/**
	 * Adds a default mapper for an XML tag mapping directly to an object that should be added to the IOC Container.
	 * A default mapper simply maps the attributes of the element with the specified tag name to properties of
	 * the specified Class with the same name.
	 * 
	 * @param type the class the XML element should be mapped to
	 * @param tagName the name of the XML element to map
	 */
	public function addDefaultObjectMapper (type:Class, tagName:String) : void {
		var builder:PropertyMapperBuilder = new PropertyMapperBuilder(type, new QName(_uri, tagName), _namingStrategy, _domain);
		builder.mapAllToAttributes();
		addCustomObjectMapper(builder.build());
	}
	
	/**
	 * Adds a default mapper for an XML tag mapping to an ObjectDefinitionFactory instance that produces definitions
	 * to be added to the IOC Container. 
	 * A default mapper simply maps the attributes of the element with the specified tag name to properties of
	 * the specified Class with the same name.
	 * 
	 * @param type the class the XML element should be mapped to
	 * @param tagName the name of the XML element to map
	 * @param decoratorArray the name of the property holding the decorators that were added as child elemens (or null if
	 * you do not want to allow regular decorator child elements or if the tag extends DefaultObjectDefinitionFactory where the
	 * decorator Array will be auto-detected)
	 */	
	public function addDefaultDefinitionFactoryMapper (type:Class, tagName:String, decoratorArray:String = null) : void {
		var builder:PropertyMapperBuilder = newFactoryMapperBuilder(type, tagName, decoratorArray);
		builder.mapAllToAttributes();
		//factories[tagName] = builder; ???
		addCustomDefinitionFactoryMapper(builder.build());
	}
	
	/**
	 * Adds a default mapper for an XML tag mapping to an ObjectDefinitionDecorator instance that modifies definitions
	 * created by the parent tag. 
	 * A default mapper simply maps the attributes of the element with the specified tag name to properties of
	 * the specified Class with the same name.
	 * 
	 * @param type the class the XML element should be mapped to
	 * @param tagName the name of the XML element to map
	 */
	public function addDefaultDecoratorMapper (type:Class, tagName:String) : void {
		var builder:PropertyMapperBuilder = new PropertyMapperBuilder(type, new QName(_uri, tagName), _namingStrategy, _domain);
		builder.mapAllToAttributes();
		addCustomDecoratorMapper(builder.build());
	}

	private function newFactoryMapperBuilder (type:Class, tagName:String, decoratorArray:String) : PropertyMapperBuilder {
		var ci:ClassInfo = ClassInfo.forClass(type, _domain);
		if (ci.isType(DefaultObjectDefinitionFactory)) decoratorArray = "decorators";
		var elementName:QName = new QName(_uri, tagName);
		validateFactory(ci, tagName, true);
		var builder:PropertyMapperBuilder = new PropertyMapperBuilder(type, elementName, _namingStrategy, _domain);
		if (decoratorArray != null) builder.mapToChildElementChoice(decoratorArray, XmlObjectDefinitionMapperFactory.getDecoratorChoice());
		return builder;
	}
	
	/**
	 * Creates a builder for a mapper for an XML tag mapping directly to an object that should be added to the IOC Container.
	 * 
	 * @param type the class the XML element should be mapped to
	 * @param tagName the name of the XML element to map
	 * @return the builder that can be used to configure the mapper
	 */
	public function createObjectMapperBuilder (type:Class, tagName:String) : PropertyMapperBuilder {
		var ci:ClassInfo = ClassInfo.forClass(type, _domain);
		validateFactory(ci, tagName);
		var builder:PropertyMapperBuilder = new PropertyMapperBuilder(type, new QName(_uri, tagName));
		factories[tagName] = builder.build();
		return builder;
	}

	/**
	 * Creates a builder for a mapper for an XML tag mapping to an ObjectDefinitionFactory instance that produces definitions
	 * to be added to the IOC Container. 
	 * 
	 * @param type the class the XML element should be mapped to
	 * @param tagName the name of the XML element to map
	 * @param decoratorArray the name of the property holding the decorators that were added as child elemens (or null if
	 * you do not want to allow regular decorator child elements or if the tag extends DefaultObjectDefinitionFactory where the
	 * decorator Array will be auto-detected)
	 * @return the builder that can be used to configure the mapper
	 */
	public function createDefinitionFactoryMapperBuilder (type:Class, tagName:String, decoratorArray:String = null) : PropertyMapperBuilder {
		var builder:PropertyMapperBuilder = newFactoryMapperBuilder(type, tagName, decoratorArray);
		factories[tagName] = builder.build();
		return builder;
	}
	
	/**
	 * Creates a builder for a mapper for an XML tag mapping to an ObjectDefinitionDecorator instance that modifies definitions
	 * created by the parent tag. 
	 * 
	 * @param type the class the XML element should be mapped to
	 * @param tagName the name of the XML element to map
	 * @return the builder that can be used to configure the mapper
	 */
	public function createDecoratorMapperBuilder (type:Class, tagName:String) : PropertyMapperBuilder {
		var ci:ClassInfo = ClassInfo.forClass(type, _domain);
		validateDecorator(ci, tagName);
		var builder:PropertyMapperBuilder = new PropertyMapperBuilder(type, new QName(_uri, tagName));
		decorators[tagName] = builder.build();
		return builder;
	}
	
	
	/**
	 * Returns all mappers for definition factories (and for objects) that have been added to this namespace.
	 * 
	 * @return all mappers for definition factories (and for objects) that have been added to this namespace
	 */
	public function getAllFactoryMappers () : Array {
		return getAllMappers(factories);
	}
	
	/**
	 * Returns all mappers for definition decorators that have been added to this namespace.
	 * 
	 * @return all mappers for definition decorators that have been added to this namespace
	 */
	public function getAllDecoratorMappers () : Array {
		return getAllMappers(decorators);
	}

	private function getAllMappers (map:Dictionary) : Array {
		var result:Array = new Array();
		for each (var dec:Object in map) {
			result.push(dec);
		}
		return result;
	}
	
	
	private function validateFactory (type:ClassInfo, tagName:String, mustBeFactory:Boolean = false) : void {
		if (factories[tagName] != null) {
			throw new IllegalArgumentError("Duplicate registration for object tag name " + tagName + " in namespace " + uri);
		}
		if (mustBeFactory && !type.isType(ObjectDefinitionFactory)) {
			throw new IllegalArgumentError("The specified factory class " + type.name 
					+ " does not implement the ObjectDefinitionFactory interface");
		}
	}
	
	private function validateDecorator (type:ClassInfo, tagName:String) : void {
		if (decorators[tagName] != null) {
			throw new IllegalArgumentError("Duplicate registration for decorator tag name " + tagName + " in namespace " + uri);
		}
		if (!type.isType(ObjectDefinitionDecorator)) {
			throw new IllegalArgumentError("The specified factory class " + type.name 
					+ " does not implement the ObjectDefinitionDecorator interface");
		}
	}
	
	private function checkNamespace (mapper:XmlObjectMapper) : void {
		if (mapper.elementName.uri != _uri) {
			throw new IllegalArgumentError("Namespace " + mapper.elementName.uri 
					+ " of mapper " + mapper + " does not match this configuration namespace: " + _uri);
		}		
	}
	
	
}
}

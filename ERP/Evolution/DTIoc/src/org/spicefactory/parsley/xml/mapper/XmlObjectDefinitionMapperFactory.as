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

package org.spicefactory.parsley.xml.mapper {
import org.spicefactory.lib.reflect.converter.BooleanConverter;
import org.spicefactory.lib.reflect.converter.ClassConverter;
import org.spicefactory.lib.reflect.converter.DateConverter;
import org.spicefactory.lib.reflect.converter.IntConverter;
import org.spicefactory.lib.reflect.converter.NumberConverter;
import org.spicefactory.lib.reflect.converter.StringConverter;
import org.spicefactory.lib.reflect.converter.UintConverter;
import org.spicefactory.lib.xml.DefaultNamingStrategy;
import org.spicefactory.lib.xml.NamingStrategy;
import org.spicefactory.lib.xml.XmlObjectMapper;
import org.spicefactory.lib.xml.mapper.Choice;
import org.spicefactory.lib.xml.mapper.PropertyMapperBuilder;
import org.spicefactory.parsley.tag.core.ArrayTag;
import org.spicefactory.parsley.tag.core.ConstructorDecoratorTag;
import org.spicefactory.parsley.tag.core.ObjectDefinitionFactoryTag;
import org.spicefactory.parsley.tag.core.ObjectReferenceTag;
import org.spicefactory.parsley.tag.core.PropertyDecoratorTag;
import org.spicefactory.parsley.tag.lifecycle.AsyncInitDecorator;
import org.spicefactory.parsley.tag.lifecycle.DestroyMethodDecorator;
import org.spicefactory.parsley.tag.lifecycle.FactoryMethodDecorator;
import org.spicefactory.parsley.tag.lifecycle.InitMethodDecorator;
import org.spicefactory.parsley.tag.lifecycle.ObserveMethodDecorator;
import org.spicefactory.parsley.tag.lifecycle.legacy.PostConstructMethodDecorator;
import org.spicefactory.parsley.tag.lifecycle.legacy.PreDestroyMethodDecorator;
import org.spicefactory.parsley.tag.messaging.MessageBindingDecorator;
import org.spicefactory.parsley.tag.messaging.MessageDispatcherDecorator;
import org.spicefactory.parsley.tag.messaging.MessageErrorDecorator;
import org.spicefactory.parsley.tag.messaging.MessageInterceptorDecorator;
import org.spicefactory.parsley.tag.resources.ResourceBindingDecorator;
import org.spicefactory.parsley.xml.ext.XmlConfigurationNamespace;
import org.spicefactory.parsley.xml.ext.XmlConfigurationNamespaceRegistry;
import org.spicefactory.parsley.xml.tag.Include;
import org.spicefactory.parsley.xml.tag.ManagedEventsDecoratorTag;
import org.spicefactory.parsley.xml.tag.MessageHandlerDecoratorTag;
import org.spicefactory.parsley.xml.tag.ObjectDefinitionFactoryContainer;
import org.spicefactory.parsley.xml.tag.Variable;

/**
 * Factory that builds the XML-to-Object mappers for the Parsley XML configuration format.
 * Built upon the Spicelib XML-to-Object Mapping Framework.
 * 
 * @author Jens Halm
 */
public class XmlObjectDefinitionMapperFactory {
	

	/**
	 * The main Parsley XML configuration namespace.
	 */
	public static const PARSLEY_NAMESPACE_URI:String = "http://www.spicefactory.org/parsley";
	
	private static const namingStrategy:NamingStrategy = new DefaultNamingStrategy();

	
	private var rootObjectChoice:Choice = new Choice();

	private var decoratorChoice:Choice = new Choice();

	private var valueChoice:Choice = new Choice();
	
	private static var decoratorChoiceDelegate:ChoiceDelegate;
	
	
	/**
	 * Returns the Choice that will be used to hold the mappers for ObjectDefinitionDecorators.
	 * This method will be primarily used by the <code>XmlConfigurationNamespace</code> class.
	 */
	public static function getDecoratorChoice () : Choice {
		if (decoratorChoiceDelegate == null) decoratorChoiceDelegate = new ChoiceDelegate();
		return decoratorChoiceDelegate;
	}

	
	/**
	 * Creates the mapper for the root objects tag of Parsley XML configuration files.
	 * 
	 * @return the mapper for the root objects tag of Parsley XML configuration files
	 */
	public function createObjectDefinitionMapper () : XmlObjectMapper {
		addCustomConfigurationNamespaces();
		buildValueChoice();
		buildDecoratorChoice();
		var builder:PropertyMapperBuilder = getMapperBuilder(ObjectDefinitionFactoryContainer, "objects"); 
		rootObjectChoice.addMapper(getRootObjectMapper());
		builder.mapToChildElementChoice("objects", rootObjectChoice);
		return builder.build();
	}
	
	/**
	 * Creates the mapper for the variable XML tag.
	 * 
	 * @return the mapper for the variable XML tag
	 */
	public function createVariableMapper () : XmlObjectMapper {
		var builder:PropertyMapperBuilder = getMapperBuilder(Variable, "variable");
		builder.mapAllToAttributes();
		return builder.build(); 
	}
	
	/**
	 * Creates the mapper for the include XML tag.
	 * 
	 * @return the mapper for the include XML tag
	 */
	public function createIncludeMapper () : XmlObjectMapper {
		var builder:PropertyMapperBuilder = getMapperBuilder(Include, "include");
		builder.mapAllToAttributes();
		return builder.build(); 		
	}

	
	private function getRootObjectMapper () : XmlObjectMapper {
		var builder:PropertyMapperBuilder = getMapperBuilder(ObjectDefinitionFactoryTag, "object"); 
		builder.mapToChildElementChoice("decorators", decoratorChoice);
		builder.mapAllToAttributes();
		return builder.build();
	}
	
	private function getNestedObjectMapper () : XmlObjectMapper {
		var builder:PropertyMapperBuilder = getMapperBuilder(ObjectDefinitionFactoryTag, "object"); 
		builder.mapToChildElementChoice("decorators", decoratorChoice);
		builder.mapToAttribute("type");
		return builder.build();
	}

	
	private function addCustomConfigurationNamespaces () : void {
		var namespaces:Array = XmlConfigurationNamespaceRegistry.getRegisteredNamespaces();
		var choiceDelegate:ChoiceDelegate = getDecoratorChoice() as ChoiceDelegate;
		choiceDelegate.delegate = decoratorChoice; // TODO - this is a bit hacky
		for each (var ns:XmlConfigurationNamespace in namespaces) {
			var factories:Array = ns.getAllFactoryMappers();
			for each (var fMapper:XmlObjectMapper in factories) {
				rootObjectChoice.addMapper(fMapper);
				valueChoice.addMapper(fMapper);
			}
			var decorators:Array = ns.getAllDecoratorMappers();
			for each (var dMapper:XmlObjectMapper in decorators) {
				decoratorChoice.addMapper(dMapper);
			}
		}
	}
	
	private function buildDecoratorChoice () : void {
		var childBuilder:PropertyMapperBuilder = getMapperBuilder(ConstructorDecoratorTag, "constructor-args");
		childBuilder.mapToChildElementChoice("values", valueChoice);
		decoratorChoice.addMapper(childBuilder.build());
		
		childBuilder = getMapperBuilder(PropertyDecoratorTag, "property");
		childBuilder.mapToChildElementChoice("childValue", valueChoice);
		childBuilder.mapAllToAttributes();
		decoratorChoice.addMapper(childBuilder.build());

		addDecoratorAttributeMapper(AsyncInitDecorator, "async-init");

		addDecoratorAttributeMapper(FactoryMethodDecorator, "factory");
		addDecoratorAttributeMapper(InitMethodDecorator, "init");
		addDecoratorAttributeMapper(DestroyMethodDecorator, "destroy");
		addDecoratorAttributeMapper(ObserveMethodDecorator, "observe");
		
		// 2 deprecated tags
		addDecoratorAttributeMapper(PostConstructMethodDecorator, "post-construct");
		addDecoratorAttributeMapper(PreDestroyMethodDecorator, "pre-destroy");
		
		addDecoratorAttributeMapperWithArrayAdapter(MessageHandlerDecoratorTag, "message-handler", "messageProperties");
		addDecoratorAttributeMapper(MessageInterceptorDecorator, "message-interceptor");
		addDecoratorAttributeMapper(MessageBindingDecorator, "message-binding");
		addDecoratorAttributeMapper(MessageErrorDecorator, "message-error");
		addDecoratorAttributeMapper(MessageDispatcherDecorator, "message-dispatcher");
		addDecoratorAttributeMapperWithArrayAdapter(ManagedEventsDecoratorTag, "managed-events", "names");

		addDecoratorAttributeMapper(ResourceBindingDecorator, "resource-binding");
	}
	
	private function addDecoratorAttributeMapper (type:Class, tagName:String) : void {
		var childBuilder:PropertyMapperBuilder = getMapperBuilder(type, tagName);
		childBuilder.mapAllToAttributes();
		decoratorChoice.addMapper(childBuilder.build());
	}
	
	private function addDecoratorAttributeMapperWithArrayAdapter (type:Class, tagName:String, arrayProp:String) : void {
		var childBuilder:PropertyMapperBuilder = getMapperBuilder(type, tagName);
		childBuilder.mapToAttribute(arrayProp + "AsString", new QName("", namingStrategy.toXmlName(arrayProp)));
		childBuilder.ignoreProperty(arrayProp);
		childBuilder.mapAllToAttributes();
		decoratorChoice.addMapper(childBuilder.build());		
	}
	
	
	private function buildValueChoice () : void {
		valueChoice.addMapper(new NullXmlObjectMapper());
		
		valueChoice.addMapper(new SimpleValueXmlObjectMapper(Boolean, "boolean", BooleanConverter.INSTANCE));
		valueChoice.addMapper(new SimpleValueXmlObjectMapper(Number, "number", NumberConverter.INSTANCE));
		valueChoice.addMapper(new SimpleValueXmlObjectMapper(int, "int", IntConverter.INSTANCE));
		valueChoice.addMapper(new SimpleValueXmlObjectMapper(uint, "uint", UintConverter.INSTANCE));
		valueChoice.addMapper(new SimpleValueXmlObjectMapper(String, "string", StringConverter.INSTANCE));
		valueChoice.addMapper(new SimpleValueXmlObjectMapper(Date, "date", DateConverter.INSTANCE));
		valueChoice.addMapper(new SimpleValueXmlObjectMapper(Class, "class", ClassConverter.INSTANCE));

		valueChoice.addMapper(new StaticPropertyRefMapper());
		addValueAttributeMapper(ObjectReferenceTag, "object-ref");

		valueChoice.addMapper(getNestedObjectMapper());

		// TODO - enable nested arrays
		var childBuilder:PropertyMapperBuilder = getMapperBuilder(ArrayTag, "array");
		childBuilder.mapToChildElementChoice("values", valueChoice);
		valueChoice.addMapper(childBuilder.build());
	}
	
	private function addValueAttributeMapper (type:Class, tagName:String) : void {
		var childBuilder:PropertyMapperBuilder = getMapperBuilder(type, tagName);
		childBuilder.mapAllToAttributes();
		valueChoice.addMapper(childBuilder.build());		
	}
	
	
	private function getMapperBuilder (type:Class, tagName:String) : PropertyMapperBuilder {
		return new PropertyMapperBuilder(type, 
				new QName(PARSLEY_NAMESPACE_URI, tagName));
	}
}
}

import org.spicefactory.lib.reflect.ClassInfo;
import org.spicefactory.lib.reflect.Converter;
import org.spicefactory.lib.reflect.types.Any;
import org.spicefactory.lib.xml.XmlObjectMapper;
import org.spicefactory.lib.xml.XmlProcessorContext;
import org.spicefactory.lib.xml.mapper.AbstractXmlObjectMapper;
import org.spicefactory.lib.xml.mapper.Choice;
import org.spicefactory.lib.xml.mapper.PropertyMapperBuilder;
import org.spicefactory.parsley.xml.mapper.XmlObjectDefinitionMapperFactory;
import org.spicefactory.parsley.xml.tag.StaticPropertyRef;

import flash.errors.IllegalOperationError;

class NullXmlObjectMapper extends AbstractXmlObjectMapper {
	
	function NullXmlObjectMapper () {
		super(ClassInfo.forClass(Object), new QName(XmlObjectDefinitionMapperFactory.PARSLEY_NAMESPACE_URI, "null"));
	}
	
	public override function mapToObject (element:XML, context:XmlProcessorContext) : Object {
		return null;
	}

	public override function mapToXml (object:Object, context:XmlProcessorContext) : XML {
		throw new IllegalOperationError("This mapper does not support mapping back to XML");
	}
	 
}

class SimpleValueXmlObjectMapper extends AbstractXmlObjectMapper {
	
	private var converter:Converter;
	
	function SimpleValueXmlObjectMapper (type:Class, tagName:String, converter:Converter) {
		super(ClassInfo.forClass(type), new QName(XmlObjectDefinitionMapperFactory.PARSLEY_NAMESPACE_URI, tagName));
		this.converter = converter;
	}
	
	public override function mapToObject (element:XML, context:XmlProcessorContext) : Object {
		return converter.convert(context.expressionContext.createExpression(element.text()[0]).value);
	}

	public override function mapToXml (object:Object, context:XmlProcessorContext) : XML {
		throw new IllegalOperationError("This mapper does not support mapping back to XML");
	}
	
}

class StaticPropertyRefMapper extends AbstractXmlObjectMapper {
	
	private var delegate:XmlObjectMapper;
	
	function StaticPropertyRefMapper () {
		super(ClassInfo.forClass(Any), new QName(XmlObjectDefinitionMapperFactory.PARSLEY_NAMESPACE_URI, "static-property"));
		var builder:PropertyMapperBuilder = new PropertyMapperBuilder(StaticPropertyRef, elementName);
		builder.mapAllToAttributes();
		delegate = builder.build();
	}
	
	public override function mapToObject (element:XML, context:XmlProcessorContext) : Object {
		var ref:StaticPropertyRef = delegate.mapToObject(element, context) as StaticPropertyRef;
		return (ref != null) ? ref.resolve(context.applicationDomain) : null;
	}

	public override function mapToXml (object:Object, context:XmlProcessorContext) : XML {
		throw new IllegalOperationError("This mapper does not support mapping back to XML");
	}	
	
	
}

class ChoiceDelegate extends Choice {
	
	public var delegate:Choice;
	
	public override function addMapper (mapper:XmlObjectMapper) : void {
		delegate.addMapper(mapper);
	}
	
	public override function getMapperForInstance (instance:Object, context:XmlProcessorContext) : XmlObjectMapper {
		return delegate.getMapperForInstance(instance, context);
	}
	
	public override function getMapperForElementName (name:QName) : XmlObjectMapper {
		return delegate.getMapperForElementName(name);
	}
	
	public override function getAllMappers () : Array {
		return delegate.getAllMappers();
	}

	public override function get xmlNames () : Array {
		return delegate.xmlNames;
	}
	
}




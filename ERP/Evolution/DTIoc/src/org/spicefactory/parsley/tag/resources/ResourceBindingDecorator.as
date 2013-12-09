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

package org.spicefactory.parsley.tag.resources {
import org.spicefactory.lib.reflect.Property;
import org.spicefactory.parsley.core.context.Context;
import org.spicefactory.parsley.core.errors.ObjectDefinitionBuilderError;
import org.spicefactory.parsley.core.lifecycle.ObjectLifecycle;
import org.spicefactory.parsley.core.registry.ObjectDefinition;
import org.spicefactory.parsley.core.registry.ObjectDefinitionDecorator;
import org.spicefactory.parsley.core.registry.ObjectDefinitionRegistry;
import org.spicefactory.parsley.tag.core.NestedTag;

import flash.utils.Dictionary;
import flash.utils.getQualifiedClassName;

[Metadata(name="ResourceBinding", types="property")]
/**
 * Represents a Metadata, MXML or XML tag that can be used to bind a property value to a resource, updating
 * automatically when the ResourceManager updates.
 * 
 * @author Jens Halm
 */
public class ResourceBindingDecorator implements ObjectDefinitionDecorator, NestedTag {


	/**
	 * The type of the adapter to use. 
	 * The decorator need to adapt to either the Flex ResourceManager or the Parsley Flash ResourceManager.
	 */
	public static var adapterClass:Class;


	/**
	 * The resource key.
	 */
	public var key:String;

	/**
	 * The bundle name.
	 */
	public var bundle:String;

	[Target]
	/**
	 * The property to bind to.
	 */
	public var property:String;
	

	private static var adapter:ResourceBindingAdapter;
	
	private var managedObjects:Dictionary = new Dictionary();
	
	private var _property:Property;
	
	
	private static function initializeAdapter () : void {
		if (adapter == null) {
			if (adapterClass == null) {
				throw new ObjectDefinitionBuilderError("adapterClass property for ResourceBindingDecorator has not been set");
			}
			var adapterImpl:Object = new adapterClass();
			if (!(adapterImpl is ResourceBindingAdapter)) {
				throw new ObjectDefinitionBuilderError("Specified adapterClass " + getQualifiedClassName(adapterClass) 
					+ " does not implement the ResourceBindingAdapter interface");
			}
			adapter = adapterImpl as ResourceBindingAdapter;
		}
	}

	
	/**
	 * @inheritDoc
	 */
	public function decorate (definition:ObjectDefinition, registry:ObjectDefinitionRegistry) : ObjectDefinition {
		initializeAdapter();
		adapter.addEventListener(ResourceBindingEvent.UPDATE, handleUpdate);
		_property = definition.type.getProperty(property);
		if (_property == null) {
			throw new ObjectDefinitionBuilderError("Class " + definition.type.name 
					+ " does not contain a property with name " + _property);
		}
		definition.objectLifecycle.addListener(ObjectLifecycle.POST_INIT, postInit);
		definition.objectLifecycle.addListener(ObjectLifecycle.PRE_DESTROY, preDestroy);
		return definition;
	}

	private function postInit (instance:Object, context:Context) : void {
		_property.setValue(instance, adapter.getResource(bundle, key));
		managedObjects[instance] = true;
	}

	private function preDestroy (instance:Object, context:Context) : void {
		delete managedObjects[instance];
	}

	private function handleUpdate (event:ResourceBindingEvent) : void {
		var resource:* = adapter.getResource(bundle, key);
		for (var instance:Object in managedObjects) {
			_property.setValue(instance, resource);
		}
	}
	
	
}

}

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

package org.spicefactory.parsley.core.registry.impl {
import org.spicefactory.lib.reflect.ClassInfo;
import org.spicefactory.parsley.core.registry.ObjectDefinition;
import org.spicefactory.parsley.core.registry.RootObjectDefinition;
import org.spicefactory.parsley.core.registry.definition.ConstructorArgRegistry;
import org.spicefactory.parsley.core.registry.definition.LifecycleListenerRegistry;
import org.spicefactory.parsley.core.registry.definition.MethodRegistry;
import org.spicefactory.parsley.core.registry.definition.ObjectInstantiator;
import org.spicefactory.parsley.core.registry.definition.PropertyRegistry;
import org.spicefactory.parsley.core.registry.model.AsyncInitConfig;

/**
 * A simple wrapper around an existing root object definition.
 * 
 * @author Jens Halm
 */
public class ObjectDefinitionWrapper implements RootObjectDefinition {


	private var _id:String;
	private var _lazy:Boolean;
	private var _singleton:Boolean;
	private var _order:int;
	private var wrappedDefinition:ObjectDefinition;


	/**
	 * Creates a new instance.
	 * 
	 * @param wrappedDefinition the definition to wrap
	 * @param id the id the object should be registered with
	 * @param lazy whether the object is lazy initializing
	 * @param singleton whether the object should be treated as a singleton
	 * @param order the initialization order for non-lazy singletons
	 */
	function ObjectDefinitionWrapper (wrappedDefinition:ObjectDefinition, id:String = null, 
			lazy:Boolean = false, singleton:Boolean = true, order:int = int.MAX_VALUE):void {
		this.wrappedDefinition = wrappedDefinition;
		_id = (id != null) ? id : IdGenerator.nextObjectId;
		_lazy = lazy;
		_singleton = singleton;
		_order = order;
	}


	/**
	 * @inheritDoc
	 */
	public function get id () : String {
		return _id;
	}
	
	/**
	 * @inheritDoc
	 */
	public function get lazy () : Boolean {
		return _lazy;
	}
	
	/**
	 * @inheritDoc
	 */
	public function get singleton () : Boolean {
		return _singleton;
	}
	
	/**
	 * @inheritDoc
	 */
	public function get order () : int {
		return _order;
	}
	
	/**
	 * @inheritDoc
	 */
	public function freeze () : void {
		wrappedDefinition.freeze();
	}

	/**
	 * @inheritDoc
	 */
	public function get type () : ClassInfo {
		return wrappedDefinition.type;
	}
	
	/**
	 * @inheritDoc
	 */
	public function get instantiator () : ObjectInstantiator {
		return wrappedDefinition.instantiator;
	}
	
	/**
	 * @inheritDoc
	 */
	public function get constructorArgs () : ConstructorArgRegistry {
		return wrappedDefinition.constructorArgs;
	}
	
	/**
	 * @inheritDoc
	 */
	public function get properties () : PropertyRegistry {
		return wrappedDefinition.properties;
	}
	
	/**
	 * @inheritDoc
	 */
	public function get injectorMethods () : MethodRegistry {
		return wrappedDefinition.injectorMethods;
	}

	/**
	 * @inheritDoc
	 */
	public function get objectLifecycle () : LifecycleListenerRegistry {
		return wrappedDefinition.objectLifecycle;
	}
	
	/**
	 * @inheritDoc
	 */
	public function get asyncInitConfig () : AsyncInitConfig {
		return wrappedDefinition.asyncInitConfig;
	}

	/**
	 * @inheritDoc
	 */
	public function get frozen () : Boolean {
		return wrappedDefinition.frozen;
	}

	/**
	 * @inheritDoc
	 */
	public function set instantiator (value:ObjectInstantiator) : void {
		wrappedDefinition.instantiator = value;
	}
	
	/**
	 * @inheritDoc
	 */
	public function set asyncInitConfig (config:AsyncInitConfig) : void {
		wrappedDefinition.asyncInitConfig = config;
	}
	
	/**
	 * @inheritDoc
	 */
	public function get initMethod () : String {
		return wrappedDefinition.initMethod;
	}

	/**
	 * @inheritDoc
	 */
	public function set initMethod (name:String) : void {
		wrappedDefinition.initMethod = name;
	}

	/**
	 * @inheritDoc
	 */
	public function get destroyMethod () : String {
		return wrappedDefinition.destroyMethod;
	}

	/**
	 * @inheritDoc
	 */
	public function set destroyMethod (name:String) : void {
		wrappedDefinition.destroyMethod = name;
	}
	
	
}
}

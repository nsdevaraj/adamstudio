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

package org.spicefactory.parsley.pimento {
import org.spicefactory.parsley.core.lifecycle.ObjectLifecycle;
import org.spicefactory.parsley.core.registry.ObjectDefinition;
import org.spicefactory.parsley.core.registry.ObjectDefinitionFactory;
import org.spicefactory.parsley.core.registry.ObjectDefinitionRegistry;
import org.spicefactory.parsley.core.registry.RootObjectDefinition;
import org.spicefactory.parsley.core.registry.impl.DefaultObjectDefinitionFactory;

import flash.errors.IllegalOperationError;

/**
 * Represents the Service MXML or XML tag, defining the configuration for a Pimento managed Cinnamon service.
 * 
 * @author Jens Halm
 */
public class ServiceTag implements ObjectDefinitionFactory {
	
    
    /**
	 * The id that the service will be registered with in the Parsley IOC Container. Usually no need to be specified explicitly.
	 */  
	public var id:String;

	[Required]
	/**
	 * The name of the service as configured on the server-side.
	 */
	public var name:String;
	
	[Required]
	/**
	 * The AS3 service implementation (usually generated with Pimentos Ant Task).
	 */
	public var type:Class;
	
	/**
	 * The id of the PimentoConfig instance to use for this service. Only required
	 * if you have more than one config tag in your Context. If there is only one (like in most use cases)
	 * it will be automatically detected.
	 */
	public var config:String;
	
	/**
	 * The request timeout in milliseconds.
	 */
	public var timeout:uint = 0;
	
	
	/**
	 * @inheritDoc
	 */
	public function createRootDefinition (registry:ObjectDefinitionRegistry) : RootObjectDefinition {
		if (id == null) id = name;
		var factory:ObjectDefinitionFactory = new DefaultObjectDefinitionFactory(type, id);
		var definition:RootObjectDefinition = factory.createRootDefinition(registry);
		var listener:ServiceLifecycleListener = new ServiceLifecycleListener(this);
		definition.objectLifecycle.addListener(ObjectLifecycle.POST_INIT, listener.postInit);
		return definition;
	}

	/**
	 * @private
	 */
	public function createNestedDefinition (registry:ObjectDefinitionRegistry) : ObjectDefinition {
		throw new IllegalOperationError("Services must be defined as root objects");
	}
}
}

import org.spicefactory.cinnamon.service.ServiceProxy;
import org.spicefactory.parsley.core.context.Context;
import org.spicefactory.parsley.core.errors.ContextError;
import org.spicefactory.parsley.pimento.ServiceTag;
import org.spicefactory.pimento.config.PimentoConfig;

class ServiceLifecycleListener {

	private var tag:ServiceTag;
	
	function ServiceLifecycleListener (tag:ServiceTag) {
		this.tag = tag;
	}

	public function postInit (instance:Object, context:Context):void {
		var configInstance:PimentoConfig;
		if (tag.config != null) {
			var configRef:Object = context.getObject(tag.config);
			if (!(configRef is PimentoConfig)) {
				throw new ContextError("Object with id " + tag.config + " is not a PimentoConfig instance");
			}
			configInstance = configRef as PimentoConfig;
		}
		else {
			configInstance = context.getObjectByType(PimentoConfig) as PimentoConfig;
		}
		configInstance.addService(tag.name, instance);
		var proxy:ServiceProxy = ServiceProxy.forService(instance);
		if (tag.timeout != 0) proxy.timeout = tag.timeout;
	}
	
	
}

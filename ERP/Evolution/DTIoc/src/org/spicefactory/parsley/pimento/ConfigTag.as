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
import org.spicefactory.parsley.core.registry.ObjectDefinition;
import org.spicefactory.parsley.core.registry.ObjectDefinitionFactory;
import org.spicefactory.parsley.core.registry.ObjectDefinitionRegistry;
import org.spicefactory.parsley.core.registry.RootObjectDefinition;
import org.spicefactory.parsley.core.registry.impl.DefaultObjectDefinitionFactory;
import org.spicefactory.pimento.config.PimentoConfig;
import org.spicefactory.pimento.service.EntityManager;

import flash.errors.IllegalOperationError;

/**
 * Represents the Config MXML or XML tag, defining the configuration for a Pimento EntityManager.
 * 
 * @author Jens Halm
 */
public class ConfigTag implements ObjectDefinitionFactory {

	
	/**
	 * The id of the Pimento configuration produced by this tag in the Parsley Context. Usually no need to be specified explicitly.
	 */
	public var id:String;

	
	[Required]
	/**
	 * The service URL the EntityManager produced by this tag should connect to.
	 */
	public var url:String;
	
	/**
	 * The request timeout in milliseconds.
	 */
	public var timeout:uint;
	
	
	/**
	 * @inheritDoc
	 */
	public function createRootDefinition (registry:ObjectDefinitionRegistry) : RootObjectDefinition {
		
		var configFactory:ObjectDefinitionFactory = new DefaultObjectDefinitionFactory(PimentoConfig, id);
		var configDef:RootObjectDefinition = configFactory.createRootDefinition(registry);
		configDef.properties.addValue("serviceUrl", url);
		if (timeout != 0) configDef.properties.addValue("defaultTimeout", timeout);
		
		var emFactory:ObjectDefinitionFactory = new DefaultObjectDefinitionFactory(EntityManager, configDef.id + "_entityManager");
		var emDef:RootObjectDefinition = emFactory.createRootDefinition(registry);
		emDef.instantiator = new EntityManagerInstantiator(configDef.id);
		registry.registerDefinition(emDef);
		
		return configDef;
	}

	/**
	 * @private
	 */
	public function createNestedDefinition (registry:ObjectDefinitionRegistry) : ObjectDefinition {
		throw new IllegalOperationError("Pimento config tag must be used for a root object definition");
	}
}
}

import org.spicefactory.parsley.core.context.Context;
import org.spicefactory.parsley.core.registry.definition.ObjectInstantiator;
import org.spicefactory.pimento.config.PimentoConfig;

class EntityManagerInstantiator implements ObjectInstantiator {
	
	private var configId:String;

	function EntityManagerInstantiator (id:String) { this.configId = id; }

	public function instantiate (context:Context) : Object {
		return PimentoConfig(context.getObject(configId)).entityManager;
	}
	
}

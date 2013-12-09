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

package org.spicefactory.parsley.tag.lifecycle {
import org.spicefactory.lib.errors.IllegalArgumentError;
import org.spicefactory.parsley.core.context.Context;
import org.spicefactory.parsley.core.context.provider.ObjectProvider;
import org.spicefactory.parsley.core.context.provider.Provider;
import org.spicefactory.parsley.core.lifecycle.ObjectLifecycle;
import org.spicefactory.parsley.core.registry.ObjectDefinition;
import org.spicefactory.parsley.core.registry.ObjectDefinitionDecorator;
import org.spicefactory.parsley.core.registry.ObjectDefinitionRegistry;
import org.spicefactory.parsley.core.registry.RootObjectDefinition;
import org.spicefactory.parsley.core.scope.Scope;
import org.spicefactory.parsley.core.scope.ScopeName;
import org.spicefactory.parsley.tag.core.NestedTag;

import flash.utils.Dictionary;

[Metadata(name="Observe", types="method", multiple="true")]
/**
 * Represents a Metadata, MXML or XML tag that can be used on methods that should be invoked for
 * lifecycle events of other objects.
 * 
 * @author Jens Halm
 */
public class ObserveMethodDecorator implements ObjectDefinitionDecorator, NestedTag {


	[Target]
	/**
	 * The name of the method.
	 */
	public var method:String;


	/**
	 * The object lifecycle phase to listen for. Default is postInit.
	 */
	public var phase:ObjectLifecycle = ObjectLifecycle.POST_INIT;
	
	/**
	 * The scope in which to listen for lifecycle events.
	 */
	public var scope:String = ScopeName.GLOBAL;
	
	/**
	 * The (optional) id of the object to observe.
	 */
	public var objectId:String;
	

	private var providers:Dictionary = new Dictionary();
	private var singletonProvider:ObjectProvider;
	
	
	/**
	 * @inheritDoc
	 */
	public function decorate (definition:ObjectDefinition, registry:ObjectDefinitionRegistry) : ObjectDefinition {
		var targetScope:Scope = registry.scopeManager.getScope(scope);
		if (definition is RootObjectDefinition) {
			var rootDef:RootObjectDefinition = RootObjectDefinition(definition);
			if (rootDef.singleton && !rootDef.lazy) {
				/* 
				 * For non-lazy singletons we must register a proxy so that a matching message
				 * may trigger instance creation. Otherwise the receiver may miss a message
				 * just because of the initialization order. 
				 */
				singletonProvider = registry.createObjectProvider(rootDef.type.getClass(), rootDef.id);
				targetScope.objectLifecycle.addProvider(singletonProvider, method, phase, objectId);
			}
		} 
		if (!singletonProvider) {
			/*
			 * For all other use cases we wait until the object is instantiated before
			 * registering it as a message receiver.
			 */
			definition.objectLifecycle.addListener(ObjectLifecycle.PRE_INIT, preInit);
		}
		definition.objectLifecycle.addListener(ObjectLifecycle.POST_DESTROY, postDestroy);
		return definition;
	}
	
	/*
	 * Executed only for objects which are not non-lazy singletons.
	 */
	private function preInit (instance:Object, context:Context) : void {
		var provider:ObjectProvider = Provider.forInstance(instance);
		if (providers[instance] != undefined) {
			throw new IllegalArgumentError("Attempt to add more than one observer for the same instance: " + instance);
		}
		providers[instance] = provider;
		var targetScope:Scope = context.scopeManager.getScope(scope);
		targetScope.objectLifecycle.addProvider(singletonProvider, method, phase, objectId);
	}
	
	/*
	 * Executed for all objects.
	 */
	private function postDestroy (instance:Object, context:Context) : void {
		var targetScope:Scope = context.scopeManager.getScope(scope);
		if (singletonProvider != null) {
			targetScope.objectLifecycle.removeProvider(singletonProvider, method, phase, objectId);
		}
		else {
			if (providers[instance] == undefined) {
				throw new IllegalArgumentError("No observer was added for the specified instance: " + instance);
			}
			targetScope.objectLifecycle.removeProvider(providers[instance] as ObjectProvider, method, phase, objectId);
			delete providers[instance];
		}
	}
	
	
}
}

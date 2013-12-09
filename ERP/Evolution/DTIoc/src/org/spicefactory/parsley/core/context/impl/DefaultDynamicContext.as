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

package org.spicefactory.parsley.core.context.impl {
import org.spicefactory.lib.errors.IllegalStateError;
import org.spicefactory.lib.logging.LogContext;
import org.spicefactory.lib.logging.Logger;
import org.spicefactory.lib.reflect.ClassInfo;
import org.spicefactory.parsley.core.context.Context;
import org.spicefactory.parsley.core.context.DynamicContext;
import org.spicefactory.parsley.core.context.DynamicObject;
import org.spicefactory.parsley.core.context.impl.ChildContext;
import org.spicefactory.parsley.core.errors.ContextError;
import org.spicefactory.parsley.core.events.ContextEvent;
import org.spicefactory.parsley.core.factory.ContextStrategyProvider;
import org.spicefactory.parsley.core.registry.ObjectDefinition;
import org.spicefactory.parsley.core.registry.ObjectDefinitionFactory;
import org.spicefactory.parsley.core.registry.RootObjectDefinition;
import org.spicefactory.parsley.core.registry.impl.DefaultObjectDefinitionFactory;

import flash.events.Event;
import flash.utils.Dictionary;

/**
 * Default implementation of the DynamicContext interface.
 * 
 * @author Jens Halm
 */
public class DefaultDynamicContext extends ChildContext implements DynamicContext {
	
	
	private static const log:Logger = LogContext.getLogger(DefaultDynamicContext);

	
	private var objects:Dictionary = new Dictionary();
	

	/**
	 * Creates a new instance.
	 * 
	 * @param provider instances to fetch all required strategies from
	 * @param parent the Context that should be used as a parent of this Context
	 */
	public function DefaultDynamicContext (provider:ContextStrategyProvider, parent:Context) {
		super(provider, parent);
		addEventListener(ContextEvent.DESTROYED, contextDestroyed);
		registry.freeze();
	}
	
	
	/**
	 * @inheritDoc
	 */
	public function addDefinition (definition:ObjectDefinition) : DynamicObject {
		checkState();
		checkDefinition(definition);
		var object:DynamicObject = new DefaultDynamicObject(this, definition);
		if (object.instance != null) {
			addDynamicObject(object);		
		}
		return object;
	}

	/**
	 * @inheritDoc
	 */
	public function addObject (instance:Object, definition:ObjectDefinition = null) : DynamicObject {
		checkState();
		if (definition == null) {
			var ci:ClassInfo = ClassInfo.forInstance(instance, registry.domain);
			var defFactory:ObjectDefinitionFactory = new DefaultObjectDefinitionFactory(ci.getClass());
			definition = defFactory.createNestedDefinition(registry);
		}
		else {
			checkDefinition(definition);
		}
		var object:DynamicObject = new DefaultDynamicObject(this, definition, instance);
		addDynamicObject(object);
		return object;
	}
	
	private function checkDefinition (definition:ObjectDefinition) : void {
		if (definition is RootObjectDefinition) {
			throw new ContextError("RootObjectDefinitions cannot be added to a DynamicContext");
		}
	}
	
	/**
	 * @private
	 */
	internal function addDynamicObject (object:DynamicObject) : void {
		objects[object.instance] = object;	
	}
	
	/**
	 * @private
	 */
	internal function removeDynamicObject (object:DefaultDynamicObject) : void {
		if (objects != null) delete objects[object.instance];	
	}
	
	/**
	 * @inheritDoc
	 */
	public function removeObject (instance:Object) : void {
		if (destroyed) return;
		var object:DefaultDynamicObject = DefaultDynamicObject(objects[instance]);
		if (object != null) {
			object.remove();
		}
	}
	
	private function contextDestroyed (event:Event) : void {
		removeEventListener(ContextEvent.DESTROYED, contextDestroyed);
		objects = null;
	}
	
	private function checkState () : void {
		if (destroyed) {
			throw new IllegalStateError("Attempt to access Context after it was destroyed");
		}
	}
	
	
}
}

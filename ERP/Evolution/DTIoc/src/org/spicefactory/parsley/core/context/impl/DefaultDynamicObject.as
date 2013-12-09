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
import org.spicefactory.parsley.core.context.DynamicObject;
import org.spicefactory.parsley.core.events.ContextEvent;
import org.spicefactory.parsley.core.registry.ObjectDefinition;

import flash.events.Event;

/**
 * Default implementation of the DynamicObject interface.
 * 
 * @author Jens Halm
 */
public class DefaultDynamicObject implements DynamicObject {
	
	
	private var _context:DefaultDynamicContext;
	private var _definition:ObjectDefinition;
	private var _instance:Object;
	
	
	/**
	 * Creates a new instance.
	 * 
	 * @param context the dynamic Context this instance belongs to
	 * @param definition the definition that was applied to the instance
	 * @param instance the actual instance that was dynamically added to the Context
	 */
	function DefaultDynamicObject (context:DefaultDynamicContext, definition:ObjectDefinition, instance:Object = null) {
		_context = context;
		_definition = definition;
		_instance = instance;
		if (!context.parent.initialized) {
			context.parent.addEventListener(ContextEvent.INITIALIZED, contextInitialized);
		}
		else {
			processInstance();
		}
	}
	
	private function contextInitialized (event:Event) : void {
		context.parent.removeEventListener(ContextEvent.INITIALIZED, contextInitialized);
		processInstance();
	}
	
	private function processInstance () : void {
		if (_instance == null) {
			_instance = context.lifecycleManager.createObject(definition, context);
			_context.addDynamicObject(this);
		}
		context.lifecycleManager.configureObject(instance, definition, context);
	}
	
	/**
	 * @inheritDoc
	 */
	public function get definition () : ObjectDefinition {
		return _definition;
	}
	
	/**
	 * @inheritDoc
	 */
	public function get instance () : Object {
		return _instance;
	}
	
	/**
	 * The dynamic Context this instance belongs to.
	 */
	public function get context () : DefaultDynamicContext {
		return _context;
	}
	
	/**
	 * @inheritDoc
	 */
	public function remove () : void {
		if (context.parent.initialized) {
			context.lifecycleManager.destroyObject(instance, definition, context);
		}
		else {
			context.parent.removeEventListener(ContextEvent.INITIALIZED, contextInitialized);
		}
		context.removeDynamicObject(this);
	}
	
	
}
}

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

package org.spicefactory.parsley.core.scope.impl {
import org.spicefactory.parsley.core.context.Context;
import org.spicefactory.parsley.core.events.ContextEvent;
import org.spicefactory.parsley.core.messaging.MessageReceiverRegistry;
import org.spicefactory.parsley.core.scope.ObjectLifecycleScope;
import org.spicefactory.parsley.core.scope.Scope;
import org.spicefactory.parsley.core.scope.ScopeExtensions;

import flash.system.ApplicationDomain;

/**
 * Default implementation of the Scope interface.
 * 
 * @author Jens Halm
 */
public class DefaultScope implements Scope {

	private var context:Context;
	private var deferredMessages:Array;
	private var activated:Boolean = false;	
	
	private var domain:ApplicationDomain;
	private var scopeDef:ScopeDefinition;
	private var _objectLifecycle:ObjectLifecycleScope;
	
	
	/**
	 * Creates a new instance.
	 * 
	 * @param context the Context this scope instance is associated with
	 * @param scopeDef the shared definition for this scope
	 * @param domain the ApplicationDomain to use for reflection
	 */
	function DefaultScope (context:Context, scopeDef:ScopeDefinition, domain:ApplicationDomain) {
		this.context = context;
		this.scopeDef = scopeDef;
		this.domain = domain;
		this._objectLifecycle = new DefaultObjectLifecycleScope(scopeDef.lifecycleEventRouter.receivers);
		
		if (context.configured) {
			activated = true;
		}
		else {
			deferredMessages = new Array();
			context.addEventListener(ContextEvent.CONFIGURED, contextConfigured);
			context.addEventListener(ContextEvent.DESTROYED, contextDestroyed);
		}
	}

	private function contextConfigured (event:ContextEvent) : void {
		removeListeners();
		activated = true;
		for each (var deferred:DeferredMessage in deferredMessages) {
			doDispatch(deferred.message, deferred.selector);
		}
		deferredMessages = new Array();
	}
	
	private function contextDestroyed (event:ContextEvent) : void {
		removeListeners();
	}
	
	private function removeListeners () : void {
		context.removeEventListener(ContextEvent.CONFIGURED, contextConfigured);
		context.removeEventListener(ContextEvent.DESTROYED, contextDestroyed);
	}
	
	
	/**
	 * @inheritDoc
	 */
	public function dispatchMessage (message:Object, selector:* = undefined) : void {
		if (!activated) {
			deferredMessages.push(new DeferredMessage(message, selector));
		}
		else {
			doDispatch(message, selector);
		}
	}	
	
	private function doDispatch (message:Object, selector:* = undefined) : void {
		scopeDef.messageRouter.dispatchMessage(message, domain, selector);
	}
	
	/**
	 * @inheritDoc
	 */
	public function get name () : String {
		return scopeDef.name;
	}
	
	/**
	 * @inheritDoc
	 */
	public function get inherited () : Boolean {
		return scopeDef.inherited;
	}
	
	/**
	 * @inheritDoc
	 */
	public function get messageReceivers () : MessageReceiverRegistry {
		return scopeDef.messageRouter.receivers;
	}
	
	/**
	 * @inheritDoc
	 */
	public function get objectLifecycle () : ObjectLifecycleScope {
		return _objectLifecycle;
	}
	
	/**
	 * @inheritDoc
	 */
	public function get extensions () : ScopeExtensions {
		return scopeDef.extensions;
	}
	
}
}

class DeferredMessage {
	internal var message:Object;
	internal var selector:*;
	function DeferredMessage (message:Object, selector:*) {
		this.message = message;
		this.selector = selector;
	}
}


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

package org.spicefactory.parsley.core.builder.impl {
import org.spicefactory.lib.errors.IllegalArgumentError;
import org.spicefactory.parsley.core.context.Context;
import org.spicefactory.parsley.core.events.ContextEvent;

import flash.utils.Dictionary;

/**
 * Manages the inherited scopes for all currently active Context instances.
 * This is an internal class that usually should only be used by custom
 * CompositeContextBuilder implementations. It is necessary since some
 * internal objects like the 2 shared MessageRouter instances that each
 * Scope manages are not accessible through the public Scope API.
 * 
 * @author Jens Halm
 */
public class InheritedScopeRegistry {
	
	
	private static const scopeMap:Dictionary = new Dictionary();
	
	
	/**
	 * Adds the specified scopes and associates them with the given Context instance.
	 * Only inherited scopes should be passed to this method.
	 * 
	 * @param context the Context instance the specified scopes are associated with
	 * @param scopes the scopes to add
	 */
	public static function addScopes (context:Context, scopes:Array) : void {
		if (scopeMap[context] != undefined) {
			throw new IllegalArgumentError("Scopes already registered for the specified Context instance");
		}
		context.addEventListener(ContextEvent.DESTROYED, contextDestroyed);
		scopeMap[context] = scopes;
	}

	private static function contextDestroyed (event:ContextEvent) : void {
		var context:Context = event.target as Context;
		context.removeEventListener(ContextEvent.DESTROYED, contextDestroyed);
		delete scopeMap[context];
	}
	
	/**
	 * Returns the inherited scopes associated with the specified Context instance.
	 * 
	 * @param context the Context to return the associated scopes for
	 * @return the inherited scopes associated with the specified Context instance
	 */
	public static function getScopes (context:Context) : Array {
		if (scopeMap[context] == undefined) {
			throw new IllegalArgumentError("No Scopes registered for the specified Context instance");
		}
		return scopeMap[context].concat();
	}
	
	
}
}

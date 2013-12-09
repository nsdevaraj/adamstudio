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

package org.spicefactory.parsley.core.scope {
import org.spicefactory.parsley.core.context.provider.ObjectProvider;
import org.spicefactory.parsley.core.lifecycle.ObjectLifecycle;

/**
 * A registry for listeners that listen to lifecycle events of objects within a single scope.
 * 
 * @author Jens Halm
 */
public interface ObjectLifecycleScope {
	
	
	/**
	 * Adds a listener to object lifecycle events in this scope.
	 * The listener function must contain a single parameter typed to the object specified with the first parameter
	 * (or a supertype). The id parameter may be omitted, in this case the listener listens for all objects with
	 * a matching type.
	 * 
	 * @param type the type of the objects the listener is interested in
	 * @param event the lifecycle event to listen for
	 * @param listener the listener function
	 * @param id the id of the object to listen for
	 */
	function addListener (type:Class, event:ObjectLifecycle, listener:Function, id:String = null) : void;

	/**
	 * Removes a listener to object lifecycle events from this scope.
	 * 
	 * @param type the type of the objects the listener is interested in
	 * @param event the lifecycle event to listen for
	 * @param listener the listener function
	 * @param id the id of the object to listen for
	 */
	function removeListener (type:Class, event:ObjectLifecycle, listener:Function, id:String = null) : void;
	
	function addProvider (provider:ObjectProvider, methodName:String, event:ObjectLifecycle, id:String = null) : void;

	function removeProvider (provider:ObjectProvider, methodName:String, event:ObjectLifecycle, id:String = null) : void;

	
}
}

/*
 * Copyright 2008-2009 the original author or authors.
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

package org.spicefactory.parsley.core.registry.definition {
import org.spicefactory.parsley.core.lifecycle.ObjectLifecycle;

/**
 * A registry for all lifecycle listeners registered for a single instance.
 * 
 * @author Jens Halm
 */
public interface LifecycleListenerRegistry {
	
	/**
	 * Adds a lifecycle listener to this registry.
	 * The function must have two parameters, the first for the instance itself and
	 * the second the Context the instance belongs to.
	 * 
	 * @param event the lifecycle event to listen for
	 * @param listener the listener function to invoke
	 * @return this registry instance for method chaining
	 */
	function addListener (event:ObjectLifecycle, listener:Function) : LifecycleListenerRegistry;
	
	/**
	 * Removes the specified listener from this registry.
	 * 
	 * @param event the lifecycle event
	 * @param listener the listener function
	 * @return this registry instance for method chaining
	 */
	function removeListener (event:ObjectLifecycle, listener:Function) : LifecycleListenerRegistry;
	
	/**
	 * Returns all listeners for the specified event type.
	 * 
	 * @param event the event to return the listeners for
	 * @return all listeners added to this registry (an Array of function references)
	 */
	function getListeners (event:ObjectLifecycle) : Array;
	
}
}

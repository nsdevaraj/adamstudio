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
import org.spicefactory.parsley.core.messaging.MessageReceiverRegistry;

/**
 * Represents a single scope.
 * 
 * @author Jens Halm
 */
public interface Scope {
	
	
	/**
	 * The name of the scope.
	 */
	function get name () : String;
	
	/**
	 * Indicates whether this scope will be inherited by child Contexts.
	 */
	function get inherited () : Boolean;
	
	/**
	 * The registry for receivers of application messages dispatched through this scope.
	 */
	function get messageReceivers () : MessageReceiverRegistry;
	
	/**
	 * The registry for listeners that listen to lifecycle events of objects within this scope.
	 */
	function get objectLifecycle () : ObjectLifecycleScope;
	
	/**
	 * Custom extensions registered for this scope.
	 */
	function get extensions () : ScopeExtensions;
	
	/**
	 * Dispatches a message through this scope.

 * 	 * @param message the message to dispatch
	 * @param selector the selector to use if it cannot be determined from the message instance itself
	 */
	function dispatchMessage (message:Object, selector:* = undefined) : void;
	
	
}
}

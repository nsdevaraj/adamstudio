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

package org.spicefactory.parsley.core.factory {
import org.spicefactory.parsley.core.messaging.ErrorPolicy;
import org.spicefactory.parsley.core.messaging.MessageRouter;
import org.spicefactory.parsley.core.messaging.receiver.MessageErrorHandler;

/**
 * Factory responsible for creating MessageRouter instances.
 * 
 * @author Jens Halm
 */
public interface MessageRouterFactory {
	
	
	/**
	 * The policy to apply for unhandled errors. An unhandled error
	 * is an error thrown by a message handler where no matching error handler
	 * was registered for.
	 */
	function get unhandledError () : ErrorPolicy;

	function set unhandledError (policy:ErrorPolicy) : void;
	
	/**
	 * Adds a global error handler that will be applied to all routers created by this factory.
	 * 
	 * @param target the error handler to add to this factory
	 */
	function addErrorHandler (target:MessageErrorHandler) : void;
	
	/**
	 * Creates a new MessageRouter instance.
	 * 
	 * @return a new MessageRouter instance
	 */
	function create () : MessageRouter;
	
	
}
}

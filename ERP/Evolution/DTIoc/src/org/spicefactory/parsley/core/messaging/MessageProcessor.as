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

package org.spicefactory.parsley.core.messaging {

/**
 * Responsible for processing a single message. Will be passed to registered message interceptors and error handlers
 * which may chose to cancel or suspend and later resume the message processing.
 * 
 * @author Jens Halm
 */
public interface MessageProcessor {
	
	/**
	 * The message instance.
	 */
	function get message () : Object;
	
	/**
	 * Proceeds with processing the message, invoking the next interceptor or handler.
	 */
	function proceed () : void;
	
	/**
	 * Rewinds the processor so it will start with the first interceptor or handler again 
	 * the next time the proceed method gets invoked. Calling this method also causes
	 * all receivers to be refetched from the registry and thus takes into account
	 * any new receivers registered after processing this message started.
	 */
	function rewind () : void;
	
}
}

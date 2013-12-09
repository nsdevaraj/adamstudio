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

package org.spicefactory.parsley.core.messaging.receiver {

/**
 * Base interface for all types of message receivers a MessageRouter handles.
 * Subinterfaces are MessageTarget, MessageInterceptor and MessageErrorHandler.
 * 
 * @author Jens Halm
 */
public interface MessageReceiver {
	
	
	/**
	 * The class or interface of the message. 
	 */
	function get messageType () : Class;
	
	/**
	 * An optional selector value to be used for selecting matching messages.
	 */
	function get selector () : *;
	
	
}
}

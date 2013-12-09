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

package org.spicefactory.parsley.core.messaging.impl {
import org.spicefactory.lib.logging.LogContext;
import org.spicefactory.lib.logging.Logger;
import org.spicefactory.lib.reflect.ClassInfo;
import org.spicefactory.parsley.core.messaging.ErrorPolicy;
import org.spicefactory.parsley.core.messaging.MessageProcessor;
import org.spicefactory.parsley.core.messaging.receiver.MessageErrorHandler;
import org.spicefactory.parsley.core.messaging.receiver.MessageInterceptor;
import org.spicefactory.parsley.core.messaging.receiver.MessageTarget;

/**
 * Default implementation of the MessageProcessor interface.
 * 
 * @author Jens Halm
 */
public class DefaultMessageProcessor implements MessageProcessor {
	
	
	private static const log:Logger = LogContext.getLogger(DefaultMessageProcessor);

	
	private var _message:Object;
	
	private var messageType:ClassInfo;
	private var selector:*;
	private var receivers:DefaultMessageReceiverRegistry;
	
	private var remainingProcessors:Array;
	private var currentProcessor:Processor;
	private var errorHandlers:Array;
	private var currentError:Error;
	private var unhandledError:ErrorPolicy;
	
	
	/**
	 * Creates a new instance.
	 * 
	 * @param message the message to process
	 * @param messageType the type of the message
	 * @param selector the selector to use (will be extracted from the message itself if it is undefined)
	 * @param receivers the registry to obtain the matching receivers from
	 * @param unhandledError policy for errors no error handler is registered for
	 */
	function DefaultMessageProcessor (message:Object, messageType:ClassInfo, selector:*, 
			receivers:DefaultMessageReceiverRegistry, unhandledError:ErrorPolicy) {
		_message = message;
		this.messageType = messageType;
		this.selector = selector;
		this.receivers = receivers;
		this.unhandledError = unhandledError;
		rewind();
	}
	

	/**
	 * @inheritDoc
	 */
	public function proceed () : void {
		var async:Boolean;
		do {
			while (!currentProcessor.hasNext()) {
				if (remainingProcessors.length == 0) return;
				currentProcessor = remainingProcessors.shift() as Processor;
			}
			async = currentProcessor.async;
			try {
				currentProcessor.proceed();
			}
			catch (e:Error) {
				log.error("Message Target threw Error {0}", e);
				if (!currentProcessor.handleErrors || (e is MessageProcessorError)) {
					// avoid the risk of endless loops
					throw e;
				}
				else {
					var handlers:Array = new Array();
					for each (var errorHandler:MessageErrorHandler in errorHandlers) {
						if (e is errorHandler.errorType) {
							handlers.push(errorHandler);
						}
					}
					log.info("Select " + handlers.length + " out of " + errorHandlers.length + " error handlers");
					if (handlers.length > 0) {
						currentError = e;
						remainingProcessors.unshift(currentProcessor);
						currentProcessor = new Processor(handlers, invokeErrorHandler, true, false);
					}
					else {
						if (unhandledError == ErrorPolicy.RETHROW) {
							throw new MessageProcessorError("Error in message receiver", e);
						}
						else if (unhandledError == ErrorPolicy.ABORT) {
							log.info("Unhandled error - abort message processor");
							return;
						}
						else {
							log.info("Unhandled error - continue message processing");
						}
					}
				}
			}
		} while (!async);
	}
	
	
	private function invokeInterceptor (interceptor:MessageInterceptor) : void {
		interceptor.intercept(this);
	}
	
	private function invokeTarget (target:MessageTarget) : void {
		target.handleMessage(message);
	}
	
	private function invokeErrorHandler (errorHandler:MessageErrorHandler) : void {
		errorHandler.handleError(this, currentError);
	}
	
	/**
	 * @inheritDoc
	 */
	public function rewind () : void {
		fetchReceivers();
	}
	
	private function fetchReceivers () : void {	
		var receiverSelection:MessageReceiverSelection = receivers.getSelection(messageType);
		var selectorValue:* = (selector == undefined) ? receiverSelection.getSelectorValue(message) : selector;
		errorHandlers = receiverSelection.getErrorHandlers(selectorValue);
		currentProcessor = new Processor(receiverSelection.getInterceptors(selectorValue), invokeInterceptor);
		remainingProcessors = [new Processor(receiverSelection.getTargets(selectorValue), invokeTarget, false)];
	}

	/**
	 * @inheritDoc
	 */
	public function get message () : Object {
		return _message;
	}
	
	
}
}

import org.spicefactory.lib.errors.NestedError;

class Processor {
	
	private var receivers:Array;
	private var handler:Function;
	private var currentIndex:uint = 0;
	internal var async:Boolean;
	internal var handleErrors:Boolean;
	
	function Processor (receivers:Array, handler:Function, async:Boolean = true, handleErrors:Boolean = true) {
		this.receivers = receivers;
		this.handler = handler;
		this.async = async;
		this.handleErrors = handleErrors;
	}
	
	internal function hasNext () : Boolean {
		return (receivers.length > currentIndex);
	}
	
	internal function rewind () : void {
		currentIndex = 0;
	}

	internal function proceed () : void {
		handler(receivers[currentIndex++]);
	}
	
}

class MessageProcessorError extends NestedError {
	
	public function MessageProcessorError (message:String = "", cause:Error = null) {
		super(message, cause);
	}
	
}



